import 'package:flutter/material.dart';

class RenterEditProfilePage extends StatefulWidget {
  const RenterEditProfilePage({Key? key}) : super(key: key);

  @override
  State<RenterEditProfilePage> createState() => _RenterEditProfilePageState();
}

class _RenterEditProfilePageState extends State<RenterEditProfilePage> {
  final TextEditingController _nameController =
      TextEditingController(text: 'Renter Name');
  final TextEditingController _bioController =
      TextEditingController(text: 'Sports field renter');
  final TextEditingController _emailController =
      TextEditingController(text: 'renter@sportconnect.com');
  final TextEditingController _phoneController =
      TextEditingController(text: '+966500000000');
  final TextEditingController _locationController =
      TextEditingController(text: 'Riyadh, Saudi Arabia');

  bool _isPrivate = false;
  String coverImagePath = 'assets/cover_photo.jpg';
  String avatarPath = 'assets/player_profile.png';

  void _handleCoverPhotoChange() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Change Cover Photo tapped')),
    );
  }

  void _handleAvatarChange() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Change Avatar tapped')),
    );
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  void _handleSave() {
    final newName = _nameController.text.trim();
    final newBio = _bioController.text.trim();
    final newEmail = _emailController.text.trim();
    final newPhone = _phoneController.text.trim();
    final newLocation = _locationController.text.trim();

    // Here you would typically connect to your Django backend API
    // to update the profile information

    // Example API call (pseudocode):
    // final response = await http.put(
    //   Uri.parse('https://yourapi.com/api/renters/profile/'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //     'Authorization': 'Bearer $token',
    //   },
    //   body: jsonEncode({
    //     'name': newName,
    //     'bio': newBio,
    //     'email': newEmail,
    //     'phone': newPhone,
    //     'location': newLocation,
    //     'private': _isPrivate,
    //   }),
    // );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Profile Saved!\n'
          'Name: $newName\n'
          'Bio: $newBio\n'
          'Email: $newEmail\n'
          'Phone: $newPhone\n'
          'Location: $newLocation\n'
          'Private? $_isPrivate',
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
            const SizedBox(height: 50),

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
            // Location
            _buildTextField(
              label: 'Location',
              controller: _locationController,
              hint: 'Enter your location',
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

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
