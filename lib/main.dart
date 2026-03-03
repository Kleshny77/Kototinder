import 'package:flutter/material.dart';
import 'core/di/app_container.dart';
import 'domain/entities/auth_user.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/onboarding_screen.dart';
import 'presentation/screens/signup_screen.dart';
import 'screens/breeds_list_screen.dart';
import 'screens/swipe_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кототиндер',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 8,
        ),
      ),
      home: const _AppGate(),
    );
  }
}

/// Determines first screen: onboarding → auth → main.
class _AppGate extends StatefulWidget {
  const _AppGate();

  @override
  State<_AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<_AppGate> {
  bool _ready = false;
  bool? _onboardingDone;
  AuthUser? _user;

  @override
  void initState() {
    super.initState();
    _resolveRoute();
  }

  Future<void> _resolveRoute() async {
    final onboardingDone =
        await AppContainer.onboardingRepository.isOnboardingCompleted();
    final user = await AppContainer.authRepository.getCurrentUser();
    if (mounted) {
      setState(() {
        _onboardingDone = onboardingDone;
        _user = user;
        _ready = true;
      });
    }
  }

  Future<void> _goToMain() async {
    final user = await AppContainer.authRepository.getCurrentUser();
    if (mounted) setState(() => _user = user);
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('🐱', style: TextStyle(fontSize: 64)),
              SizedBox(height: 24),
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }
    if (_onboardingDone != true) {
      return OnboardingScreen(onComplete: () {
        setState(() => _onboardingDone = true);
      });
    }
    if (_user == null) {
      return LoginScreen(
        onSuccess: _goToMain,
        onGoToSignUp: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SignUpScreen(
                onSuccess: _goToMain,
                onGoToLogin: () => Navigator.pop(context),
              ),
            ),
          );
        },
      );
    }
    return const MainScreen();
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const SwipeScreen(),
    const BreedsListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 14,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.pets, size: 28),
              label: 'Котики',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list, size: 28),
              label: 'Список пород',
            ),
          ],
        ),
      ),
    );
  }
}
