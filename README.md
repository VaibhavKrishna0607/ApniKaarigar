# ApnaKaarigar 🛕

**A Flutter marketplace app connecting Indian artisans with customers.**

ApnaKaarigar ("Your Artisan") is a full-stack cross-platform mobile and web application that empowers traditional Indian craftsmen — woodworkers, potters, weavers, metalworkers, and more — to showcase and sell their handcrafted products. Customers can browse the marketplace, discover unique handcrafted pieces, and place orders directly.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore%20%7C%20Auth%20%7C%20Storage-FFCA28?logo=firebase)](https://firebase.google.com)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green)]()

---

## Screenshots

> App runs on Android (tested on API 35 physical device + API 36 emulator) and Web (Chrome/Edge).

| Marketplace | My Products | Orders | AI Assistant |
|-------------|-------------|--------|--------------|
| Browse & search handcrafted products | Manage your product listings | Track order status in real time | AI-powered product & marketing help |

---

## Features

### For Artisans
- **Product Management** — Add, edit and manage product listings with photos, price, category, material, stock count, and auto-generated tags
- **Image Uploads** — Pick images from camera or gallery; uploads go directly to Firebase Storage
- **AI-Assisted Listings** — One-tap AI description generation and marketing content (social captions, pricing tips, shipping advice)
- **Order Dashboard** — View incoming orders filtered by status: New / Active / Done / All
- **Artisan Profile** — Shop name, bio, city, verification badge, profile photo

### For Customers
- **Marketplace** — Browse all available products from every artisan on the platform
- **Search & Filter** — Live search by name/description + filter by product category (Woodwork, Pottery, Textile, Metalwork, etc.)
- **Product Detail** — High-res images, full description, artisan info, and AI-generated content buttons
- **Order Placement** — Enter delivery details and place orders with quantity selection and total price display

### Platform & Infrastructure
- **Cross-platform** — Single codebase runs on Android, iOS, Web, Windows, macOS
- **Firebase Auth** — Email + password sign up / login with persistent sessions
- **Firestore** — Real-time NoSQL database with composite indexes for fast marketplace queries
- **Firebase Storage** — Secure image hosting under `artisans/{uid}/products/`
- **Offline Support** — Firestore persistence enabled on web for cached reads
- **AI Assistant** — Conversational chat UI for product copywriting and business tips

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| UI Framework | Flutter 3.x + Dart 3.x |
| State Management | `ChangeNotifier` (singleton services) |
| Authentication | Firebase Auth |
| Database | Cloud Firestore |
| File Storage | Firebase Storage |
| Image Picking | `image_picker` |
| ID Generation | `uuid` |
| AI Content | `AIService` (pluggable — ready for OpenAI / Gemini) |

---

## Project Structure

```
lib/
├── main.dart                  # App entry point, Firebase init, bottom nav
├── firebase_options.dart      # Firebase config per platform
├── theme/
│   └── app_theme.dart         # Colors, typography, shared theme
├── models/
│   ├── artisan.dart           # Artisan profile model
│   ├── product.dart           # Product listing model
│   └── order.dart             # Order model + OrderStatus enum
├── services/
│   ├── auth_service.dart      # Firebase Auth (sign up, login, logout)
│   ├── firestore_service.dart # All Firestore CRUD (singleton)
│   ├── storage_service.dart   # Firebase Storage image upload (web-safe)
│   ├── marketplace_service.dart # ChangeNotifier: all public products
│   ├── user_data_provider.dart  # ChangeNotifier: current user's data
│   ├── ai_service.dart        # AI description / marketing generation
│   └── demo_mode_service.dart # Offline demo mode without Firebase
└── screens/
    ├── auth_wrapper.dart        # Auth gate (logged in vs. login screen)
    ├── auth_screen.dart         # Login + Sign-up tabs
    ├── home_screen.dart         # Artisan dashboard (stats, quick actions)
    ├── marketplace_screen.dart  # Public marketplace (browse + search)
    ├── products_screen.dart     # Artisan's own product management
    ├── add_product_screen.dart  # Add/edit product form with AI assist
    ├── product_detail_screen.dart # Full product view
    ├── orders_screen.dart       # Order management (tabbed by status)
    ├── order_placement_screen.dart # Customer checkout form
    ├── ai_assistant_screen.dart # Chat-based AI assistant
    └── profile_screen.dart      # User profile + settings
```

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `>=3.0.0`
- [Firebase CLI](https://firebase.google.com/docs/cli) (for deploying rules/indexes)
- Android Studio / Xcode for mobile builds
- A Firebase project (see [Firebase setup](#firebase-setup))

### Installation

```bash
# Clone the repository
git clone https://github.com/VaibhavKrishna0607/ApniKaarigar.git
cd ApniKaarigar

# Install dependencies
flutter pub get
```

### Firebase Setup

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable **Authentication** → Email/Password
3. Enable **Cloud Firestore** in production mode
4. Enable **Firebase Storage**
5. Add your platform apps (Android / iOS / Web) and download config files:
   - `google-services.json` → `android/app/`
   - `GoogleService-Info.plist` → `ios/Runner/`
6. Update `lib/firebase_options.dart` with your project's config values

### Deploy Firestore Rules & Indexes

```bash
# Deploy security rules and composite indexes
firebase deploy --only firestore
```

The `firestore.rules` file allows artisans to write only their own data, while all authenticated users can read products. The `firestore.indexes.json` defines composite indexes required for marketplace queries (e.g. `isAvailable + createdAt`).

### Run

```bash
# Android (physical device or emulator)
flutter run -d <device-id>

# Web
flutter run -d chrome

# List connected devices
flutter devices
```

### Build

```bash
# Android APK (debug)
flutter build apk --debug

# Android APK (release)
flutter build apk --release

# Web
flutter build web
```

---

## Data Models

### Artisan
| Field | Type | Description |
|-------|------|-------------|
| `id` | String | Firebase UID |
| `name` | String | Full name |
| `email` | String | Login email |
| `phone` | String | Contact number |
| `shopName` | String | Display name of the shop |
| `shopDescription` | String | About the shop |
| `address`, `city`, `state` | String | Location |
| `specialties` | List\<String\> | Craft categories |
| `isVerified` | bool | Platform-verified badge |
| `profileImage` | String? | Firebase Storage URL |

### Product
| Field | Type | Description |
|-------|------|-------------|
| `id` | String | UUID |
| `artisanId` | String | Owner's UID |
| `name` | String | Product title |
| `description` | String | Full description |
| `price` | double | Price in INR |
| `category` | String | Woodwork, Pottery, Textile, etc. |
| `images` | List\<String\> | Firebase Storage URLs |
| `stock` | int | Available quantity |
| `material` | String | Primary material |
| `tags` | List\<String\> | Search tags |
| `isAvailable` | bool | Visible in marketplace |

### Order
| Field | Type | Description |
|-------|------|-------------|
| `id` | String | UUID |
| `productId` / `productName` | String | Ordered item |
| `artisanId` / `customerId` | String | Parties involved |
| `customerName`, `customerPhone` | String | Delivery contact |
| `deliveryAddress` | String | Shipping address |
| `quantity` | int | Number of units |
| `totalPrice` | double | Final amount |
| `status` | OrderStatus | pending → confirmed → processing → shipped → delivered |

---

## Firestore Security Rules

```js
// Artisans can only write their own profile and products.
// All authenticated users can read products and artisan profiles.
// Orders are accessible only to the artisan or the customer involved.
```

See [`firestore.rules`](firestore.rules) for the full ruleset.

---

## Firebase Storage CORS

Image uploads from web browsers require CORS to be configured on your Firebase Storage bucket. See [`storage.cors.json`](storage.cors.json) for the configuration. Apply it via the [Google Cloud Console](https://console.cloud.google.com/storage/browser) or with `gsutil`:

```bash
gsutil cors set storage.cors.json gs://<your-bucket>
```

---

## AI Assistant

The `AIService` currently uses template-based responses to simulate an AI assistant (no API key required). It supports:

- **Product description generation** — By category and material
- **Marketing content** — Instagram captions, hashtags, promotional copy
- **Pricing guidance** — Suggestions based on category
- **Product tags** — Auto-generated searchable keywords
- **Shipping advice** — Packaging tips for fragile handcrafts

To connect a real AI API (e.g. Google Gemini or OpenAI), replace the template logic in `lib/services/ai_service.dart` with your HTTP calls.

---

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m 'Add your feature'`
4. Push to the branch: `git push origin feature/your-feature`
5. Open a Pull Request

---

## License

This project is licensed under the MIT License.

---

## Acknowledgements

Built with ❤️ for India's artisan community using [Flutter](https://flutter.dev) and [Firebase](https://firebase.google.com).

