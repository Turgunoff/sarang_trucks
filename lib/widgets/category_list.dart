// lib/widgets/category_list.dart - TUZATILGAN VERSIYA
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vehicle_provider.dart';
import '../models/category.dart';
import '../screens/catalog_screen.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VehicleProvider>(
      builder: (context, vehicleProvider, child) {
        if (vehicleProvider.categories.isEmpty) {
          return _buildEmptyState(context);
        }

        return SizedBox(
          height: 170, // Increased height for better visuals
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: vehicleProvider.categories.length,
            itemBuilder: (context, index) {
              final category = vehicleProvider.categories[index];
              return _buildCategoryCard(context, category, index);
            },
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    Category category,
    int index,
  ) {
    // Different colors for each category
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];

    final color = colors[index % colors.length];

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        // Scale qiymatini musbat qilib saqlash
        final safeScale = value.clamp(0.0, 2.0);
        return Transform.scale(
          scale: safeScale,
          child: Container(
            width: 130,
            margin: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () => _onCategoryTap(context, category),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withOpacity(0.2), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon container with glow effect
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: _buildCategoryIcon(category, color),
                      ),

                      const SizedBox(height: 12),

                      // Category name
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: color.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // Vehicle count (mock data for now)
                      Text(
                        '${(index + 1) * 5}+ ta',
                        style: TextStyle(
                          fontSize: 11,
                          color: color.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryIcon(Category category, Color color) {
    // Map category names to appropriate icons
    IconData icon;
    switch (category.name.toLowerCase()) {
      case 'kichik yuk mashinalari':
      case 'kichik':
        icon = Icons.local_shipping_outlined;
        break;
      case 'o\'rta yuk mashinalari':
      case 'o\'rta':
        icon = Icons.fire_truck_outlined;
        break;
      case 'katta yuk mashinalari':
      case 'katta':
        icon = Icons.airport_shuttle_outlined;
        break;
      case 'furgonlar':
      case 'furgan':
        icon = Icons.rv_hookup_outlined;
        break;
      default:
        icon = Icons.local_shipping_outlined;
    }

    return Icon(icon, size: 32, color: color);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'Kategoriyalar yuklanmoqda...',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔧 TUZATILGAN: Category tanlanganda catalog screen'ga o'tish
  void _onCategoryTap(BuildContext context, Category category) async {
    try {
      // 1. Filter qo'llash
      final vehicleProvider = context.read<VehicleProvider>();
      await vehicleProvider.applyFilters(categoryId: category.id);

      // 2. Catalog screen'ga navigate qilish
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const CatalogScreen()));

      // 3. Success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.category, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${category.name} kategoriyasi tanlandi',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint('❌ Category tanlashda xatolik: $e');

      // Error feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Xatolik yuz berdi. Qayta urinib ko\'ring.',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
