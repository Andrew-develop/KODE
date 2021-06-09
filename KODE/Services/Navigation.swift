//
//  Navigation.swift
//  KODE
//
//  Created by Sergio Ramos on 07.06.2021.
//

import UIKit

class Navigation {
    
    private let navigationController: UINavigationController
    
    init(window: UIWindow, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
        window.rootViewController = self.navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
        showMainScreen()
    }
    
    private func showMainScreen() {
        let viewModel = RecipesViewModel(alamofireHelper: AlamofireHelper())
        viewModel.didSelectRecipe = { [weak self] recipe in
            self?.showRecipe(recipe: recipe)
        }
        
        let instance = RecipesViewController(viewModel: viewModel)
        navigationController.pushViewController(instance, animated: false)
    }
    
    private func showRecipe(recipe: SomeRecipe) {
        let viewModel = RecipeDetailsViewModel(recipe: recipe)
        viewModel.didBackButtonTapped = { [weak self] in
            self?.backToPreviosVC()
        }
        let instance = RecipeDetailsViewController(viewModel: viewModel)
        self.navigationController.pushViewController(instance, animated: true)
    }
    
    private func backToPreviosVC() {
        navigationController.popViewController(animated: true)
    }
}
