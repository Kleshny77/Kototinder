import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/di/app_container.dart';
import '../models/cat_image.dart';
import '../widgets/cat_card.dart';
import '../widgets/like_counter.dart';
import '../widgets/action_buttons.dart';
import '../widgets/gradient_background.dart';
import '../widgets/gradient_app_bar.dart';
import 'breed_detail_screen.dart';
import 'cat_image_detail_screen.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen>
    with SingleTickerProviderStateMixin {
  final _catRepository = AppContainer.catRepository;
  CatImage? _currentCat;
  final List<CatImage> _catQueue = [];
  bool _isLoading = true;
  int _likeCount = 0;
  double _swipeOffset = 0.0;
  bool _isSwipingRight = false;
  bool _isPreloading = false;
  late AnimationController _cardAnimationController;
  bool _isAnimating = false;

  static const int _queueSize = 5;

  @override
  void initState() {
    super.initState();
    _cardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _initializeQueue();
  }

  @override
  void dispose() {
    _cardAnimationController.dispose();
    super.dispose();
  }

  Future<void> _initializeQueue() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final futures = List.generate(
        _queueSize,
        (_) => _catRepository.getRandomCatImage(),
      );
      final cats = await Future.wait(futures);

      if (mounted) {
        _catQueue.addAll(cats);
        _loadNextCat();
        _preloadImages();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    }
  }

  void _loadNextCat() {
    if (_catQueue.isNotEmpty) {
      setState(() {
        _currentCat = _catQueue.removeAt(0);
        _isLoading = false;
        _swipeOffset = 0.0;
      });
      _refillQueue();
    } else {
      _initializeQueue();
    }
  }

  Future<void> _refillQueue() async {
    if (_isPreloading || _catQueue.length >= _queueSize) return;

    _isPreloading = true;
    try {
      final cat = await _catRepository.getRandomCatImage();
      if (mounted) {
        _catQueue.add(cat);
        precacheImage(CachedNetworkImageProvider(cat.url), context);
      }
    } catch (_) {
      // ignore preload failure
    } finally {
      _isPreloading = false;
    }
  }

  void _preloadImages() {
    for (var cat in _catQueue) {
      precacheImage(CachedNetworkImageProvider(cat.url), context);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _loadNextCat();
            },
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }

  void _onLike() {
    if (_isAnimating) return;
    setState(() {
      _likeCount++;
    });
    _animateCardExit(true);
  }

  void _onDislike() {
    if (_isAnimating) return;
    _animateCardExit(false);
  }

  void _animateCardExit(bool isLike) {
    if (_isAnimating) return;
    _isAnimating = true;

    _cardAnimationController.forward().then((_) {
      if (mounted) {
        _loadNextCat();
        _cardAnimationController.reset();
        _isAnimating = false;
      }
    });
  }

  Widget _buildContent() {
    final cat = _currentCat;
    if (cat == null) return const SizedBox.shrink();
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: AnimatedBuilder(
              animation: _cardAnimationController,
              builder: (context, child) {
                final opacity = _isAnimating
                    ? 1.0 -
                        Curves.easeOut.transform(
                          _cardAnimationController.value,
                        )
                    : 1.0;
                return CatCard(
                  cat: cat,
                  swipeOffset: _swipeOffset,
                  isSwipingRight: _isSwipingRight,
                  opacity: opacity,
                  onTap: _openDetail,
                  onDragUpdate: (delta) {
                    setState(() {
                      _swipeOffset += delta;
                      _isSwipingRight = _swipeOffset > 0;
                    });
                  },
                  onDragEnd: () {
                    if (_swipeOffset.abs() > 100) {
                      if (_isSwipingRight) {
                        _onLike();
                      } else {
                        _onDislike();
                      }
                    } else {
                      setState(() {
                        _swipeOffset = 0.0;
                      });
                    }
                  },
                );
              },
            ),
          ),
        ),
        ActionButtons(onDislike: _onDislike, onLike: _onLike),
      ],
    );
  }

  void _openDetail() {
    final cat = _currentCat;
    if (cat == null) return;
    final breed = cat.breed;
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => breed != null
            ? BreedDetailScreen(
                breed: breed,
                imageUrl: cat.url,
              )
            : CatImageDetailScreen(imageUrl: cat.url),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'Кототиндер',
        actions: [Center(child: LikeCounter(count: _likeCount))],
      ),
      body: GradientBackground(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : _currentCat == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Не удалось загрузить котика',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadNextCat,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.deepPurple,
                      ),
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              )
            : _buildContent(),
      ),
    );
  }
}
