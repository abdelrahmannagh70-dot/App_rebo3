import 'package:app3/core/themes/app_colors.dart';
import 'package:app3/features/book_details/data/models/book_details_model.dart';
import 'package:app3/features/book_details/presentaion/cubit/book_details_cubit.dart';
import 'package:app3/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BookDetailsScreen extends StatefulWidget {
  final int? bookId;
  const BookDetailsScreen({super.key, this.bookId});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen>
    with SingleTickerProviderStateMixin {
  int _quantity = 1;
  bool _isFavorite = false;
  bool _isDescriptionExpanded = false;
  int _selectedFormatIndex = 0; // 0: Paperback, 1: Hardcover, 2: E-Book
  int _selectedTabSection = 0; // 0: Overview, 1: Details, 2: Reviews

  final List<String> _formats = const ['Paperback', 'Hardcover', 'E-Book'];

  void _incrementQuantity(int maxStock) {
    if (_quantity < maxStock) {
      HapticFeedback.lightImpact();
      setState(() {
        _quantity++;
      });
    } else {
      HapticFeedback.mediumImpact();
      _showCustomToast(
        context,
        icon: Icons.info_outline_rounded,
        message: 'Maximum available stock is $maxStock items.',
        color: const Color(0xFFE57373),
      );
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      HapticFeedback.lightImpact();
      setState(() {
        _quantity--;
      });
    }
  }

  void _toggleFavorite(BookDetailsData? book) {
    HapticFeedback.mediumImpact();
    setState(() {
      _isFavorite = !_isFavorite;
    });

    _showCustomToast(
      context,
      icon: _isFavorite ? Icons.bookmark_added_rounded : Icons.bookmark_remove_rounded,
      message: _isFavorite
          ? '"${book?.name ?? 'Book'}" added to your Wishlist!'
          : 'Removed from your Wishlist.',
      color: _isFavorite ? AppColors.mainColor : AppColors.darkColor,
    );
  }

  void _showCustomToast(
    BuildContext context, {
    required IconData icon,
    required String message,
    required Color color,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 18.r),
            ),
            12.horizontalSpace,
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontFamily: 'DM',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        margin: EdgeInsets.all(16.r),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  num _getEffectivePrice(BookDetailsData? data) {
    if (data?.priceAfterDiscount != null && data!.priceAfterDiscount! > 0) {
      return data.priceAfterDiscount!;
    }
    if (data?.price != null) {
      final parsed = num.tryParse(
        data!.price!.replaceAll(RegExp(r'[^0-9.]'), ''),
      );
      if (parsed != null) return parsed;
    }
    return 0;
  }

  num _getOriginalPrice(BookDetailsData? data) {
    if (data?.price != null) {
      final parsed = num.tryParse(
        data!.price!.replaceAll(RegExp(r'[^0-9.]'), ''),
      );
      if (parsed != null) return parsed;
    }
    return _getEffectivePrice(data);
  }

  void _openShareModal(BuildContext context, BookDetailsData? book) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _buildShareBottomSheet(ctx, book),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookId = widget.bookId ??
        ModalRoute.of(context)?.settings.arguments as int?;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(64.h),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  iconSize: 17.r,
                  tooltip: 'Go back',
                  onTap: () => Navigator.pop(context),
                ),
                Text(
                  'Book Details',
                  style: TextStyle(
                    fontFamily: 'DM',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkColor,
                    letterSpacing: 0.3,
                  ),
                ),
                BlocBuilder<BookDetailsCubit, BookDetailsState>(
                  builder: (context, state) {
                    final book = state is GetDetailsSuccess ? state.detailsData : null;
                    return Row(
                      children: [
                        _buildActionIconButton(
                          icon: _isFavorite
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          iconColor: _isFavorite
                              ? AppColors.mainColor
                              : AppColors.darkColor,
                          tooltip: 'Add to Wishlist',
                          onTap: () => _toggleFavorite(book),
                        ),
                        8.horizontalSpace,
                        _buildActionIconButton(
                          icon: Icons.share_outlined,
                          iconSize: 19.r,
                          tooltip: 'Share book',
                          onTap: () => _openShareModal(context, book),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<BookDetailsCubit, BookDetailsState>(
        builder: (context, state) {
          if (state is GetDetailsLoading) {
            return _buildSkeletonLoading();
          } else if (state is GetDetailsSuccess) {
            final book = state.detailsData;
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        12.verticalSpace,
                        _buildHeroBookCover(book),
                        20.verticalSpace,
                        _buildBookHeader(book),
                        16.verticalSpace,
                        _buildQuickFeatureStats(book),
                        20.verticalSpace,
                        _buildFormatSelector(book),
                        20.verticalSpace,
                        _buildSegmentedTabSection(book),
                        20.verticalSpace,
                        _buildQuantitySection(book),
                        20.verticalSpace,
                        _buildGuaranteesBanner(),
                        28.verticalSpace,
                      ],
                    ),
                  ),
                ),
                _buildStickyBottomBar(book),
              ],
            );
          } else {
            return _buildErrorState(context, bookId);
          }
        },
      ),
    );
  }

  // --- Pro Sub-Widgets & Components ---

  Widget _buildActionIconButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
    double? iconSize,
    String? tooltip,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: AppColors.borderColor.withValues(alpha: 0.8),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: iconColor ?? AppColors.darkColor,
              size: iconSize ?? 20.r,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBookCover(BookDetailsData? book) {
    final discount = book?.discount;
    final hasDiscount = (discount != null && discount > 0);
    final isBestSeller = (book?.bestSeller == 1);

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Ambient Layered Backdrop Glow
          Container(
            width: double.infinity,
            height: 270.h,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.2),
                radius: 0.85,
                colors: [
                  AppColors.mainColor.withValues(alpha: 0.16),
                  AppColors.mainColor.withValues(alpha: 0.04),
                  Colors.white,
                ],
              ),
              borderRadius: BorderRadius.circular(28.r),
              border: Border.all(
                color: AppColors.borderColor.withValues(alpha: 0.8),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.mainColor.withValues(alpha: 0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
          ),

          // 3D Realistic Book with Spine and Shadows
          Positioned(
            child: Container(
              height: 230.h,
              width: 160.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  // Book drop shadow
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.22),
                    blurRadius: 26,
                    spreadRadius: 1,
                    offset: const Offset(0, 14),
                  ),
                  // Left spine depth shadow
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(-4, 4),
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14.r),
                    child: book?.image != null && book!.image!.isNotEmpty
                        ? Image.network(
                            book.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildCoverFallback(book.name),
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: Colors.grey.shade100,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: AppColors.mainColor,
                                  ),
                                ),
                              );
                            },
                          )
                        : _buildCoverFallback(book?.name),
                  ),

                  // Book Spine 3D Lighting Illusion Overlay
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.r),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.black.withValues(alpha: 0.28),
                              Colors.white.withValues(alpha: 0.15),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.05),
                            ],
                            stops: const [0.0, 0.04, 0.12, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Discount Badge
          if (hasDiscount)
            Positioned(
              top: 14.h,
              left: 14.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEF5350), Color(0xFFE53935)],
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE53935).withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_offer_rounded,
                        color: Colors.white, size: 12.r),
                    5.horizontalSpace,
                    Text(
                      '-$discount% OFF',
                      style: TextStyle(
                        fontFamily: 'DM',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.5.sp,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Best Seller / Award Badge
          if (isBestSeller)
            Positioned(
              top: 14.h,
              right: 14.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.mainColor,
                      const Color(0xFFA88940),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mainColor.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.workspace_premium_rounded,
                        color: Colors.white, size: 14.r),
                    4.horizontalSpace,
                    Text(
                      'BESTSELLER',
                      style: TextStyle(
                        fontFamily: 'DM',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.5.sp,
                        letterSpacing: 0.7,
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

  Widget _buildCoverFallback(String? name) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14.r),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AppColors.mainColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_stories_rounded,
              size: 38.r,
              color: AppColors.mainColor,
            ),
          ),
          12.verticalSpace,
          Text(
            name ?? 'Bookia Edition',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'DM',
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrayColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookHeader(BookDetailsData? book) {
    final effectivePrice = _getEffectivePrice(book);
    final originalPrice = _getOriginalPrice(book);
    final discount = book?.discount;
    final hasDiscount = (discount != null && discount > 0);
    final savedAmount = (originalPrice - effectivePrice).clamp(0, double.infinity);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Pill and Stock Status Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (book?.category != null && book!.category!.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColors.mainColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: AppColors.mainColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  book.category!.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'DM',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainColor,
                    letterSpacing: 0.8,
                  ),
                ),
              )
            else
              const SizedBox.shrink(),
            _buildStockBadge(book?.stock),
          ],
        ),

        10.verticalSpace,

        // Book Title
        Text(
          book?.name ?? 'Untitled Edition',
          style: TextStyle(
            fontFamily: 'DM',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.darkColor,
            height: 1.25,
            letterSpacing: 0.2,
          ),
        ),

        6.verticalSpace,

        // Subtitle / Publisher Tag
        Row(
          children: [
            Icon(Icons.verified_rounded, size: 15.r, color: AppColors.mainColor),
            6.horizontalSpace,
            Text(
              'Official Publisher Edition',
              style: TextStyle(
                fontFamily: 'DM',
                fontSize: 12.5.sp,
                color: AppColors.darkGrayColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            12.horizontalSpace,
            Container(
              width: 4.r,
              height: 4.r,
              decoration: const BoxDecoration(
                color: AppColors.grayColor,
                shape: BoxShape.circle,
              ),
            ),
            12.horizontalSpace,
            Row(
              children: [
                Icon(Icons.star_rounded, size: 16.r, color: const Color(0xFFFFB800)),
                3.horizontalSpace,
                Text(
                  '4.9',
                  style: TextStyle(
                    fontFamily: 'DM',
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkColor,
                  ),
                ),
                3.horizontalSpace,
                Text(
                  '(128)',
                  style: TextStyle(
                    fontFamily: 'DM',
                    fontSize: 11.5.sp,
                    color: AppColors.grayColor,
                  ),
                ),
              ],
            ),
          ],
        ),

        14.verticalSpace,

        // Price Breakdown Card
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Price',
                    style: TextStyle(
                      fontFamily: 'DM',
                      fontSize: 11.5.sp,
                      color: AppColors.grayColor,
                    ),
                  ),
                  2.verticalSpace,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '\$${effectivePrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontFamily: 'DM',
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.mainColor,
                        ),
                      ),
                      if (hasDiscount && originalPrice > effectivePrice) ...[
                        8.horizontalSpace,
                        Text(
                          '\$${originalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontFamily: 'DM',
                            fontSize: 14.sp,
                            color: AppColors.grayColor,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              const Spacer(),
              if (hasDiscount && savedAmount > 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: const Color(0xFFA5D6A7)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.savings_outlined,
                          size: 15.r, color: const Color(0xFF2E7D32)),
                      5.horizontalSpace,
                      Text(
                        'Save \$${savedAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontFamily: 'DM',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStockBadge(int? stock) {
    final inStock = (stock ?? 0) > 0;
    final isLowStock = inStock && (stock ?? 0) <= 5;

    final badgeBg = !inStock
        ? const Color(0xFFFFEBEE)
        : isLowStock
            ? const Color(0xFFFFF8E1)
            : const Color(0xFFE8F5E9);

    final badgeBorder = !inStock
        ? const Color(0xFFFFCDD2)
        : isLowStock
            ? const Color(0xFFFFECB3)
            : const Color(0xFFC8E6C9);

    final textColor = !inStock
        ? const Color(0xFFC62828)
        : isLowStock
            ? const Color(0xFFEF6C00)
            : const Color(0xFF2E7D32);

    final text = !inStock
        ? 'Out of Stock'
        : isLowStock
            ? 'Only $stock left'
            : 'In Stock (${stock ?? 0})';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: badgeBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: badgeBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7.r,
            height: 7.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: textColor,
            ),
          ),
          6.horizontalSpace,
          Text(
            text,
            style: TextStyle(
              fontFamily: 'DM',
              fontSize: 11.5.sp,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFeatureStats(BookDetailsData? book) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCardItem(
            icon: Icons.star_rounded,
            iconColor: const Color(0xFFFFB800),
            title: '4.9 Rating',
            subtitle: '128 Reviews',
          ),
          Container(
            height: 36.h,
            width: 1.2,
            color: AppColors.borderColor,
          ),
          _buildStatCardItem(
            icon: Icons.auto_stories_rounded,
            iconColor: AppColors.mainColor,
            title: '348 Pages',
            subtitle: 'Hardcover / PB',
          ),
          Container(
            height: 36.h,
            width: 1.2,
            color: AppColors.borderColor,
          ),
          _buildStatCardItem(
            icon: Icons.language_rounded,
            iconColor: const Color(0xFF4A90E2),
            title: 'English',
            subtitle: 'Original Edition',
          ),
        ],
      ),
    );
  }

  Widget _buildStatCardItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(7.r),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18.r, color: iconColor),
        ),
        6.verticalSpace,
        Text(
          title,
          style: TextStyle(
            fontFamily: 'DM',
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.darkColor,
          ),
        ),
        2.verticalSpace,
        Text(
          subtitle,
          style: TextStyle(
            fontFamily: 'DM',
            fontSize: 10.5.sp,
            color: AppColors.grayColor,
          ),
        ),
      ],
    );
  }

  Widget _buildFormatSelector(BookDetailsData? book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Format',
          style: TextStyle(
            fontFamily: 'DM',
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.darkColor,
          ),
        ),
        10.verticalSpace,
        Row(
          children: List.generate(_formats.length, (index) {
            final isSelected = _selectedFormatIndex == index;
            final icons = [
              Icons.book_outlined,
              Icons.menu_book_rounded,
              Icons.devices_other_rounded,
            ];

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _selectedFormatIndex = index;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: index < 2 ? 10.w : 0),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.mainColor.withValues(alpha: 0.08)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.mainColor
                          : AppColors.borderColor,
                      width: isSelected ? 1.8 : 1.2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.mainColor.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        icons[index],
                        size: 20.r,
                        color: isSelected
                            ? AppColors.mainColor
                            : AppColors.darkGrayColor,
                      ),
                      6.verticalSpace,
                      Text(
                        _formats[index],
                        style: TextStyle(
                          fontFamily: 'DM',
                          fontSize: 12.sp,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected
                              ? AppColors.mainColor
                              : AppColors.darkColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSegmentedTabSection(BookDetailsData? book) {
    final tabs = ['Overview', 'Specifications', 'Reviews'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.borderColor),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Segmented Header
          Container(
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F6),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              children: List.generate(tabs.length, (index) {
                final isSelected = _selectedTabSection == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _selectedTabSection = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          fontFamily: 'DM',
                          fontSize: 12.5.sp,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected
                              ? AppColors.darkColor
                              : AppColors.grayColor,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          16.verticalSpace,

          // Tab Content
          if (_selectedTabSection == 0)
            _buildOverviewContent(book)
          else if (_selectedTabSection == 1)
            _buildSpecificationsContent(book)
          else
            _buildReviewsContent(book),
        ],
      ),
    );
  }

  Widget _buildOverviewContent(BookDetailsData? book) {
    final description =
        (book?.description != null && book!.description!.trim().isNotEmpty)
            ? book.description!.trim()
            : 'Explore this captivating book and enrich your knowledge. Packed with inspiring concepts, profound storytelling, and memorable narratives tailored for curious minds.';

    final isLong = description.length > 180;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            description,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'DM',
              fontSize: 13.5.sp,
              color: AppColors.darkGrayColor,
              height: 1.65,
            ),
          ),
          secondChild: Text(
            description,
            style: TextStyle(
              fontFamily: 'DM',
              fontSize: 13.5.sp,
              color: AppColors.darkGrayColor,
              height: 1.65,
            ),
          ),
          crossFadeState: _isDescriptionExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
        if (isLong) ...[
          8.verticalSpace,
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                _isDescriptionExpanded = !_isDescriptionExpanded;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isDescriptionExpanded ? 'Show Less' : 'Read Full Overview',
                  style: TextStyle(
                    fontFamily: 'DM',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainColor,
                  ),
                ),
                4.horizontalSpace,
                Icon(
                  _isDescriptionExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 18.r,
                  color: AppColors.mainColor,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSpecificationsContent(BookDetailsData? book) {
    final specs = [
      {'label': 'Category', 'value': book?.category ?? 'General Fiction'},
      {'label': 'Format', 'value': _formats[_selectedFormatIndex]},
      {'label': 'Language', 'value': 'English (United States)'},
      {'label': 'Pages', 'value': '348 Printed Pages'},
      {'label': 'ISBN', 'value': '978-0143127741'},
      {'label': 'Dimensions', 'value': '5.5 x 0.9 x 8.4 inches'},
      {'label': 'Weight', 'value': '11.2 ounces'},
    ];

    return Column(
      children: specs.map((spec) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                spec['label']!,
                style: TextStyle(
                  fontFamily: 'DM',
                  fontSize: 12.5.sp,
                  color: AppColors.grayColor,
                ),
              ),
              Text(
                spec['value']!,
                style: TextStyle(
                  fontFamily: 'DM',
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkColor,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReviewsContent(BookDetailsData? book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overall Rating Highlight Box
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFC),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '4.9',
                        style: TextStyle(
                          fontFamily: 'DM',
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkColor,
                        ),
                      ),
                      6.horizontalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                Icons.star_rounded,
                                size: 14.r,
                                color: const Color(0xFFFFB800),
                              ),
                            ),
                          ),
                          Text(
                            'Based on 128 ratings',
                            style: TextStyle(
                              fontFamily: 'DM',
                              fontSize: 10.sp,
                              color: AppColors.grayColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.mainColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '98% Recommended',
                  style: TextStyle(
                    fontFamily: 'DM',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainColor,
                  ),
                ),
              ),
            ],
          ),
        ),

        14.verticalSpace,

        // Sample Verified Review
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundColor: AppColors.mainColor.withValues(alpha: 0.15),
              child: Text(
                'SA',
                style: TextStyle(
                  fontFamily: 'DM',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainColor,
                ),
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sarah Adams',
                        style: TextStyle(
                          fontFamily: 'DM',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkColor,
                        ),
                      ),
                      Text(
                        '2 days ago',
                        style: TextStyle(
                          fontFamily: 'DM',
                          fontSize: 10.5.sp,
                          color: AppColors.grayColor,
                        ),
                      ),
                    ],
                  ),
                  4.verticalSpace,
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        Icons.star_rounded,
                        size: 13.r,
                        color: const Color(0xFFFFB800),
                      ),
                    ),
                  ),
                  6.verticalSpace,
                  Text(
                    'Incredible quality and fast shipping. The book arrived in pristine condition. Highly recommended for every reading lover!',
                    style: TextStyle(
                      fontFamily: 'DM',
                      fontSize: 12.sp,
                      color: AppColors.darkGrayColor,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantitySection(BookDetailsData? book) {
    final stock = book?.stock ?? 0;
    final maxStock = stock > 0 ? stock : 1;
    final isOutOfStock = stock <= 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quantity',
                style: TextStyle(
                  fontFamily: 'DM',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkColor,
                ),
              ),
              2.verticalSpace,
              Text(
                isOutOfStock
                    ? 'Currently unavailable'
                    : 'Available in stock: $maxStock',
                style: TextStyle(
                  fontFamily: 'DM',
                  fontSize: 11.5.sp,
                  color: isOutOfStock
                      ? const Color(0xFFE53935)
                      : AppColors.grayColor,
                  fontWeight:
                      isOutOfStock ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Row(
              children: [
                _buildQuantityButton(
                  icon: Icons.remove_rounded,
                  onTap: isOutOfStock ? null : _decrementQuantity,
                  enabled: _quantity > 1 && !isOutOfStock,
                ),
                Container(
                  alignment: Alignment.center,
                  width: 44.w,
                  child: Text(
                    '$_quantity',
                    style: TextStyle(
                      fontFamily: 'DM',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkColor,
                    ),
                  ),
                ),
                _buildQuantityButton(
                  icon: Icons.add_rounded,
                  onTap: isOutOfStock ? null : () => _incrementQuantity(maxStock),
                  enabled: _quantity < maxStock && !isOutOfStock,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onTap,
    required bool enabled,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          width: 34.r,
          height: 34.r,
          decoration: BoxDecoration(
            color: enabled ? AppColors.mainColor : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10.r),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 18.r,
            color: enabled ? Colors.white : AppColors.grayColor,
          ),
        ),
      ),
    );
  }

  Widget _buildGuaranteesBanner() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.mainColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.mainColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildGuaranteeItem(
            icon: Icons.local_shipping_outlined,
            title: 'Free Shipping',
            desc: 'Over \$35',
          ),
          Container(
            height: 30.h,
            width: 1,
            color: AppColors.mainColor.withValues(alpha: 0.2),
          ),
          _buildGuaranteeItem(
            icon: Icons.restart_alt_rounded,
            title: '7 Days Return',
            desc: 'Hassle-free',
          ),
          Container(
            height: 30.h,
            width: 1,
            color: AppColors.mainColor.withValues(alpha: 0.2),
          ),
          _buildGuaranteeItem(
            icon: Icons.verified_user_outlined,
            title: '100% Genuine',
            desc: 'Guaranteed',
          ),
        ],
      ),
    );
  }

  Widget _buildGuaranteeItem({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20.r, color: AppColors.mainColor),
        6.verticalSpace,
        Text(
          title,
          style: TextStyle(
            fontFamily: 'DM',
            fontSize: 11.5.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.darkColor,
          ),
        ),
        2.verticalSpace,
        Text(
          desc,
          style: TextStyle(
            fontFamily: 'DM',
            fontSize: 10.sp,
            color: AppColors.grayColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStickyBottomBar(BookDetailsData? book) {
    final unitPrice = _getEffectivePrice(book);
    final totalPrice = (unitPrice * _quantity).toStringAsFixed(2);
    final isOutOfStock = (book?.stock ?? 0) <= 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Total Price Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total Price',
                  style: TextStyle(
                    fontFamily: 'DM',
                    fontSize: 11.5.sp,
                    color: AppColors.grayColor,
                    letterSpacing: 0.3,
                  ),
                ),
                Text(
                  '\$$totalPrice',
                  style: TextStyle(
                    fontFamily: 'DM',
                    fontSize: 23.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkColor,
                  ),
                ),
              ],
            ),
            18.horizontalSpace,

            // Primary Add To Cart Button
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isOutOfStock
                      ? null
                      : () {
                          HapticFeedback.heavyImpact();
                          _showCustomToast(
                            context,
                            icon: Icons.check_circle_rounded,
                            message:
                                'Added $_quantity × "${book?.name ?? 'Book'}" to your cart!',
                            color: const Color(0xFF2E7D32),
                          );
                        },
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    height: 54.h,
                    decoration: BoxDecoration(
                      gradient: isOutOfStock
                          ? null
                          : LinearGradient(
                              colors: [
                                AppColors.mainColor,
                                const Color(0xFFA88940),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      color: isOutOfStock ? Colors.grey.shade400 : null,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: isOutOfStock
                          ? null
                          : [
                              BoxShadow(
                                color:
                                    AppColors.mainColor.withValues(alpha: 0.38),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isOutOfStock
                              ? Icons.remove_shopping_cart_outlined
                              : Icons.shopping_bag_outlined,
                          color: Colors.white,
                          size: 20.r,
                        ),
                        10.horizontalSpace,
                        Text(
                          isOutOfStock ? 'Out of Stock' : 'Add To Cart',
                          style: TextStyle(
                            fontFamily: 'DM',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareBottomSheet(BuildContext context, BookDetailsData? book) {
    final bookTitle = book?.name ?? 'Discover this book on Bookia';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            16.verticalSpace,
            Text(
              'Share Book',
              style: TextStyle(
                fontFamily: 'DM',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.darkColor,
              ),
            ),
            8.verticalSpace,
            Text(
              'Recommend "$bookTitle" to your friends and book club members.',
              style: TextStyle(
                fontFamily: 'DM',
                fontSize: 12.5.sp,
                color: AppColors.grayColor,
              ),
            ),
            20.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildShareTargetItem(
                  icon: Icons.link_rounded,
                  label: 'Copy Link',
                  color: AppColors.mainColor,
                  onTap: () {
                    Navigator.pop(context);
                    Clipboard.setData(
                      ClipboardData(
                        text: 'Check out "$bookTitle" on Bookia: https://bookia.app/book/${book?.id ?? 0}',
                      ),
                    );
                    _showCustomToast(
                      context,
                      icon: Icons.copy_rounded,
                      message: 'Book link copied to clipboard!',
                      color: AppColors.darkColor,
                    );
                  },
                ),
                _buildShareTargetItem(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Messages',
                  color: const Color(0xFF25D366),
                  onTap: () {
                    Navigator.pop(context);
                    _showCustomToast(
                      context,
                      icon: Icons.send_rounded,
                      message: 'Shared to Messages!',
                      color: AppColors.darkColor,
                    );
                  },
                ),
                _buildShareTargetItem(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  color: const Color(0xFFEA4335),
                  onTap: () {
                    Navigator.pop(context);
                    _showCustomToast(
                      context,
                      icon: Icons.mail_rounded,
                      message: 'Opened Email client!',
                      color: AppColors.darkColor,
                    );
                  },
                ),
                _buildShareTargetItem(
                  icon: Icons.more_horiz_rounded,
                  label: 'More',
                  color: const Color(0xFF757575),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            14.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildShareTargetItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: color, size: 24.r),
          ),
          8.verticalSpace,
          Text(
            label,
            style: TextStyle(
              fontFamily: 'DM',
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.darkColor,
            ),
          ),
        ],
      ),
    );
  }

  // --- Skeleton Loading View ---

  Widget _buildSkeletonLoading() {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  12.verticalSpace,
                  Center(
                    child: Container(
                      height: 270.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(28.r),
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  Container(
                    width: 100.w,
                    height: 22.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  10.verticalSpace,
                  Container(
                    width: 250.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  14.verticalSpace,
                  Container(
                    height: 64.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  16.verticalSpace,
                  Container(
                    height: 80.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                  ),
                  16.verticalSpace,
                  Container(
                    height: 140.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  20.verticalSpace,
                ],
              ),
            ),
          ),
          Container(
            height: 74.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  // --- Error View ---

  Widget _buildErrorState(BuildContext context, int? bookId) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(28.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                shape: BoxShape.circle,
              ),
              child: Assets.images.error.image(width: 90.w, height: 90.w),
            ),
            18.verticalSpace,
            Text(
              'Unable to Load Book Details',
              style: TextStyle(
                fontFamily: 'DM',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.darkColor,
              ),
            ),
            8.verticalSpace,
            Text(
              'We encountered a problem fetching this book\'s data. Please check your internet connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DM',
                fontSize: 13.sp,
                color: AppColors.grayColor,
                height: 1.5,
              ),
            ),
            24.verticalSpace,
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (bookId != null) {
                    context.read<BookDetailsCubit>().getDetails(bookId);
                  }
                },
                borderRadius: BorderRadius.circular(14.r),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.mainColor,
                        const Color(0xFFA88940),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mainColor.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.refresh_rounded, color: Colors.white),
                      8.horizontalSpace,
                      Text(
                        'Try Again',
                        style: TextStyle(
                          fontFamily: 'DM',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
