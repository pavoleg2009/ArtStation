import UIKit

struct AppFont {
    
    private struct AppCustomFontNames {
        static let openSansLight = "OpenSans-Light"
        static let openSansRegular = "OpenSans"
        static let openSansSemibold = "OpenSans-Semibold"
        static let openSansBold = "OpenSans-Bold"
    }
    
    static func brandLight(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppCustomFontNames.openSansLight, size: size)
            ?? UIFont.systemFont(ofSize: size, weight: .light)
    }
    
    static func brandRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppCustomFontNames.openSansRegular, size: size)
            ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    static func brandSemibold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppCustomFontNames.openSansSemibold, size: size)
            ?? UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    static func brandBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppCustomFontNames.openSansBold, size: size)
            ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    /*
    // 100    Thin (Hairline)
    // 200    Extra Light (Ultra Light)
    // 300    Light
    // 400    Normal
    // 500    Medium
    // 600    Semi Bold (Demi Bold)
    // 700    Bold
    // 800    Extra Bold (Ultra Bold)
    // 900    Black (Heavy)
    */
}
