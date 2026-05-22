import Foundation
import SwiftUI

class TimerManager: ObservableObject {
    @Published var timeRemaining: Int
    @Published var timerState: TimerState = .idle
    @Published var sessionType: SessionType = .focus
    @Published var focusCount: Int = 0
    
    private var timer: Timer?
    private var settings: UserSettings
    private var totalDuration: Int = 0
    
    init(settings: UserSettings = UserSettings()) {
        self.settings = settings
        self.timeRemaining = settings.focusDuration * 60
        self.totalDuration = settings.focusDuration * 60
    }
    
    func start() {
        guard timerState != .running else { return }
        timerState = .running
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timerDidFinish()
            }
        }
    }
    
    func pause() {
        timerState = .paused
        timer?.invalidate()
        timer = nil
    }
    
    func reset() {
        pause()
        timerState = .idle
        timeRemaining = totalDuration
    }
    
    func switchSession(to type: SessionType) {
        pause()
        timerState = .idle
        sessionType = type
        
        switch type {
        case .focus:
            timeRemaining = settings.focusDuration * 60
            totalDuration = settings.focusDuration * 60
        case .shortBreak:
            timeRemaining = settings.shortBreakDuration * 60
            totalDuration = settings.shortBreakDuration * 60
        case .longBreak:
            timeRemaining = settings.longBreakDuration * 60
            totalDuration = settings.longBreakDuration * 60
        }
    }
    
    func updateSettings(_ newSettings: UserSettings) {
        self.settings = newSettings
        if timerState == .idle {
            switch sessionType {
            case .focus:
                timeRemaining = newSettings.focusDuration * 60
                totalDuration = newSettings.focusDuration * 60
            case .shortBreak:
                timeRemaining = newSettings.shortBreakDuration * 60
                totalDuration = newSettings.shortBreakDuration * 60
            case .longBreak:
                timeRemaining = newSettings.longBreakDuration * 60
                totalDuration = newSettings.longBreakDuration * 60
            }
        }
    }
    
    var progress: Double {
        guard totalDuration > 0 else { return 0 }
        return Double(timeRemaining) / Double(totalDuration)
    }
    
    var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func timerDidFinish() {
        pause()
        
        if sessionType == .focus {
            focusCount += 1
        }
        
        let nextSession: SessionType
        if sessionType == .focus {
            nextSession = (focusCount % settings.longBreakInterval == 0) ? .longBreak : .shortBreak
        } else {
            nextSession = .focus
        }
        
        switchSession(to: nextSession)
        
        if settings.autoStartBreak && sessionType != .focus {
            start()
        }
    }
}
