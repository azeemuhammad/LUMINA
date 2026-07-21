import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../widgets/shimmer_button.dart';
import 'select_photo_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const SelectPhotoScreen(),
    const Center(
        child: Text("History Coming Soon", style: TextStyle(fontSize: 24))),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF1F1F28),
        selectedItemColor: const Color(0xFFC3C0FF),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_photo_alternate), label: 'Enhance'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.camera_enhance, color: Color(0xFFC3C0FF), size: 40),
                SizedBox(width: 12),
                Text("LUMINA",
                    style:
                        TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Bring clarity to your memories.",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
            const SizedBox(height: 40),
            GlassCard(
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.auto_fix_high,
                        color: Color(0xFF4CD7F6), size: 40),
                    title: Text("Enhance Photo"),
                    subtitle: Text("Blur Removal, Sharpening & Colorization"),
                  ),
                  ShimmerButton(
                    text: "Start Restoration",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SelectPhotoScreen()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
