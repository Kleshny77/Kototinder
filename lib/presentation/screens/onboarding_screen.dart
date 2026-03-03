import 'package:flutter/material.dart';
import '../../core/di/app_container.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    required this.onComplete,
  });

  final VoidCallback onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _catController;
  int _currentPage = 0;

  static const _steps = [
    _OnboardingStep(
      title: 'Свайпай котиков',
      text: 'Листай карточки влево и вправо. Лайк — вправо, дизлайк — влево.',
      icon: Icons.swipe,
      catEmoji: '🐱',
    ),
    _OnboardingStep(
      title: 'Узнавай о породах',
      text: 'Нажми на карточку и читай описание породы, характер и характеристики.',
      icon: Icons.info_outline,
      catEmoji: '😺',
    ),
    _OnboardingStep(
      title: 'Список пород',
      text: 'Во вкладке «Список пород» смотри все породы и открывай детали по тапу.',
      icon: Icons.list,
      catEmoji: '🐈',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _catController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _catController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await AppContainer.onboardingRepository.setOnboardingCompleted();
    if (mounted) widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade400,
              Colors.purple.shade300,
              Colors.pink.shade200,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _steps.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (context, index) {
                    return _OnboardingPage(
                      step: _steps[index],
                      pageIndex: index,
                      animation: _catController,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        _steps.length,
                        (i) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == i
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    ),
                    FilledButton(
                      onPressed: () {
                        if (_currentPage >= _steps.length - 1) {
                          _finish();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.deepPurple,
                      ),
                      child: Text(
                        _currentPage >= _steps.length - 1 ? 'Начать' : 'Далее',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingStep {
  const _OnboardingStep({
    required this.title,
    required this.text,
    required this.icon,
    required this.catEmoji,
  });
  final String title;
  final String text;
  final IconData icon;
  final String catEmoji;
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.step,
    required this.pageIndex,
    required this.animation,
  });

  final _OnboardingStep step;
  final int pageIndex;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 14 * (animation.value - 0.5)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      step.catEmoji,
                      style: const TextStyle(fontSize: 72),
                    ),
                    const SizedBox(height: 8),
                    Icon(
                      step.icon,
                      size: 48,
                      color: Colors.white,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 48),
          Text(
            step.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            step.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
