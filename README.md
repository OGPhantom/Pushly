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
<p align="center">
  <img width="350" height="1311" alt="IMG_1823" src="https://github.com/user-attachments/assets/c97226d2-ec3b-4fa0-aedb-63358db33f99"/>
  <img width="350" height="1311" alt="IMG_1862" src="https://github.com/user-attachments/assets/d435fee8-1c60-4a0c-8eaa-8f838b3d2353" />
</p>

### 🎥 Workout & Summary
<p align="center">
  <img width="350" height="1311" alt="IMG_1872" src="https://github.com/user-attachments/assets/bb2e7b08-9b7e-4915-ac57-dcbeaa5d6290" />
  <img width="350" height="1311" alt="IMG_1873" src="https://github.com/user-attachments/assets/f96838e9-cabc-48ec-a547-d738c651847e" />
  <img width="350" height="1311" alt="IMG_1866" src="https://github.com/user-attachments/assets/9e046df2-2267-46ce-90a5-f85bac239ee7" />
  <img width="350" height="1311" alt="IMG_1867" src="https://github.com/user-attachments/assets/c674e70f-d5dd-4039-8f44-3a258c6c99e2" />
  <img width="350" height="1311" alt="IMG_1868" src="https://github.com/user-attachments/assets/016950f9-7d37-4b87-9a8f-f92c27e65374" />
</p>

### 📈 History
<p align="center">
  <img width="350" height="1311" alt="IMG_1824" src="https://github.com/user-attachments/assets/617ccdcf-d086-4124-978b-070f49861627" />
  <img width="350" height="1311" alt="IMG_1863" src="https://github.com/user-attachments/assets/486ce673-058f-4a64-b138-989ab6f0197b" />
  <img width="350" height="1311" alt="IMG_1864" src="https://github.com/user-attachments/assets/0742707f-0853-4114-bde8-7fcbe150c5d2" />
  <img width="350" height="1311" alt="IMG_1865" src="https://github.com/user-attachments/assets/e81b4aa3-b6f1-48bc-9aef-ded02a37018c" />
</p>  

### 🎯 📆 Calendar
<p align="center">
  <img width="350" height="1311" alt="IMG_1825" src="https://github.com/user-attachments/assets/d34a833f-cef5-4df8-baaa-af58d899e6b7" />
  <img width="350" height="1311" alt="IMG_1869" src="https://github.com/user-attachments/assets/f0740650-2cbe-41c3-b5ce-df2121ba8310" />
</p>

### 🎯 Goals
<p align="center">
  <img width="350" height="1311" alt="IMG_1826" src="https://github.com/user-attachments/assets/b5a19bea-9b69-4782-b6c9-68c452332fc6" />
  <img width="350" height="1311" alt="IMG_1871" src="https://github.com/user-attachments/assets/2a60eaaf-fa6b-474f-8518-bb55fcff2fb9" />
</p>

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
