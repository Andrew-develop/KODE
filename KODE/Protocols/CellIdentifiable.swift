//
//  CellIdentifiable.swift
//  KODE
//
//  Created by Sergio Ramos on 06.06.2021.
//

import UIKit

protocol CellIdentifiable: class {
    var uniqueId: IndexPath? { get set }
}

private struct AssociatedKeys {
    static var UniqueID = "UniqueID"
}

extension UITableViewCell: CellIdentifiable {
    var uniqueId: IndexPath? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.UniqueID) as? IndexPath }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.UniqueID, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.UniqueID, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

extension UICollectionViewCell : CellIdentifiable {
    var uniqueId: IndexPath? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.UniqueID) as? IndexPath }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.UniqueID, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.UniqueID, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}
