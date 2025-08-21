// lib/services/connectivity_service.dart - TUZATILGAN VERSIYA
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final InternetConnectionChecker _internetChecker =
      InternetConnectionChecker.createInstance();

  StreamController<bool>? _connectionStatusController;
  StreamSubscription<List<ConnectivityResult>>?
  _connectivitySubscription; // 🔧 TUZATILDI
  StreamSubscription<InternetConnectionStatus>? _internetSubscription;

  bool _hasConnection = true;
  bool get hasConnection => _hasConnection;

  // Stream to listen to connection changes
  Stream<bool> get connectionStream {
    _connectionStatusController ??= StreamController<bool>.broadcast();
    return _connectionStatusController!.stream;
  }

  // Initialize the service
  Future<void> initialize() async {
    debugPrint('🌐 ConnectivityService: Initializing...');

    try {
      // Check initial connection
      await checkConnection();

      // Listen to connectivity changes
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        _onConnectivityChanged,
        onError: (error) {
          debugPrint(
            '🌐 ConnectivityService: Connectivity stream error: $error',
          );
        },
      );

      // Listen to internet connection status
      _internetSubscription = _internetChecker.onStatusChange.listen(
        _onInternetStatusChanged,
        onError: (error) {
          debugPrint(
            '🌐 ConnectivityService: Internet checker stream error: $error',
          );
        },
      );

      debugPrint(
        '🌐 ConnectivityService: Initialized with connection: $_hasConnection',
      );
    } catch (e) {
      debugPrint('🌐 ConnectivityService: Initialization error: $e');
      _hasConnection = false;
    }
  }

  // Check current connection status
  Future<bool> checkConnection() async {
    try {
      final connectivityResults = await _connectivity
          .checkConnectivity(); // 🔧 TUZATILDI

      // 🔧 TUZATILDI: List<ConnectivityResult> ni tekshirish
      if (connectivityResults.contains(ConnectivityResult.none)) {
        _updateConnectionStatus(false);
        return false;
      }

      // Even if we have connectivity, check if we can actually reach the internet
      final hasInternet = await _internetChecker.hasConnection;
      _updateConnectionStatus(hasInternet);
      return hasInternet;
    } catch (e) {
      debugPrint('🌐 ConnectivityService: Error checking connection: $e');
      _updateConnectionStatus(false);
      return false;
    }
  }

  // 🔧 TUZATILDI: Handle connectivity changes
  void _onConnectivityChanged(List<ConnectivityResult> results) {
    debugPrint('🌐 ConnectivityService: Connectivity changed to $results');

    if (results.contains(ConnectivityResult.none)) {
      _updateConnectionStatus(false);
    } else {
      // When connectivity is restored, double-check internet access
      _checkInternetAfterConnectivity();
    }
  }

  // Handle internet status changes
  void _onInternetStatusChanged(InternetConnectionStatus status) {
    final isConnected = status == InternetConnectionStatus.connected;
    debugPrint('🌐 ConnectivityService: Internet status changed to $status');
    _updateConnectionStatus(isConnected);
  }

  // Check internet after connectivity is restored
  Future<void> _checkInternetAfterConnectivity() async {
    try {
      // Small delay to ensure connection is stable
      await Future.delayed(const Duration(seconds: 1));
      final hasInternet = await _internetChecker.hasConnection;
      _updateConnectionStatus(hasInternet);
    } catch (e) {
      debugPrint(
        '🌐 ConnectivityService: Error checking internet after connectivity: $e',
      );
      _updateConnectionStatus(false);
    }
  }

  // Update connection status
  void _updateConnectionStatus(bool isConnected) {
    if (_hasConnection != isConnected) {
      _hasConnection = isConnected;
      debugPrint(
        '🌐 ConnectivityService: Connection status updated to: $isConnected',
      );
      _connectionStatusController?.add(isConnected);
    }
  }

  // Test connection by pinging a reliable server
  Future<bool> testConnection() async {
    try {
      return await _internetChecker.hasConnection;
    } catch (e) {
      debugPrint('🌐 ConnectivityService: Error testing connection: $e');
      return false;
    }
  }

  // 🔧 TUZATILDI: Get connection type
  Future<String> getConnectionType() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();

      if (connectivityResults.contains(ConnectivityResult.wifi)) {
        return 'WiFi';
      } else if (connectivityResults.contains(ConnectivityResult.mobile)) {
        return 'Mobile Data';
      } else if (connectivityResults.contains(ConnectivityResult.ethernet)) {
        return 'Ethernet';
      } else if (connectivityResults.contains(ConnectivityResult.bluetooth)) {
        return 'Bluetooth';
      } else if (connectivityResults.contains(ConnectivityResult.vpn)) {
        return 'VPN';
      } else if (connectivityResults.contains(ConnectivityResult.other)) {
        return 'Other';
      } else {
        return 'No Connection';
      }
    } catch (e) {
      debugPrint('🌐 ConnectivityService: Error getting connection type: $e');
      return 'Unknown';
    }
  }

  // Dispose the service
  void dispose() {
    debugPrint('🌐 ConnectivityService: Disposing...');
    _connectivitySubscription?.cancel();
    _internetSubscription?.cancel();
    _connectionStatusController?.close();
    _connectionStatusController = null;
  }
}
