import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:shotgun_v2/providers/ride_provider.dart';

class JoinRideScreen extends StatelessWidget {
  const JoinRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rideProvider = Provider.of<RideProvider>(context);
    rideProvider.addListener(() {
      if (rideProvider.errorMessage != null) {
        _showErrorSnackbar(context, rideProvider.errorMessage!);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Ride'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // String qrCodeResult = await FlutterBarcodeScanner.scanBarcode(
                //   '#ff6666',
                //   'Cancel',
                //   true,
                //   ScanMode.QR,
                // );

                // if (qrCodeResult != '-1') {
                //   rideProvider.joinRide(
                //     qrCodeResult,
                //     'currentUserId',
                //     1,
                //   );
                // }
              },
              child: const Text('Scan QR Code'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  await rideProvider.joinRide(
                    '7S02Z8iUYhNNgoJpXdRq',
                    'currentUserId',
                    1,
                  );
                } catch (e) {
                  log(e.toString());
                }
              },
              child: const Text('Test Join'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Implement joining ride via push notification here
              },
              child: const Text('Join via Notification'),
            ),
          ],
        ),
      ),
    );
  }

  _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
