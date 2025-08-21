// lib/widgets/hero_section.dart
import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Professional yuk mashinalari ijarasi',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Ishonchli xizmat, qulay narxlar',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Catalog tab-ga o'tish uchun
                _navigateToCatalog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Katalogni ko\'rish',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCatalog(BuildContext context) {
    // MainScreen state-ni topib, catalog tab-ga o'tish
    // Hozircha oddiy snackbar ko'rsatamiz
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Katalog sahifasiga o\'tish...'),
        duration: Duration(seconds: 1),
      ),
    );

    // Alternatif: Agar MainScreen-da method mavjud bo'lsa
    // try {
    //   final mainScreenState = context.findAncestorStateOfType<_MainScreenState>();
    //   mainScreenState?.onTabTapped(1); // Catalog tab index
    // } catch (e) {
    //   // Fallback
    // }
  }
}
