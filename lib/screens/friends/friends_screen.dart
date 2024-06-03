import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:shotgun_v2/providers/friend_provider.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FriendProvider>(context, listen: false).getFriends();
      Provider.of<FriendProvider>(context, listen: false)
          .streamFriendRequests();
    });
  }

  Future<void> _refreshFriends() async {
    await Provider.of<FriendProvider>(context, listen: false).getFriends();
  }

  _goToAddFriend() {
    Navigator.of(context).pushNamed('/addFriend');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Friends'),
              Tab(text: 'Requests'),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _refreshFriends();
              },
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Friends Tab
                  Consumer<FriendProvider>(builder: (context, provider, s) {
                    return ListView.builder(
                      itemCount: provider.friends.length,
                      itemBuilder: (context, index) {
                        final friend = provider.friends[index];
                        return Card(
                          child: ListTile(
                            title: Text(friend.name ?? ''),
                            subtitle: Text(friend.email ?? ''),
                            leading: friend.imageUrl != null
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(friend.imageUrl!))
                                : null,
                          ),
                        );
                      },
                    );
                  }),
                  // Requests Tab
                  Consumer<FriendProvider>(builder: (context, provider, s) {
                    return ListView.builder(
                      itemCount: provider.friendRequests.length,
                      itemBuilder: (context, index) {
                        final request = provider.friendRequests[index];
                        return Card(
                          child: ListTile(
                            title: Text(request.name ?? ''),
                            subtitle: Text(request.email ?? ''),
                            leading: request.imageUrl != null
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(request.imageUrl!))
                                : null,
                            trailing:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              IconButton(
                                icon: const Icon(CupertinoIcons.check_mark),
                                onPressed: () {
                                  provider.acceptFriendRequest(request.userId);
                                },
                              ),
                              IconButton(
                                icon: const Icon(CupertinoIcons.xmark),
                                onPressed: () {
                                  provider.declineFriendRequest(request.userId);
                                },
                              ),
                            ]),
                          ),
                        ).animate().fadeIn();
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddFriend,
        heroTag: 'addFriend',
        child: const Icon(CupertinoIcons.person_add_solid),
      ),
    );
  }
}
