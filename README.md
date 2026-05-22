# 🍅 FocusTomato

一个基于番茄工作法的专注计时工具，帮助用户提升工作效率，培养专注习惯。

[![Version](https://img.shields.io/badge/version-1.0-blue.svg)](https://github.com)
[![Platform](https://img.shields.io/badge/platform-iOS-blue.svg)](https://developer.apple.com/ios/)
[![Swift Version](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## ✨ 功能特性

- **专注计时**：标准番茄工作法，25分钟专注周期
- **智能休息**：短休息5分钟，长休息15分钟，每4个番茄后自动长休息
- **进度可视化**：圆形进度环实时显示时间进度
- **本地通知**：计时结束推送通知提醒
- **数据统计**：记录每日和累计专注时长
- **自定义设置**：灵活调整专注/休息时长
- **深色模式**：自动适配系统外观偏好
- **数据持久化**：使用 SwiftData 安全存储记录

## 🛠️ 技术栈

| 组件 | 技术 | 版本要求 |
|------|------|----------|
| 平台 | iOS | 17.0+ |
| 语言 | Swift | 5.9+ |
| UI框架 | SwiftUI | 5.0+ |
| 数据存储 | SwiftData | - |
| 通知服务 | UserNotifications | - |

## 📁 项目结构

```
FocusTomato/
├── FocusTomato/
│   ├── Assets.xcassets/       # 资源文件（图标等）
│   ├── FocusTomatoApp.swift   # App 入口
│   ├── ContentView.swift      # 主界面组件
│   ├── Item.swift             # 数据模型定义
│   ├── TimerManager.swift     # 计时器管理逻辑
│   └── NotificationManager.swift # 通知管理
├── FocusTomatoTests/          # 单元测试
├── FocusTomatoUITests/        # UI 测试
└── FocusTomato.xcodeproj/     # Xcode 项目配置
```

## 📱 界面预览

| 功能 | 描述 |
|------|------|
| 计时器界面 | 大字体显示剩余时间，圆形进度环动画 |
| 状态切换 | 一键切换专注/短休/长休模式 |
| 设置面板 | 自定义时长和偏好设置 |
| 统计信息 | 今日完成番茄数和累计统计 |

## 🚀 快速开始

### 环境要求

- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### 安装运行

1. 克隆或下载项目代码
2. 使用 Xcode 打开 `FocusTomato.xcodeproj`
3. 选择目标设备或模拟器
4. 点击 Run 按钮启动应用

## 🎯 使用指南

1. **开始专注**：点击「开始」按钮启动计时器
2. **暂停/继续**：点击「暂停」按钮暂停，再次点击继续
3. **重置计时**：点击「重置」按钮恢复默认时间
4. **切换模式**：点击「专注」「短休」「长休」切换状态
5. **查看设置**：点击齿轮图标进入设置页面

## 🔧 设置选项

| 设置项 | 默认值 | 范围 |
|--------|--------|------|
| 专注时长 | 25分钟 | 1-60分钟 |
| 短休息时长 | 5分钟 | 1-15分钟 |
| 长休息时长 | 15分钟 | 10-30分钟 |
| 长休息间隔 | 4个番茄 | 1-10个 |
| 自动开始休息 | 开启 | - |
| 音效 | 开启 | - |
| 振动 | 开启 | - |

## 📊 数据统计

- **今日统计**：显示当天完成的番茄数量
- **累计统计**：显示所有历史完成的番茄数量
- **历史记录**：使用 SwiftData 持久化存储所有专注记录

## 📝 更新日志

### v1.0.0 (2026-05-22)

- ✅ 基础计时功能
- ✅ 专注/休息状态切换
- ✅ 本地通知提醒
- ✅ 今日统计显示
- ✅ 深色/浅色模式支持
- ✅ 自定义时长设置

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

> 这是一个 vibe coding 练手项目 🍅

---

*Built with ❤️ using SwiftUI*
