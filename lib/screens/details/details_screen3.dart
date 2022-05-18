import 'package:flutter/material.dart';
import 'package:guard/components/sensor_status_switcher.dart';
import 'package:guard/constants.dart';
import 'package:flutter/services.dart';
import 'package:guard/database.dart';
import 'package:guard/riverpod/sensor_status_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DetailsScreenS extends ConsumerStatefulWidget {
  const DetailsScreenS(
      {Key? key,
      required this.name,
      required this.status,
      required this.location})
      : super(key: key);

  final String name;
  final bool status;
  final String location;

  @override
  DetailsScreen4 createState() => DetailsScreen4();
}

class DetailsScreen4 extends ConsumerState<DetailsScreenS> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    final statusConfig = ref.watch(sensorStatusProvider("AS7262"));
    return Scaffold(
        appBar: buildAppBar(),
        body: statusConfig.when(
            data: (data) {
              final value = ref.watch(data);
              return StreamBuilder<Map<String, dynamic>>(
                  stream: getReadings(widget.name),
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
                    final spectrum = data["Spectrum"];

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
                                        "assets/images/spectrum.jpg",
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
                                          sensorName: "AS7262"),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Spectrum',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                        ),
                                      ),
                                      Text(
                                        'Measures the level of spectrum',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        'colors that are around the room',
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
                                                '$spectrum',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                'SPECTRUM',
                                                style: TextStyle(
                                                    height: 2,
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
                                      children: [],
                                    )
                                  : Row(),
                              SizedBox(height: 0.5),
                              value == true
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Note:',
                                                style: TextStyle(
                                                  height: 2,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                '* Spectrum a band of colours, as seen in a rainbow, produced by separation of the components of light by their different degrees of refraction according to wavelength.',
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                    height: 1.7,
                                                    fontSize: 16,
                                                    color: Colors.grey),
                                              ),
                                              Text(
                                                '* Spectrum consists of 6 colors which are:\n'
                                                '1: Red\n'
                                                '2: Blue\n'
                                                '3: Green\n'
                                                '4: Violet\n'
                                                '5: Orange\n'
                                                '6: Yellow',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  height: 2,
                                                  color: Colors.grey,
                                                ),
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
