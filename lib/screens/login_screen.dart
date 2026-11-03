import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/form_widgets.dart';
import 'register_screen.dart';
import 'success_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _remember = true;
  bool _loading = false;
  bool _submitted = false;
  String? _error;
  String? _success;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _submitted = true;
      _error = null;
      _success = null;
    });

    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _loading = true);
    try {
      final user = await ApiService.login(
        email: _email.text.trim().toLowerCase(),
        password: _password.text,
        remember: _remember,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => SuccessScreen(user: user)),
      );
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openRegister() async {
    final message = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
    if (message != null && mounted) {
      setState(() {
        _success = message;
        _error = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Form(
        key: _formKey,
        autovalidateMode:
            _submitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome back', style: AppText.title),
            const SizedBox(height: 4),
            const Text('Sign in to report and track city issues.', style: AppText.subtitle),
            const SizedBox(height: 24),
            if (_success != null) ...[
              AlertBox(message: _success!, success: true),
              const SizedBox(height: 16),
            ],
            if (_error != null) ...[
              AlertBox(message: _error!),
              const SizedBox(height: 16),
            ],
            AppTextField(
              label: 'Email',
              controller: _email,
              hint: 'name@example.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              validator: Validators.email,
            ),
            const SizedBox(height: 16),
            PasswordField(
              label: 'Password',
              controller: _password,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              validator: Validators.loginPassword,
              onSubmitted: _submit,
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => setState(() => _remember = !_remember),
              borderRadius: BorderRadius.circular(6),
              child: Row(
                children: [
                  Checkbox(
                    value: _remember,
                    onChanged: (value) => setState(() => _remember = value ?? false),
                    activeColor: AppColors.civic,
                    side: const BorderSide(color: AppColors.border, width: 1.5),
                  ),
                  const Text('Keep me signed in', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(label: 'Sign in', loading: _loading, onPressed: _submit),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No account yet?', style: TextStyle(color: AppColors.slate)),
                TextButton(
                  onPressed: _openRegister,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.civic,
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  child: const Text('Create one'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
