//
//  RecipeCellViewModel.swift
//  KODE
//
//  Created by Sergio Ramos on 06.06.2021.
//

import UIKit

final class RecipeCellViewModel {
    
    private let recipe: SomeRecipe
    private var restrictedTo: IndexPath?
    
    init(recipe: SomeRecipe) {
        self.recipe = recipe
    }
    
    var didError: ((Error) -> Void)?
    var didUpdate: ((RecipeCellViewModel) -> Void)?
    var didSelectRecipe: ((SomeRecipe) -> Void)?
    
    var name: String {
        recipe.name ?? ""
    }
    
    var recipeDescription : String {
        recipe.recipeDescription ?? ""
    }
    
    var image: String {
        let images = recipe.someImage?.allObjects as? [SomeImage]
        return images?[0].name ?? ""
    }
    
    func allowedAccess(object: CellIdentifiable) -> Bool {
        guard
            let restrictedTo = self.restrictedTo,
            let uniqueId = object.uniqueId
            else { return true }
        
        return uniqueId == restrictedTo
    }
}

extension RecipeCellViewModel: TableCellRepresentable {
    
    static func registerCell(tableView: UITableView) {
        tableView.register(UINib(nibName: String(describing: RecipeTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: RecipeTableViewCell.self))
    }
    
    func dequeueCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecipeTableViewCell.self), for: indexPath as IndexPath) as! RecipeTableViewCell
        cell.uniqueId = indexPath
        self.restrictedTo = indexPath
        cell.setup(viewModel: self)
        return cell
    }
    
    func cellSelected() {
        didSelectRecipe?(recipe)
    }
}
