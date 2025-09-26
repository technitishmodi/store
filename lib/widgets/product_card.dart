import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../screens/product_detail_screen.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isPressed = false;

  void _setPressed(bool pressed) {
    if (_isPressed == pressed) return;
    setState(() => _isPressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedScale(
      scale: _isPressed ? 0.985 : 1.0,
      duration: const Duration(milliseconds: 110),
      curve: Curves.easeOut,
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Colors.grey.shade200, width: 0.4),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Main tappable area
            InkWell(
              onTap: () => _navigateToProductDetail(context),
              onTapDown: (_) => _setPressed(true),
              onTapCancel: () => _setPressed(false),
              onTapUp: (_) => _setPressed(false),
              borderRadius: BorderRadius.circular(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // allow the column to fill available height from the grid tile
                // so we can make the product details flexible and avoid overflow
                mainAxisSize: MainAxisSize.max,
                children: [
              // Image Section - make flexible so it can share the available
              // tile height with the details area. This prevents the image
              // from taking too much vertical space in compact grid tiles.
              Flexible(flex: 6, child: _buildImageSection(context, colorScheme)),

              // Product Details Section — make flexible so it can shrink to fit
              Flexible(flex: 4, child: _buildProductDetails(context, theme)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, ColorScheme colorScheme) {
    return LayoutBuilder(builder: (context, constraints) {
      // Use the height allocated by the parent flex. If it's unconstrained,
      // fall back to a reasonable height.
      final h = constraints.maxHeight.isFinite ? constraints.maxHeight : 140.0;

      return SizedBox(
        height: h,
        child: Stack(
          children: [
            Positioned.fill(
              child: Hero(
                tag: 'product_${widget.product.id}_image',
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.surface,
                        colorScheme.surfaceVariant.withOpacity(0.4)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                    child: Image.network(
                      widget.product.image,
                      fit: BoxFit.contain,
                      loadingBuilder: _buildImageLoadingWidget,
                      errorBuilder: _buildImageErrorWidget,
                    ),
                  ),
                ),
              ),
            ),

            // Wishlist Button
            Positioned(
              right: 8,
              top: 8,
              child: _buildWishlistButton(context),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildProductDetails(BuildContext context, ThemeData theme) {
    return Padding(
      // slightly smaller vertical padding to save a few pixels in tight tiles
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
      child: LayoutBuilder(builder: (context, constraints) {
        final available = constraints.maxHeight.isFinite ? constraints.maxHeight : 60.0;
        final compact = available < 60.0;

        // Target button height (prefer small on compact tiles)
        double minButton = 24.0;
        double buttonHeight = compact ? math.max(minButton, available * 0.28) : 30.0;

        // Constrain the whole details area to the available height so children
        // can flex/scale down when there's very little vertical room.
        return SizedBox(
          height: constraints.maxHeight.isFinite ? constraints.maxHeight : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Title + price/rating area takes the remaining space and can
              // shrink using Expanded -> inner Column with mainAxisSize.min.
              Flexible(
                fit: FlexFit.loose,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // use min so the column takes intrinsic height and won't be
                  // forced to fill a too-small height (avoids tiny overflows)
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Product title
                    Text(
                      widget.product.title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 2),

                    // Price + Rating Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${widget.product.price.toStringAsFixed(2)}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        _buildRatingChip(theme),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              // Add to Cart Button — use LayoutBuilder to get a finite width and
              // avoid passing infinite width constraints to descendants.
              LayoutBuilder(builder: (bctx, bconstraints) {
                final availableWidth = bconstraints.maxWidth.isFinite
                    ? bconstraints.maxWidth
                    : 160.0; // fallback finite width

                return SizedBox(
                  height: buttonHeight,
                  width: availableWidth,
                  child: _buildAddToCartButton(context),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildWishlistButton(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<WishlistProvider>(
      builder: (context, wishlistProvider, _) {
        final isInWishlist = wishlistProvider.isInWishlist(widget.product.id);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () =>
                _toggleWishlist(context, wishlistProvider, isInWishlist),
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: isInWishlist
                    ? theme.colorScheme.secondary.withOpacity(0.15)
                    : Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isInWishlist ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey(isInWishlist),
                  color: isInWishlist
                      ? theme.colorScheme.secondary
                      : Colors.grey.shade600,
                  size: 18,
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
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 12, color: Colors.amber.shade600),
          const SizedBox(width: 2),
          Text(
            widget.product.rating.rate.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.amber.shade800,
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
        final isInCart = cartProvider.isInCart(widget.product.id);
        final quantity = cartProvider.getQuantity(widget.product.id);

        return ElevatedButton(
          onPressed: () => _addToCart(context, cartProvider),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor:
                isInCart ? theme.colorScheme.secondary : theme.colorScheme.primary,
            foregroundColor: Colors.white,
            // Remove default minimumSize and shrink vertical padding so the
            // button can be smaller inside compact grid tiles.
            minimumSize: const Size(0, 0),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isInCart ? Icons.shopping_bag : Icons.add_shopping_cart_outlined,
                size: 14,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  isInCart ? 'In Cart ($quantity)' : 'Add',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
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
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 32,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  void _navigateToProductDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: widget.product),
      ),
    );
  }

  void _toggleWishlist(
      BuildContext context, WishlistProvider wishlistProvider, bool wasInWishlist) {
    wishlistProvider.toggleWishlist(widget.product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          wasInWishlist
              ? '${widget.product.title} removed from wishlist'
              : '${widget.product.title} added to wishlist',
        ),
        duration: const Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _addToCart(BuildContext context, CartProvider cartProvider) {
    cartProvider.addItem(widget.product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Expanded(child: Text('${widget.product.title} added to cart')),
          ],
        ),
        duration: const Duration(milliseconds: 1400),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green.shade600,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
