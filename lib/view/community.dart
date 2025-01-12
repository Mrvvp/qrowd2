import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
 CommunityPage({super.key});

  final List<Map<String, dynamic>> communities = [
    {
      'name': 'Community A',
      'imageUrl': 'lib/assets/images/people-with-gothic-style-costumes-make-up-performing-drama-world-theatre-day copy.jpg', // Replace with image path
      'description': 'A vibrant community known for its festivals.',
      'events': [
        {'title': 'Festival 1', 'date': '2024-11-15'},
        {'title': 'Event 2', 'date': '2024-11-22'},
      ],
      'culture': 'Rich cultural heritage, known for its art and music.',
      'members': 500,
    },
    {
      'name': 'Community B',
      'imageUrl': 'lib/assets/images/people-with-gothic-style-costumes-make-up-performing-drama-world-theatre-day copy.jpg', // Replace with image path
      'description': 'A close-knit community focused on sustainability.',
      'events': [
        {'title': 'Workshop 1', 'date': '2024-11-29'},
        {'title': 'Meeting 2', 'date': '2024-12-06'},
      ],
      'culture': 'Emphasis on environmental conservation and community.',
      'members': 250,
    },
    // Add more community data here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Communities'),
      ),
      body: ListView.builder(
        itemCount: communities.length,
        itemBuilder: (context, index) {
          return _buildCommunityCard(context, communities[index]);
        },
      ),
    );
  }

  Widget _buildCommunityCard(BuildContext context, Map<String, dynamic> community) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            community['imageUrl'],
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  community['name'],
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(community['description']),
                const SizedBox(height: 16.0),
                const Text('Events:', style: TextStyle(fontWeight: FontWeight.bold)),
                _buildEventsList(community['events']),
                const SizedBox(height: 16.0),
                Text('Culture: ${community['culture']}'),
                Text('Members: ${community['members']}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(List<dynamic> events) {
    return Column(
      children: events
          .map((event) => ListTile(
                title: Text(event['title']),
                subtitle: Text(event['date']),
              ))
          .toList(),
    );
  }
}
