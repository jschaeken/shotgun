import 'package:flutter/material.dart';
import 'package:shotgun/features/passenger_booking/domain/entities/activities/activity.dart';
import 'package:shotgun/features/core/domain/entities/utils/constants.dart';
import 'package:shotgun/features/passenger_booking/domain/entities/booking/seat_info.dart';

class CarView extends StatelessWidget {
  const CarView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/car-top-view.png');
  }
}

class SeatButton extends StatelessWidget {
  const SeatButton({
    super.key,
    required this.seatInfo,
    required this.selected,
    required this.onTap,
  });

  final SeatInfo seatInfo;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: seatInfo.position,
      child: Material(
        color: Colors.white,
        borderRadius: Constants.borderRadius,
        child: InkWell(
          borderRadius: Constants.borderRadius,
          onTap: () {
            onTap();
          },
          child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: !seatInfo.available
                      ? seatInfo.user != null
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(seatInfo.user!.photoUrl))
                          : null
                      : null),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: !seatInfo.available
                    ? seatInfo.user != null
                        ? Center(
                            child: Image.network(seatInfo.user!.photoUrl,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    )),
                          )
                        : const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          )
                    : selected
                        ? const Icon(
                            Icons.done,
                            color: Colors.green,
                          )
                        : const Icon(
                            Icons.crop_square_rounded,
                            color: Colors.black,
                          ),
              )),
        ),
      ),
    );
  }
}

class ActivityButton extends StatelessWidget {
  const ActivityButton({
    super.key,
    required this.activity,
  });

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: activity.position,
      child: Material(
        color: activity.color,
        borderRadius: Constants.borderRadius,
        child: InkWell(
          borderRadius: Constants.borderRadius,
          onTap: () {},
          child: Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                activity.icon,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
