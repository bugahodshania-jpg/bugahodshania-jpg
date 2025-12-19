import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/classification_provider.dart';
import 'screens/home_screen.dart';
import 'screens/history_screen.dart';
import 'screens/charts_screen.dart';
import 'screens/class_info_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/main_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TeachableMachineApp());
}

class TeachableMachineApp extends StatelessWidget {
  const TeachableMachineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClassificationProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Teachable Machine Classifier',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        home: const LandingScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ClassInfoScreen(),
    const MainHomeScreen(),
    const HistoryScreen(),
    const ChartsScreen(),
  ];

  // 🎨 Colors
  final Color darkBlue = const Color(0xFF0A2540);
  final Color tealBlue = const Color.fromARGB(255, 15, 185, 177);
  final LinearGradient iconGradient = const LinearGradient(
    colors: [Color(0xFF0A2540), Color(0xFF0FB9B1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.camera_alt_outlined, 'Camera', 0),
            _buildNavItem(Icons.info_outline, 'Classes', 1),
            _buildNavItem(Icons.home_outlined, 'Home', 2),
            _buildNavItem(Icons.history_outlined, 'History', 3),
            _buildNavItem(Icons.bar_chart_outlined, 'Charts', 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    final Color selectedColor = const Color(
      0xFF0FB9B1,
    ); // Use solid color instead of gradient

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              color: isSelected ? selectedColor : Colors.grey.shade400,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? selectedColor : Colors.grey.shade400,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 100), // Reduced from 200ms
            margin: const EdgeInsets.only(top: 6),
            height: 3,
            width: isSelected ? 30 : 0,
            decoration: BoxDecoration(
              color: selectedColor, // Use solid color instead of gradient
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
        ],
      ),
    );
  }
}
