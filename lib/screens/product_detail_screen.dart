import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Consumer<WishlistProvider>(
            builder: (context, wishlistProvider, child) {
              final isInWishlist = wishlistProvider.isInWishlist(product.id);
              return IconButton(
                icon: Icon(isInWishlist ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  wishlistProvider.toggleWishlist(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isInWishlist ? 'Removed from wishlist' : 'Added to wishlist')),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Hero(
                  tag: 'product_${product.id}_image',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.image,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                product.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text('${product.rating.rate} (${product.rating.count})'),
                  const Spacer(),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                product.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Consumer<CartProvider>(
                      builder: (context, cartProvider, child) {
                        final isInCart = cartProvider.isInCart(product.id);
                        return ElevatedButton.icon(
                          onPressed: () {
                            cartProvider.addItem(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${product.title} added to cart')),
                            );
                          },
                          icon: const Icon(Icons.shopping_cart_outlined),
                          label: Text(isInCart ? 'Add More' : 'Add to Cart'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Consumer<WishlistProvider>(
                    builder: (context, wishlistProvider, child) {
                      final isInWishlist = wishlistProvider.isInWishlist(product.id);
                      return OutlinedButton(
                        onPressed: () {
                          wishlistProvider.toggleWishlist(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(isInWishlist ? 'Removed from wishlist' : 'Added to wishlist')),
                          );
                        },
                        child: Icon(isInWishlist ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
