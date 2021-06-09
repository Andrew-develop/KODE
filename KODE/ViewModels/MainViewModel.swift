//
//  MainViewModel.swift
//  KODE
//
//  Created by Sergio Ramos on 04.06.2021.
//

import Foundation

final class RecipesViewModel {
    
    private let alamofireHelper : AlamofireHelper
    
    private var staticRecipes : [Recipe]?
    private var recipes : [Recipe]?
    
    private var sortType = TypeOfSort.byDate
    
    init(alamofireHelper : AlamofireHelper) {
        self.alamofireHelper = alamofireHelper
    }
    
    var didError: ((String) -> Void)?
    var didUpdate: ((RecipesViewModel) -> Void)?
    var didSelectRecipe: ((Recipe) -> Void)?
    
    let recipeViewModelsTypes: [TableCellRepresentable.Type] = [RecipeCellViewModel.self]
    
    private(set) var recipeViewModels = [TableCellRepresentable]()
    
    private(set) var isUpdating: Bool = false {
        didSet { self.didUpdate?(self) }
    }
    
    func getData() {
        isUpdating = true
        
        alamofireHelper.getRecipes { (recipes) in
            self.staticRecipes = recipes?.recipes
            self.recipes = recipes?.recipes
            self.sort(sortMethod: self.sortType)
            self.isUpdating = false
        } onError: { (error) in
            self.didError?(error.description)
            self.isUpdating = false
        }
    }
    
    func search(text : String) {
        isUpdating = true
        recipes = staticRecipes
        if text != "" {
            recipes?.forEach { (recipe) in
                if !isCoencidence(text: text, whereSearch: recipe.name) {
                    if !isCoencidence(text: text, whereSearch: recipe.description) {
                        if !isCoencidence(text: text, whereSearch: recipe.instructions) {
                            if let ind = recipes?.firstIndex(of: recipe) {
                                recipes?.remove(at: ind)
                            }
                        }
                    }
                }
            }
        }
        sort(sortMethod: sortType)
        isUpdating = false
    }
    
    private func isCoencidence(text : String, whereSearch : String?) -> Bool {
        let regExp = "\(text)*"
        let regex = try! NSRegularExpression(pattern: regExp)
        let range = NSRange(location: 0, length: whereSearch?.count ?? 0)
        return regex.firstMatch(in: whereSearch ?? "", options: [], range: range) != nil
    }
    
    func sort(sortMethod : TypeOfSort) {
        isUpdating = true
        sortType = sortMethod
        if sortMethod == TypeOfSort.byDate {
            sortByDate()
        }
        else {
            sortByName()
        }
        recipeViewModels = recipes!.map { self.viewModelFor(recipe: $0) }
        isUpdating = false
    }
    
    private func sortByDate() {
        recipes?.sort {
            $0.lastUpdated > $1.lastUpdated
        }
    }
    
    private func sortByName() {
        recipes?.sort {
            $0.name < $1.name
        }
    }
    
    private func viewModelFor(recipe: Recipe) -> TableCellRepresentable {
        let viewModel = RecipeCellViewModel(recipe: recipe)
        viewModel.didSelectRecipe = { [weak self] recipe in
            self?.didSelectRecipe?(recipe)
        }
        viewModel.didError = { [weak self] error in
            self?.didError?(error.localizedDescription)
        }
        return viewModel
    }
}
