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
    }

    init() {
        super.init(frame: .zero)
        setTitleColor(.textColor, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .mainColor
        layer.cornerRadius = Constants.cornerRadius
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
