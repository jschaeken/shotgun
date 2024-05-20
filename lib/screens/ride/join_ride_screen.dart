import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shotgun_v2/providers/ride_provider.dart';

class JoinRideScreen extends StatefulWidget {
  const JoinRideScreen({super.key});

  @override
  State<JoinRideScreen> createState() => _JoinRideScreenState();
}

class _JoinRideScreenState extends State<JoinRideScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;

  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

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
            Flexible(
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  await rideProvider.joinRide(
                    'Xvgva3rXY15OLWXdGrqQ',
                    'dbgJ9pJgRDboJ3rFrWPpkkaI35J2',
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
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
