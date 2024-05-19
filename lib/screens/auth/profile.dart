import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shotgun_v2/providers/auth_provider.dart' as auth_provider;
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final auth_provider.AuthProvider auth;

  @override
  void initState() {
    super.initState();
    auth = Provider.of<auth_provider.AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Consumer<auth_provider.AuthProvider>(
        builder: (context, auth, child) {
          if (auth.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (auth.errorMessage != null) {
            return Center(child: Text('Error: ${auth.errorMessage}'));
          } else if (auth.user == null) {
            return const Center(child: Text('No user found'));
          } else {
            final user = auth.user!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: double.infinity,
                    height: 100,
                  ),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user.photoURL != null
                        ? NetworkImage(user.photoURL!)
                        : null,
                    child: user.photoURL == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.displayName ?? 'No display name',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email ?? 'No email',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await auth.signOut();
                      if (mounted) {
                        _signOut(context);
                      }
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  _signOut(BuildContext context) async {
    Navigator.pop(context);
    await auth.signOut();
  }
}
