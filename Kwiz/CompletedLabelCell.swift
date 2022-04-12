//
//  CompletedLabelCell.swift
//  Kwiz
//
//  Created by Megan Wynn on 01/04/2022.
//

import UIKit

class CompletedLabelCell: UICollectionViewCell {

    // MARK: - Properties
    var label = UILabel()

    // MARK: - Initialise
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setUpCell()
        setupLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setUpCell() {
        backgroundColor = .backgroundColor
        contentView.clipsToBounds = true
        layer.masksToBounds = false
    }

    private func setupLabel() {
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .secondaryColor
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.labelPadding),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.labelPadding),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.labelPadding),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.labelPadding)
        ])
    }
    
}

// MARK: - Constants
extension CompletedLabelCell {
    enum Constants {
        static let labelPadding: CGFloat = 10
    }
}
