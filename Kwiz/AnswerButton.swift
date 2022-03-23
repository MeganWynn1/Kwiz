//
//  AnswerButton.swift
//  Kwiz
//
//  Created by Megan Wynn on 02/11/2021.
//

import UIKit

class AnswerButton: UIButton {

    init() {
        super.init(frame: .zero)
        setTitleColor(.textColor, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .primaryColor
        layer.cornerRadius = Constants.cornerRadius
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension AnswerButton {
    enum Constants {
        static let cornerRadius: CGFloat = 5.0
    }
}
