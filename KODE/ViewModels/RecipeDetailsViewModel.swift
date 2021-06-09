//
//  RecipeViewModel.swift
//  KODE
//
//  Created by Sergio Ramos on 04.06.2021.
//

import Foundation

class RecipeDetailsViewModel {
    
    private let recipe : SomeRecipe
    
    init(recipe : SomeRecipe) {
        self.recipe = recipe
    }
    
    var didError: ((Error) -> Void)?
    var didUpdate: ((RecipeDetailsViewModel) -> Void)?
    var didBackButtonTapped: (() -> Void)?
    
    let pictureViewModelsTypes: [CollectionCellRepresentable.Type] = [PictureCellViewModel.self]
    let difficultyViewModelsTypes: [CollectionCellRepresentable.Type] = [DifficultyCellViewModel.self]
    
    private(set) var pictureViewModels = [CollectionCellRepresentable]()
    private(set) var difficultyViewModels = [CollectionCellRepresentable]()
    
    private(set) var isUpdating: Bool = false {
        didSet { self.didUpdate?(self) }
    }
    
    func getPictures() {
        isUpdating = true
        let images = recipe.someImage?.allObjects as? [SomeImage]
        if let images = images {
            pictureViewModels = images.map { self.viewModelForPictures(picture: $0.name ?? "") }
        }
        isUpdating = false
    }
    
    func getDifficulty() {
        isUpdating = true
        var arr = [String]()
        for _ in 0..<recipe.difficulty {
            arr.append("star")
        }
        difficultyViewModels = arr.map { self.viewModelForDifficulty(picture: $0) }
        isUpdating = false
    }
    
    var name : String {
        recipe.name ?? ""
    }
    
    var recipeDescription : String {
        recipe.recipeDescription ?? ""
    }
    
    var instructions : String {
        recipe.instructions?.replacingOccurrences(of: "<br>", with: "\n") ?? ""
    }
    
    var lastUpdated : String {
        dateFromTimestamp(value: Int(recipe.lastUpdated))
    }
    
    func openRecipeList() {
        didBackButtonTapped?()
    }
    
    private func dateFromTimestamp(value : Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(value))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
    private func viewModelForPictures(picture: String) -> CollectionCellRepresentable {
        let viewModel = PictureCellViewModel(picture: picture)
        return viewModel
    }
    
    private func viewModelForDifficulty(picture: String) -> CollectionCellRepresentable {
        let viewModel = DifficultyCellViewModel(picture: picture)
        return viewModel
    }
    
}
