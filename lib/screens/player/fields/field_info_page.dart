import 'package:flutter/material.dart';

class FieldInfoPage extends StatelessWidget {
  final String fieldName;
  final String location;
  final String imagePath;
  final bool suitableForWomen;

  const FieldInfoPage({
    super.key,
    required this.fieldName,
    required this.location,
    required this.imagePath,
    required this.suitableForWomen,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> facilitiesList = [
      const FacilityRow(
        icon: Icons.local_parking,
        text: 'Parking Available',
      ),
      const SizedBox(height: 10),
      const FacilityRow(
        icon: Icons.people,
        text: 'Capacity: 200 people',
      ),
      const SizedBox(height: 10),
      const FacilityRow(
        icon: Icons.lightbulb,
        text: 'Lighting Available',
      ),
    ];

    if (suitableForWomen) {
      facilitiesList.addAll([
        const SizedBox(height: 10),
        const FacilityRow(
          icon: Icons.sports_basketball,
          text: 'Suitable for Women 🙋‍♀️',
        ),
      ]);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Field Information'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              fieldName,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Location: $location',
              style: const TextStyle(color: Colors.grey, fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              'Description:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'This field has a premium surface and is ideal for both recreational and competitive events. Available for booking 24/7 with top-notch facilities including lighting, seating, and changing rooms.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Facilities:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: facilitiesList,
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellowAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Field Reserved')),
                  );
                },
                child: const Text(
                  'Reserve Now',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FacilityRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const FacilityRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.green, size: 30),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
