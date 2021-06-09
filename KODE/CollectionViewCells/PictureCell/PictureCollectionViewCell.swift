//
//  RegularCollectionViewCell.swift
//  KODE
//
//  Created by Sergio Ramos on 04.06.2021.
//

import UIKit

final class PictureCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    func setup(viewModel: PictureCellViewModel) {
        guard viewModel.allowedAccess(object: self) else { return }

        self.imageView.kf.setImage(with: URL(string: viewModel.imageForCell))
        
        viewModel.didUpdate = self.setup
    }
}
