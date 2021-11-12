import UIKit

extension UIColor {
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1) -> UIColor {
        //The "static"  allows to use this methods with UIColor class. For example: UIColor.rgb(...)
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
    
    static func mainBlue() -> UIColor {
        return .rgb(17, 154, 237)
    }
}
