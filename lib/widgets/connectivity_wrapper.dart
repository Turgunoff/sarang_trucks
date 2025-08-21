// lib/widgets/connectivity_wrapper.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/connectivity_provider.dart';
import '../screens/no_internet_screen.dart';

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;
  final bool showNoInternetScreen;

  const ConnectivityWrapper({
    super.key,
    required this.child,
    this.showNoInternetScreen = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivityProvider, _) {
        // If we should show no internet screen and there's no connection
        if (showNoInternetScreen &&
            connectivityProvider.isInitialized &&
            !connectivityProvider.isConnected) {
          return const NoInternetScreen();
        }

        // Otherwise show the child widget
        return child;
      },
    );
  }
}

// Global overlay for connection status
class ConnectionStatusOverlay extends StatefulWidget {
  final Widget child;

  const ConnectionStatusOverlay({super.key, required this.child});

  @override
  State<ConnectionStatusOverlay> createState() =>
      _ConnectionStatusOverlayState();
}

class _ConnectionStatusOverlayState extends State<ConnectionStatusOverlay>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  bool _showBanner = false;
  bool _wasDisconnected = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleConnectionChange(bool isConnected) {
    if (!isConnected && !_wasDisconnected) {
      // Connection lost
      _wasDisconnected = true;
      setState(() {
        _showBanner = true;
      });
      _animationController.forward();
    } else if (isConnected && _wasDisconnected) {
      // Connection restored
      _wasDisconnected = false;
      // Show "connection restored" banner briefly
      setState(() {
        _showBanner = true;
      });
      _animationController.forward();

      // Hide after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _animationController.reverse().then((_) {
            if (mounted) {
              setState(() {
                _showBanner = false;
              });
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivityProvider, _) {
        // Handle connection changes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (connectivityProvider.isInitialized) {
            _handleConnectionChange(connectivityProvider.isConnected);
          }
        });

        return Stack(
          children: [
            widget.child,

            // Connection status banner
            if (_showBanner)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SafeArea(
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: connectivityProvider.isConnected
                            ? Colors.green
                            : Colors.red,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            connectivityProvider.isConnected
                                ? Icons.wifi
                                : Icons.wifi_off,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              connectivityProvider.isConnected
                                  ? 'Internet aloqasi tiklandi'
                                  : 'Internet aloqasi yo\'q',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
