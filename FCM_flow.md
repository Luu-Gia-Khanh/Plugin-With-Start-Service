# Luồng Đăng Ký và Nhận FCM Message ở Flutter & Android Native (Cả 2 Cùng Nhận)

## 1. Đăng ký FCM ở Flutter

- **Khởi tạo Firebase** trong `main.dart`:
  ```dart
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  ```
- **Đăng ký handler nhận message:**
  - Foreground:  
    ```dart
    FirebaseMessaging.onMessage.listen((RemoteMessage message) { ... });
    ```
  - Background/Terminated:  
    ```dart
    @pragma('vm:entry-point')
    Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async { ... }
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    ```

## 2. Đăng ký FCM ở Android Native

- **Khai báo service trong AndroidManifest.xml:**
  ```xml
  <service
      android:name=".MyFirebaseMessagingService"
      android:exported="false">
      <intent-filter>
          <action android:name="com.google.firebase.MESSAGING_EVENT" />
      </intent-filter>
  </service>
  ```
  > Nếu service nằm ở package khác, dùng tên đầy đủ:  
  > `android:name="com.example.service_noti.MyFirebaseMessagingService"`

- **Kế thừa `FlutterFirebaseMessagingService` hoặc `FirebaseMessagingService`:**
  ```kotlin
  class MyFirebaseMessagingService : FlutterFirebaseMessagingService() {
      override fun onMessageReceived(remoteMessage: RemoteMessage) {
          super.onMessageReceived(remoteMessage) // Đảm bảo Flutter nhận được background message
          // Xử lý logic native ở đây
      }
  }
  ```

## 3. Luồng nhận message thực tế (với cấu hình hiện tại)

| Trạng thái app      | Flutter nhận (Dart) | Native nhận (Service) |
|---------------------|:-------------------:|:---------------------:|
| Foreground          |         ✅           |          ❌           |
| Background          |         ✅           |          ✅           |
| Terminated          |         ✅           |          ✅           |

- **Foreground:** Flutter nhận qua `onMessage`.
- **Background/Terminated:**  
  - **Flutter nhận** qua `_firebaseMessagingBackgroundHandler` (nhờ gọi `super.onMessageReceived` trong native).
  - **Native cũng nhận** qua `onMessageReceived` của service.

> **Lưu ý:**  
> - Để cả Flutter và native cùng nhận background message, bạn phải kế thừa `FlutterFirebaseMessagingService` và gọi `super.onMessageReceived(remoteMessage)` TRƯỚC khi xử lý logic native.
> - Nếu chỉ kế thừa `FirebaseMessagingService`, chỉ native nhận background message, Flutter không nhận.

---

## 4. Tổng kết

- **Cả Flutter và native đều nhận được background message** nếu dùng `FlutterFirebaseMessagingService` và gọi `super.onMessageReceived`.
- Đây là trường hợp đặc biệt, phù hợp khi bạn muốn vừa xử lý logic native, vừa muốn Flutter nhận background message (ví dụ: hiển thị notification native và đồng bộ dữ liệu lên Flutter).

---

## 5. Lưu ý về payload FCM

- **Để cả Flutter và native cùng nhận background message, payload FCM gửi xuống phải là dạng `data-only` (chỉ có trường `data`, KHÔNG có trường `notification`).**
- Nếu payload có trường `notification`, Android sẽ tự hiển thị notification và KHÔNG gọi vào service hoặc background handler của Flutter.

**Ví dụ đúng:**
```json
{
  "to": "<FCM_TOKEN>",
  "data": {
    "service_type": "background",
    "auto_start": "true",
    "title": "Test",
    "body": "This is a test message"
  }
}
```

**Ví dụ sai (KHÔNG dùng):**
```json
{
  "to": "<FCM_TOKEN>",
  "notification": {
    "title": "Test",
    "body": "This is a test message"
  },
  "data": {
    "service_type": "background"
  }
}
```

> **Chỉ dùng payload `data` để đảm bảo cả Flutter và native đều nhận được background message!**
