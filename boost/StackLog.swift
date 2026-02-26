import Foundation
import SwiftData

@Model
final class StackLog {
    var stackId: String
    var stackName: String
    var stackEmoji: String
    var supplementNames: [String]
    var timestamp: Date

    init(
        stackId: String,
        stackName: String,
        stackEmoji: String,
        supplementNames: [String],
        timestamp: Date = .now
    ) {
        self.stackId = stackId
        self.stackName = stackName
        self.stackEmoji = stackEmoji
        self.supplementNames = supplementNames
        self.timestamp = timestamp
    }
}
