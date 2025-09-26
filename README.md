# Shopping Store - Flutter App

A modern Flutter shopping app with clean UI, state management using Provider, and API integration with FakeStore API.

## Features

### ✅ Authentication
- **Mock Login System**: Email validation with test credentials
- **Secure Login**: Only accepts `test@test.com` with password `123456`
- **Form Validation**: Email format and password length validation
- **Loading States**: Visual feedback during authentication

### ✅ Product Catalog
- **API Integration**: Fetches products from [FakeStore API](https://fakestoreapi.com/products)
- **Grid Layout**: Clean product grid with images, titles, and prices
- **Search Functionality**: Real-time product search
- **Category Filtering**: Filter products by categories
- **Loading States**: Shimmer loading and error handling
- **Pull to Refresh**: Refresh product data

### ✅ Shopping Cart
- **Add to Cart**: Add products with quantity management
- **Cart Management**: Update quantities, remove items
- **Cart Badge**: Real-time cart count in app bar
- **Total Calculation**: Automatic price calculations
- **Persistent State**: Cart state maintained during app usage

### ✅ Wishlist (Bonus Feature)
- **Add to Favorites**: Heart button to add/remove from wishlist
- **Persistent Storage**: Uses SharedPreferences to save wishlist
- **Wishlist Screen**: Dedicated screen to view saved items
- **Cross-Session Persistence**: Wishlist survives app restarts

### ✅ Additional Features
- **Material 3 Design**: Modern UI with clean aesthetics
- **Responsive Layout**: Works on different screen sizes
- **Error Handling**: Comprehensive error states and user feedback
- **Navigation**: Smooth navigation between screens
- **State Management**: Provider pattern for clean architecture

## Project Structure

```
lib/
├── main.dart                 # App entry point with providers setup
├── models/
│   ├── product.dart         # Product data model
│   └── cart_item.dart       # Cart item model
├── providers/
│   ├── auth_provider.dart   # Authentication state management
│   ├── cart_provider.dart   # Shopping cart state management
│   └── wishlist_provider.dart # Wishlist state management
├── screens/
│   ├── login_screen.dart    # Login/authentication screen
│   ├── home_screen.dart     # Product listing screen
│   ├── cart_screen.dart     # Shopping cart screen
│   └── wishlist_screen.dart # Wishlist screen
├── services/
│   └── api_service.dart     # API integration service
└── widgets/
    └── product_card.dart    # Reusable product card widget
```

## Dependencies

- **flutter**: SDK
- **provider**: ^6.1.2 - State management
- **http**: ^1.2.1 - API calls
- **shared_preferences**: ^2.2.3 - Local storage for wishlist
- **cupertino_icons**: ^1.0.8 - iOS style icons

# Shopping Store - Flutter App

A modern Flutter shopping app with a clean UI, Provider-based state management, and integration with the FakeStore API for demo product data.

## Quick overview

- Small demo app showcasing: authentication (mock), product catalog from an API, search & category filtering, shopping cart, and a wishlist with persistence using SharedPreferences.
- Built with Flutter and Provider for state management.

## Features

- Authentication (mock login for demo)
- Product catalog fetched from FakeStore API
- Search and category filtering
- Shopping cart with quantity management and real-time totals
- Wishlist saved using SharedPreferences (persists across app restarts)
- Material 3 inspired UI and responsive layouts

## Project structure

```
lib/
├── main.dart                 # App entry point with providers setup
├── models/                   # Data models (product, cart item)
├── providers/                # Provider classes (auth, cart, wishlist)
├── screens/                  # Screens (login, home, cart, wishlist, product detail)
├── services/                 # API integration and helpers
└── widgets/                  # Reusable widgets (e.g. product card)
```

## Requirements

- Flutter SDK (recommended: stable channel, 3.8+)
- Dart (bundled with Flutter)
- Android Studio or VS Code (optional)

## Setup & run (Windows / Bash)

1. Clone the repo and enter the folder

```bash
git clone <repository-url>
cd store
```

2. Install dependencies

```bash
flutter pub get
```

3. Run the app on a connected device or emulator

```bash
flutter run
```

To build a release APK

```bash
flutter build apk --release
```

## Demo credentials

- Email: `test@test.com`
- Password: `123456`

## API

This project uses the FakeStore API for demo data: https://fakestoreapi.com

Key endpoints used:

- /products
- /products/categories
- /products/{id}

## Testing the app (manual)

1. Launch the app and sign in with the demo credentials
2. Browse, search and filter products
3. Add items to cart and adjust quantities
4. Add/remove items to wishlist and restart the app to confirm persistence

## Troubleshooting

- If you hit build issues, try:

```bash
flutter clean
flutter pub get
```

- If the API isn't reachable, check your internet connection or try again later — FakeStore is a free demo API and may occasionally be slow.

## Future improvements

- Real authentication & backend
- Order checkout flow and payment integration
- Offline support & caching
- Unit and widget tests

## Contributing

Contributions are welcome. Typical workflow:

1. Fork the repository
2. Create a feature branch
3. Make changes and add tests
4. Open a pull request

## License

This repository does not include a license file. Add a LICENSE if you want to specify reuse terms.

---

If you'd like, I can add a small CONTRIBUTING.md, a LICENSE file, or update package versions in `pubspec.yaml`. Tell me which next.