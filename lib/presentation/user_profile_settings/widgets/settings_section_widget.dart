import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsSectionWidget extends StatelessWidget {
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool darkMode;
  final String selectedLanguage;
  final String selectedCurrency;
  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<bool> onEmailNotificationsChanged;
  final ValueChanged<bool> onSmsNotificationsChanged;
  final ValueChanged<bool> onDarkModeChanged;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<String> onCurrencyChanged;
  final VoidCallback onHelpPressed;
  final VoidCallback onPrivacyPressed;
  final VoidCallback onTermsPressed;
  final VoidCallback onLogoutPressed;
  final VoidCallback onDeleteAccountPressed;

  const SettingsSectionWidget({
    Key? key,
    required this.notificationsEnabled,
    required this.emailNotifications,
    required this.smsNotifications,
    required this.darkMode,
    required this.selectedLanguage,
    required this.selectedCurrency,
    required this.onNotificationsChanged,
    required this.onEmailNotificationsChanged,
    required this.onSmsNotificationsChanged,
    required this.onDarkModeChanged,
    required this.onLanguageChanged,
    required this.onCurrencyChanged,
    required this.onHelpPressed,
    required this.onPrivacyPressed,
    required this.onTermsPressed,
    required this.onLogoutPressed,
    required this.onDeleteAccountPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        SizedBox(height: 2.h),
        
        // Notifications Section
        Card(
          child: Column(
            children: [
              _buildSwitchTile(
                icon: 'notifications',
                title: 'Push Notifications',
                subtitle: 'Receive booking updates and messages',
                value: notificationsEnabled,
                onChanged: onNotificationsChanged,
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: 'email',
                title: 'Email Notifications',
                subtitle: 'Receive updates via email',
                value: emailNotifications,
                onChanged: onEmailNotificationsChanged,
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: 'sms',
                title: 'SMS Notifications',
                subtitle: 'Receive important updates via SMS',
                value: smsNotifications,
                onChanged: onSmsNotificationsChanged,
              ),
            ],
          ),
        ),
        
        SizedBox(height: 3.h),
        
        // Preferences Section
        Card(
          child: Column(
            children: [
              _buildSwitchTile(
                icon: 'dark_mode',
                title: 'Dark Mode',
                subtitle: 'Use dark theme',
                value: darkMode,
                onChanged: onDarkModeChanged,
              ),
              const Divider(height: 1),
              _buildDropdownTile(
                icon: 'language',
                title: 'Language',
                subtitle: selectedLanguage,
                onTap: () => _showLanguageDialog(context),
              ),
              const Divider(height: 1),
              _buildDropdownTile(
                icon: 'attach_money',
                title: 'Currency',
                subtitle: selectedCurrency,
                onTap: () => _showCurrencyDialog(context),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 3.h),
        
        // Support Section
        Card(
          child: Column(
            children: [
              _buildTile(
                icon: 'help',
                title: 'Help & Support',
                subtitle: 'Get help or contact support',
                onTap: onHelpPressed,
              ),
              const Divider(height: 1),
              _buildTile(
                icon: 'privacy_tip',
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                onTap: onPrivacyPressed,
              ),
              const Divider(height: 1),
              _buildTile(
                icon: 'description',
                title: 'Terms of Service',
                subtitle: 'Read our terms and conditions',
                onTap: onTermsPressed,
              ),
            ],
          ),
        ),
        
        SizedBox(height: 3.h),
        
        // Account Actions
        Card(
          child: Column(
            children: [
              _buildTile(
                icon: 'logout',
                title: 'Logout',
                subtitle: 'Sign out of your account',
                onTap: onLogoutPressed,
                textColor: AppTheme.lightTheme.colorScheme.error,
              ),
              const Divider(height: 1),
              _buildTile(
                icon: 'delete_forever',
                title: 'Delete Account',
                subtitle: 'Permanently delete your account',
                onTap: onDeleteAccountPressed,
                textColor: AppTheme.lightTheme.colorScheme.error,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdownTile({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      trailing: CustomIconWidget(
        iconName: 'arrow_forward_ios',
        color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.4),
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildTile({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: (textColor ?? AppTheme.lightTheme.colorScheme.primary).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: textColor ?? AppTheme.lightTheme.colorScheme.primary,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      trailing: CustomIconWidget(
        iconName: 'arrow_forward_ios',
        color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.4),
        size: 16,
      ),
      onTap: onTap,
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(context, 'English'),
            _buildLanguageOption(context, 'العربية'),
            _buildLanguageOption(context, 'Français'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String language) {
    return ListTile(
      title: Text(language),
      leading: Radio<String>(
        value: language,
        groupValue: selectedLanguage,
        onChanged: (value) {
          onLanguageChanged(value!);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCurrencyOption(context, 'EGP'),
            _buildCurrencyOption(context, 'USD'),
            _buildCurrencyOption(context, 'EUR'),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyOption(BuildContext context, String currency) {
    return ListTile(
      title: Text(currency),
      leading: Radio<String>(
        value: currency,
        groupValue: selectedCurrency,
        onChanged: (value) {
          onCurrencyChanged(value!);
          Navigator.pop(context);
        },
      ),
    );
  }
}