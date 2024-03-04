import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SeatBookScreenV2 extends StatefulWidget {
  const SeatBookScreenV2({super.key});

  @override
  State<SeatBookScreenV2> createState() => _SeatBookScreenV2State();
}

class _SeatBookScreenV2State extends State<SeatBookScreenV2> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
        ),
        SeatSelector(),
      ],
    ));
  }
}

class SeatSelector extends StatefulWidget {
  const SeatSelector({super.key});

  @override
  _SeatSelectorState createState() => _SeatSelectorState();
}

class _SeatSelectorState extends State<SeatSelector> {
  // Example layout: 2 rows with 3 seats each. true if selected, false otherwise.
  List<List<bool>> seats = [
    [false, true, false],
    [false, false, false],
  ];

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: FractionallySizedBox(
        widthFactor: 0.7,
        heightFactor: 0.7,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: seats[0].length, // Number of seats per row
              childAspectRatio: 1.0,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: seats.length * seats[0].length,
            itemBuilder: (context, index) {
              final int row = index ~/ seats[0].length;
              final int seat = index % seats[0].length;
              return InkWell(
                onTap: () {
                  setState(() {
                    seats[row][seat] =
                        !seats[row][seat]; // Toggle seat selection
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: seats[row][seat] ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
