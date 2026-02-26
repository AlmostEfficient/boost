import SwiftUI

enum Theme {
    static let bg = Color(red: 0.06, green: 0.06, blue: 0.07)
    static let card = Color(red: 0.11, green: 0.11, blue: 0.13)
    static let cardElevated = Color(red: 0.16, green: 0.16, blue: 0.19)
    static let secondary = Color.white.opacity(0.4)
    static let tertiary = Color.white.opacity(0.2)
    static let separator = Color.white.opacity(0.08)

    static func accent(for color: StackColor) -> Color {
        switch color {
        case .performance: return Color(red: 0.29, green: 0.62, blue: 1.0)
        case .reset: return Color(red: 1.0, green: 0.70, blue: 0.28)
        case .social: return Color(red: 0.71, green: 0.50, blue: 1.0)
        case .behavioural: return Color.white.opacity(0.30)
        case .daily: return Color.white
        }
    }
}
