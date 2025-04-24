import 'package:flutter/material.dart';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({Key? key}) : super(key: key);

  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  // Text controllers for each approach
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  void _addUsingCode() {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a player code.')),
      );
      return;
    }
    // Implement your add friend logic using player code
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Friend added using code: $code')),
    );
  }

  void _addUsingPhone() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a phone number.')),
      );
      return;
    }
    // Implement your add friend logic using phone
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Friend added using phone: $phone')),
    );
  }

  void _addUsingName() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a player name.')),
      );
      return;
    }
    // Implement your add friend logic using player name
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Friend added using name: $name')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Add Friend', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.greenAccent),
          onPressed: () => Navigator.pop(context), // go back
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Add using player code
            _buildSectionTitle('Add Using Player Code'),
            _buildTextField(_codeController, 'Enter Player Code'),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _addUsingCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Add', style: TextStyle(color: Colors.black)),
              ),
            ),
            const Divider(color: Colors.grey, height: 30),

            // Add using phone number
            _buildSectionTitle('Add Using Phone Number'),
            _buildTextField(_phoneController, 'Enter Phone Number',
                keyboardType: TextInputType.phone),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _addUsingPhone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Add', style: TextStyle(color: Colors.black)),
              ),
            ),
            const Divider(color: Colors.grey, height: 30),

            // Add using player name
            _buildSectionTitle('Add Using Player Name'),
            _buildTextField(_nameController, 'Enter Player Name'),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _addUsingName,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Add', style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build each section title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.greenAccent,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Helper to build the text fields
  Widget _buildTextField(TextEditingController controller, String hint,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
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
    );
  }
}
