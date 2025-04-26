import 'package:flutter/material.dart';

class PlayerSettingsPage extends StatefulWidget {
  const PlayerSettingsPage({Key? key}) : super(key: key);

  @override
  State<PlayerSettingsPage> createState() => _PlayerSettingsPageState();
}

class _PlayerSettingsPageState extends State<PlayerSettingsPage> {
  bool pushOn   = true;
  bool emailOn  = false;
  bool dmSounds = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.greenAccent),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.greenAccent),
        ),
      ),
      body: ListView(
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
            trailing: const Icon(Icons.chevron_right, color: Colors.white24),
            onTap: () {
              // TODO: push a theme picker if you have one
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Theme picker coming soon')),
              );
            },
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
            leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
            title: const Text(
              'Delete account',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => _confirmDelete(context),
          ),
        ],
      ),
    );
  }

  // helper widget -----------------------------------------------------------
  Widget _buildSwitchTile(
      {required String title,
      required bool value,
      required ValueChanged<bool> onChanged}) {
    return SwitchListTile(
      activeColor: Colors.greenAccent,
      inactiveThumbColor: Colors.grey,
      inactiveTrackColor: Colors.grey[800],
      title: Text(title, style: const TextStyle(color: Colors.white)),
      value: value,
      onChanged: onChanged,
    );
  }

  void _confirmDelete(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Delete account',
            style: TextStyle(color: Colors.redAccent)),
        content: const Text(
          'This action is irreversible. Are you sure?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
            onPressed: () {
              // TODO: call your delete-account backend
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Account deletion not implemented')));
            },
          ),
        ],
      ),
    );
  }
}
