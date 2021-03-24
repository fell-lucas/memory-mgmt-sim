import '../Globals.dart';
import 'package:uuid/uuid.dart';
import 'dart:math' as math;

import 'MMU.dart';

class Process {
  String pid, color;
  int sizeInMemory;

  Process(this.sizeInMemory) {
    const uuid = Uuid();
    pid = uuid.v4();
    color = 'rgba(${math.Random().nextInt(255)}, ${math.Random().nextInt(255)}, ${math.Random().nextInt(255)}, 0.7)';
  }

  void run() {
    var memoryAddresses = guessMemoryAddress();
    for (var i = 0; i < memoryAddresses.length; i++) {
      MMU.addProcessToAddress(this, memoryAddresses[i]);
    }
  }
}

List<int> guessMemoryAddress() {
  var availableAddresses = MMU.getAvailableAddresses();
  var howManyPages = math.Random().nextInt(
    (availableAddresses.length > PROC_MAX_ALLOCATED_PAGES
      ? PROC_MAX_ALLOCATED_PAGES
      : availableAddresses.length)) + 1;
  var chosenAddresses = List<int>.empty(growable: true);
  for (var i = 0; i < howManyPages; i++) {
    var idx = math.Random().nextInt(availableAddresses.length);
    chosenAddresses.add(availableAddresses[idx]);
    availableAddresses.removeAt(idx);
  }
  return chosenAddresses;
}
