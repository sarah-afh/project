import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guard/constants.dart';
import 'package:guard/database.dart';
import 'package:guard/riverpod/sensor_status_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/new_user_model.dart';

class SensorStatusSwitcher extends ConsumerWidget {
  final String sensorName;

  SensorStatusSwitcher({required this.sensorName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusConfig = ref.read(sensorStatusProvider(sensorName));
    return statusConfig.when(
        data: (value) {
          final status = ref.watch(value);
          return SizedBox(
            height: 35,
            child: FloatingActionButton.extended(
                onPressed: () {
                  updateData(sensorName, 'Status ', !status);
                  ref.read(value.state).state = !ref.read(value);
                },
                // extendedPadding: EdgeInsets.only(bottom: 10),
                label: status ? const Text("On") : const Text("Off"),
                backgroundColor: status ? kPrimaryColor2 : Colors.grey,
                icon: Icon(
                  status ? Icons.toggle_on : Icons.toggle_off,
                )),
          );
        },
        error: (er, _) => Text("failed to load sensor status"),
        loading: () => const SizedBox.shrink());
  }
}
