//
//  RegularTableViewCell.swift
//  KODE
//
//  Created by Sergio Ramos on 02.06.2021.
//

import UIKit
import Kingfisher

final class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func setup(viewModel: RecipeCellViewModel) {
        guard viewModel.allowedAccess(object: self) else { return }
        
        self.titleLabel.text = viewModel.name
        self.descriptionLabel.text = viewModel.recipeDescription
        self.recipeImageView.kf.setImage(with: URL(string: viewModel.image))
        
        viewModel.didUpdate = self.setup
    }
    
}
