//
//  CollectionCellRepresentable.swift
//  KODE
//
//  Created by Sergio Ramos on 08.06.2021.
//

import UIKit

protocol CollectionCellRepresentable {
    static func registerCell(collectionView: UICollectionView)
    func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
}
