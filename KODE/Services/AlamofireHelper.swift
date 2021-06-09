//
//  AlamofireHelper.swift
//  KODE
//
//  Created by Sergio Ramos on 02.06.2021.
//

import Alamofire

class AlamofireHelper {
    
    func getRecipes(onComplete: @escaping (_ recipes: Recipes?) -> Void, onError:  @escaping (_ message: String) -> Void) {
        AF.request("https://test.kode-t.ru/recipes.json",
                   method: .get).response { response in
                    switch response.result {
                    case .success(let data):
                        onComplete(try! JSONDecoder().decode(Recipes.self, from: data!))
                    case .failure(let error):
                        onError(error.errorDescription ?? "")
                    }
                   }
    }
    
}
