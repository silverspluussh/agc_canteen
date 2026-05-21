import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:agc_canteen/views/widgets/app_buttons.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/admin_auth_controller.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../core/di/injection_container.dart';
import '../../core/di/securestorage.dart';
import '../../main.dart';
import '../../services/activity_log_service.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  String? _adminEmail;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final storage = getIt<SecureStorage>();
    final email = await storage.readAdminEmail();
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _adminEmail = email;
        _appVersion = 'v${info.version} (${info.buildNumber})';
      });
    }
  }

  Future<void> _showLanguageDialog() async {
    const languages = [
      Lang('English', 'en'),
      Lang('French', 'fr'),
      Lang('Spanish', 'es'),
    ];

    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getString('app_language') ?? 'en';

    if (!mounted) return;
    String selected = current;

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setD) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  const Icon(Icons.language),
                  const SizedBox(width: 8),
                  Text(AppLocalizations.of(context).language),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: languages.map((lang) {
                  return RadioListTile<String>(
                    value: lang.code,
                    groupValue: selected,
                    title: Text(lang.label),
                    onChanged: (v) => setD(() => selected = v!),
                    contentPadding: EdgeInsets.zero,
                  );
                }).toList(),
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(AppLocalizations.of(context).cancel),
                ),

                PrimaryButton(
                  width: 110,
                  
                  onPressed: () async {
                    await prefs.setString('app_language', selected);
                    ref.read(localeProvider.notifier).state = Locale(selected);
                    getIt<ActivityLogService>().log(
                      type: 'language_changed',
                      message:
                          'Language changed from settings: $current → $selected',
                      actorType: 'admin',
                      metadata: {
                        'old_language': current,
                        'new_language': selected,
                      },
                    );
                    if (ctx.mounted) Navigator.of(ctx).pop();
                  },label: const Text(
                    'Apply',
                    style: TextStyle(color: Colors.white),
                  ),)
               
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showThemeDialog() async {
    final current = AdaptiveTheme.of(context).mode;
    AdaptiveThemeMode selected = current;

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setD) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  const Icon(Icons.brightness_6),
                  const SizedBox(width: 8),
                  Text(AppLocalizations.of(context).appearance),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<AdaptiveThemeMode>(
                    value: AdaptiveThemeMode.light,
                    groupValue: selected,
                    title: Text(AppLocalizations.of(context).lightMode),
                    secondary: const Icon(Icons.light_mode),
                    onChanged: (v) => setD(() => selected = v!),
                    contentPadding: EdgeInsets.zero,
                  ),
                  RadioListTile<AdaptiveThemeMode>(
                    value: AdaptiveThemeMode.dark,
                    groupValue: selected,
                    title: Text(AppLocalizations.of(context).darkMode),
                    secondary: const Icon(Icons.dark_mode),
                    onChanged: (v) => setD(() => selected = v!),
                    contentPadding: EdgeInsets.zero,
                  ),
                  RadioListTile<AdaptiveThemeMode>(
                    value: AdaptiveThemeMode.system,
                    groupValue: selected,
                    title: Text(AppLocalizations.of(context).systemMode),
                    secondary: const Icon(Icons.brightness_auto),
                    onChanged: (v) => setD(() => selected = v!),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(AppLocalizations.of(context).cancel),
                ),

                PrimaryButton(
                  width: 110,
                  onPressed: () {
                    AdaptiveTheme.of(context).setThemeMode(selected);
                    getIt<ActivityLogService>().log(
                      type: 'theme_changed',
                      message: 'Theme changed: $current → $selected',
                      actorType: 'admin',
                      metadata: {
                        'old_theme': current.name,
                        'new_theme': selected.name,
                      },
                    );
                    Navigator.of(ctx).pop();
                  },
                  label: Text(
                    AppLocalizations.of(
                      context,
                    ).applyFilters, // Using applyFilters as a generic apply
                    style: const TextStyle(color: Colors.white),
                  ),
                  )

              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showAdminInfoDialog() async {
    final adminState = ref.read(adminAuthProvider);
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(Icons.account_circle),
              const SizedBox(width: 8),
              Text(AppLocalizations.of(context).accountInfo),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoRow(
                label: AppLocalizations.of(context).email,
                value: _adminEmail ?? '—',
              ),
              const SizedBox(height: 8),
              _InfoRow(
                label: AppLocalizations.of(context).status,
                value: adminState.isOffline
                    ? AppLocalizations.of(context).offline
                    : AppLocalizations.of(
                        context,
                      ).success, // "Online" isn't explicitly there, success/offline
              ),
              const SizedBox(height: 8),
              _InfoRow(
                label: AppLocalizations.of(context).appTitle,
                value: _appVersion,
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(AppLocalizations.of(context).close),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(AppLocalizations.of(context).signOutConfirm),
        content: Text(AppLocalizations.of(context).signOutWarning),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              AppLocalizations.of(context).signOutConfirm,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(adminAuthProvider.notifier).logout();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: Text(l10n.settings),
        centerTitle: true,
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        physics: const ClampingScrollPhysics(),
        children: [
          // ── Account ────────────────────────────────────────────────────────
          _SectionHeader(label: l10n.account),
          // _SettingsTile(
          //   icon: Icons.account_circle_outlined,
          //   title: l10n.adminAccountInfo,
          //   subtitle: _adminEmail ?? l10n.loading,
          //   onTap: _showAdminInfoDialog,
          // ),
          //staff managment
          _SettingsTile(
            icon: Icons.group_outlined,
            title: l10n.staffManagement, // "Staff Management"
            subtitle: l10n
                .manageStaffSubtitle, // "Register and remove fingerprints for staff access"
            onTap: () => Navigator.of(context).pushNamed('/staff'),
          ),
          //POS managment
          _SettingsTile(
            icon: Icons.device_hub_outlined,
            title: l10n.posSettings, // "POS Settings"
            subtitle: l10n
                .managePosSubtitle, // "Manage POS devices and configurations"
            onTap: () => Navigator.of(context).pushNamed('/pos'),
          ),

          // ── Data ───────────────────────────────────────────────────────────
          _SectionHeader(label: l10n.data),
          _SettingsTile(
            icon: Icons.fastfood_rounded,
            title: l10n.manualPosOrder,
            subtitle: l10n.manualPosOrderSubtitle,
            onTap: () =>
                Navigator.of(context).pushNamed('/create-manual-order'),
          ),
          _SettingsTile(
            icon: Icons.bar_chart_rounded,
            title: l10n.orders,
            subtitle: l10n.viewReportsSubtitle,
            onTap: () => Navigator.of(context).pushNamed('/reports'),
          ),
          _SettingsTile(
            icon: Icons.sync_rounded,
            title: AppLocalizations.of(context).syncData,
            subtitle: l10n.pushPullSubtitle,
            onTap: () => Navigator.of(context).pushNamed('/sync'),
          ),

          // ── Preferences ────────────────────────────────────────────────────
          _SectionHeader(label: l10n.preferences),
          _SettingsTile(
            icon: Icons.language_outlined,
            title: l10n.language,
            subtitle: l10n.changeLanguage,
            onTap: _showLanguageDialog,
          ),
          _SettingsTile(
            icon: Icons.brightness_6_outlined,
            title: l10n.appearance,
            subtitle: l10n.appearanceSubtitle,
            onTap: _showThemeDialog,
          ),

          // ── System ─────────────────────────────────────────────────────────
          _SectionHeader(label: l10n.system),
          // _SettingsTile(
          //   icon: Icons.system_update_alt_rounded,
          //   title: l10n.appUpdate,
          //   subtitle: l10n.checkLatestVersion,
          //   onTap: () {
          //     ScaffoldMessenger.of(
          //       context,
          //     ).showSnackBar(SnackBar(content: Text(l10n.latestVersion)));
          //   },
          // ),
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            title: l10n.about,
            subtitle: _appVersion.isNotEmpty ? _appVersion : l10n.appTitle,
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: l10n.appTitle,
                applicationVersion: _appVersion,
                applicationIcon: Image.asset(
                  'assets/app_logo.png',
                  width: 48,
                  height: 48,
                ),
              );
            },
          ),

          const Divider(height: 32),

          ListTile(
            leading: CircleAvatar(
              backgroundColor: colorScheme.errorContainer,
              child: Icon(Icons.logout, color: Colors.white, size: 20),
            ),
            title: Text(
              l10n.signOutConfirm,
              style: TextStyle(
                color: colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(l10n.signOutSubtitle),
            onTap: _confirmLogout,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Helper Widgets ─────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: colorScheme.primaryContainer,
        child: Icon(icon, color: colorScheme.primary, size: 15),
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      trailing: const Icon(Icons.chevron_right, size: 15),
      onTap: onTap,
    );
  }
}

class _SyncStatRow extends StatelessWidget {
  const _SyncStatRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.outline,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class Lang {
  const Lang(this.label, this.code);
  final String label;
  final String code;
}
