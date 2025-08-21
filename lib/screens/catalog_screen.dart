// lib/screens/catalog_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vehicle_provider.dart';
import '../widgets/vehicle_card.dart';
import '../models/vehicle.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    // Load vehicles when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleProvider>().loadVehicles(refresh: true);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          _buildSearchBar(),

          // Filters (if shown)
          if (_showFilters) _buildFilters(),

          // Vehicle list
          Expanded(child: _buildVehicleList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Mashina qidirish...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    context.read<VehicleProvider>().searchVehicles('');
                  },
                  icon: const Icon(Icons.clear),
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
        onChanged: (value) {
          setState(() {});
          // Debounce search
          Future.delayed(const Duration(milliseconds: 500), () {
            if (_searchController.text == value) {
              context.read<VehicleProvider>().searchVehicles(value);
            }
          });
        },
      ),
    );
  }

  Widget _buildFilters() {
    return Consumer<VehicleProvider>(
      builder: (context, vehicleProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter title
              Row(
                children: [
                  Icon(
                    Icons.tune,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Filterlar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      vehicleProvider.clearFilters();
                    },
                    child: const Text('Tozalash'),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Category filter
              if (vehicleProvider.categories.isNotEmpty) ...[
                Text(
                  'Kategoriya',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: vehicleProvider.categories.map((category) {
                    final isSelected =
                        vehicleProvider.selectedCategoryId == category.id;
                    return FilterChip(
                      label: Text(category.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        vehicleProvider.applyFilters(
                          categoryId: selected ? category.id : null,
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],

              // Capacity filter
              Text(
                'Minimal sig\'im (tonna)',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Slider(
                value: vehicleProvider.minCapacity ?? 1.0,
                min: 1.0,
                max: 25.0,
                divisions: 24,
                label:
                    '${(vehicleProvider.minCapacity ?? 1.0).toStringAsFixed(1)} t',
                onChanged: (value) {
                  vehicleProvider.applyFilters(minCapacity: value);
                },
              ),

              const SizedBox(height: 16),

              // Features filter
              Text(
                'Xususiyatlar',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('Haydovchi'),
                    selected: vehicleProvider.hasDriver,
                    onSelected: (selected) {
                      vehicleProvider.applyFilters(hasDriver: selected);
                    },
                  ),
                  FilterChip(
                    label: const Text('Konditsioner'),
                    selected: vehicleProvider.hasAC,
                    onSelected: (selected) {
                      vehicleProvider.applyFilters(hasAC: selected);
                    },
                  ),
                  FilterChip(
                    label: const Text('GPS'),
                    selected: vehicleProvider.hasGPS,
                    onSelected: (selected) {
                      vehicleProvider.applyFilters(hasGPS: selected);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVehicleList() {
    return Consumer<VehicleProvider>(
      builder: (context, vehicleProvider, child) {
        if (vehicleProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (vehicleProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Xatolik yuz berdi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  vehicleProvider.error!,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    vehicleProvider.loadVehicles(refresh: true);
                  },
                  child: const Text('Qayta urinish'),
                ),
              ],
            ),
          );
        }

        final vehicles = _searchController.text.isNotEmpty
            ? vehicleProvider.searchResults
            : vehicleProvider.vehicles;

        if (vehicles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  _searchController.text.isNotEmpty
                      ? 'Qidiruv bo\'yicha natija topilmadi'
                      : 'Mashinalar topilmadi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                if (_searchController.text.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    '"${_searchController.text}" uchun',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await vehicleProvider.loadVehicles(refresh: true);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: VehicleCard(
                  vehicle: vehicle,
                  isFavorite: vehicleProvider.isFavorite(vehicle.id),
                  onTap: () {
                    _navigateToVehicleDetails(vehicle);
                  },
                  onFavoriteToggle: () {
                    vehicleProvider.toggleFavorite(vehicle.id);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _navigateToVehicleDetails(Vehicle vehicle) {
    // Navigate to vehicle details screen
    // This will be implemented later
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${vehicle.name} batafsil ma\'lumotlari'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
