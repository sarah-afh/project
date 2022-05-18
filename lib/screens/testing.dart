import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guard/screens/adding_sensors/adding_senor.dart';

class Testing extends StatelessWidget {
  const Testing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection("Anomalies").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.size != 0) {
            return ListView.separated(
              itemBuilder: (context, index) => AnomalyNotification(
                anomaly: snapshot.data!.docs[index].data(),
              ),
              itemCount: snapshot.data!.size,
              separatorBuilder: (context, index) => const SizedBox(
                height: 20,
              ),
            );
          }
          return Center(
            child: Text('No Warning',style: TextStyle(color: Colors.black),),
          );
        },
      ),
    );
  }
}

class AnomalyNotification extends StatelessWidget {
  final Map<String, dynamic> anomaly;

  const AnomalyNotification({Key? key, required this.anomaly})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Anomaly detected:  ${fromString(anomaly["sensorCode"])}",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Properties:",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  "At:  ${anomaly["time"]}",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            ...anomaly.keys
                .where((key) =>
            key != "time" && key != "sensorCode" && key != "docId")
                .map((e) => Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                children: [
                  Text(
                    "$e:",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${anomaly[e]}",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ))
                .toList()
          ],
        ),
      ),
    );
  }
}
