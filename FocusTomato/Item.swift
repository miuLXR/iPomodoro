import Foundation
import SwiftData

@Model
final class TomatoRecord {
    let id: UUID
    let date: Date
    let duration: Int
    let taskName: String?
    let isCompleted: Bool
    
    init(id: UUID = UUID(), date: Date = Date(), duration: Int, taskName: String? = nil, isCompleted: Bool = true) {
        self.id = id
        self.date = date
        self.duration = duration
        self.taskName = taskName
        self.isCompleted = isCompleted
    }
}

struct UserSettings: Codable, Equatable {
    var focusDuration: Int = 25
    var shortBreakDuration: Int = 5
    var longBreakDuration: Int = 15
    var soundEnabled: Bool = true
    var vibrationEnabled: Bool = true
    var autoStartBreak: Bool = true
    var longBreakInterval: Int = 4
}

enum TimerState {
    case idle, running, paused
}

enum SessionType {
    case focus, shortBreak, longBreak
}
