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

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  List<String> _categories = ['All'];

  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
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

  _controller?.forward();
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

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // 🏗️ BUILD
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: false,
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
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                "Shopping Store",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
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
            _buildBadgeIcon(
              context,
              icon: Icons.favorite_rounded,
              count: context.watch<WishlistProvider>().itemCount,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WishlistScreen()),
              ),
              iconColor: theme.colorScheme.onPrimary,
            ),
            _buildBadgeIcon(
              context,
              icon: Icons.shopping_bag_rounded,
              count: context.watch<CartProvider>().itemCount,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              ),
              iconColor: theme.colorScheme.onPrimary,
            ),
            Consumer<AuthProvider>(
              builder: (context, auth, _) {
                final initials = (auth.userEmail ?? "G")[0].toUpperCase();
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: theme.colorScheme.onPrimary.withOpacity(0.15),
                      child: Text(initials,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onPrimary)),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // 🌟 Body
      body: Column(
        children: [
          // 🔍 Floating Search Bar
          Container(
            // body is already positioned below the AppBar, so don't add status-bar inset again
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: Material(
              elevation: 6,
              shadowColor: Colors.black26,
              borderRadius: BorderRadius.circular(28),
              child: TextField(
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: "Search products...",
                  prefixIcon:
                      Icon(Icons.search, color: theme.colorScheme.primary),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
            ),
          ),

          // 🌈 Category Chips
          SizedBox(
            height: 46,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final cat = _categories[i];
                final selected = cat == _selectedCategory;
                return AnimatedScale(
                  scale: selected ? 1.05 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: selected,
                    labelStyle: TextStyle(
                        color: selected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface),
                    selectedColor: theme.colorScheme.primary,
                    backgroundColor: theme.colorScheme.surface,
                    onSelected: (_) => _onCategoryChanged(cat),
                  ),
                );
              },
            ),
          ),

          // 🛍️ Products
          Expanded(
            child: _isLoading
                ? _buildShimmerLoader(theme)
                : _error != null
                    ? _buildErrorState(theme)
                    : _filteredProducts.isEmpty
                        ? _buildEmptyState(theme)
                        : RefreshIndicator(
                            onRefresh: _loadData,
                            color: theme.colorScheme.primary,
                            child: GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 14,
                                childAspectRatio: 0.72,
                              ),
                              itemCount: _filteredProducts.length,
                              itemBuilder: (ctx, i) {
                                final animation = _controller == null
                                    ? AlwaysStoppedAnimation<double>(1.0)
                                    : CurvedAnimation(
                                        parent: _controller!,
                                        curve: Interval(
                                          _products.isEmpty ? 0.0 : (i / _products.length),
                                          1.0,
                                          curve: Curves.easeOut,
                                        ),
                                      );

                                return FadeTransition(
                                  opacity: animation,
                                  child: ScaleTransition(
                                    scale: animation,
                                    child: ProductCard(product: _filteredProducts[i]),
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  // 🎯 Modern Badge Icon
  Widget _buildBadgeIcon(BuildContext context,
      {required IconData icon,
      required int count,
      required VoidCallback onTap,
      Color? iconColor}) {
    final theme = Theme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(icon, color: iconColor ?? theme.colorScheme.primary, size: 26),
          onPressed: onTap,
        ),
        if (count > 0)
          Positioned(
            right: 4,
            top: 6,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                shape: BoxShape.circle,
              ),
              child: Text("$count",
                  style: const TextStyle(
                      fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
      ],
    );
  }

  // 🌟 Shimmer Loader
  Widget _buildShimmerLoader(ThemeData theme) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text("Oops! Something went wrong",
                style: theme.textTheme.titleLarge),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      );

  Widget _buildEmptyState(ThemeData theme) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text("No products found",
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Try adjusting your search or filters",
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      );
}
