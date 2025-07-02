# FCM Flutter App

Ứng dụng Flutter demo với Firebase Cloud Messaging (FCM) tích hợp để nhận thông báo push.

## Tính năng

- **Đăng ký FCM Token**: Lấy và hiển thị FCM token từ cả Android native code và Flutter
- **Lắng nghe thông báo**: Xử lý thông báo khi app đang mở, nền, và đã đóng
- **Hiển thị thông báo**: Tự động hiển thị notification trên Android
- **Subscribe topic**: Tự động đăng ký topic "general" để nhận thông báo chung
- **History**: Lưu và hiển thị lịch sử các thông báo đã nhận

## Cài đặt

### 1. Cài đặt dependencies

```bash
flutter pub get
```

### 2. Cấu hình Firebase

1. Tạo project trên [Firebase Console](https://console.firebase.google.com/)
2. Thêm Android app với package name: `com.example.start_service_flutter`
3. Tải file `google-services.json` và đặt vào `android/app/`
4. Cập nhật `lib/firebase_options.dart` với thông tin từ Firebase Console

### 3. Chạy ứng dụng

```bash
flutter run
```

## Kiến trúc

### Android Native (MainActivity.kt)

- **FCM Token**: Method channel để lấy FCM token từ native Android
- **Background service**: `MyFirebaseMessagingService` xử lý thông báo background
- **Topic subscription**: Tự động subscribe topic "general"

### Flutter (main.dart)

- **Foreground messages**: Lắng nghe và hiển thị dialog cho thông báo foreground
- **Background messages**: Xử lý thông báo background với top-level function
- **Token management**: Quản lý và refresh FCM token
- **UI**: Hiển thị token, thông báo cuối và lịch sử

## Cách sử dụng

### 1. Lấy FCM Token

- Token sẽ tự động hiển thị khi mở app
- Nhấn nút copy để sao chép token
- Nhấn nút refresh để lấy lại token

### 2. Gửi thông báo test

Sử dụng Firebase Console hoặc API để gửi thông báo:

#### Firebase Console:
1. Vào Cloud Messaging trong Firebase Console
2. Chọn "Send your first message"
3. Nhập title và body
4. Chọn target: Token (dán FCM token) hoặc Topic (nhập "general")

#### API (curl):
```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "FCM_TOKEN_HERE",
    "notification": {
      "title": "Test Notification",
      "body": "This is a test message"
    },
    "data": {
      "key1": "value1",
      "key2": "value2"
    }
  }'
```

### 3. Test các trường hợp

- **Foreground**: App đang mở → Hiển thị dialog
- **Background**: App ở background → Hiển thị notification
- **Terminated**: App đã đóng → Nhấn notification để mở app

## Files quan trọng

- `lib/main.dart`: Flutter FCM implementation
- `android/app/src/main/kotlin/.../MainActivity.kt`: Android native FCM
- `android/app/src/main/kotlin/.../MyFirebaseMessagingService.kt`: Background service
- `android/app/src/main/AndroidManifest.xml`: Permissions và service registration
- `lib/firebase_options.dart`: Firebase configuration
- `android/app/google-services.json`: Firebase Android config

## Troubleshooting

### Không nhận được thông báo

1. Kiểm tra token có đúng không
2. Kiểm tra internet connection
3. Kiểm tra Firebase project configuration
4. Kiểm tra app permissions

### Build errors

1. Chạy `flutter clean && flutter pub get`
2. Kiểm tra `google-services.json` đã được đặt đúng vị trí
3. Kiểm tra Firebase plugin đã được thêm vào `android/build.gradle.kts`

### Token null hoặc empty

1. Kiểm tra Google Play Services đã được cài đặt
2. Kiểm tra device có kết nối internet
3. Restart app và thử lại

## Next Steps

- Thêm FCM cho iOS
- Implement custom notification UI
- Thêm local database để lưu messages
- Thêm user authentication
- Implement targeted messaging
