# Hermes App

Hermes AI Chat WebView สำหรับ iPhone

## ฟีเจอร์
- WebView แบบ full-screen แสดง Hermes Web UI
- Push notification จาก ntfy (ntfy.sh/AiMeet)
- ธีม iOS สไตล์ iMessage

## Build ด้วย GitHub Actions
- ไปที่ Actions tab → Run workflow
- ไฟล์ `.ipa` จะดาวน์โหลดได้จาก Artifacts

## Setup

```bash
flutter pub get
cd ios && pod install
```

## โฟลเดอร์

```
C:/Users/Apinan/ToolsHermes/repos/hermes_app/
├── lib/
│   ├── main.dart
│   └── notification_service.dart
├── ios/
├── .github/workflows/build-ios.yml
└── pubspec.yaml
```
