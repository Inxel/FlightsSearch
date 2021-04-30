//
//  UITableView+Register.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

import UIKit

extension UITableView {
    
    final func register<Cell: UITableViewCell>(_ cell: Cell.Type) where Cell: ReusableView {
        register(cell, forCellReuseIdentifier: "\(Cell.reuseID)")
    }
    
    final func dequeueReusableCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell where Cell: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: Cell.reuseID, for: indexPath) as? Cell else {
            fatalError("Could not dequeue cell with ID: \(Cell.reuseID)")
        }
        
        return cell
    }
    
}
