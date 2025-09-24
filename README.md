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

## Setup Instructions

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Android Emulator or iOS Simulator

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd store
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Demo Credentials
- **Email**: `test@test.com`
- **Password**: `123456`

## API Integration

The app integrates with [FakeStore API](https://fakestoreapi.com/) for product data:

- **Products Endpoint**: `https://fakestoreapi.com/products`
- **Categories Endpoint**: `https://fakestoreapi.com/products/categories`
- **Single Product**: `https://fakestoreapi.com/products/{id}`

## State Management Architecture

### Provider Pattern
- **AuthProvider**: Manages user authentication state
- **CartProvider**: Handles shopping cart operations and state
- **WishlistProvider**: Manages wishlist with persistent storage

### Data Flow
1. **API Service** fetches data from external API
2. **Providers** manage application state
3. **Screens** consume state via Consumer widgets
4. **Widgets** display data and handle user interactions

## Key Features Implementation

### Mock Authentication
```dart
// Only accepts specific credentials
if (email == 'test@test.com' && password == '123456') {
  _isAuthenticated = true;
  return true;
}
```

### Persistent Wishlist
```dart
// Saves to SharedPreferences
final wishlistJson = json.encode(_items.map((item) => item.toJson()).toList());
await prefs.setString(_wishlistKey, wishlistJson);
```

### Real-time Cart Updates
```dart
// Provider notifies listeners on state changes
void addItem(Product product) {
  // Add logic
  notifyListeners(); // Updates UI automatically
}
```

## Testing the App

1. **Login**: Use the demo credentials provided
2. **Browse Products**: Scroll through the product grid
3. **Search**: Use the search bar to find specific products
4. **Filter**: Select categories to filter products
5. **Add to Cart**: Tap "Add to Cart" on any product
6. **Wishlist**: Tap the heart icon to add/remove favorites
7. **Cart Management**: View cart, update quantities, remove items
8. **Persistent Wishlist**: Close and reopen app to verify wishlist persistence

## Troubleshooting

### Common Issues

1. **API Connection Issues**
   - Check internet connection
   - Verify API endpoint accessibility

2. **Build Issues**
   - Run `flutter clean` then `flutter pub get`
   - Ensure Flutter SDK is up to date

3. **SharedPreferences Issues**
   - Clear app data if wishlist doesn't persist
   - Check device storage permissions

## Future Enhancements

- User registration and real authentication
- Product details screen
- Order history
- Payment integration
- Push notifications
- Offline support
- Product reviews and ratings

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is created for educational purposes and assessment.
