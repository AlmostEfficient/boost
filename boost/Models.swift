import Foundation

// MARK: - Top-level container

struct BoostData {
    let supplements: [String: Supplement]
    let stacks: [Stack]
    let timeDefaults: [TimeDefault]
    let contextModifiers: [ContextModifier]
}

// MARK: - Supplement

struct Supplement {
    let name: String
    let dose: String
    let category: SupplementCategory
    let notes: String?
    let cycling: CyclingInfo?

    init(name: String, dose: String, category: SupplementCategory, notes: String? = nil, cycling: CyclingInfo? = nil) {
        self.name = name
        self.dose = dose
        self.category = category
        self.notes = notes
        self.cycling = cycling
    }

    var purpose: String { category.purpose }
}

enum SupplementCategory {
    case cholinergic, cholinergicSupport, dopaminergic, calming
    case adaptogen, metabolic, buffer, antioxidant
    case neuroplasticity, cerebralFlow, daily

    var purpose: String {
        switch self {
        case .cholinergic:        return "Acetylcholine synthesis"
        case .cholinergicSupport: return "Supports cholinergic function"
        case .dopaminergic:       return "Dopamine precursor"
        case .calming:            return "Calms the nervous system"
        case .adaptogen:          return "Stress adaptation"
        case .metabolic:          return "Metabolic cofactor"
        case .buffer:             return "Cellular buffer"
        case .antioxidant:        return "Antioxidant protection"
        case .neuroplasticity:    return "Long-term brain growth"
        case .cerebralFlow:       return "Cerebral blood flow"
        case .daily:              return "Daily foundational"
        }
    }
}

struct CyclingInfo {
    let onDays: Int
    let offDays: Int
}

// MARK: - Stack

struct Stack: Identifiable {
    let id: String
    let name: String
    let emoji: String
    let state: StackState
    let description: String
    let triggerTimes: [String]
    let supplements: [String]
    let optional: [String]?
    let notes: String?

    init(
        id: String, name: String, emoji: String, state: StackState,
        description: String, triggerTimes: [String], supplements: [String],
        optional: [String]? = nil, notes: String? = nil
    ) {
        self.id = id; self.name = name; self.emoji = emoji; self.state = state
        self.description = description; self.triggerTimes = triggerTimes
        self.supplements = supplements; self.optional = optional; self.notes = notes
    }

    var isBehavioural: Bool { state == .behavioural }

    var accentColor: StackColor {
        switch state {
        case .performance: return .performance
        case .reset:       return .reset
        case .social:      return .social
        case .behavioural: return .behavioural
        case .daily:       return .daily
        }
    }
}

enum StackState: Equatable {
    case performance, reset, social, behavioural, daily

    var label: String {
        switch self {
        case .performance: return "PERFORMANCE"
        case .reset:       return "RESET"
        case .social:      return "SOCIAL"
        case .behavioural: return "BEHAVIOURAL"
        case .daily:       return "DAILY"
        }
    }
}

// MARK: - Time default

struct TimeDefault {
    let time: String
    let defaultStack: String
}

// MARK: - Context modifier

struct ContextModifier: Identifiable {
    let id: String
    let label: String
    let overridesStack: String
}

// MARK: - Stack color (for theming)

enum StackColor {
    case performance, reset, social, behavioural, daily
}
