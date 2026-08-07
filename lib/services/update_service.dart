import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';

/// Update tekshiruvi natijasining umumlashgan holati.
enum UpdateCheckStatus {
  /// Yangi versiya mavjud.
  available,

  /// App eng oxirgi versiyada.
  upToDate,

  /// Update allaqachon yuklab olingan, faqat o'rnatish (restart) kerak.
  readyToInstall,

  /// Update yuklab olinmoqda (avval boshlangan flexible update).
  downloading,

  /// Platforma qo'llab-quvvatlamaydi (iOS, web, desktop).
  unsupported,

  /// Tekshirishda xatolik (internet yo'q, Play Store'dan o'rnatilmagan va h.k.).
  error,
}

/// [UpdateService.checkForUpdate] qaytaradigan natija.
class UpdateCheckResult {
  const UpdateCheckResult({
    required this.status,
    this.info,
    this.errorCode,
    this.errorMessage,
  });

  final UpdateCheckStatus status;

  /// Play API'dan kelgan xom ma'lumot. [status] == [UpdateCheckStatus.unsupported]
  /// yoki [UpdateCheckStatus.error] bo'lsa `null`.
  final AppUpdateInfo? info;

  /// `PlatformException.code` — masalan `ERROR_APP_NOT_OWNED`, `-10`.
  final String? errorCode;
  final String? errorMessage;

  bool get hasUpdate => status == UpdateCheckStatus.available;

  /// Yangi versiyaning `versionCode`i (pubspec'dagi `+N` qismi).
  int? get availableVersionCode => info?.availableVersionCode;

  /// Play Store bu update haqida necha kundan beri biladi.
  /// Majburiy yangilanishga o'tish qarorini shu asosida qabul qilish mumkin.
  int? get stalenessDays => info?.clientVersionStalenessDays;

  /// Play Developer API orqali o'rnatilgan prioritet (0..5).
  /// Console UI'da bu maydon yo'q — API'siz release qilinsa doim 0 bo'ladi.
  int get priority => info?.updatePriority ?? 0;

  bool get immediateAllowed => info?.immediateUpdateAllowed ?? false;

  bool get flexibleAllowed => info?.flexibleUpdateAllowed ?? false;
}

/// Update oqimining natijasi (foydalanuvchi rozi bo'ldi / bekor qildi / xato).
enum UpdateActionResult { success, userDenied, failed, unsupported }

/// Google Play In-App Updates ustidagi yupqa qatlam.
///
/// Faqat Android'da ishlaydi va app **Play Store orqali o'rnatilgan** bo'lishi
/// shart. Debug build yoki qo'lda o'rnatilgan APK'da `checkForUpdate`
/// `ERROR_APP_NOT_OWNED` / `-10` xatosini beradi — bu normal holat.
class UpdateService {
  const UpdateService();

  bool get isSupported => !kIsWeb && Platform.isAndroid;

  /// Yuklab olish jarayonini kuzatish uchun stream.
  /// Qo'llab-quvvatlanmagan platformada bo'sh stream qaytadi.
  Stream<InstallStatus> get installStatusStream {
    if (!isSupported) return const Stream<InstallStatus>.empty();
    return InAppUpdate.installUpdateListener;
  }

  /// Play'dan update holatini so'raydi. Hech qachon exception tashlamaydi —
  /// har qanday muammo [UpdateCheckStatus.error] bo'lib qaytadi.
  Future<UpdateCheckResult> checkForUpdate() async {
    if (!isSupported) {
      return const UpdateCheckResult(status: UpdateCheckStatus.unsupported);
    }

    try {
      final info = await InAppUpdate.checkForUpdate();
      return UpdateCheckResult(status: _statusFrom(info), info: info);
    } on PlatformException catch (e) {
      return UpdateCheckResult(
        status: UpdateCheckStatus.error,
        errorCode: e.code,
        errorMessage: e.message ?? e.code,
      );
    } catch (e) {
      return UpdateCheckResult(
        status: UpdateCheckStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  /// Majburiy yangilanish: Play to'liq ekranli oqimni o'zi boshqaradi,
  /// tugagach app qayta ishga tushadi.
  Future<UpdateActionResult> performImmediateUpdate() {
    return _guard(InAppUpdate.performImmediateUpdate);
  }

  /// Fon rejimida yuklab oladi — user app'dan foydalanishda davom etadi.
  /// Future muvaffaqiyat bilan tugasa, [completeUpdate] chaqirish mumkin.
  Future<UpdateActionResult> startFlexibleUpdate() {
    return _guard(InAppUpdate.startFlexibleUpdate);
  }

  /// Yuklab olingan flexible update'ni o'rnatadi va app'ni restart qiladi.
  Future<UpdateActionResult> completeUpdate() async {
    if (!isSupported) return UpdateActionResult.unsupported;
    try {
      await InAppUpdate.completeFlexibleUpdate();
      return UpdateActionResult.success;
    } catch (_) {
      return UpdateActionResult.failed;
    }
  }

  UpdateCheckStatus _statusFrom(AppUpdateInfo info) {
    // Avval boshlangan update davom etayotgan bo'lsa, install holatiga qaraymiz.
    if (info.updateAvailability ==
        UpdateAvailability.developerTriggeredUpdateInProgress) {
      switch (info.installStatus) {
        case InstallStatus.downloaded:
          return UpdateCheckStatus.readyToInstall;
        case InstallStatus.pending:
        case InstallStatus.downloading:
        case InstallStatus.installing:
          return UpdateCheckStatus.downloading;
        default:
          return UpdateCheckStatus.available;
      }
    }

    if (info.updateAvailability == UpdateAvailability.updateAvailable) {
      return info.installStatus == InstallStatus.downloaded
          ? UpdateCheckStatus.readyToInstall
          : UpdateCheckStatus.available;
    }

    return UpdateCheckStatus.upToDate;
  }

  Future<UpdateActionResult> _guard(
    Future<AppUpdateResult> Function() action,
  ) async {
    if (!isSupported) return UpdateActionResult.unsupported;
    try {
      final result = await action();
      switch (result) {
        case AppUpdateResult.success:
          return UpdateActionResult.success;
        case AppUpdateResult.userDeniedUpdate:
          return UpdateActionResult.userDenied;
        case AppUpdateResult.inAppUpdateFailed:
          return UpdateActionResult.failed;
      }
    } catch (_) {
      return UpdateActionResult.failed;
    }
  }
}
