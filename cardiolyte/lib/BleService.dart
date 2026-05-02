import 'dart:async';
import 'dart:convert';

import 'package:cardiolyte/main.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// import '../utils/extra.dart';
// import '../utils/snackbar.dart';

class BleService {
  BleService({required this.updateChartIndicesCallback});

  List<EkgSampleData> receivedData = [];

  // BluetoothConnectionState _connectionState = BluetoothConnectionState.disconnected;
  // List<BluetoothService> _services = [];
  // bool _isDiscoveringServices = false;
  // bool _isConnecting = false;
  // bool _isDisconnecting = false;

  BluetoothDevice? device;

  Function(List<int>) updateChartIndicesCallback;

  Future<void> scanForDevice() async {
    const List<String> deviceNamesToSearchFor = [
      "Cardiolyte",
      "Pi Pico",
      "ESP",
    ];

    // listen to scan results
    // Note: `onScanResults` clears the results between scans. You should use
    //  `scanResults` if you want the current scan results *or* the results from the previous scan.

    var subscription = FlutterBluePlus.onScanResults.listen((results) {
      BluetoothDevice? deviceFound;

      if (results.isNotEmpty) {
        int numDevicesWithEmptyName = 0;
        for (ScanResult r in results) {
          final String deviceName = r.device.platformName;

          if (deviceName.isEmpty) {
            numDevicesWithEmptyName++;
            continue;
          }

          print(
            '${r.device.remoteId}: "$deviceName (${r.advertisementData.advName})" found!',
          );
          for (String deviceNameToSearchFor in deviceNamesToSearchFor) {
            if (deviceName.contains(deviceNameToSearchFor)) {
              print("That's the device we want!");
              deviceFound = r.device;
            }
          }
        }

        print("Found $numDevicesWithEmptyName with empty names");
      }

      device = deviceFound;
    }, onError: (e) => print(e));

    // cleanup: cancel subscription when scanning stops
    FlutterBluePlus.cancelWhenScanComplete(subscription);

    // Wait for Bluetooth enabled & permission granted
    // In your real app you should use `FlutterBluePlus.adapterState.listen` to handle all states
    await FlutterBluePlus.adapterState
        .where((val) => val == BluetoothAdapterState.on)
        .first;

    // Start scanning w/ timeout
    // Optional: use `stopScan()` as an alternative to timeout
    await FlutterBluePlus.startScan(
      // withServices: [Guid("4ae60003-a1ad-46b0-8234-88a23ad055b9")],
      // match any of the specified services
      // withKeywords: ["Cardiolyte"], // *or* any of the specified keywords
      timeout: Duration(seconds: 15),
    );

    // wait for scanning to stop
    await FlutterBluePlus.isScanning.where((val) => val == false).first;
  }

  Future<void> connectAndSubscribeToDevice() async {
    BluetoothDevice? device = this.device;
    if (device == null) {
      print("[ERROR] device is null");
      return;
    }

    // --- Connection ---
    // await device.connectAndUpdateStream().catchError((e) {
    //   Snackbar.show(
    //     ABC.c,
    //     prettyException("Connect Error:", e),
    //     success: false,
    //   );
    // });

    // --- Getting services ---

    BluetoothService? ekgService = await () async {
      List<BluetoothService> services = await device.discoverServices();

      for (var service in services) {
        print(service);
        if (service.uuid ==
            Guid.fromString("4ae60001-a1ad-46b0-8234-88a23ad055b9")) {
          return service;
        }
      }

      return null;
    }();
    if (ekgService == null) {
      print("ekgService == null :(");
      return;
    }

    final characteristics = ekgService.characteristics;
    final ekgCharacteristic = characteristics.firstWhere((characteristic) {
      return characteristic.uuid ==
          Guid.fromString("4ae60003-a1ad-46b0-8234-88a23ad055b9");
    });

    // --- Subscribing to new values (notifications) ---
    final subscription = ekgCharacteristic.onValueReceived.listen((value) {
      final EkgSampleData sample = _parseBleValue(value);

      print("got sample: $sample");

      receivedData.add(sample);

      updateChartIndicesCallback([receivedData.length - 1]);
    });

    device.cancelWhenDisconnected(subscription);

    await ekgCharacteristic.setNotifyValue(true);
  }

  EkgSampleData _parseBleValue(List<int> value) {
    final String str = ascii.decode(value);

    print("$value => $str");

    final splitStrings = str.split(" ");

    final int firstNum = int.tryParse(splitStrings[0]) ?? 0;
    final int secondNum = int.tryParse(splitStrings[1]) ?? 0;

    final EkgSampleData sample = EkgSampleData(x: firstNum, y: secondNum);

    return sample;
  }
}
