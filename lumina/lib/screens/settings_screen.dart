import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GlassCard(
            child: const ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text("Julian Aris"),
              subtitle: Text("Pro Archivist • julian@lumina.ai"),
            ),
          ),
          const SizedBox(height: 20),
          GlassCard(
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text("Notifications"),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  leading: Icon(Icons.cloud),
                  title: Text("Cloud Storage"),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  leading: Icon(Icons.memory),
                  title: Text("AI Engine"),
                  trailing: Text("v4.2"),
                ),
                Divider(),
                ListTile(leading: Icon(Icons.logout), title: Text("Sign Out")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
