import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shotgun_v2/providers/friend_provider.dart';
import 'package:shotgun_v2/widgets/qr_scanner.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  // Functional //
  _searchForFriend(String _) {
    Provider.of<FriendProvider>(context, listen: false)
        .searchForFriend(_searchController.text);
  }

  _addFriendByEmail() {
    Provider.of<FriendProvider>(context, listen: false)
        .addFriendByEmail(_searchController.text);
  }

  _addFriendByUserId(String userId) {
    Provider.of<FriendProvider>(context, listen: false)
        .addFriendByUserId(userId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchFocusNode.requestFocus();
  }

  // UI //
  Future<void> _startQrUserScan() async {
    final res = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          color: Colors.white,
          child: const Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Scan QR Code',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(height: 300, width: 300, child: QrScannerView()),
            ],
          ),
        );
      },
    );
    if (res != null) {
      _addFriendByUserId(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friend'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          // Search Bar with QR Code Scanner
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Flexible(
                  flex: 7,
                  child: TextField(
                    focusNode: _searchFocusNode,
                    controller: _searchController,
                    onChanged: _searchForFriend,
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(Icons.qr_code),
                    onPressed: () {
                      _startQrUserScan();
                    },
                  ),
                ),
              ],
            ),
          ),
          // Search Results
          Expanded(
            child: Consumer<FriendProvider>(
              builder: (context, provider, _) {
                return ListView.builder(
                  itemCount: provider.searchResults.length,
                  itemBuilder: (context, index) {
                    final friend = provider.searchResults[index];
                    return Card(
                      child: ListTile(
                        title: Text(friend.name ?? ''),
                        subtitle: Text(friend.email ?? ''),
                        leading: friend.imageUrl != null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(friend.imageUrl!))
                            : null,
                        trailing: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            _addFriendByUserId(friend.userId!);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
