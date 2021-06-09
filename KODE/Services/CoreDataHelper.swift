//
//  CoreDataHelper.swift
//  KODE
//
//  Created by Sergio Ramos on 09.06.2021.
//

import UIKit
import CoreData

class CoreDataHelper {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func recipesRequest() -> [SomeRecipe] {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<SomeRecipe> = SomeRecipe.fetchRequest()
        let recipes = try! context.fetch(fetchRequest)
        return recipes
    }
    
    func createRecipes(recipes : [Recipe]) {
        let contex = appDelegate.persistentContainer.viewContext
        recipes.forEach { (recipe) in
            let newRecipe = SomeRecipe(context: contex)
            newRecipe.name = recipe.name
            newRecipe.difficulty = Int32(recipe.difficulty)
            newRecipe.recipeDescription = recipe.description
            newRecipe.instructions = recipe.instructions
            newRecipe.lastUpdated = Int32(recipe.lastUpdated)
            
            recipe.images.forEach { (image) in
                let newImage = SomeImage(context: contex)
                newImage.name = image
                newRecipe.addToSomeImage(newImage)
            }
        }
        appDelegate.saveContext()
    }
    
    func deleteFromCoreData<T : NSManagedObject>(mass : [T]) {
        let context = appDelegate.persistentContainer.viewContext
        
        mass.forEach { (element) in
            context.delete(element)
        }
        appDelegate.saveContext()
    }
    
    private func saveData() {
        appDelegate.saveContext()
    }
}
