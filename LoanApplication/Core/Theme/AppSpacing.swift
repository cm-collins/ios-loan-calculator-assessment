import SwiftUI

enum AppSpacing {
    static var screenHorizontal: CGFloat {
        responsive(16)
    }

    static var headerHeight: CGFloat {
        responsive(130)
    }

    static var loanCardHeight: CGFloat {
        responsive(150)
    }

    static var loanCardCornerRadius: CGFloat {
        responsive(6)
    }

    static var loanCardImageWidth: CGFloat {
        responsive(128)
    }

    static var loanCardImageHeight: CGFloat {
        responsive(128)
    }

    static var activeLoanCardHeight: CGFloat {
        responsive(190)
    }

    static func responsive(_ value: CGFloat) -> CGFloat {
        let designWidth: CGFloat = 375
        let screenWidth = UIScreen.main.bounds.width
        let scale = screenWidth / designWidth

        // Keep scaling controlled so UI does not become too huge on bigger iPhones.
        let clampedScale = min(max(scale, 0.92), 1.06)

        return value * clampedScale
    }
}
