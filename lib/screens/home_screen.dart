import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'wishlist_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  List<String> _categories = ['All'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final products = await ApiService.fetchProducts();
      final categories = await ApiService.fetchCategories();

      if (!mounted) return;
      setState(() {
        _products = products;
        _filteredProducts = products;
        _categories = ['All', ...categories];
        _isLoading = false;
      });

      await Provider.of<WishlistProvider>(context, listen: false).loadWishlist();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterProducts() {
    setState(() {
      _filteredProducts = _products.where((product) {
        final matchesSearch = product.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            product.description.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesCategory = _selectedCategory == 'All' || product.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterProducts();
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterProducts();
  }

  // ignore: unused_element
  void _logout() {
    Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  // Profile screen navigation replaced the modal sheet; kept for reference.

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary, theme.colorScheme.secondary.withOpacity(0.9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: const Text("Shopping Store"),
            ),
          ),
          centerTitle: false,
          titleSpacing: 8,
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.12),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          actions: [
          // Wishlist
          Consumer<WishlistProvider>(
            builder: (context, wishlistProvider, child) {
              return _buildBadgeIcon(
                context,
                icon: Icons.favorite_rounded,
                count: wishlistProvider.itemCount,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const WishlistScreen()),
                ),
              );
            },
          ),
          // Cart
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return _buildBadgeIcon(
                context,
                icon: Icons.shopping_bag_rounded,
                count: cartProvider.itemCount,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                ),
              );
            },
          ),
          // Profile avatar (replaces logout icon)
          Consumer<AuthProvider>(
            builder: (context, auth, child) {
              final email = auth.userEmail ?? 'Guest';
              final initials = email.isNotEmpty ? email[0].toUpperCase() : 'G';
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  ),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: theme.colorScheme.onPrimaryContainer.withOpacity(0.12),
                    child: Text(initials, style: TextStyle(color: theme.colorScheme.onPrimary)),
                  ),
                ),
              );
            },
          ),
        ],
          ),
        ),
      body: Column(
        children: [
          // 🔍 Search + Filter
          Container(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            hintText: "Search products...",
                            prefixIcon: Icon(Icons.search_rounded, color: theme.colorScheme.onSurfaceVariant),
                            filled: false,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.tune_rounded, color: theme.colorScheme.secondary),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 18),
                // Category Chips with pill style
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = category == _selectedCategory;
                      return GestureDetector(
                        onTap: () => _onCategoryChanged(category),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: isSelected ? theme.colorScheme.primary.withOpacity(0.9) : theme.colorScheme.outline.withOpacity(0.06),
                            ),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // 🛍️ Products Grid
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: theme.colorScheme.secondary))
                : _error != null
                    ? _buildErrorState(theme)
                    : _filteredProducts.isEmpty
                        ? _buildEmptyState(theme)
                        : RefreshIndicator(
                            color: theme.colorScheme.secondary,
                            onRefresh: _loadData,
                            child: GridView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.66,
                              ),
                              itemCount: _filteredProducts.length,
                              itemBuilder: (context, index) {
                                return ProductCard(product: _filteredProducts[index]);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeIcon(BuildContext context,
      {required IconData icon, required int count, required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(icon, size: 26, color: theme.colorScheme.onPrimaryContainer),
        ),
        if (count > 0)
          Positioned(
            right: 6,
            top: 6,
            child: CircleAvatar(
              radius: 9,
              backgroundColor: theme.colorScheme.error,
              child: Text(
                "$count",
                style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
      ],
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 80, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text("Failed to load products", style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text("Retry"),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: theme.colorScheme.outline),
          const SizedBox(height: 16),
          Text("No products found", style: theme.textTheme.titleLarge),
          const SizedBox(height: 6),
          Text("Try adjusting your search or filters",
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}