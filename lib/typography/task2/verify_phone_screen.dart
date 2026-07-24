import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'app_style.dart';

class VerifyPhoneScreen extends StatefulWidget {
  final String phoneNumber;
  const VerifyPhoneScreen({super.key, required this.phoneNumber});

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> with CodeAutoFill {
  static const _codeLength = 4;
  String _currentCode = '';
  String? _appSignature;

  @override
  void initState() {
    super.initState();
    _startAutofill();
  }

  Future<void> _startAutofill() async {
    if (Platform.isAndroid) {
      final signature = await SmsAutoFill().getAppSignature;
      if (mounted) setState(() => _appSignature = signature);
    }
    await SmsAutoFill().listenForCode();
  }

  @override
  void codeUpdated() {
    if (!mounted) return;
    setState(() => _currentCode = code ?? '');
  }

  @override
  void dispose() {
    cancel();
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  void _verify() {
    if (_currentCode.length < _codeLength) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(content: Text('Please enter the full code')),
        );
      return;
    }
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          backgroundColor: TolkiColors.primary,
          content: Text('Verifying code $_currentCode ...'),
        ),
      );
  }

  Future<void> _resend() async {
    await SmsAutoFill().listenForCode();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(content: Text('A new code has been sent')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TolkiColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: TolkiColors.textPrimary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Text(
                'Verify Phone',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: TolkiColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Code has been sent to ${widget.phoneNumber}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: TolkiColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              PinFieldAutoFill(
                codeLength: _codeLength,
                currentCode: _currentCode,
                onCodeChanged: (value) {
                  setState(() => _currentCode = value ?? '');
                },
                onCodeSubmitted: (_) => _verify(),
                decoration: BoxLooseDecoration(
                  radius: const Radius.circular(14),
                  gapSpace: 14,
                  strokeWidth: 1.4,
                  strokeColorBuilder: PinListenColorBuilder(
                    TolkiColors.primary,
                    TolkiColors.otpEmpty,
                  ),
                  bgColorBuilder: PinListenColorBuilder(
                    TolkiColors.primary,
                    const Color(0xFFF4F4FA),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't get OTP Code ?  ",
                    style: TextStyle(
                      fontSize: 13,
                      color: TolkiColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: _resend,
                    child: const Text(
                      'Resend Code',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: TolkiColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              TolkiButton(text: 'Verify', onPressed: _verify),
              if (_appSignature != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: TolkiColors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'App signature: $_appSignature',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      color: TolkiColors.textSecondary,
                    ),
                  ),
                ),
              ],
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
