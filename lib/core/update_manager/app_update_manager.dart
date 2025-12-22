import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateData {
  final String name;
  final String currentVersion;
  final String latestVersion;
  final String storeUrl;
  final bool hasUpdate;
  final bool isForceUpdate;

  UpdateData({
    required this.name,
    required this.currentVersion,
    required this.latestVersion,
    required this.storeUrl,
    required this.hasUpdate,
    required this.isForceUpdate,
  });
}

class AppUpdateManager {
  static final AppUpdateManager _instance = AppUpdateManager._internal();

  factory AppUpdateManager() => _instance;

  AppUpdateManager._internal();

  static const String _baseUrl = 'http://209.250.237.58:5670/versions/';
  late final Dio _dio;
  late final String _bundleId;
  late final GlobalKey<NavigatorState> _navigatorKey;
  bool _isInitialized = false;
  bool _isChecking = false;
  bool _dialogVisible = false;
  OverlayEntry? _overlayEntry;

  static Future<void> initialize(String bundleId, GlobalKey<NavigatorState> navigatorKey) async {
    await AppUpdateManager()._init(bundleId, navigatorKey);
  }

  Future<void> _init(String bundleId, GlobalKey<NavigatorState> navigatorKey) async {
    if (_isInitialized) return;
    _bundleId = bundleId;
    _navigatorKey = navigatorKey;
    _dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      )
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          compact: true,
          maxWidth: 80,
        ),
      );
    _isInitialized = true;
    WidgetsBinding.instance.addObserver(_LifecycleObserver());
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkSilently());
  }

  Future<void> checkWithDialog() async {
    final data = await _fetchUpdateData();
    if (data == null) {
      _showDialog(_errorDialog('فشل في التحقق من التحديثات'));
      return;
    }
    if (data.hasUpdate) {
      _showDialog(_updateDialog(data));
    } else {
      _showDialog(_noUpdateDialog());
    }
  }

  Future<void> _checkSilently() async {
    final data = await _fetchUpdateData();
    if (data?.hasUpdate == true) {
      _showDialog(_updateDialog(data!));
    }
  }

  Future<UpdateData?> _fetchUpdateData() async {
    if (_isChecking || !_isInitialized) return null;
    try {
      _isChecking = true;
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final response = await _dio.get('$_baseUrl$_bundleId');
      if (response.statusCode != 200) return null;
      final json = response.data as Map<String, dynamic>;
      final appName = json['name']?.toString() ?? 'التطبيق';
      final latestVersion =
          Platform.isAndroid
              ? json['androidVersion']?.toString() ?? json['version']?.toString() ?? '1.0.0'
              : json['iosVersion']?.toString() ?? json['version']?.toString() ?? '1.0.0';
      final storeUrl =
          Platform.isAndroid
              ? json['googlePlayUrl']?.toString() ?? ''
              : json['appStoreUrl']?.toString() ?? '';
      final isForceUpdate = json['isForceUpdate'] == true;
      if (storeUrl.isEmpty) return null;
      final hasUpdate = _needsUpdate(currentVersion, latestVersion);
      return UpdateData(
        name: appName,
        currentVersion: currentVersion,
        latestVersion: latestVersion,
        storeUrl: storeUrl,
        hasUpdate: hasUpdate,
        isForceUpdate: isForceUpdate,
      );
    } catch (e) {
      debugPrint('Update check failed: $e');
      return null;
    } finally {
      _isChecking = false;
    }
  }

  bool _needsUpdate(String current, String latest) {
    try {
      final currentParts = current.split('.').map(int.parse).toList();
      final latestParts = latest.split('.').map(int.parse).toList();
      final maxLength = [currentParts.length, latestParts.length].reduce((a, b) => a > b ? a : b);
      while (currentParts.length < maxLength) {
        currentParts.add(0);
      }
      while (latestParts.length < maxLength) {
        latestParts.add(0);
      }
      for (int i = 0; i < maxLength; i++) {
        if (latestParts[i] > currentParts[i]) return true;
        if (latestParts[i] < currentParts[i]) return false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void _showDialog(Widget dialog) {
    final context = _navigatorKey.currentContext;
    if (context == null || _dialogVisible) return;
    _dialogVisible = true;
    _overlayEntry = OverlayEntry(
      builder:
          (_) => Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                child: Container(color: Colors.black.withValues(alpha: 0.3)),
              ),
              Center(child: dialog),
            ],
          ),
    );
    final overlay = _navigatorKey.currentState?.overlay;
    if (overlay != null && _overlayEntry != null) overlay.insert(_overlayEntry!);
  }

  void _dismissDialog() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _dialogVisible = false;
  }

  Widget _updateDialog(UpdateData data) {
    return PopScope(
      canPop: !data.isForceUpdate,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white /*.withValues(alpha:0.85)*/,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.red.withValues(alpha: 0.1),
                    child: Icon(
                      data.isForceUpdate ? Icons.warning_rounded : Icons.system_update_alt_rounded,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    data.isForceUpdate ? 'تحديث إجباري' : 'تحديث متاح',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    data.isForceUpdate
                        ? 'لا يمكنك متابعة استخدام ${data.name} بدون التحديث.'
                        : 'يوجد إصدار جديد من ${data.name}.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  _versionRow('الإصدار الحالي', data.currentVersion, Colors.orange),
                  const SizedBox(height: 8),
                  _versionRow('الإصدار الجديد', data.latestVersion, Colors.green),
                  const SizedBox(height: 30),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await _openStore(data.storeUrl);
                          if (!data.isForceUpdate) _dismissDialog();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('تحديث الآن', style: TextStyle(fontSize: 16)),
                      ),
                      if (!data.isForceUpdate)
                        TextButton(
                          onPressed: _dismissDialog,
                          child: const Text('لاحقًا', style: TextStyle(color: Colors.grey)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _noUpdateDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white /*.withValues(alpha:0.85)*/,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline, size: 50, color: Colors.green),
                const SizedBox(height: 12),
                const Text(
                  'أنت تستخدم أحدث إصدار',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text('لا يوجد تحديث متاح حالياً.', textAlign: TextAlign.center),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _dismissDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    minimumSize: const Size.fromHeight(45),
                  ),
                  child: const Text('موافق'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _errorDialog(String message) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white /*.withValues(alpha:0.85)*/,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 50, color: Colors.red),
                const SizedBox(height: 12),
                const Text(
                  'حدث خطأ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                const SizedBox(height: 10),
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _dismissDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    minimumSize: const Size.fromHeight(45),
                  ),
                  child: const Text('حسناً'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _versionRow(String label, String version, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            version,
            style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Future<void> _openStore(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Store launch failed: $e');
    }
  }

  void _onAppResumed() {
    if (_isInitialized && !_dialogVisible) {
      _checkSilently();
    }
  }
}

class _LifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      AppUpdateManager()._onAppResumed();
    }
  }
}
