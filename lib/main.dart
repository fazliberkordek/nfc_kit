import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ValueNotifier<String> status = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC Demo'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Container(
              margin: EdgeInsets.all(4),
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(border: Border.all()),
              child: SingleChildScrollView(
                child: ValueListenableBuilder<String>(
                  valueListenable: status,
                  builder: (context, value, _) => Text('${value ?? ''}'),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              margin: EdgeInsets.all(4),
              constraints: BoxConstraints.expand(),
              child: ElevatedButton(
                onPressed: thisShallScan,
                child: Text('Scan NFC Tag'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> thisShallScan() async {
    status.value = 'Checking NFC availability...';
    NFCAvailability availability;
    try {
      availability = await FlutterNfcKit.nfcAvailability;
    } on PlatformException {
      availability = NFCAvailability.not_supported;
    }

    if (availability == NFCAvailability.not_supported) {
      status.value = 'NFC is not supported on this device.';
      return;
    }

    status.value = 'Polling for NFC tag...';
    try {
      NFCTag tag = await FlutterNfcKit.poll();
      status.value = 'NFC tag found: ${tag.id}';
    } catch (e) {
      status.value = 'Error scanning NFC tag: $e';
    }
  }
}
