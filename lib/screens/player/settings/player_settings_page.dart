// lib/screens/player/settings/player_settings_page.dart

import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';

class PlayerSettingsPage extends StatefulWidget {
  const PlayerSettingsPage({Key? key}) : super(key: key);

  @override
  State<PlayerSettingsPage> createState() => _PlayerSettingsPageState();
}

class _PlayerSettingsPageState extends State<PlayerSettingsPage> {
  // Settings state
  bool pushOn = true;
  bool emailOn = false;
  bool dmSounds = true;
  bool _isPrivate = false;

  // For loading indicators and saving state
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // In a real implementation, you'd fetch settings from the API
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // Simulate API call
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));

    // In a real app, you'd do:
    // final settings = await PlayerSettingsService.getUserSettings();
    // setState(() {
    //   pushOn = settings['push_notifications'] ?? true;
    //   emailOn = settings['email_notifications'] ?? false;
    //   dmSounds = settings['dm_sounds'] ?? true;
    //   _isPrivate = settings['is_private'] ?? false;
    // });

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, you'd do:
    // final settings = {
    //   'push_notifications': pushOn,
    //   'email_notifications': emailOn,
    //   'dm_sounds': dmSounds,
    //   'is_private': _isPrivate,
    // };
    // final success = await PlayerSettingsService.updateUserSettings(settings);

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.greenAccent))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ──  Notifications  ──────────────────────────────────────────
                const Text(
                  'Notifications',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                _buildSwitchTile(
                  title: 'Push notifications',
                  value: pushOn,
                  onChanged: (v) => setState(() => pushOn = v),
                ),
                _buildSwitchTile(
                  title: 'E-mail notifications',
                  value: emailOn,
                  onChanged: (v) => setState(() => emailOn = v),
                ),
                _buildSwitchTile(
                  title: 'Play DM sounds',
                  value: dmSounds,
                  onChanged: (v) => setState(() => dmSounds = v),
                ),

                const SizedBox(height: 24),

                // ──  Privacy  ────────────────────────────────────────────────
                const Text(
                  'Privacy',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                _buildSwitchTile(
                  title: 'Private account',
                  value: _isPrivate,
                  onChanged: (v) => setState(() => _isPrivate = v),
                ),

                const SizedBox(height: 24),

                // ──  Appearance  ────────────────────────────────────────────
                const Text(
                  'Appearance',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.palette, color: Colors.greenAccent),
                  title: const Text(
                    'Theme & Colors',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing:
                      const Icon(Icons.chevron_right, color: Colors.white30),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Theme settings available in drawer menu')),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // ──  Account Management  ───────────────────────────────────────
                const Text(
                  'Account Management',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading:
                      const Icon(Icons.password, color: Colors.greenAccent),
                  title: const Text(
                    'Change Password',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing:
                      const Icon(Icons.chevron_right, color: Colors.white30),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Password change coming soon')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.amber),
                  title: const Text(
                    'Log out',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => _confirmLogout(context),
                ),

                const SizedBox(height: 24),

                // ──  Danger zone  ──────────────────────────────────────────
                const Text(
                  'Danger zone',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading:
                      const Icon(Icons.delete_forever, color: Colors.redAccent),
                  title: const Text(
                    'Delete account',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => _confirmDelete(context),
                ),

                // Save button
                const SizedBox(height: 30),
                _isSaving
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: Colors.greenAccent))
                    : ElevatedButton(
                        onPressed: _saveSettings,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Save Settings',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
              ],
            ),
    );
  }

  // helper widget -----------------------------------------------------------
  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      activeColor: Colors.greenAccent,
      inactiveThumbColor: Colors.grey,
      inactiveTrackColor: Colors.grey[800],
      title: Text(title, style: const TextStyle(color: Colors.white)),
      value: value,
      onChanged: onChanged,
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Log out', style: TextStyle(color: Colors.amber)),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            child: const Text('Log Out'),
            onPressed: () async {
              Navigator.pop(context); // Close dialog

              // Show loading indicator
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const AlertDialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  content: Center(
                    child: CircularProgressIndicator(color: Colors.amber),
                  ),
                ),
              );

              // Logout process
              try {
                await AuthService.logout();

                if (mounted) {
                  // Close loading indicator
                  Navigator.pop(context);

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged out successfully')),
                  );

                  // Navigate back to login screen
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              } catch (e) {
                if (mounted) {
                  // Close loading indicator
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logout failed: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Delete account',
            style: TextStyle(color: Colors.redAccent)),
        content: const Text(
          'This action is irreversible. Are you sure you want to delete your account?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion coming soon')),
              );
            },
          ),
        ],
      ),
    );
  }
}
