import Foundation

enum DataLoader {
    static func load() -> BoostData {
        BoostData(
            supplements: supplements,
            stacks: stacks,
            timeDefaults: timeDefaults,
            contextModifiers: contextModifiers
        )
    }
}

// MARK: - Supplements

private let supplements: [String: Supplement] = [
    "alpha_gpc":     .init(name: "Alpha GPC",                   dose: "300mg",    category: .cholinergic,        notes: "Take with food if possible"),
    "alcar":         .init(name: "Acetyl L-Carnitine",           dose: "500mg",    category: .cholinergicSupport),
    "l_tyrosine":    .init(name: "L-Tyrosine",                   dose: "500mg",    category: .dopaminergic),
    "l_theanine":    .init(name: "L-Theanine",                   dose: "400mg",    category: .calming),
    "rhodiola":      .init(name: "Rhodiola Rosea",               dose: "500mg",    category: .adaptogen,          cycling: .init(onDays: 5, offDays: 2)),
    "ttfd_b1":       .init(name: "TTFD B1",                      dose: "100mg",    category: .metabolic),
    "taurine":       .init(name: "Taurine",                      dose: "500mg",    category: .buffer),
    "nac":           .init(name: "NAC",                          dose: "600mg",    category: .antioxidant),
    "bacopa":        .init(name: "Bacopa Monnieri",              dose: "500mg",    category: .neuroplasticity,    notes: "Cumulative effect over weeks, take daily"),
    "lions_mane":    .init(name: "Lion's Mane",                  dose: "2100mg",   category: .neuroplasticity,    notes: "Cumulative effect, take daily"),
    "ginkgo":        .init(name: "Ginkgo Biloba",                dose: "1000mg",   category: .cerebralFlow),
    "magnesium":     .init(name: "Magnesium Glycinate",          dose: "400mg",    category: .calming),
    "creatine":      .init(name: "Creatine",                     dose: "5g",       category: .daily),
    "iron":          .init(name: "Ferro-F-Tab",                  dose: "310mg",    category: .daily,              notes: "Take fasted with orange juice"),
    "vitamin_c":     .init(name: "Vitamin C",                    dose: "500mg",    category: .daily),
    "collagen":      .init(name: "Marine Collagen",              dose: "standard", category: .daily,              notes: "Take with Vitamin C"),
    "hair_nails_skin": .init(name: "Blackmores Hair, Nails & Skin", dose: "1 tablet", category: .daily),
]

// MARK: - Stacks

private let stacks: [Stack] = [
    .init(id: "morning_baseline",  name: "Morning Baseline",  emoji: "🌅", state: .daily,       description: "First thing, fasted",                             triggerTimes: ["07:00", "08:00"],         supplements: ["iron"],                                                 notes: "Iron + OJ only. Nothing else competes with absorption."),
    .init(id: "daily_lunch",       name: "Daily Stack",       emoji: "🥗", state: .daily,       description: "With lunch, every day no matter what",             triggerTimes: ["12:00", "13:00"],         supplements: ["bacopa", "lions_mane", "nac", "ginkgo", "hair_nails_skin", "creatine", "collagen", "vitamin_c"]),
    .init(id: "deep_work",         name: "Deep Work",         emoji: "🔒", state: .performance, description: "Proactive, planned coding session",                 triggerTimes: ["09:00", "10:00", "14:00"], supplements: ["alpha_gpc", "alcar", "ttfd_b1", "l_tyrosine"],          optional: ["rhodiola"]),
    .init(id: "lock_in",           name: "Lock In",           emoji: "🚀", state: .performance, description: "Late urgent session — compensating for lost day",  triggerTimes: ["18:00", "19:00", "20:00"], supplements: ["alpha_gpc", "l_tyrosine", "taurine"],                   notes: "No Rhodiola this late. Keep it clean so you can sleep."),
    .init(id: "doom_loop_exit",    name: "Exit the Loop",     emoji: "⚡", state: .reset,       description: "Anxious, overthinking, want to get something done", triggerTimes: ["14:00", "15:00", "16:00"], supplements: ["l_theanine", "l_tyrosine"],                             notes: "Calms the noise, gives direction. Not a full performance stack."),
    .init(id: "screen_exit",       name: "Close the Laptop",  emoji: "🚪", state: .behavioural, description: "Stuck at screen, want to leave",                   triggerTimes: ["11:00", "15:00", "18:00"], supplements: [],                                                       notes: "No supplements. Just a nudge. Go outside."),
    .init(id: "sustained_output",  name: "Sustained Output",  emoji: "🔋", state: .performance, description: "Long day ahead, no crash, steady flow",            triggerTimes: ["09:00", "10:00"],         supplements: ["alpha_gpc", "rhodiola", "taurine", "alcar"]),
    .init(id: "dance_class",       name: "Dance Class",       emoji: "💃", state: .social,      description: "Bachata, movement, presence",                      triggerTimes: ["17:00", "18:00", "19:00"], supplements: ["l_theanine", "l_tyrosine"],                             optional: ["magnesium"]),
    .init(id: "night_out",         name: "Night Out",         emoji: "🌙", state: .social,      description: "Going out, rave, social event",                    triggerTimes: ["20:00", "21:00"],         supplements: ["l_theanine", "l_tyrosine", "magnesium"],                notes: "Magnesium helps with muscle fatigue if dancing hard."),
]

// MARK: - Time defaults

private let timeDefaults: [TimeDefault] = [
    .init(time: "07:00", defaultStack: "morning_baseline"),
    .init(time: "08:00", defaultStack: "morning_baseline"),
    .init(time: "12:00", defaultStack: "daily_lunch"),
    .init(time: "13:00", defaultStack: "daily_lunch"),
    .init(time: "14:00", defaultStack: "doom_loop_exit"),
    .init(time: "15:00", defaultStack: "doom_loop_exit"),
    .init(time: "16:00", defaultStack: "sustained_output"),
    .init(time: "18:00", defaultStack: "lock_in"),
    .init(time: "19:00", defaultStack: "dance_class"),
    .init(time: "20:00", defaultStack: "night_out"),
    .init(time: "21:00", defaultStack: "night_out"),
]

// MARK: - Context modifiers

private let contextModifiers: [ContextModifier] = [
    .init(id: "deep_work",    label: "Deep Work",        overridesStack: "deep_work"),
    .init(id: "doom_loop",    label: "Exit Doom Loop",   overridesStack: "doom_loop_exit"),
    .init(id: "lock_in",      label: "Lock In",          overridesStack: "lock_in"),
    .init(id: "dance",        label: "Dance / Movement", overridesStack: "dance_class"),
    .init(id: "night_out",    label: "Night Out",        overridesStack: "night_out"),
    .init(id: "leave_screen", label: "Close the Laptop", overridesStack: "screen_exit"),
]
