import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final name = auth.fullName ?? 'Siti Aisyah';
    final email = auth.email ?? 'siti@graduate.utm.my';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.border, width: 2),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&h=200&fit=crop&crop=face',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: AppTheme.info,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                        ),
                        child: const Icon(Icons.check_rounded,
                            color: Colors.white, size: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(name, style: AppTheme.headingLg),
                const SizedBox(height: 2),
                Text(email, style: AppTheme.bodyMd),
                const SizedBox(height: 4),
                Text(
                  auth.faculty?.isNotEmpty == true
                      ? '${auth.faculty} · ${auth.location}'
                      : 'FC — Computing · UTM Skudai',
                  style: AppTheme.bodySm,
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _StatBox(
                      label: 'Trust Score',
                      value: auth.trustScore,
                      color: AppTheme.success,
                    ),
                    const SizedBox(width: 10),
                    _StatBox(
                      label: 'Swaps',
                      value: '${auth.successfulSwaps}',
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 10),
                    _StatBox(
                      label: 'Listings',
                      value: '${auth.listings.length}',
                      color: AppTheme.info,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Menu list
          _MenuTile(
            icon: Icons.inventory_2_outlined,
            label: 'My Listings',
            trailing: '${auth.listings.length}',
          ),
          _MenuTile(
            icon: Icons.favorite_border_rounded,
            label: 'Saved Items',
          ),
          _MenuTile(
            icon: Icons.history_rounded,
            label: 'Trade History',
          ),
          _MenuTile(
            icon: Icons.shield_outlined,
            label: 'Campus Safety & Policy',
          ),
          _MenuTile(
            icon: Icons.help_outline_rounded,
            label: 'Help Centre',
          ),

          const SizedBox(height: 24),

          // Sign out
          SizedBox(
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () async {
                await auth.logout();
                if (context.mounted) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login', (_) => false);
                }
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Sign out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.error,
                side: const BorderSide(color: AppTheme.error, width: 1.2),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTheme.headingMd.copyWith(color: color, fontSize: 18),
            ),
            const SizedBox(height: 2),
            Text(label, style: AppTheme.bodySm),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  const _MenuTile({
    required this.icon,
    required this.label,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: ListTile(
        leading: Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: AppTheme.primary),
        ),
        title: Text(label, style: AppTheme.headingSm),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailing != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(trailing!, style: AppTheme.bodyMd),
              ),
            const Icon(Icons.chevron_right_rounded, color: AppTheme.textHint),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}
