import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class IPS_IDS extends StatefulWidget {
  static const id = 'IPS_IDS';
  const IPS_IDS({super.key});

  @override
  State<IPS_IDS> createState() => _IPS_IDSState();
}

class _IPS_IDSState extends State<IPS_IDS> {
  List<String> logData = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    runSnortScript();
    startLogReading();
  }

  void runSnortScript() {
    Process.start('bash', ['snort.sh']).then((Process process) {
      process.stdout.transform(utf8.decoder).listen((data) {
        print(data);
      });
      process.stderr.transform(utf8.decoder).listen((data) {
        print('stderr: $data');
      });
    });
  }

  void startLogReading() {
    const logFilePath = 'snort.log';
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      File(logFilePath).readAsString().then((String contents) {
        setState(() {
          logData = contents.split('\n');
        });
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.amber,
        ),
        title: Text(
          "IPS/IDS",
          style: TextStyle(color: Colors.amber),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                Text(
                  "IPS/IDS : ",
                  style: TextStyle(fontSize: 22),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: LiteRollingSwitch(
                    value: false,
                    width: 115,
                    textSize: 12,
                    textOn: 'ENABLE',
                    textOff: 'DISABLE',
                    textOffColor: Colors.white,
                    textOnColor: Colors.white,
                    colorOn: Color.fromARGB(255, 0, 0, 0),
                    colorOff: const Color.fromARGB(255, 0, 0, 0),
                    iconOn: Icons.lightbulb_outline,
                    iconOff: Icons.power_settings_new,
                    animationDuration: const Duration(milliseconds: 300),
                    onTap: () {},
                    onDoubleTap: () {},
                    onSwipe: () {},
                    onChanged: (bool state) {
                      if (state) {
                        runSnortScript();
                      } else {
                        _timer?.cancel();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          Divider(
            height: 0.2,
            color: Colors.black,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.779,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.black),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: logData.length,
                    itemBuilder: (context, index) {
                      return Text(
                        logData[index],
                        style: TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
