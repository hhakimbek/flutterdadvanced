import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'app_style.dart';
import 'verify_phone_screen.dart';

class Country {
  final String name;
  final String flag;
  final String dialCode;
  const Country(this.name, this.flag, this.dialCode);
}

const _countries = <Country>[
  Country('Uzbekistan', '🇺🇿', '+998'),
  Country('Indonesia', '🇮🇩', '+62'),
  Country('United States', '🇺🇸', '+1'),
  Country('India', '🇮🇳', '+91'),
  Country('United Kingdom', '🇬🇧', '+44'),
  Country('Russia', '🇷🇺', '+7'),
  Country('Turkey', '🇹🇷', '+90'),
  Country('Germany', '🇩🇪', '+49'),
];

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  Country _selected = _countries.first;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _autofillPhone());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _autofillPhone() async {
    if (!Platform.isAndroid) return;
    try {
      final hint = await SmsAutoFill().hint;
      if (hint == null || hint.isEmpty || !mounted) return;
      _applyHint(hint);
    } catch (_) {}
  }

  void _applyHint(String hint) {
    var number = hint.replaceAll(RegExp(r'[\s\-()]'), '');
    final match = _countries.firstWhere(
      (c) => number.startsWith(c.dialCode),
      orElse: () => _selected,
    );
    if (number.startsWith(match.dialCode)) {
      number = number.substring(match.dialCode.length);
    } else if (number.startsWith('+')) {
      number = number.replaceFirst('+', '');
    }
    setState(() {
      _selected = match;
      _controller.text = number;
    });
  }

  void _onNext() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final fullNumber = '${_selected.dialCode}${_controller.text.trim()}';
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VerifyPhoneScreen(phoneNumber: fullNumber),
      ),
    );
  }

  Future<void> _pickCountry() async {
    final result = await showModalBottomSheet<Country>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          for (final c in _countries)
            ListTile(
              leading: Text(c.flag, style: const TextStyle(fontSize: 24)),
              title: Text(c.name),
              trailing: Text(
                c.dialCode,
                style: const TextStyle(color: TolkiColors.textSecondary),
              ),
              onTap: () => Navigator.pop(context, c),
            ),
        ],
      ),
    );
    if (result != null) setState(() => _selected = result);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TolkiLogo(),
              const SizedBox(height: 40),
              const Text('Hi! welcome to Tolki', style: TolkiText.heading),
              const SizedBox(height: 6),
              const Text(
                'Create your account',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: TolkiColors.primary,
                ),
              ),
              const SizedBox(height: 36),
              const Text(
                'Enter your phone number',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: TolkiColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Form(
                key: _formKey,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _pickCountry,
                      child: Container(
                        height: 54,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: TolkiColors.fieldBorder),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Text(
                              _selected.flag,
                              style: const TextStyle(fontSize: 22),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: TolkiColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(
                          fontSize: 15,
                          color: TolkiColors.textPrimary,
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Enter your phone number';
                          }
                          if (v.trim().length < 6) {
                            return 'Phone number is too short';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: '8234792323',
                          hintStyle: const TextStyle(color: TolkiColors.hint),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: TolkiColors.fieldBorder,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: TolkiColors.primary,
                              width: 1.4,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFEF4444)),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFEF4444),
                              width: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Securing your personal information is our priority.',
                style: TextStyle(
                  fontSize: 12,
                  color: TolkiColors.textSecondary,
                ),
              ),
              const Spacer(),
              TolkiButton(text: 'Next', onPressed: _onNext),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
