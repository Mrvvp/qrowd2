import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qrowd2/view/map.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Information Section
            const CircleAvatar(
              radius: 40,
            ),
            const SizedBox(height: 10),
            const Text(
              'John Doe', // Replace with dynamic user name
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              'johndoe@example.com', // Replace with dynamic user email
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const Divider(height: 40, thickness: 1),

            // Options Section
            ListTile(
              leading: const Icon(Icons.add_location, color: Colors.blue),
              title: const Text('Add Event'),
              subtitle: const Text('Switch to Add Mode on Map'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomMapPage(
                    ),
                  ),
                );
              },
            ),
            const Divider(height: 20, thickness: 1),

            // Other Options
            ListTile(
              leading: const Icon(Icons.event, color: Colors.green),
              title: const Text('My Events'),
              subtitle: const Text('View the events you’ve added'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('My Events functionality not implemented yet.')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.orange),
              title: const Text('Settings'),
              subtitle: const Text('Manage account settings'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings functionality not implemented yet.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
