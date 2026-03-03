import 'package:flutter/material.dart';
import '../core/di/app_container.dart';
import '../models/breed.dart';
import '../widgets/breed_card.dart';
import '../widgets/gradient_background.dart';
import '../widgets/gradient_app_bar.dart';

class BreedsListScreen extends StatefulWidget {
  const BreedsListScreen({super.key});

  @override
  State<BreedsListScreen> createState() => _BreedsListScreenState();
}

class _BreedsListScreenState extends State<BreedsListScreen> {
  final _catRepository = AppContainer.catRepository;
  List<Breed> _breeds = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBreeds();
  }

  Future<void> _loadBreeds() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final breeds = await _catRepository.getAllBreeds();
      setState(() {
        _breeds = breeds;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      if (mounted) {
        _showErrorDialog(e.toString());
      }
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
              _loadBreeds();
            },
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Список пород'),
      body: GradientBackground(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : _error != null && _breeds.isEmpty
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
                      'Не удалось загрузить породы',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _loadBreeds,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Повторить'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              )
            : SafeArea(
                child: RefreshIndicator(
                  onRefresh: _loadBreeds,
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: _breeds.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      return BreedCard(breed: _breeds[index]);
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
