//
//  UIImage+extensions.swift
//  Quiz
//
//  Created by Megan Wynn on 19/10/2021.
//

import UIKit

public extension UIImage {

    static var correct: UIImage! {
        return UIImage(named: "correct", in: Bundle(for: HomeViewController.self), with: nil)
    }

    static var incorrect: UIImage! {
        return UIImage(named: "incorrect", in: Bundle(for: HomeViewController.self), with: nil)
    }

    static var appIcon: UIImage! {
        return UIImage(named: "mainIconImage", in: Bundle(for: HomeViewController.self), with: nil)
    }

    static var star: UIImage! {
        return UIImage(named: "star", in: Bundle(for: HomeViewController.self), with: nil)
    }

    static var email: UIImage! {
        return UIImage(named: "email", in: Bundle(for: HomeViewController.self), with: nil)
    }

    static var bin: UIImage! {
        return UIImage(named: "bin", in: Bundle(for: HomeViewController.self), with: nil)
    }
}


