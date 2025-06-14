# TestTask iOS Application

A SwiftUI-based iOS application demonstrating user registration and management functionality using a clean MVVM architecture.

---

## 📽 Screencast

Click on the image below to watch the screencast of the app on iPhone 13:

[![Watch the screencast]](https://drive.google.com/drive/folders/1LSOxYOQRh89BLYSJl6xUoAeF2EoRRQ53?usp=drive_link)


---

## 📱 Features

* **User List**: Paginated display of users with infinite scroll.
* **User Registration**: Form with validation for name, email, phone, position, and photo.
* **Photo Upload**: Action sheet for Camera, Gallery, or Cancel; integration with `UIImagePickerController`.
* **Offline Support**: Network reachability detection and "No Internet" view.
* **Form Validation**: Real-time feedback using `ValidationService`.
* **Keyboard Management**: Seamless keyboard handling via IQKeyboardManager.

---

## 🛠 Dependencies & Requirements

* **iOS**: 15.0+
* **Xcode**: 14.0+
* **Swift**: 5.7+

### External Libraries

| Library                | Purpose                         |
| ---------------------- | ------------------------------- |
| Alamofire              | HTTP networking & JSON decoding |
| IQKeyboardManagerSwift | Automatic keyboard dismissal    |

---

## 🏗 Architecture

The app follows **MVVM** with a dedicated Networking layer:

```
Views (SwiftUI)
   ↓
ViewModels (Combine)
   ↓
Models (Decodable)
   ↑
Services (Alamofire)
```

**Folder Structure**:

```
TestTask/
├── Models/                 # Data models & API responses
├── ViewModels/             # Business logic & state management
├── Views/                  # SwiftUI components & screens
├── Services/               # NetworkService & NetworkMonitor
├── Extensions/             # Utility extensions (e.g. Validation, UIColor)
└── TestTaskApp.swift       # App entry point & configuration
```

---

## 🔧 Installation & Setup

1. **Clone the repository**:

   ```bash
   git clone https://github.com/yourusername/TestTask-iOS.git
   cd TestTask-iOS
   ```

2. **Install dependencies** via Swift Package Manager:

   * In Xcode: **File → Add Packages...**
   * Add:

     * `https://github.com/Alamofire/Alamofire.git`
     * `https://github.com/hackiftekhar/IQKeyboardManager.git`

3. **Open and run**:

   * Open `TestTask.xcodeproj`
   * Select your development team
   * Build & Run (⌘R)

---

## 🔍 API Documentation

**Base URL**: `https://frontend-test-assignment-api.abz.agency/api/v1`

| Method | Endpoint                           | Description                       | Auth  |
| ------ | ---------------------------------- | --------------------------------- | ----- |
| GET    | `/users?page={page}&count={count}` | Fetch paginated users             | None  |
| GET    | `/positions`                       | Fetch list of positions           | None  |
| GET    | `/token`                           | Fetch one-time registration token | None  |
| POST   | `/users`                           | Register new user (multipart)     | Token |

### API Models

* **User**:

  ```json
  {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "+380123456789",
    "position_id": 1,
    "photo": "https://...",
    "registration_timestamp": 1640995200
  }
  ```

* **Position**:

  ```json
  {"id": 2, "name": "Designer"}
  ```

---

## 🧪 Testing

* **Unit Tests**:

  ```bash
  xcodebuild test -scheme TestTask -destination 'platform=iOS Simulator,name=iPhone 14'
  ```
* **Coverage**:

  * ViewModels & Validation
  * NetworkService via mocks

---

## 📝 Time & Challenges

| Issue                         | Time Spent | Summary                                    |
| ----------------------------- | ---------- | ------------------------------------------ |
| Token header format           | \~1 h      | Removed "Bearer " prefix in NetworkService |
| Dark/Light mode inconsistency | \~10 min   | Locked app to light mode                   |
| Keyboard dismissal            | \~10 min   | Integrated IQKeyboardManager               |
| Architecture & DI             | \~2 h      | Added protocols, DI, ValidationService     |

---

## 🔒 Security & Performance

* All communications over HTTPS.
* Input validation to prevent malformed data.
* Combine subscriptions managed to avoid memory leaks.
* Pagination and request cancellation for large lists.

---

**License**: For demonstration purposes.

**Last Updated:** June 2025
