//
//  QuizMenuButton.swift
//  Quiz
//
//  Created by Megan Wynn on 28/10/2021.
//

import UIKit

class QuizMenuButton: UIButton {

    enum Constants {
        static let font: UIFont = UIFont.preferredFont(forTextStyle: .headline).withSize(24)
        static let cornerRadius: CGFloat = 10.0
    }

    init(title: String, backgroundColor: UIColor) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = Constants.font
        self.layer.cornerRadius = Constants.cornerRadius
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
