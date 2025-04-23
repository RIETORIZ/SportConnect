import 'package:flutter/material.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  // For demonstration, some placeholders
  final TextEditingController _nameController =
      TextEditingController(text: 'adminP 🎓');
  final TextEditingController _bioController =
      TextEditingController(text: 'admin account for player');
  final TextEditingController _sportRoleController =
      TextEditingController(text: 'Coach / Player / Renter');
  final TextEditingController _preferredSportsController =
      TextEditingController(text: 'Soccer, Tennis, Padel');
  final TextEditingController _emailController =
      TextEditingController(text: 'adminP@sportconnect.com');
  final TextEditingController _phoneController =
      TextEditingController(text: '+966500000000');

  // Private account switch
  bool _isPrivate = false;

  // Fake cover & avatar images
  String coverImagePath = 'assets/cover_photo.jpg';
  String avatarPath = 'assets/player_profile.png';

  void _handleCoverPhotoChange() {
    // In real code, you'd open an Image Picker
    // For demonstration, we just show a SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Change Cover Photo tapped')),
    );
  }

  void _handleAvatarChange() {
    // Similarly, open an ImagePicker or camera
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Change Avatar tapped')),
    );
  }

  void _handleCancel() {
    // Simply pop the screen
    Navigator.pop(context);
  }

  void _handleSave() {
    // Gather new data
    final newName = _nameController.text.trim();
    final newBio = _bioController.text.trim();
    final newRole = _sportRoleController.text.trim();
    final newSports = _preferredSportsController.text.trim();
    final newEmail = _emailController.text.trim();
    final newPhone = _phoneController.text.trim();

    // In real code, you'd call an API or store data locally
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Profile Saved!\n'
          'Name: $newName\n'
          'Bio: $newBio\n'
          'Role: $newRole\n'
          'Preferred: $newSports\n'
          'Email: $newEmail\n'
          'Phone: $newPhone\n'
          'Private? $_isPrivate',
        ),
      ),
    );
    Navigator.pop(context); // return to previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // or a dark theme
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: TextButton(
          onPressed: _handleCancel,
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.redAccent, fontSize: 16),
          ),
        ),
        title: const Text('Edit profile',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _handleSave,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.greenAccent, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cover photo
            GestureDetector(
              onTap: _handleCoverPhotoChange,
              child: Stack(
                children: [
                  Image.asset(
                    coverImagePath,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                  // Avatar that overlaps the bottom
                  Positioned(
                    bottom: -40,
                    left: 16,
                    child: GestureDetector(
                      onTap: _handleAvatarChange,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          radius: 38,
                          backgroundImage: AssetImage(avatarPath),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50), // so the avatar doesn't overlap fields

            // Name
            _buildTextField(
              label: 'Name',
              controller: _nameController,
              hint: 'Enter your name',
            ),
            // Bio
            _buildTextField(
              label: 'Bio',
              controller: _bioController,
              hint: 'Describe yourself...',
              maxLines: 2,
            ),
            // Sport Role
            _buildTextField(
              label: 'Sport Role',
              controller: _sportRoleController,
              hint: 'e.g. Player, Coach, Renter',
            ),
            // Preferred Sports
            _buildTextField(
              label: 'Preferred Sports',
              controller: _preferredSportsController,
              hint: 'e.g. Soccer, Tennis',
            ),
            // Private Account
            ListTile(
              title: const Text(
                'Private Account',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Switch(
                value: _isPrivate,
                onChanged: (val) {
                  setState(() {
                    _isPrivate = val;
                  });
                },
                activeColor: Colors.green,
              ),
            ),
            // Email
            _buildTextField(
              label: 'Email',
              controller: _emailController,
              hint: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
            ),
            // Phone
            _buildTextField(
              label: 'Phone Number',
              controller: _phoneController,
              hint: 'Enter phone number',
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // A helper method for text fields
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.greenAccent, fontSize: 14),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.grey[900],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
