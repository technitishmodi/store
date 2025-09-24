import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/cart_provider.dart';
import '../models/product.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Consumer<WishlistProvider>(
            builder: (context, wishlistProvider, child) {
              if (wishlistProvider.items.isNotEmpty) {
                return TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Clear Wishlist'),
                        content: const Text('Are you sure you want to remove all items from your wishlist?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              wishlistProvider.clearWishlist();
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Wishlist cleared')),
                              );
                            },
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Clear All'),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<WishlistProvider>(
        builder: (context, wishlistProvider, child) {
          if (wishlistProvider.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_outline,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your wishlist is empty',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text('Add some products to your favorites'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Continue Shopping'),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: wishlistProvider.items.length,
            itemBuilder: (context, index) {
              return WishlistItemCard(product: wishlistProvider.items[index]);
            },
          );
        },
      ),
    );
  }
}

class WishlistItemCard extends StatelessWidget {
  final Product product;

  const WishlistItemCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    product.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported, size: 50),
                      );
                    },
                  ),
                ),
                // Remove from Wishlist Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer<WishlistProvider>(
                    builder: (context, wishlistProvider, child) {
                      return GestureDetector(
                        onTap: () {
                          wishlistProvider.removeItem(product.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${product.title} removed from wishlist')),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromRGBO(0, 0, 0, 0.1),
                                spreadRadius: 1,
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Product Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    child: Consumer<CartProvider>(
                      builder: (context, cartProvider, child) {
                        final isInCart = cartProvider.isInCart(product.id);
                        return ElevatedButton(
                          onPressed: () {
                            if (isInCart) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Item already in cart')),
                              );
                            } else {
                              cartProvider.addItem(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${product.title} added to cart')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isInCart ? Colors.grey : null,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            isInCart ? 'In Cart' : 'Add to Cart',
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
