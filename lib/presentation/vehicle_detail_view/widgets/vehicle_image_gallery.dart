import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VehicleImageGallery extends StatefulWidget {
  final List<String> images;
  final VoidCallback onBack;
  final VoidCallback onFavorite;
  final VoidCallback onShare;
  final bool isFavorite;

  const VehicleImageGallery({
    Key? key,
    required this.images,
    required this.onBack,
    required this.onFavorite,
    required this.onShare,
    required this.isFavorite,
  }) : super(key: key);

  @override
  State<VehicleImageGallery> createState() => _VehicleImageGalleryState();
}

class _VehicleImageGalleryState extends State<VehicleImageGallery> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40.h,
        child: Stack(children: [
          // Image PageView
          PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () => _showFullScreenGallery(context, index),
                    child: CustomImageWidget(
                        imageUrl: widget.images[index],
                        width: double.infinity,
                        height: 40.h,
                        fit: BoxFit.cover));
              }),
          // Gradient overlay for better text visibility
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.transparent,
                Colors.transparent,
                Colors.black.withValues(alpha: 0.3),
              ]))),
          // Top controls
          Positioned(
              top: MediaQuery.of(context).padding.top + 1.h,
              left: 4.w,
              right: 4.w,
              child: Row(children: [
                GestureDetector(
                    onTap: widget.onBack,
                    child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle),
                        child: CustomIconWidget(
                            iconName: 'arrow_back',
                            color: Colors.white,
                            size: 20))),
                const Spacer(),
                GestureDetector(
                    onTap: widget.onShare,
                    child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle),
                        child: CustomIconWidget(
                            iconName: 'share', color: Colors.white, size: 20))),
                SizedBox(width: 2.w),
                GestureDetector(
                    onTap: widget.onFavorite,
                    child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle),
                        child: CustomIconWidget(
                            iconName: widget.isFavorite
                                ? 'favorite'
                                : 'favorite_border',
                            color:
                                widget.isFavorite ? Colors.red : Colors.white,
                            size: 20))),
              ])),
          // Page indicators
          if (widget.images.length > 1)
            Positioned(
                bottom: 2.h,
                left: 0,
                right: 0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.images.asMap().entries.map((entry) {
                      return Container(
                          width: _currentIndex == entry.key ? 8 : 6,
                          height: _currentIndex == entry.key ? 8 : 6,
                          margin: EdgeInsets.symmetric(horizontal: 1.w),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == entry.key
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.5)));
                    }).toList())),
          // Image counter
          Positioned(
              bottom: 2.h,
              right: 4.w,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text('${_currentIndex + 1}/${widget.images.length}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w500)))),
        ]));
  }

  void _showFullScreenGallery(BuildContext context, int initialIndex) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => _FullScreenGallery(
                images: widget.images, initialIndex: initialIndex)));
  }
}

class _FullScreenGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const _FullScreenGallery({
    Key? key,
    required this.images,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<_FullScreenGallery> createState() => __FullScreenGalleryState();
}

class __FullScreenGalleryState extends State<_FullScreenGallery> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [
          PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 3.0,
                    child: Center(
                        child: CustomImageWidget(
                            imageUrl: widget.images[index],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.contain)));
              }),
          Positioned(
              top: MediaQuery.of(context).padding.top + 1.h,
              left: 4.w,
              child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle),
                      child: CustomIconWidget(
                          iconName: 'close', color: Colors.white, size: 20)))),
          if (widget.images.length > 1)
            Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 2.h,
                left: 0,
                right: 0,
                child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                        '${_currentIndex + 1} of ${widget.images.length}',
                        textAlign: TextAlign.center,
                        style: AppTheme.lightTheme.textTheme.bodyMedium
                            ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500)))),
        ]));
  }
}