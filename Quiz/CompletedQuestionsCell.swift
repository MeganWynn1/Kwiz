//
//  CompletedQuestionsCell.swift
//  Quiz
//
//  Created by Megan Wynn on 12/11/2021.
//

import UIKit

class CompletedQuestionsCell: UICollectionViewCell {

    // MARK: - Properties
    var label = UILabel()
    var resultImage = UIImageView()

    // MARK: - Initialise
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupImage()
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

    private func setupImage() {
        resultImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(resultImage)

        NSLayoutConstraint.activate([
            resultImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.labelPadding),
            resultImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.labelPadding),
            resultImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.labelPadding),
            resultImage.widthAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.font
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .textColour
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.labelPadding),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.labelPadding),
            label.leadingAnchor.constraint(equalTo: resultImage.trailingAnchor, constant: Constants.labelPadding),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.labelPadding)
        ])
    }
}

// MARK: - Constants
extension CompletedQuestionsCell {
    enum Constants {
        static let labelPadding: CGFloat = 10
        static let font = UIFont.systemFont(ofSize: 16)
        static let cellCornerRadius: CGFloat = 5.0
        static let shadowRadius: CGFloat = 3.0
        static let shadowOffset: CGFloat = 2.0
        static let shadowOpacity: Float = 2.0
    }
}
