//
//  UIImage+extensions.swift
//  Quiz
//
//  Created by Megan Wynn on 19/10/2021.
//

import UIKit

public extension UIImage {

    static var correct: UIImage! {
        return UIImage(named: "correct", in: Bundle(for: ViewController.self), with: nil)
    }

    static var incorrect: UIImage! {
        return UIImage(named: "incorrect", in: Bundle(for: ViewController.self), with: nil)
    }

    static var appIcon: UIImage! {
        return UIImage(named: "mainIconImage", in: Bundle(for: ViewController.self), with: nil)
    }
}


