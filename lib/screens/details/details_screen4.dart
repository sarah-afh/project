import 'package:flutter/material.dart';
import 'package:guard/components/sensor_status_switcher.dart';
import 'package:guard/constants.dart';
import 'package:flutter/services.dart';
import 'package:guard/database.dart';
import 'package:guard/riverpod/sensor_status_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DetailsScreenM extends ConsumerStatefulWidget {
  const DetailsScreenM(
      {Key? key,
      required this.name,
      required this.status,
      required this.location})
      : super(key: key);

  final String name;
  final bool status;
  final String location;

  @override
  DetailsScreen5 createState() => DetailsScreen5();
}

class DetailsScreen5 extends ConsumerState<DetailsScreenM> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    final statusConfig = ref.watch(sensorStatusProvider("LSM303D"));

    return Scaffold(
      appBar: buildAppBar(),
      body: statusConfig.when(
          data: (data) {
            final value = ref.watch(data);
            return StreamBuilder<Map<String, dynamic>>(
                stream: getReadings("LSM303D"),
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
                  final acc = data["Accelerometer"];
                  final mag = data["Magnetometer"];
                  return SafeArea(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.05),
                          child: Column(children: [
                            SizedBox(height: size.height * 0.02),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Icon(
                            //       Icons.arrow_back,
                            //       size: 30,
                            //       color: kPrimaryColor2,
                            //     ),
                            //     Text(
                            //       'Home',
                            //       style: TextStyle(
                            //         color: Colors.black87,
                            //         fontWeight: FontWeight.bold,
                            //         fontSize: 20,
                            //       ),
                            //     ),
                            //   ],
                            // ),

                            SizedBox(height: size.height * 0.03),
                            Row(
                              children: [
                                Container(
                                  height: 120,
                                  width: 120,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      "assets/images/motion.jpg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: size.width * 0.05),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SensorStatusSwitcher(
                                        sensorName: widget.name),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Motion',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                    Text(
                                      'Measures the movements done',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      'in your room',
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
                                              '$acc',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              'Accelerometer',
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
                                              '$mag',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              'Magnetometer',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(),
                            SizedBox(height: 0.5),
                            if (value == true)
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: []),
                                  ),
                                ],
                              )
                            else
                              Row()
                          ])));
                });
          },
          error: (err, _) => Text(err.toString()),
          loading: () => Center(child: CircularProgressIndicator())),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kPrimaryColor,
      elevation: 0,
      centerTitle: true,
      title: Text(widget.location),
      actions: [],
    );
  }
}
