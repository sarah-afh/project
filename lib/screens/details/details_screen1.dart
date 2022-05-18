// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:guard/components/sensor_status_switcher.dart';
import 'package:guard/constants.dart';
import 'package:flutter/services.dart';
import 'package:guard/database.dart';
import 'package:guard/riverpod/sensor_status_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DetailsScreen extends ConsumerStatefulWidget {
  const DetailsScreen(
      {Key? key,
      required this.name,
      required this.status,
      required this.location})
      : super(key: key);

  final String name;
  final bool status;
  final String location;

  @override
  DetailsScreenx createState() => DetailsScreenx();
}

class DetailsScreenx extends ConsumerState<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    final statusConfig = ref.watch(sensorStatusProvider("BME680"));
    return Scaffold(
        appBar: buildAppBar(),
        body: statusConfig.when(
            data: (data) {
              final value = ref.watch(data);
              return StreamBuilder<Map<String, dynamic>>(
                  stream: getReadings("BME680"),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: const CircularProgressIndicator());
                    }
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text("There is no data for ${widget.name}"),
                      );
                    }
                    final data = snapshot.data!;
                    final temperature = double.parse(data["Temperature"]);
                    final gas = data["Gas"];
                    final humidity = double.parse(data["Humidity"]);
                    final pressure = double.parse(data["Pressure"]);
                    return SafeArea(
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.05),
                            child: Column(children: [
                              SizedBox(height: size.height * 0.05),
                              Row(
                                children: [
                                  Container(
                                    height: 120,
                                    width: 120,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                        "assets/images/air_quality.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: size.width * 0.05),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SensorStatusSwitcher(
                                          sensorName: "BME680"),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Air Quality',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                        ),
                                      ),
                                      Text(
                                        'Measures the air quality of your',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        'room through temperature,',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        'humidity, pressure and gas',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * 0.05),
                              value == true
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '$temperature',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: (temperature < 40)
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                              ),
                                              Text(
                                                'TEMPERATURE',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '$pressure',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: (pressure < 1100)
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                              ),
                                              Text(
                                                'PRESSURE',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      child: Text(
                                        'Sensor is turned off',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.red),
                                      ),
                                    ),
                              SizedBox(height: 40),
                              value == true
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '$humidity',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: (humidity < 50)
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                              ),
                                              Text(
                                                'HUMIDITY',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '$gas',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                'GAS',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row()
                            ])));
                  });
            },
            error: (err, _) => Text(err.toString()),
            loading: () => Center(child: CircularProgressIndicator())));
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.indigo,
      elevation: 0,
      centerTitle: true,
      title: Text(widget.location),
      actions: [
        // IconButton(
        //   icon: Icon(Icons.edit),
        //   onPressed: () {},
        // ),
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {},
        ),
      ],
    );
  }
}

class InfoDetails extends StatelessWidget {
  const InfoDetails({
    Key? key,
    required this.reading,
    required this.value,
  }) : super(key: key);

  final String reading;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width / 4,
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(this.reading),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(this.value.toString()),
          ),
        ],
      ),
    );
  }
}
