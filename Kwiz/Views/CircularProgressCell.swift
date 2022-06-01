//
//  CircularProgressCell.swift
//  Kwiz
//
//  Created by Megan Wynn on 01/04/2022.
//

import UIKit

class CircularProgressCell: UICollectionViewCell {

    private var circularProgressView: CircularProgressView?
    private var percentageLabel = UILabel()

    var startValue = 0
    var percentage: Int = 0

    var score: Int = 0 {
       didSet {
           percentage = (score * 10)
           setupCircularView(percentage: Float(score)/10)
           setUpPercentageLabel()
       }
    }

    // MARK: - Initialise
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()

        let displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        displayLink.add(to: .main, forMode: .default)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleUpdate() {
        self.percentageLabel.text = "\(startValue)%"
        startValue += 1

        if startValue > percentage {
            startValue = percentage
        }
    }

    // MARK: - Setup
    private func setUpCell() {
        contentView.clipsToBounds = true
        layer.masksToBounds = false
    }

    private func setUpPercentageLabel() {
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        percentageLabel.textAlignment = .center
        percentageLabel.textColor = .titleColor
        percentageLabel.font = UIFont.preferredFont(forTextStyle: .body).withSize(28)
        contentView.addSubview(percentageLabel)

        NSLayoutConstraint.activate([
            percentageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            percentageLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    private func setupCircularView(percentage: Float) {
        let circularProgressView = CircularProgressView()
        circularProgressView.createCircularPath()
        circularProgressView.progressAnimation(toValue: percentage)
        circularProgressView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(circularProgressView)

        NSLayoutConstraint.activate([
            circularProgressView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
            circularProgressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0),
            circularProgressView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])

        self.circularProgressView = circularProgressView
    }
    
}
