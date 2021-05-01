//
//  NiblessTableViewCell.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 30.04.2021.
//

import UIKit

class NiblessTableViewCell: UITableViewCell {
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    @available(*, unavailable, message: "This cell is nibless")
    required init?(coder: NSCoder) {
        fatalError("Loading this TableViewCell from a nib is unsupported. File: \(#file); Line: \(#line)")
    }
    
    // MARK: - Could be overridden
    
    func commonInit() {}
    
}

