import 'dart:html';

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
    shortPid = pid.substring(0, 8);
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
      interruptToHtml(interrupt);
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
    } else {
      throw Interrupt('Page fault: No available addresses in virtual memory.', this);
    }
  }
  
  void interruptToHtml(Interrupt interrupt) {
    var interruptsDiv = querySelector('#interrupts');
    var processInterrupt = DivElement();
    var processPid = ParagraphElement();
    var interruptMsg = ParagraphElement();
    var interruptCount = ParagraphElement();

    processPid.attributes.addAll({'id': '${interrupt.p.pid}'});
    processPid.text = interrupt.p.shortPid;
    processPid.style.background = interrupt.p.color;
    interruptMsg.attributes.addAll({'msg': '${interrupt.message.substring(0, 50)}'});
    interruptMsg.text = interrupt.message;
    interruptCount.text = '1';

    var alreadyExists = querySelector(
      '#interrupts > div > p[id="${interrupt.p.pid}"] + p[msg^="${interrupt.message.substring(0, 50)}"]'
      );
    if(alreadyExists != null) {
      var interruptCountToUpdate = alreadyExists.nextElementSibling;
      interruptCountToUpdate.text = (int.parse(interruptCountToUpdate.text) + 1).toString();
    } else {
      processInterrupt.children.addAll([processPid, interruptMsg, interruptCount]);
      interruptsDiv.append(processInterrupt);
    }
  }
}

