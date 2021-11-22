import UIKit

extension UIColor {
    static func setRGBA(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        //The "static"  allows to use this methods with UIColor class. For example: UIColor.rgb(...)
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
    
    static func customBlue() -> UIColor {
        return .setRGBA(red: 17, green: 154, blue: 237)
    }
    
    static func customLightBlue() -> UIColor {
        return .setRGBA(red: 149, green: 204, blue: 244)
    }
    
    static func customGray() -> UIColor {
        return .setRGBA(red: 230, green: 230, blue: 230)
    }
    
}
