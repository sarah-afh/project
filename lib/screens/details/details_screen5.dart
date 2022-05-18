import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guard/components/sensor_status_switcher.dart';
import 'package:guard/constants.dart';
import 'package:guard/database.dart';
import 'package:guard/riverpod/sensor_status_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DetailsScreenC extends ConsumerStatefulWidget {
  const DetailsScreenC(
      {Key? key,
      required this.name,
      required this.status,
      required this.location})
      : super(key: key);

  final String name;
  final bool status;
  final String location;

  @override
  DetailsScreen6 createState() => DetailsScreen6();
}

class DetailsScreen6 extends ConsumerState<DetailsScreenC> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    final statusConfig = ref.watch(sensorStatusProvider("BH1745"));

    return Scaffold(
      appBar: buildAppBar(),
      body: statusConfig.when(
          data: (data) {
            final value = ref.watch(data);
            return StreamBuilder<Map<String, dynamic>>(
                stream: getReadings("BH1745"),
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
                  final rgb = data["RGBC"];

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
                                      "assets/images/colors.jpg",
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
                                      'Color & Luminance',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                    Text(
                                      'Measures the colors and luminance',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      'percentages in your room',
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
                                              '$rgb',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              '     Red        Green       Blue        Light Concentration',
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
                                              'Note:',
                                              style: TextStyle(
                                                height: 2,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              '* Colors are calculated based on the primary colors Red, Green and Blue.',
                                              style: TextStyle(
                                                  height: 2,
                                                  fontSize: 16,
                                                  color: Colors.grey),
                                            ),
                                            Text(
                                              '* Light concentration measures the intensity of light emitted from a surface ',
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
          loading: () => Center(child: CircularProgressIndicator())),
    );
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
