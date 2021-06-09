//
//  DifficultyCellViewModel.swift
//  KODE
//
//  Created by Sergio Ramos on 08.06.2021.
//

import UIKit

final class DifficultyCellViewModel {
    
    private let picture: String
    private var restrictedTo: IndexPath?
    
    init(picture: String) {
        self.picture = picture
    }
    
    var didError: ((Error) -> Void)?
    var didUpdate: ((DifficultyCellViewModel) -> Void)?
    
    var imageForCell: String {
        picture
    }
    
    func allowedAccess(object: CellIdentifiable) -> Bool {
        guard
            let restrictedTo = self.restrictedTo,
            let uniqueId = object.uniqueId
            else { return true }
        
        return uniqueId == restrictedTo
    }
}

extension DifficultyCellViewModel: CollectionCellRepresentable {
    static func registerCell(collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: String(describing: DifficultyCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: DifficultyCollectionViewCell.self))
    }
    
    func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DifficultyCollectionViewCell.self), for: indexPath as IndexPath) as! DifficultyCollectionViewCell
        cell.uniqueId = indexPath
        self.restrictedTo = indexPath
        cell.setup(viewModel: self)
        return cell
    }
}
