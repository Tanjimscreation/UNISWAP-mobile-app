import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

const _faculties = <String>[
  'FC — Computing',
  'FKM — Mechanical Engineering',
  'FKE — Electrical Engineering',
  'FKA — Civil Engineering',
  'FES — Engineering Sciences',
  'FABU — Built Environment',
  'FS — Science',
  'AHIBS — Business',
];

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String? _faculty;
  String _campus = 'Skudai';
  bool _terms = false;
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    final err = await context.read<AuthProvider>().register(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
          fullName: _nameCtrl.text.trim(),
          faculty: _faculty ?? '',
          campus: _campus,
          phoneNumber:
              _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
          acceptedTerms: _terms,
        );
    if (!mounted) return;
    setState(() => _loading = false);
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }
    Navigator.of(context).pushReplacementNamed('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Create account', style: AppTheme.displayMd),
              const SizedBox(height: 8),
              Text(
                'Exclusive to UTM students. Use your @utm.my email.',
                style: AppTheme.bodyMd,
              ),
              const SizedBox(height: 32),

              _Label('Full Name'),
              TextField(
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'e.g. Siti Aisyah',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
              ),
              const SizedBox(height: 18),

              _Label('UTM Email'),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'name@utm.my',
                  prefixIcon: Icon(Icons.alternate_email_rounded),
                ),
              ),
              const SizedBox(height: 18),

              _Label('Password'),
              TextField(
                controller: _passCtrl,
                obscureText: _obscure,
                decoration: InputDecoration(
                  hintText: 'At least 6 characters',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppTheme.textHint,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              _Label('Phone (optional)'),
              TextField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: '+60',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
              const SizedBox(height: 18),

              _Label('Faculty'),
              DropdownButtonFormField<String>(
                value: _faculty,
                items: _faculties
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (v) => setState(() => _faculty = v),
                decoration: const InputDecoration(
                  hintText: 'Choose your faculty',
                  prefixIcon: Icon(Icons.school_outlined),
                ),
              ),
              const SizedBox(height: 18),

              _Label('Campus'),
              Row(
                children: [
                  Expanded(child: _CampusChip(
                    label: 'UTM Skudai',
                    selected: _campus == 'Skudai',
                    onTap: () => setState(() => _campus = 'Skudai'),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: _CampusChip(
                    label: 'UTM KL',
                    selected: _campus == 'KL',
                    onTap: () => setState(() => _campus = 'KL'),
                  )),
                ],
              ),
              const SizedBox(height: 20),

              // Terms
              InkWell(
                onTap: () => setState(() => _terms = !_terms),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _terms,
                        onChanged: (v) => setState(() => _terms = v ?? false),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 13),
                          child: Text(
                            "I agree to UniSwap's Campus Safety & Fair Trade policy.",
                            style: AppTheme.bodyMd,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5, color: Colors.white),
                        )
                      : const Text('Create Account'),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already a UTMian? ', style: AppTheme.bodyMd),
                  GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushReplacementNamed('/login'),
                    child: Text(
                      'Sign In',
                      style: AppTheme.labelLg.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text, style: AppTheme.labelLg),
    );
  }
}

class _CampusChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _CampusChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.r16),
          border: Border.all(
            color: selected ? AppTheme.primary : AppTheme.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: AppTheme.labelLg.copyWith(
            color: selected ? AppTheme.primary : AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
