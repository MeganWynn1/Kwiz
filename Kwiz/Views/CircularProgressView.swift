//
//  CircularProgressView.swift
//  Kwiz
//
//  Created by Megan Wynn on 05/11/2021.
//

import UIKit

class CircularProgressView: UIView {

    // MARK: - Properties
    private var circleLayer: CAShapeLayer!
    private var progressLayer: CAShapeLayer!
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createCircularPath() {
        circleLayer = CAShapeLayer()
        circleLayer.frame = CGRect(origin: .zero, size: CGSize(width: 180.0, height: 180.0))
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: circleLayer.frame.size.width / 2.0, y: circleLayer.frame.size.height / 2.0), radius: 80, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 20.0
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.white.cgColor
        layer.addSublayer(circleLayer)

        progressLayer = CAShapeLayer()
        progressLayer.frame = CGRect(origin: .zero, size: CGSize(width: 180.0, height: 180.0))
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 10
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.primaryColor.cgColor
        layer.addSublayer(progressLayer)
    }

    func progressAnimation(toValue: Float) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = 2
        circularProgressAnimation.toValue = toValue
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        circleLayer.position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        progressLayer.position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
    }

}
