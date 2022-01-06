//
//  CategoryCell.swift
//  Quiz
//
//  Created by Megan Wynn on 29/09/2021.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    // MARK: - Properties
    var label = UILabel()

    // MARK: - Initialise
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setUpCell() {
        contentView.backgroundColor = .cellColour
        layer.cornerRadius = Constants.cellCornerRadius
        contentView.layer.cornerRadius = Constants.cellCornerRadius
        contentView.clipsToBounds = true
        layer.borderWidth = 0
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: Constants.shadowOffset)
        layer.shadowRadius = Constants.shadowRadius
        layer.shadowOpacity = Constants.shadowOpacity
        layer.masksToBounds = false
    }

    private func setupLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.font
        label.textAlignment = .center
        label.textColor = .textColour
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
extension CategoryCell {
    enum Constants {
        static let labelPadding: CGFloat = 10
        static let font = UIFont.systemFont(ofSize: 20)
        static let cellCornerRadius: CGFloat = 5.0
        static let shadowRadius: CGFloat = 3.0
        static let shadowOffset: CGFloat = 2.0
        static let shadowOpacity: Float = 2.0
    }
}

