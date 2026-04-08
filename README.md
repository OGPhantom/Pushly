# 💪 Pushly
A **privacy-first, on-device computer-vision push-up tracker for iOS** built with **SwiftUI**, **SwiftData**, **Vision**, **AVFoundation**, and **Charts**.  
Track your **push-up workouts in real time**, monitor **form and pace**, and review your **history, goals, and progress analytics** without sending workout data off your device.

---

### 📌 Short Description

Pushly is a focused iOS fitness app built for **camera-based push-up tracking**, **daily goal consistency**, and **clear progress analytics**.  
It uses on-device body pose detection to count reps, estimate form quality, and generate workout summaries with metrics like **reps, duration, tempo, calories, and technique score**.
The app also helps users stay consistent with a **daily goal system**, a **goal calendar**, and a **history dashboard** that visualizes training data across multiple time ranges, from **hourly activity in a single day** to **monthly and all-time trends**.

---

### 🚀 Why Pushly

- 💪 Real-time push-up tracking powered by on-device pose detection
- 🔒 Privacy-first workout analysis with no cloud dependency
- 📈 Clear history, goals, and trend visualizations built for consistency

---

## 📹 App Demo

[Watch Demo](https://drive.google.com/file/d/1DS-_RLZoa4aEnERgZR2TkOTgi4eVLgGB/view?usp=sharing)

---

## 📸 Screenshots

### 🏠 Home
Add home screen screenshots here.

### 🎥 Workout & Summary
Add workout tracking and session summary screenshots here.

### 📈 History
Add history, analytics, and chart screenshots here.

### 🎯 Goals
Add goal settings and goal calendar screenshots here.

---

## ✨ Features

- 🎥 **Camera-based push-up tracking** using on-device body pose detection
- 🔢 Real-time **rep counting**, **timer tracking**, and **workout state management**
- 🧠 Post-workout **technique and pacing summary** with visual feedback
- 📆 Set and update a **daily push-up goal**
- 🗓 Track goal completion in a dedicated **calendar view**
- 📊 Explore workout history with **period-based analytics**
- 🏃 Review session metrics like **reps, duration, pace, calories, and form score**
- 💾 Store workout sessions locally with **SwiftData**
- 🌙 Custom polished **dark UI** optimized for a focused training experience
- 📱 Optional body tracking debug overlay
- 📹 Zero-rep workout protection

---

## 🛠️ Tech Stack

iOS
- **SwiftUI**
- **SwiftData**
- **Charts**
- **AVFoundation**
- **Vision**
- **AppStorage**

Architecture & UI
- **MVVM-style state organization**
- **Observation (`@Observable`)**
- **Native iOS design patterns**
- **SF Symbols**

---

## 📄 Requirements

- Xcode 26+
- iOS 26+
- Camera access for workout tracking features

---

## 🚀 Installation

1. Clone the repository.
2. Open `Pushly.xcodeproj` in Xcode.
3. Build and run on an iPhone simulator or physical device.
4. Grant **camera permission** to use real-time push-up tracking.

---

## 🧠 Notes

- Workout sessions are stored locally with **SwiftData**.
- Daily goal preferences are persisted on-device.
- Push-up tracking depends on camera availability and permission status.
- Pose detection and rep analysis run **entirely on-device**.
- If camera access is unavailable, history and goal-tracking parts of the app remain accessible.
