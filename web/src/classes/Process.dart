import '../Globals.dart';
import 'package:uuid/uuid.dart';
import 'dart:math' as math;

import 'Interrupt.dart';
import 'MMU.dart';

class Process {
  String pid, color, interruptMsg, shortPid;
  int sizeInMemory, calculatedPagesToAlloc;
  bool interrupted = false;

  Process(this.sizeInMemory) {
    const uuid = Uuid();
    pid = uuid.v4();
    shortPid = pid.substring(1, 8);
    color = 'rgba(${math.Random().nextInt(255)}, ${math.Random().nextInt(255)}, ${math.Random().nextInt(255)}, 0.7)';
    calculatedPagesToAlloc = ((SYS_PAGE_SIZE + sizeInMemory) / SYS_PAGE_SIZE).floor();
    print(calculatedPagesToAlloc);
    print(sizeInMemory);
  }

  void run() {
    try {
      var memoryAddresses = guessMemoryAddress();
      for (var i = 0; i < memoryAddresses.length; i++) {
        MMU.addProcessToAddress(this, memoryAddresses[i]);
      }
    } catch (interrupt) {
      interrupted = true;
      interruptMsg = interrupt.message;
    }
  }

  List<int> guessMemoryAddress() {
    var availableAddresses = MMU.getAvailableAddresses();
    if(availableAddresses.isNotEmpty) {
      var howManyPages = math.Random().nextInt(
        (availableAddresses.length > PROC_MAX_ALLOCATED_PAGES
          ? calculatedPagesToAlloc
          : availableAddresses.length)) + 1;
      var chosenAddresses = List<int>.empty(growable: true);
      for (var i = 0; i < howManyPages; i++) {
        var idx = math.Random().nextInt(availableAddresses.length);
        chosenAddresses.add(availableAddresses[idx]);
        availableAddresses.removeAt(idx);
      }
      return chosenAddresses;
    // } 
    // else {
    //     throw Interrupt('''Page fault: process tried to allocate ($numPagesToAlloc) pages
    //     but the maximum number of pages allowed to each process is ($PROC_MAX_ALLOCATED_PAGES).''', this);
    //   }
    } else {
      throw Interrupt('Page fault: no available addresses in virtual memory.', this);
    }
  }

}

