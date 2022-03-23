//
//  HeaderView.swift
//  Kwiz
//
//  Created by Megan Wynn on 19/11/2021.
//

import UIKit

class HeaderView: UICollectionReusableView {

    var identifier = "Header"
    var titleLabel = UILabel()
    var ovalView = UIView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupOvalView()
        setupTitleLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupOvalView() {
        ovalView.backgroundColor = .secondaryColor
        ovalView.layer.cornerRadius = 10.0
        ovalView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ovalView)

        NSLayoutConstraint.activate([
            ovalView.centerXAnchor.constraint(equalTo: centerXAnchor),
            ovalView.centerYAnchor.constraint(equalTo: centerYAnchor),
            ovalView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            ovalView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            ovalView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.size.width/3),
            ovalView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(frame.size.width/3))
        ])
    }

    private func setupTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        ovalView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: ovalView.bottomAnchor),
            titleLabel.topAnchor.constraint(equalTo: ovalView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: ovalView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: ovalView.trailingAnchor)
        ])
    }
        
}
