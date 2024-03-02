import 'package:flutter/material.dart';
import 'package:shotgun/domain/models/activities/activities.dart';
import 'package:shotgun/domain/models/activities/music.dart';
import 'package:shotgun/domain/models/utils/constants.dart';
import 'package:shotgun/domain/models/booking/seat_info.dart';
import 'package:shotgun/domain/models/auth/user.dart';
import 'package:shotgun/presentation/components/seat_booking_widgets.dart';

class SeatBookScreen extends StatefulWidget {
  const SeatBookScreen({super.key, required this.tripId});
  final String tripId;

  @override
  State<SeatBookScreen> createState() => _SeatBookScreenState();
}

class _SeatBookScreenState extends State<SeatBookScreen> {
  List<User> bookedPassengers = [
    User(id: 'id', photoUrl: 'https://picsum.photos/200/300', name: 'Johnny'),
    User(id: 'id1', photoUrl: 'https://picsum.photos/200/301', name: 'Jacques'),
    User(id: 'id2', photoUrl: 'https://picsum.photos/200/302', name: 'Peter'),
  ];

  List<SeatInfo> seats = [
    SeatInfo(
      position: const Alignment(0.27, -.1),
      available: false,
      number: 1,
      user: User(
        id: 'X',
        name: 'Jacques',
        photoUrl: 'https://picsum.photos/200/300',
      ),
    ),
    SeatInfo(
      position: const Alignment(-0.27, -.1),
      number: 2,
      available: true,
    ),
    SeatInfo(
      position: const Alignment(-0.3, .26),
      number: 3,
      available: true,
    ),
    SeatInfo(
      position: const Alignment(0, .26),
      number: 4,
      available: true,
    ),
    SeatInfo(
      position: const Alignment(0.3, .26),
      number: 5,
      available: true,
    ),
  ];

  List<Activity> activities = [
    Music(
      color: const Color.fromARGB(255, 255, 145, 0),
      icon: Icons.speaker,
      name: 'Music',
      position: const Alignment(0, -.4),
      type: Music,
    ),
  ];
  int _selectedSeat = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Trip name will be here'),
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Passengers
              SingleChildScrollView(
                child: ListView.builder(
                  itemCount: bookedPassengers.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        foregroundImage: NetworkImage(
                          bookedPassengers[index].photoUrl,
                        ),
                      ),
                      title: Text(bookedPassengers[index].name),
                      subtitle: Text('Seat: ${index + 1}'),
                    );
                  },
                ),
              ),

              // Logout
              ElevatedButton(
                onPressed: () {},
                child: const Text('Leave Trip'),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: Constants.padding,
          //   child: const Row(
          //     children: [
          //       Text(
          //         'Trip to Bora Bora',
          //         textAlign: TextAlign.left,
          //         style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          //       ),
          //     ],
          //   ),
          // ),
          Flexible(
            child: Stack(
              children: [
                const Center(child: CarView()),
                for (final seat in seats)
                  SeatButton(
                    onTap: () {
                      seatButtonTapped(seat.number);
                    },
                    selected: seat.number == _selectedSeat,
                    seatInfo: seat,
                  ),
                for (final activity in activities)
                  ActivityButton(activity: activity),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _selectedSeat == -1
                ? null
                : () {
                    bookSeat(_selectedSeat);
                  },
            child: Text(
              _selectedSeat == -1
                  ? 'Choose a seat'
                  : 'Book Seat $_selectedSeat',
            ),
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  void seatButtonTapped(int number) {
    setState(() {
      if (number == _selectedSeat) {
        _selectedSeat = -1;
      } else if (!seats.map((seat) => seat.available).toList()[number - 1]) {
      } else {
        _selectedSeat = number;
      }
    });
  }

  void bookSeat(int number) {
    //TODO: Implement sever side
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: Text('Booked Seat: $number')),
        body: const Placeholder(),
      );
    }));
  }
}
