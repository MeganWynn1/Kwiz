//
//  CircularProgressCell.swift
//  Kwiz
//
//  Created by Megan Wynn on 01/04/2022.
//

import UIKit

class CircularProgressCell: UICollectionViewCell {

    private var circularProgressView: CircularProgressView?

    // MARK: - Initialise
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        setUpCell()
        setupCircularView()
    }

    // MARK: - Setup
    private func setUpCell() {
        backgroundColor = .orange
        contentView.clipsToBounds = true
        layer.masksToBounds = false
    }

    private func setupCircularView() {
        let circularProgressView = CircularProgressView()
        circularProgressView.createCircularPath()
        circularProgressView.progressAnimation(toValue: 50)
        circularProgressView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(circularProgressView)

        NSLayoutConstraint.activate([
            circularProgressView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
            circularProgressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0),
            circularProgressView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])

        circularProgressView.setContentCompressionResistancePriority(.required, for: .vertical)

        self.circularProgressView = circularProgressView
    }
    
}
