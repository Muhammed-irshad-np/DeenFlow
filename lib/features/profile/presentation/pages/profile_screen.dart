import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(context),
              SizedBox(height: 32.h),
              _buildSettingsGroup(context, 'Worship Settings', [
                _SettingsTile(
                  icon: Icons.mosque_outlined,
                  title: 'Prayer Alert Preferences',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.menu_book,
                  title: 'Quran Reading Goals',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.my_location,
                  title: 'Location & Calculation',
                  onTap: () {},
                ),
              ]),
              SizedBox(height: 24.h),
              _buildSettingsGroup(context, 'App Settings', [
                _SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  value: 'System',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.language,
                  title: 'Language',
                  value: 'English',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.notifications_active_outlined,
                  title: 'Notifications',
                  onTap: () {},
                ),
              ]),
              SizedBox(height: 24.h),
              _buildSettingsGroup(context, 'Support & Info', [
                _SettingsTile(
                  icon: Icons.help_outline,
                  title: 'Help Center',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.info_outline,
                  title: 'About DeenFlow',
                  onTap: () {},
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.r,
            backgroundColor: Theme.of(
              context,
            ).primaryColor.withAlpha((255 * 0.1).toInt()),
            child: Icon(
              Icons.person,
              size: 40.r,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(width: 20.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Profile',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Assalamu Alaikum',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              top: BorderSide(color: Colors.grey.shade200),
              bottom: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(value!, style: TextStyle(color: Colors.grey.shade600)),
          if (value != null) SizedBox(width: 8.w),
          Icon(
            Icons.arrow_forward_ios,
            size: 16.r,
            color: Colors.grey.shade400,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
