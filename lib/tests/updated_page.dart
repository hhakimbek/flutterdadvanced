import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

import '../services/update_service.dart';

/// Sahifa ochilishi bilan Play'dan update tekshiradi.
class UpdaterPage extends StatefulWidget {
  const UpdaterPage({super.key, this.service = const UpdateService()});

  final UpdateService service;

  @override
  State<UpdaterPage> createState() => _UpdaterPageState();
}

class _UpdaterPageState extends State<UpdaterPage> {
  UpdateService get _service => widget.service;

  UpdateCheckResult? _result;
  bool _checking = true;
  InstallStatus? _installStatus;
  StreamSubscription<InstallStatus>? _installSub;

  @override
  void initState() {
    super.initState();
    _installSub = _service.installStatusStream.listen((status) {
      if (!mounted) return;
      setState(() => _installStatus = status);
    });
    _check();
  }

  @override
  void dispose() {
    _installSub?.cancel();
    super.dispose();
  }

  Future<void> _check() async {
    setState(() => _checking = true);
    final result = await _service.checkForUpdate();
    if (!mounted) return;
    setState(() {
      _result = result;
      _checking = false;
    });
  }

  Future<void> _runFlexible() async {
    final result = await _service.startFlexibleUpdate();
    if (result == UpdateActionResult.success) {
      // Yuklab olindi — endi o'rnatishni taklif qilamiz.
      if (!mounted) return;
      setState(() => _installStatus = InstallStatus.downloaded);
      return;
    }
    _reportAction(result);
  }

  Future<void> _install() async {
    final result = await _service.completeUpdate();
    if (result != UpdateActionResult.success) _reportAction(result);
  }

  void _reportAction(UpdateActionResult result) {
    if (!mounted) return;
    final text = switch (result) {
      UpdateActionResult.success => 'Update muvaffaqiyatli.',
      UpdateActionResult.userDenied => 'Yangilanish bekor qilindi.',
      UpdateActionResult.failed => 'Yangilanishni bajarolmadik. Keyinroq urinib ko\'ring.',
      UpdateActionResult.unsupported => 'Bu platformada in-app update yo\'q.',
    };
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yangilanish'),
        actions: [
          IconButton(
            onPressed: _checking ? null : _check,
            icon: const Icon(Icons.refresh),
            tooltip: 'Qayta tekshirish',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(child: _buildBody()),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_checking) {
      return const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Yangilanish tekshirilmoqda...'),
        ],
      );
    }

    final result = _result;
    if (result == null) return const SizedBox.shrink();

    // Yuklab olish jarayoni ustunlik qiladi.
    if (_installStatus == InstallStatus.downloading ||
        _installStatus == InstallStatus.pending ||
        result.status == UpdateCheckStatus.downloading) {
      return _state(
        icon: Icons.downloading,
        title: 'Yuklab olinmoqda',
        message: 'Yangilanish fon rejimida yuklanmoqda. App\'dan '
            'foydalanishda davom etishingiz mumkin.',
        child: const Padding(
          padding: EdgeInsets.only(top: 24),
          child: LinearProgressIndicator(),
        ),
      );
    }

    if (_installStatus == InstallStatus.downloaded ||
        result.status == UpdateCheckStatus.readyToInstall) {
      return _state(
        icon: Icons.download_done,
        title: 'Yuklab olindi',
        message: 'O\'rnatish uchun app qayta ishga tushadi.',
        action: FilledButton.icon(
          onPressed: _install,
          icon: const Icon(Icons.restart_alt),
          label: const Text('O\'rnatish va qayta ishga tushirish'),
        ),
      );
    }

    return switch (result.status) {
      UpdateCheckStatus.available => _availableState(result),
      UpdateCheckStatus.upToDate => _state(
          icon: Icons.verified,
          color: Colors.green,
          title: 'Eng oxirgi versiya',
          message: 'App yangilangan holatda — hech narsa qilish kerak emas.',
        ),
      UpdateCheckStatus.unsupported => _state(
          icon: Icons.phonelink_off,
          title: 'Qo\'llab-quvvatlanmaydi',
          message: 'In-app update faqat Android (Play Store) uchun mavjud.',
        ),
      UpdateCheckStatus.error => _state(
          icon: Icons.error_outline,
          color: Theme.of(context).colorScheme.error,
          title: 'Tekshirib bo\'lmadi',
          message: _errorHint(result),
          action: OutlinedButton.icon(
            onPressed: _check,
            icon: const Icon(Icons.refresh),
            label: const Text('Qayta urinish'),
          ),
        ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _availableState(UpdateCheckResult result) {
    final version = result.availableVersionCode;
    final staleness = result.stalenessDays;

    return _state(
      icon: Icons.system_update,
      color: Theme.of(context).colorScheme.primary,
      title: 'Yangi versiya mavjud',
      message: [
        if (version != null) 'Versiya kodi: $version',
        if (staleness != null) 'Play\'da $staleness kundan beri mavjud',
        if (result.priority > 0) 'Prioritet: ${result.priority}/5',
      ].join('\n'),
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: result.flexibleAllowed ? _runFlexible : null,
                icon: const Icon(Icons.cloud_download_outlined),
                label: const Text('Yangilash'),
              ),
            ),
            if (!result.flexibleAllowed) ...[
              const SizedBox(height: 12),
              Text(
                'Bu yangilanishni app ichida yuklab bo\'lmaydi — '
                'Play Store\'dan qo\'lda yangilash kerak.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _state({
    required IconData icon,
    required String title,
    required String message,
    Color? color,
    Widget? action,
    Widget? child,
  }) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 64, color: color ?? theme.colorScheme.outline),
        const SizedBox(height: 20),
        Text(title, style: theme.textTheme.titleLarge),
        if (message.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        if (action != null) ...[const SizedBox(height: 24), action],
        ?child,
      ],
    );
  }

  String _errorHint(UpdateCheckResult result) {
    final code = result.errorCode ?? '';
    if (code.contains('APP_NOT_OWNED') || code.contains('-10')) {
      return 'App Play Store orqali o\'rnatilmagan. Bu funksiya faqat '
          'Play\'dan yuklangan build\'da ishlaydi (Internal testing ham bo\'ladi).';
    }
    return result.errorMessage ?? 'Noma\'lum xatolik.';
  }
}
