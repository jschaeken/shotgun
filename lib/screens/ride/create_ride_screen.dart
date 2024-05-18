import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shotgun_v2/providers/auth_provider.dart';
import 'package:shotgun_v2/providers/ride_provider.dart';
import 'package:shotgun_v2/utils/dateTime.dart';

class CreateRideScreen extends StatefulWidget {
  const CreateRideScreen({super.key});

  @override
  _CreateRideScreenState createState() => _CreateRideScreenState();
}

class _CreateRideScreenState extends State<CreateRideScreen> {
  final _formKey = GlobalKey<FormState>();
  late RideProvider rideProvider;
  late AuthProvider authProvider;
  String _destination = '';
  DateTime? _dateTime;
  int _seatCounter = 4;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rideProvider = Provider.of<RideProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Ride'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Destination
              TextFormField(
                decoration: const InputDecoration(labelText: 'Destination'),
                onSaved: (value) {
                  _destination = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a destination';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  const Text('Seats Available:',
                      style: TextStyle(fontSize: 16.0)),
                  const Spacer(),
                  Row(
                    children: [
                      ButtonIncrementor(
                        icon: Icons.remove,
                        onPressed: () {
                          setState(() {
                            if (_seatCounter > 0) {
                              _seatCounter--;
                            }
                          });
                        },
                      ),
                      Text('$_seatCounter'),
                      ButtonIncrementor(
                        icon: Icons.add,
                        onPressed: () {
                          setState(() {
                            _seatCounter++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),

              // Date and Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _selectDateTime(context);
                    },
                    child: _dateTime == null
                        ? const Icon(Icons.calendar_today)
                        : const Icon(Icons.edit),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Text(
                      _dateTime == null
                          ? 'Now'
                          : dateTimeToHumanReadable(_dateTime!),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              // Seats Available Counter
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  final uid = authProvider.user?.uid;
                  if (uid == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please login to create a ride'),
                      ),
                    );
                    return;
                  }
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Ride newRide = Ride.upload(
                      driverId: uid,
                      destination: _destination,
                      dateTime: _dateTime ?? DateTime.now(),
                      availableSeats: _seatCounter,
                      passengerMaps: [],
                    );
                    rideProvider.createRide(newRide).then((_) {
                      Navigator.pop(context);
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in all fields'),
                      ),
                    );
                  }
                },
                child: const Text('Create Ride'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dateTime) {
      if (mounted) {
        final TimeOfDay? timePicked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(_dateTime ?? DateTime.now()),
        );
        if (timePicked != null) {
          setState(() {
            _dateTime = DateTime(
              picked.year,
              picked.month,
              picked.day,
              timePicked.hour,
              timePicked.minute,
            );
          });
        }
      }
    }
  }
}

class ButtonIncrementor extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const ButtonIncrementor({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[300],
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
        ),
      ),
    );
  }
}
