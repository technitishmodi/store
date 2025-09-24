import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade200, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigateToProductDetail(context),
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            _buildImageSection(context, colorScheme),

            // Flexible Details Section
            Flexible(
              child: _buildProductDetails(context, theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, ColorScheme colorScheme) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: Stack(
        children: [
          // Product Image
          Positioned.fill(
            child: Hero(
              tag: 'product_${product.id}_image',
              child: Container(
                color: colorScheme.surface,
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                  loadingBuilder: _buildImageLoadingWidget,
                  errorBuilder: _buildImageErrorWidget,
                ),
              ),
            ),
          ),

          // Discount Tag (if applicable)
          // Product model does not define a `discount` field; remove the discount badge or add the field to the model.
          // (No discount badge is shown by default.)

          // Wishlist Button
          Positioned(
            right: 8,
            top: 8,
            child: _buildWishlistButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      child: LayoutBuilder(builder: (context, constraints) {
        final compact = constraints.maxHeight < 60;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top group
            Flexible(
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Category chip with modern styling - removed to save space

                  // Product title with modern typography (smaller in compact)
                  Text(
                    product.title,
                    style: (compact
                            ? theme.textTheme.bodySmall
                            : theme.textTheme.titleSmall)
                        ?.copyWith(
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                      letterSpacing: 0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: compact ? 2 : 4),

                  // Price and Rating with modern styling
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // Price with modern typography
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(
                        height: compact ? 14 : 20,
                        child: _buildRatingChip(theme),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // Add to Cart Button with modern styling
            SizedBox(
              height: compact ? 32 : 36,
              width: double.infinity,
              child: _buildAddToCartButton(context),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildWishlistButton(BuildContext context) {
    final theme = Theme.of(context);
    
    return Consumer<WishlistProvider>(
      builder: (context, wishlistProvider, _) {
        final isInWishlist = wishlistProvider.isInWishlist(product.id);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () =>
                _toggleWishlist(context, wishlistProvider, isInWishlist),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isInWishlist 
                    ? theme.colorScheme.primaryContainer.withOpacity(0.9)
                    : Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isInWishlist ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey(isInWishlist),
                  color: isInWishlist ? Colors.red : Colors.grey.shade600,
                  size: 20,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRatingChip(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.amber.shade200, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: 10,
            color: Colors.amber.shade600,
          ),
          const SizedBox(width: 1),
          Text(
            product.rating.rate.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Colors.amber.shade800,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    final theme = Theme.of(context);
    
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        final isInCart = cartProvider.isInCart(product.id);
        final quantity = cartProvider.getQuantity(product.id);

        return ElevatedButton(
          onPressed: () => _addToCart(context, cartProvider),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            backgroundColor: isInCart
                ? theme.colorScheme.secondary
                : theme.colorScheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isInCart ? Icons.shopping_bag : Icons.add_shopping_cart_outlined,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                isInCart ? 'In Cart ($quantity)' : 'Add to Cart',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageLoadingWidget(
      BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) return child;

    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: CircularProgressIndicator.adaptive(
          strokeWidth: 2,
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        ),
      ),
    );
  }

  Widget _buildImageErrorWidget(
      BuildContext context, Object error, StackTrace? stackTrace) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: 40,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              'Image not available',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToProductDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  void _toggleWishlist(
      BuildContext context, WishlistProvider wishlistProvider, bool wasInWishlist) {
    wishlistProvider.toggleWishlist(product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          wasInWishlist
              ? '${product.title} removed from wishlist'
              : '${product.title} added to wishlist',
        ),
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _addToCart(BuildContext context, CartProvider cartProvider) {
    cartProvider.addItem(product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text('${product.title} added to cart'),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green.shade600,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
