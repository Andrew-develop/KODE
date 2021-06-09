//
//  DifficultyCollectionViewCell.swift
//  KODE
//
//  Created by Sergio Ramos on 05.06.2021.
//

import UIKit

final class DifficultyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var difficultyImage: UIImageView!
    
    func setup(viewModel: DifficultyCellViewModel) {
        guard viewModel.allowedAccess(object: self) else { return }

        self.difficultyImage.image = UIImage(named: "star")
        
        viewModel.didUpdate = self.setup
    }
}
