import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/cat_image.dart';

class CatCard extends StatelessWidget {
  final CatImage cat;
  final double swipeOffset;
  final bool isSwipingRight;
  final double opacity;
  final VoidCallback onTap;
  final Function(double) onDragUpdate;
  final Function() onDragEnd;

  const CatCard({
    super.key,
    required this.cat,
    required this.swipeOffset,
    required this.isSwipingRight,
    required this.opacity,
    required this.onTap,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onHorizontalDragUpdate: (details) => onDragUpdate(details.delta.dx),
      onHorizontalDragEnd: (details) => onDragEnd(),
      child: Transform.translate(
        offset: Offset(swipeOffset, 0),
        child: Transform.rotate(
          angle: swipeOffset / 1000,
          child: Opacity(
            opacity: opacity,
            child: _CardContainer(
              child: _CardContent(
                cat: cat,
                isSwipingRight: isSwipingRight,
                swipeOffset: swipeOffset,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardContainer extends StatelessWidget {
  final Widget child;

  const _CardContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 30,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Card(margin: EdgeInsets.zero, elevation: 0, child: child),
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  final CatImage cat;
  final bool isSwipingRight;
  final double swipeOffset;

  const _CardContent({
    required this.cat,
    required this.isSwipingRight,
    required this.swipeOffset,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(child: _CatImage(imageUrl: cat.url)),
            _CatInfo(cat: cat),
          ],
        ),
        if (swipeOffset.abs() > 20)
          _SwipeIndicator(isSwipingRight: isSwipingRight),
      ],
    );
  }
}

class _CatImage extends StatelessWidget {
  final String imageUrl;

  const _CatImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[300],
          child: const Icon(Icons.error, size: 50),
        ),
      ),
    );
  }
}

class _CatInfo extends StatelessWidget {
  final CatImage cat;

  const _CatInfo({required this.cat});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cat.breedName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          if (cat.breed?.origin != null) ...[
            const SizedBox(height: 4),
            Text(
              cat.breed!.origin!,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
          const SizedBox(height: 8),
          const Text(
            'Нажмите на изображение для деталей',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeIndicator extends StatelessWidget {
  final bool isSwipingRight;

  const _SwipeIndicator({required this.isSwipingRight});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSwipingRight
              ? Colors.green.withValues(alpha: 0.3)
              : Colors.red.withValues(alpha: 0.3),
        ),
        child: Center(
          child: Icon(
            isSwipingRight ? Icons.favorite : Icons.close,
            size: 100,
            color: isSwipingRight ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}
