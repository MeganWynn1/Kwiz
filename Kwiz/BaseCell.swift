//
//  BaseCell.swift
//  Kwiz
//
//  Created by Megan Wynn on 07/01/2022.
//

import UIKit

class BaseCell: UICollectionViewCell {

    // MARK: - Initialise
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpCell() {
        contentView.backgroundColor = .primaryColor
        layer.cornerRadius = Constants.cellCornerRadius
        contentView.layer.cornerRadius = Constants.cellCornerRadius
        contentView.clipsToBounds = true
        layer.masksToBounds = false
    }
}

// MARK: - Constants
extension BaseCell {
    enum Constants {
        static let cellCornerRadius: CGFloat = 10.0
    }
}
