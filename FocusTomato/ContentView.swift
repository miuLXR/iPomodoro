import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TomatoRecord.date, order: .reverse) private var records: [TomatoRecord]
    @StateObject private var timerManager = TimerManager()
    @State private var showingSettings = false
    @State private var settings = UserSettings()
    @State private var currentTask: String = ""
    
    private var todayRecords: [TomatoRecord] {
        let calendar = Calendar.current
        return records.filter { calendar.isDateInToday($0.date) }
    }
    
    private var totalRecords: Int {
        records.count
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Text("FocusTomato")
                    .font(.system(size: 34, weight: .bold))
                
                ZStack {
                    Circle()
                        .stroke(Color(uiColor: .systemGray5), lineWidth: 12)
                        .frame(width: 280, height: 280)
                    
                    Circle()
                        .trim(from: 0, to: 1 - timerManager.progress)
                        .stroke(accentColor, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .frame(width: 280, height: 280)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: timerManager.progress)
                    
                    Text(timerManager.formattedTime)
                        .font(.caption)
                }
                
                HStack(spacing: 20) {
                    if timerManager.timerState == .running {
                        Button(action: pauseTimer) {
                            Label("暂停", systemImage: "pause.fill")
                                .font(.system(size: 17, weight: .medium))
                                .padding(.horizontal, 30)
                                .padding(.vertical, 15)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(25)
                        }
                    } else {
                        Button(action: startTimer) {
                            Label("开始", systemImage: "play.fill")
                                .font(.system(size: 17, weight: .medium))
                                .padding(.horizontal, 30)
                                .padding(.vertical, 15)
                                .background(accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(25)
                        }
                    }
                    
                    Button(action: resetTimer) {
                        Label("重置", systemImage: "arrow.clockwise")
                            .font(.system(size: 17, weight: .medium))
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            .background(Color(uiColor: .systemGray5))
                            .foregroundColor(.primary)
                            .cornerRadius(25)
                    }
                }
                
                HStack(spacing: 15) {
                    SessionButton(title: "专注", type: .focus, currentType: timerManager.sessionType, action: { switchSession(to: .focus) })
                    SessionButton(title: "短休", type: .shortBreak, currentType: timerManager.sessionType, action: { switchSession(to: .shortBreak) })
                    SessionButton(title: "长休", type: .longBreak, currentType: timerManager.sessionType, action: { switchSession(to: .longBreak) })
                }
                
                if !currentTask.isEmpty {
                    HStack {
                        Image(systemName: "checklist")
                        Text("当前任务：\(currentTask)")
                            .font(.system(size: 16))
                    }
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Divider()
                
                HStack {
                    HStack {
                        Image(systemName: "timer")
                        Text("今日 \(todayRecords.count)")
                            .font(.system(size: 17, weight: .medium))
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "chart.bar.fill")
                        Text("总计 \(totalRecords)")
                            .font(.system(size: 17, weight: .medium))
                    }
                    
                    Spacer()
                    
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gear")
                            .font(.system(size: 20))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
            }
            .padding()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView(settings: $settings)
        }
        .onAppear {
            NotificationManager.shared.requestAuthorization()
            loadSettings()
        }
        .onChange(of: settings) { _, newSettings in
            saveSettings()
            timerManager.updateSettings(newSettings)
        }
    }
    
    private var accentColor: Color {
        switch timerManager.sessionType {
        case .focus:
            return Color(red: 255/255, green: 107/255, blue: 107/255)
        case .shortBreak, .longBreak:
            return Color(red: 78/255, green: 205/255, blue: 196/255)
        }
    }
    
    private func startTimer() {
        timerManager.start()
        NotificationManager.shared.scheduleNotification(for: timerManager.sessionType, in: TimeInterval(timerManager.timeRemaining))
        if timerManager.sessionType == .focus && timerManager.timerState == .idle {
            let record = TomatoRecord(date: Date(), duration: settings.focusDuration, taskName: currentTask.isEmpty ? nil : currentTask)
            modelContext.insert(record)
        }
    }
    
    private func pauseTimer() {
        timerManager.pause()
        NotificationManager.shared.cancelAllNotifications()
    }
    
    private func resetTimer() {
        timerManager.reset()
        NotificationManager.shared.cancelAllNotifications()
    }
    
    private func switchSession(to type: SessionType) {
        timerManager.switchSession(to: type)
        NotificationManager.shared.cancelAllNotifications()
    }
    
    private func saveSettings() {
        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: "UserSettings")
        }
    }
    
    private func loadSettings() {
        if let data = UserDefaults.standard.data(forKey: "UserSettings"),
           let loadedSettings = try? JSONDecoder().decode(UserSettings.self, from: data) {
            settings = loadedSettings
            timerManager.updateSettings(loadedSettings)
        }
    }
}

struct SessionButton: View {
    let title: String
    let type: SessionType
    let currentType: SessionType
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(currentType == type ? accentColor : Color(uiColor: .systemGray5))
                .foregroundColor(currentType == type ? .white : .primary)
                .cornerRadius(20)
        }
    }
    
    private var accentColor: Color {
        switch type {
        case .focus:
            return Color(red: 255/255, green: 107/255, blue: 107/255)
        case .shortBreak, .longBreak:
            return Color(red: 78/255, green: 205/255, blue: 196/255)
        }
    }
}

struct SettingsView: View {
    @Binding var settings: UserSettings
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("专注时长") {
                    Stepper("\(settings.focusDuration) 分钟", value: $settings.focusDuration, in: 1...60)
                }
                
                Section("休息时长") {
                    Stepper("短休息 \(settings.shortBreakDuration) 分钟", value: $settings.shortBreakDuration, in: 1...15)
                    Stepper("长休息 \(settings.longBreakDuration) 分钟", value: $settings.longBreakDuration, in: 10...30)
                }
                
                Section("长休息间隔") {
                    Stepper("每 \(settings.longBreakInterval) 个番茄后长休息", value: $settings.longBreakInterval, in: 1...10)
                }
                
                Section("偏好设置") {
                    Toggle("自动开始休息", isOn: $settings.autoStartBreak)
                    Toggle("音效", isOn: $settings.soundEnabled)
                    Toggle("振动", isOn: $settings.vibrationEnabled)
                }
            }
            .navigationTitle("设置")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TomatoRecord.self, inMemory: true)
}
