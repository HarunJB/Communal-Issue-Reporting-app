import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/form_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  String _language = 'bs';
  bool _loading = false;
  bool _submitted = false;
  String? _error;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _submitted = true;
      _error = null;
    });

    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _loading = true);
    try {
      await ApiService.register(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        email: _email.text.trim().toLowerCase(),
        phone: _phone.text.trim(),
        password: _password.text,
        language: _language,
      );
      if (!mounted) return;
      // Back to the login screen, which shows this message.
      Navigator.of(context).pop('Account created. You can now sign in.');
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      maxWidth: 520,
      child: Form(
        key: _formKey,
        autovalidateMode:
            _submitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Create your account', style: AppText.title),
            const SizedBox(height: 4),
            const Text(
              'An account is required to submit reports. It takes a minute.',
              style: AppText.subtitle,
            ),
            const SizedBox(height: 24),
            if (_error != null) ...[
              AlertBox(message: _error!),
              const SizedBox(height: 16),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'First name',
                    controller: _firstName,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.givenName],
                    validator: (v) => Validators.requiredText(v, 'First name is required.'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    label: 'Last name',
                    controller: _lastName,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.familyName],
                    validator: (v) => Validators.requiredText(v, 'Last name is required.'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
            AppTextField(
              label: 'Phone',
              optional: true,
              controller: _phone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.telephoneNumber],
              validator: Validators.optionalPhone,
            ),
            const SizedBox(height: 16),
            LabeledField(
              label: 'Language',
              child: DropdownButtonFormField<String>(
                initialValue: _language,
                isExpanded: true,
                dropdownColor: Colors.white,
                decoration: AppTheme.input(),
                items: const [
                  DropdownMenuItem(value: 'bs', child: Text('Bosanski')),
                  DropdownMenuItem(value: 'en', child: Text('English')),
                ],
                onChanged: (value) => setState(() => _language = value ?? 'bs'),
              ),
            ),
            const SizedBox(height: 16),
            PasswordField(
              label: 'Password',
              controller: _password,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              validator: Validators.newPassword,
            ),
            const SizedBox(height: 16),
            PasswordField(
              label: 'Confirm password',
              controller: _confirm,
              textInputAction: TextInputAction.done,
              onSubmitted: _submit,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please confirm your password.';
                if (value != _password.text) return 'Passwords do not match.';
                return null;
              },
            ),
            const SizedBox(height: 24),
            PrimaryButton(label: 'Create account', loading: _loading, onPressed: _submit),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already registered?', style: TextStyle(color: AppColors.slate)),
                TextButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.civic,
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  child: const Text('Sign in'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
