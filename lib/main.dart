import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'input_field.dart';

void main() => runApp(const TutorialApp());

class TutorialApp extends StatelessWidget {
  const TutorialApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Reusable InputField',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3157C8)),
      useMaterial3: true,
    ),
    home: const ProfileForm(),
  );
}

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _username = TextEditingController();
  final _phone = TextEditingController();
  final _fieldKeys = List.generate(4, (_) => GlobalKey<InputFieldState>());
  bool _submitted = false;

  void _submit() {
    FocusScope.of(context).unfocus();
    final valid = _formKey.currentState!.validate();
    setState(() => _submitted = valid);
  }

  void _reset() {
    FocusScope.of(context).unfocus();
    for (final key in _fieldKeys) {
      key.currentState?.reset();
    }
    setState(() => _submitted = false);
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _username.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('One widget. Four fields.')),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              onChanged: () {
                if (_submitted) setState(() => _submitted = false);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Create your profile',
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Reusable inputs with clear, helpful feedback.'),
                  const SizedBox(height: 24),
                  InputField(
                    key: _fieldKeys[0],
                    controller: _email,
                    title: 'Email',
                    hintText: 'learner@example.com',
                    icon: Icons.mail_outline,
                    type: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) return 'Email is required';
                      if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                          .hasMatch(text)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  InputField(
                    key: _fieldKeys[1],
                    controller: _password,
                    title: 'Password',
                    hintText: 'At least 8 characters',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    autofillHints: const [AutofillHints.newPassword],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 8) return 'Use at least 8 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  InputField(
                    key: _fieldKeys[2],
                    controller: _username,
                    title: 'Username',
                    hintText: 'flutter_learner',
                    icon: Icons.person_outline,
                    autofillHints: const [AutofillHints.username],
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) return 'Username is required';
                      if (!RegExp(r'^[a-zA-Z0-9_]{3,20}$').hasMatch(text)) {
                        return 'Use 3–20 letters, digits or underscores';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  InputField(
                    key: _fieldKeys[3],
                    controller: _phone,
                    title: 'Phone',
                    hintText: 'Optional +, then 7–15 digits',
                    icon: Icons.phone_outlined,
                    type: TextInputType.phone,
                    autofillHints: const [AutofillHints.telephoneNumber],
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                      LengthLimitingTextInputFormatter(16),
                    ],
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) return 'Phone is required';
                      if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(text)) {
                        return 'Use 7–15 digits with an optional leading +';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _submit,
                    child: const Text('Validate form'),
                  ),
                  TextButton(onPressed: _reset, child: const Text('Reset')),
                  if (_submitted)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Semantics(
                        liveRegion: true,
                        child: const Text(
                          'All fields are valid!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF126A42),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  const Text(
                    'Demo only • No data is sent or stored.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
