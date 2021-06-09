//
//  CellRepresentable.swift
//  KODE
//
//  Created by Sergio Ramos on 06.06.2021.
//

import UIKit

protocol TableCellRepresentable {
    static func registerCell(tableView: UITableView)
    func dequeueCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func cellSelected()
}
