import 'package:flutter/material.dart';

class FamilyMembersPage extends StatefulWidget {
   FamilyMembersPage({Key? key}) : super(key: key);

  @override
  State<FamilyMembersPage> createState() => _FamilyMembersPageState();
}

class _FamilyMembersPageState extends State<FamilyMembersPage> {
  // Example family member list with adminC and adminR
  final List<String> _familyMembers = ['adminC', 'adminR'];

  void _addFamilyMember() {
    // Implement "Add Family Member" logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add family member tapped')),
    );
  }

  void _deleteMember(String member) {
    setState(() {
      _familyMembers.remove(member);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$member deleted')),
    );
  }

  void _dmMember(String member) {
    // Implement "DM" logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('DM with $member pressed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Dark theme
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context), // Go back
        ),
        title: const Text(
          'Family Members',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // "Add Family Member" button near the top
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              onPressed: _addFamilyMember,
              icon: const Icon(Icons.person_add, color: Colors.white),
              label: const Text(
                'Add Family Member',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          // List of current family members
          Expanded(
            child: _familyMembers.isNotEmpty
                ? ListView.builder(
                    itemCount: _familyMembers.length,
                    itemBuilder: (context, index) {
                      final member = _familyMembers[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Card(
                          color: Colors.grey[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          shadowColor: Colors.greenAccent,
                          child: ListTile(
                            title: Text(
                              member,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Two action buttons on the trailing side:
                            trailing: SizedBox(
                              width: 120, // Enough space for two buttons
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _dmMember(member),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'DM',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => _deleteMember(member),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Del',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'No family members yet.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
