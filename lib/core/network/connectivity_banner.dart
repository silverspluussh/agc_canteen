import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'server_health.dart';

/// Non-blocking, lifecycle-aware status strip shown at the top of the app.
///
/// It never blocks the UI or the user: an already-signed-in offline device keeps
/// working from its local cache (handled elsewhere by the auth/sync layers).
/// This widget only surfaces *why* the server is not reachable.
class ConnectivityBanner extends StatefulWidget {
  const ConnectivityBanner({super.key, required this.child});

  final Widget child;

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner>
    with WidgetsBindingObserver {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  Timer? _reprobeTimer;

  bool _hasConnection = true;
  ServerStatus _server = ServerStatus.ok;
  bool _probing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _connectivitySub =
        _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
    _refresh();
  }

  @override
  void dispose() {
    _reprobeTimer?.cancel();
    _connectivitySub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refresh();
    }
  }

  static bool _isOnline(List<ConnectivityResult> results) =>
      results.contains(ConnectivityResult.wifi) ||
      results.contains(ConnectivityResult.ethernet) ||
      results.contains(ConnectivityResult.mobile) ||
      results.contains(ConnectivityResult.vpn);

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final online = _isOnline(results);
    if (!mounted) return;
    setState(() {
      _hasConnection = online;
      if (!online) {
        // Can't validate the server without a network; don't misreport it.
        _server = ServerStatus.ok;
      }
    });
    if (online) _probe();
  }

  Future<void> _refresh() async {
    final results = await _connectivity.checkConnectivity();
    final online = _isOnline(results);
    if (!mounted) return;
    setState(() {
      _hasConnection = online;
      if (!online) _server = ServerStatus.ok;
    });
    if (online) await _probe();
  }

  Future<void> _probe() async {
    if (_probing || !_hasConnection) return;
    _probing = true;
    final status = await ServerHealth.check();
    _probing = false;
    if (!mounted) return;
    setState(() => _server = status);
    _scheduleReprobe(status);
  }

  /// While the server looks unreachable, keep a slow retry going so the banner
  /// clears by itself once the server/network recovers.
  void _scheduleReprobe(ServerStatus status) {
    _reprobeTimer?.cancel();
    if (status == ServerStatus.ok || !_hasConnection) return;
    _reprobeTimer = Timer(const Duration(seconds: 30), () {
      if (mounted) _probe();
    });
  }

  @override
  Widget build(BuildContext context) {
    final banner = _bannerFor(context);
    return Column(
      children: [
        ?banner,
        Expanded(child: widget.child),
      ],
    );
  }

  Widget? _bannerFor(BuildContext context) {
    if (!_hasConnection) {
      return _banner(
        color: const Color(0xFFB45309), // amber-700
        icon: Icons.wifi_off,
        text: 'Offline; changes will sync when you reconnect',
      );
    }

    switch (_server) {
      case ServerStatus.ok:
        return null;
      case ServerStatus.dnsFailure:
        return _banner(
          color: const Color(0xFFB45309),
          icon: Icons.wifi_off,
          text: 'Wrong network, cannot reach the canteen server',
        );
      case ServerStatus.unreachable:
        return _banner(
          color: const Color(0xFFB45309),
          icon: Icons.cloud_off,
          text: 'Canteen server unreachable, working offline',
        );
      case ServerStatus.serverError:
        return _banner(
          color: const Color(0xFFB45309),
          icon: Icons.cloud_off,
          text: 'Canteen server not ready, working offline',
        );
      case ServerStatus.tlsError:
        return _banner(
          color: const Color(0xFFB91C1C), // red-700
          icon: Icons.lock_outline,
          text: 'Secure connection failed, contact IT',
        );
    }
  }

  Widget _banner({
    required Color color,
    required IconData icon,
    required String text,
  }) {
    return Material(
      color: color,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              Icon(icon, size: 16, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
