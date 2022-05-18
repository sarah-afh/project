// ignore_for_file: unnecessary_new

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

late final RTreference = FirebaseDatabase.instance.reference();

// writing into a realtime firebase
WTDBWrite() {
  RTreference.child("SensorInfo").set({
    'Status': "true",
    'Name': "test",
    'Location': "test",
    'ID': '3',
    'Description': null
  });
}

Stream<Map<String, dynamic>> getReadings(SensorName) {
  final transformer =
      StreamTransformer<Event, Map<String, dynamic>>.fromHandlers(
          handleData: (Event event, EventSink<Map<String, dynamic>> sink) {
    if (event.snapshot.value == null) {
      sink.add({});
      return;
    }
    final document = Map.from(event.snapshot.value);
    sink.add(Map.from(document.values.first));
  });

  return RTreference.child(SensorName)
      .orderByKey()
      .limitToLast(1)
      .onValue
      .transform(transformer);
}

x() {
  Future<int> GetInitial(String SensorName) async {
    final dbRef = FirebaseDatabase.instance.reference().child(SensorName);
    final snapshot = await dbRef.child(SensorName).once();
    print('Data : ${snapshot.value}');
    return int.parse(snapshot.value);
  }
}

CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection('SensorInfo');

// // // getting all data from Cloud data base
// getData(sensor, field) async {
//   // Get docs from collection reference
//   DocumentSnapshot documentSnapshot = await _collectionRef.doc(sensor).get();
//   final allData = documentSnapshot.get(field);
//   print(allData);

//   return (allData);
// }

// Reading data from the Cloud firebase
Future<bool> readData(DocId, field) async {
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection("SensorInfo").doc(DocId);
  final dataSnapshot = await documentReference.get();
  return dataSnapshot.get(field) as bool;
}

// Updating Cloud firebase Values.
Future<void> updateData(DocId, location, bool status) async {
  // DocumentReference doReference =
  //     FirebaseFirestore.instance.collection("SensorInfo").doc(DocId);
  DocumentReference doReference = _collectionRef.doc(DocId);

  await doReference.update({'Location': location});
}
