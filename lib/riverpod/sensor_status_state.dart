import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guard/database.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final sensorStatusProvider =
    FutureProvider.family<StateProvider<bool>, String>((ref, sensorName) async {
  final status = await readData(sensorName, 'Status ');
  return StateProvider((ref) {
    return status;
  });
});