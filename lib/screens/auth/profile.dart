import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shotgun_v2/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final Auth auth;
  late final FirebaseFirestore _firestore;
  bool editMode = false;
  bool loading = false;
  FocusNode? displayNameNode;

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    auth = Provider.of<Auth>(context, listen: false);
  }

  toggleEditMode() {
    setState(() {
      editMode = !editMode;
      if (editMode) {
        displayNameNode = FocusNode();
        displayNameNode!.requestFocus();
      } else {
        displayNameNode!.unfocus();
        displayNameNode = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: editMode ? const Icon(Icons.done) : const Icon(Icons.edit),
            onPressed: () {
              toggleEditMode();
            },
          ),
        ],
      ),
      body: Consumer<Auth>(
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
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: double.infinity,
                          height: 100,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (editMode) {
                              _startNewProfileImageFlow();
                            }
                          },
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: user.photoURL != null
                                ? NetworkImage(user.photoURL!)
                                : null,
                            child: user.photoURL == null
                                ? const Icon(Icons.person, size: 50)
                                : null,
                          ),
                        ),
                        const SizedBox(height: 16),
                        editMode
                            ? TextField(
                                decoration: const InputDecoration(
                                  labelText: 'Display Name',
                                ),
                                focusNode: displayNameNode,
                                controller: TextEditingController(
                                    text: user.displayName),
                                onSubmitted: (value) async {
                                  toggleEditMode();
                                  _setLoading(true);
                                  await auth.editUserName(value);
                                  _setLoading(false);
                                },
                              )
                            : Text(
                                user.displayName ?? 'No display name',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
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
                            if (context.mounted) {
                              _signOut(context);
                            }
                          },
                          child: const Text('Sign Out'),
                        ),
                      ],
                    ),
                  ),
                  if (loading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _startNewProfileImageFlow() async {
    _setLoading(true);
    try {
      // image picker
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        // Process the selected image
      }
    } catch (e) {
      print(e);
    }
    _setLoading(false);
  }

  void _uploadProfileImage(XFile image) async {}

  void _setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  _signOut(BuildContext context) async {
    Navigator.pop(context);
    await auth.signOut();
  }
}
