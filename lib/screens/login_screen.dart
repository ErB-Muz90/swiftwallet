import 'package:flutter/material.dart';
import 'package:swiftwallet/utils/localization.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLogin;
  const LoginScreen({Key? key, required this.onLogin}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool isOtpSent = false;
  bool loading = false;

  void sendOtp() async {
    final i18n = AppLocalizations.of(context)!;
    if (_emailController.text.isEmpty) {
      _showAlert(i18n.translate('error')!, i18n.translate('enterEmail')!);
      return;
    }
    setState(() => loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      isOtpSent = true;
      loading = false;
    });
    _showAlert(i18n.translate('success')!, i18n.translate('otpSent')!);
  }

  void verifyOtp() {
    final i18n = AppLocalizations.of(context)!;
    if (_otpController.text.isEmpty) {
      _showAlert(i18n.translate('error')!, i18n.translate('enterOtp')!);
      return;
    }
    if (_otpController.text == '123456') {
      widget.onLogin();
    } else {
      _showAlert(i18n.translate('error')!, i18n.translate('invalidOtp')!);
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                i18n.translate('welcome') ?? 'Welcome',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                i18n.translate('loginSubtitle') ?? '',
                style: const TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 2),
                      blurRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: i18n.translate('email'),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        enabled: !isOtpSent,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      enabled: !isOtpSent,
                    ),
                    const SizedBox(height: 15),
                    if (isOtpSent)
                      ...[
                        TextField(
                          controller: _otpController,
                          decoration: InputDecoration(
                            hintText: i18n.translate('enterOtp'),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: verifyOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3b82f6),
                            minimumSize: const Size.fromHeight(48),
                          ),
                          child: Text(i18n.translate('verifyOtp') ?? 'Verify OTP', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ]
                    else
                      ElevatedButton(
                        onPressed: loading ? null : sendOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: loading ? const Color(0xFF93c5fd) : const Color(0xFF3b82f6),
                          minimumSize: const Size.fromHeight(48),
                        ),
                        child: Text(
                          loading ? (i18n.translate('sending') ?? 'Sending...') : (i18n.translate('sendOtp') ?? 'Send OTP'),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFF3b82f6),
    );
  }
}
