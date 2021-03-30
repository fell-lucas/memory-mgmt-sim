import '../Globals.dart';
import 'package:uuid/uuid.dart';
import 'dart:math' as math;

import 'Interrupt.dart';
import 'MMU.dart';

class Process {
  String pid, color, shortPid;
  int sizeInMemory, calculatedPagesToAlloc, allocatedPages, triedToAllocate;

  Process(this.sizeInMemory) {
    const uuid = Uuid();
    pid = uuid.v4();
    shortPid = pid.substring(0, 8);
    color = 'rgba(${math.Random().nextInt(255)}, ${math.Random().nextInt(255)}, ${math.Random().nextInt(255)}, 0.7)';
    calculatedPagesToAlloc = ((SYS_PAGE_SIZE + sizeInMemory) / SYS_PAGE_SIZE).floor();
    allocatedPages = 0;
    triedToAllocate = -1;
  }

  void run() {
    try {
      var memoryAddresses = guessMemoryAddress();
      for (var i = 0; i < memoryAddresses.length; i++) {
        MMU.addProcessToAddress(this, memoryAddresses[i]);
        ++allocatedPages;
      }
    } catch (interrupt) {
      Interrupt.toHtml(interrupt);
    }
  }

  List<int> guessMemoryAddress() {
    var availableAddresses = MMU.getAvailableAddresses();
    if(availableAddresses.isNotEmpty) {
      var howManyPages = math.Random().nextInt(
        (availableAddresses.length > PROC_MAX_ALLOCATED_PAGES
          ? calculatedPagesToAlloc
          : availableAddresses.length)) + 1;
      triedToAllocate = howManyPages;
      var chosenAddresses = List<int>.empty(growable: true);
      for (var i = 0; i < howManyPages; i++) {
        var idx = math.Random().nextInt(availableAddresses.length);
        chosenAddresses.add(availableAddresses[idx]);
        availableAddresses.removeAt(idx);
      }
      return chosenAddresses;
    } else {
      throw Interrupt('Page fault: No available addresses in virtual memory.', this);
    }
  }

}

