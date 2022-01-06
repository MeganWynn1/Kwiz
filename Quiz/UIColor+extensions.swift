//
//  UIColor+extensions.swift
//  Quiz
//
//  Created by Megan Wynn on 29/09/2021.
//

import UIKit

extension UIColor {

    static var backgroundColour: UIColor {
        return UIColor(named: Constants.Colour.backgroundColour.rawValue)!
    }

    static var cellColour: UIColor {
        return UIColor(named: Constants.Colour.cellColour.rawValue)!
    }

    static var textColour: UIColor {
        return UIColor(named: Constants.Colour.textColour.rawValue)!
    }

    static var spinnerBackground: UIColor {
        return UIColor(named: Constants.Colour.spinnerBackground.rawValue)!
    }

    static var startButtonColour: UIColor {
        return UIColor(named: Constants.Colour.startButtonColour.rawValue)!
    }

    static var resultButtonColour: UIColor {
        return UIColor(named: Constants.Colour.resultButtonColour.rawValue)!
    }
}

// MARK: - Constants
private extension UIColor {
    struct Constants {
        enum Colour: String {
            case backgroundColour = "quiz_bgColor"
            case cellColour = "cellColour"
            case textColour = "textColour"
            case spinnerBackground = "spinnerBackground"
            case startButtonColour = "startButtonColour"
            case resultButtonColour = "resultButtonColour"
        }
    }
}
