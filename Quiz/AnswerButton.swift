//
//  AnswerButton.swift
//  Quiz
//
//  Created by Megan Wynn on 02/11/2021.
//

import UIKit

class AnswerButton: UIButton {

    enum Constants {
        static let cornerRadius: CGFloat = 5.0
        static let shadowRadius: CGFloat = 3.0
        static let shadowOffset: CGFloat = 2.0
        static let shadowOpacity: Float = 2.0
    }

    init() {
        super.init(frame: .zero)
        setTitleColor(.black, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .cellColour
        layer.cornerRadius = Constants.cornerRadius
        layer.borderWidth = 0
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: Constants.shadowOffset)
        layer.shadowRadius = Constants.shadowRadius
        layer.shadowOpacity = Constants.shadowOpacity
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
