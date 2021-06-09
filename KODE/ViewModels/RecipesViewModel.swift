//
//  MainViewModel.swift
//  KODE
//
//  Created by Sergio Ramos on 04.06.2021.
//

import Foundation

final class RecipesViewModel {
    
    private let alamofireHelper : AlamofireHelper
    private var recipes : [SomeRecipe]?
    private var sortType = TypeOfSort.byDate
    
    init(alamofireHelper : AlamofireHelper) {
        self.alamofireHelper = alamofireHelper
    }
    
    var didError: ((String) -> Void)?
    var didUpdate: ((RecipesViewModel) -> Void)?
    var didSelectRecipe: ((SomeRecipe) -> Void)?
    
    let recipeViewModelsTypes: [TableCellRepresentable.Type] = [RecipeCellViewModel.self]
    
    private(set) var recipeViewModels = [TableCellRepresentable]()
    
    private(set) var isUpdating: Bool = false {
        didSet { self.didUpdate?(self) }
    }
    
    func getData() {
        alamofireHelper.getRecipes { (recipes) in
            if let recipes = recipes {
                self.reloadData(someFunc: self.writeRecipes(recipes: recipes.recipes))
            }
        } onError: { (error) in
            self.reloadData(someFunc: self.getRecipesWithoutNetworkConnection(error: error.description))
        }
    }
    
    func search(text : String) {
        reloadData(someFunc: searchRecipes(text: text))
    }
    
    func sort(sortMethod : TypeOfSort) {
        sortType = sortMethod
        reloadData(someFunc: ())
    }
    
    private func writeRecipes(recipes : [Recipe]) {
        let cdh = CoreDataHelper()
        let recs = cdh.recipesRequest()
        cdh.deleteFromCoreData(mass: recs)
        cdh.createRecipes(recipes: recipes)
        self.recipes = cdh.recipesRequest()
    }
    
    private func getRecipesWithoutNetworkConnection(error : String) {
        self.didError?(error)
        self.recipes = CoreDataHelper().recipesRequest()
    }
    
    private func searchRecipes(text : String) {
        recipes = CoreDataHelper().recipesRequest()
        if text != "" {
            recipes?.forEach { (recipe) in
                if !checkOnCoencidence(text: text, whereSearch: recipe.name) {
                    if !checkOnCoencidence(text: text, whereSearch: recipe.recipeDescription ?? "") {
                        if !checkOnCoencidence(text: text, whereSearch: recipe.instructions) {
                            if let ind = recipes?.firstIndex(of: recipe) {
                                recipes?.remove(at: ind)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func checkOnCoencidence(text : String, whereSearch : String?) -> Bool {
        let regExp = "\(text)*"
        let regex = try! NSRegularExpression(pattern: regExp)
        let range = NSRange(location: 0, length: whereSearch?.count ?? 0)
        return regex.firstMatch(in: whereSearch ?? "", options: [], range: range) != nil
    }
    
    private func sorting() {
        if sortType == TypeOfSort.byDate {
            sortByDate()
        }
        else {
            sortByName()
        }
    }
    
    private func sortByDate() {
        recipes?.sort {
            $0.lastUpdated > $1.lastUpdated
        }
    }
    
    private func sortByName() {
        recipes?.sort {
            $0.name ?? "" < $1.name ?? ""
        }
    }
    
    private func reloadData(someFunc : ()) {
        isUpdating = true
        someFunc
        sorting()
        if let recipes = self.recipes {
            recipeViewModels = recipes.map { self.viewModelFor(recipe: $0) }
        }
        isUpdating = false
    }
    
    private func viewModelFor(recipe: SomeRecipe) -> TableCellRepresentable {
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
