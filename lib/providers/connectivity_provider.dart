// lib/providers/connectivity_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../services/connectivity_service.dart';

class ConnectivityProvider extends ChangeNotifier {
  final ConnectivityService _connectivityService = ConnectivityService();
  StreamSubscription<bool>? _connectionSubscription;

  bool _isConnected = true;
  bool _isInitialized = false;
  String _connectionType = 'Unknown';

  // Getters
  bool get isConnected => _isConnected;
  bool get isInitialized => _isInitialized;
  String get connectionType => _connectionType;

  ConnectivityProvider() {
    _initialize();
  }

  // Initialize connectivity monitoring
  Future<void> _initialize() async {
    try {
      debugPrint('🔌 ConnectivityProvider: Initializing...');

      // Initialize the service
      await _connectivityService.initialize();

      // Get initial connection status
      _isConnected = _connectivityService.hasConnection;
      _connectionType = await _connectivityService.getConnectionType();

      // Listen to connection changes
      _connectionSubscription = _connectivityService.connectionStream.listen(
        _onConnectionChanged,
        onError: (error) {
          debugPrint('🔌 ConnectivityProvider: Stream error: $error');
        },
      );

      _isInitialized = true;
      notifyListeners();

      debugPrint(
        '🔌 ConnectivityProvider: Initialized with connection: $_isConnected ($_connectionType)',
      );
    } catch (e) {
      debugPrint('🔌 ConnectivityProvider: Initialization error: $e');
      _isConnected = false;
      _isInitialized = true;
      notifyListeners();
    }
  }

  // Handle connection status changes
  void _onConnectionChanged(bool isConnected) async {
    debugPrint('🔌 ConnectivityProvider: Connection changed to: $isConnected');

    _isConnected = isConnected;

    // Update connection type
    _connectionType = await _connectivityService.getConnectionType();

    notifyListeners();
  }

  // Manually check connection
  Future<bool> checkConnection() async {
    try {
      final isConnected = await _connectivityService.checkConnection();

      if (_isConnected != isConnected) {
        _isConnected = isConnected;
        _connectionType = await _connectivityService.getConnectionType();
        notifyListeners();
      }

      return isConnected;
    } catch (e) {
      debugPrint('🔌 ConnectivityProvider: Error checking connection: $e');
      return false;
    }
  }

  // Test connection
  Future<bool> testConnection() async {
    try {
      return await _connectivityService.testConnection();
    } catch (e) {
      debugPrint('🔌 ConnectivityProvider: Error testing connection: $e');
      return false;
    }
  }

  // Refresh connection status
  Future<void> refresh() async {
    await checkConnection();
  }

  @override
  void dispose() {
    debugPrint('🔌 ConnectivityProvider: Disposing...');
    _connectionSubscription?.cancel();
    _connectivityService.dispose();
    super.dispose();
  }
}
