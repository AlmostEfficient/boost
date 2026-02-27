import SwiftUI

enum Theme {
    static let bg = Color(red: 0.05, green: 0.05, blue: 0.07)
    static let card = Color(red: 0.10, green: 0.10, blue: 0.13)
    static let cardElevated = Color(red: 0.16, green: 0.16, blue: 0.20)
    static let secondary = Color.white.opacity(0.45)
    static let tertiary = Color.white.opacity(0.22)
    static let separator = Color.white.opacity(0.07)

    static func accent(for color: StackColor) -> Color {
        switch color {
        case .performance: return Color(red: 0.25, green: 0.58, blue: 1.0)
        case .reset:       return Color(red: 1.0, green: 0.68, blue: 0.22)
        case .social:      return Color(red: 0.62, green: 0.88, blue: 0.72)
        case .behavioural: return Color.white.opacity(0.30)
        case .daily:       return Color.white
        }
    }

    static func accentSubtle(for color: StackColor) -> Color {
        accent(for: color).opacity(0.08)
    }

    static func accentMid(for color: StackColor) -> Color {
        accent(for: color).opacity(0.18)
    }
}
