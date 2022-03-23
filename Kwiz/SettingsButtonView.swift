//
//  SettingsButtonView.swift
//  Kwiz
//
//  Created by Megan Wynn on 11/03/2022.
//

import UIKit

enum AdditionalSettings {
    case rateApplication
    case emailFeedback
    case clearLeaderboard

    var title: String {
        switch self {
        case .rateApplication:
            return "Rate Application"
        case .emailFeedback:
            return "Email Feedback"
        case .clearLeaderboard:
            return "Clear Leaderboard"
        }
    }
}

class SettingsButtonView: UIView {

    var titleLabel = UILabel()
    var imageView = UIImageView()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondaryColor
        layer.cornerRadius = Constants.cornerRadius

        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupViews() {
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),

            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            imageView.widthAnchor.constraint(equalToConstant: 30)
        ])

    }
}

extension SettingsButtonView {
    enum Constants {
        static let cornerRadius: CGFloat = 10
    }
}
