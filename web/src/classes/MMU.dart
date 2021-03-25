import 'dart:html';

import '../Globals.dart';
import 'Interrupt.dart';
import 'Process.dart';

class MMU {
  static var virtualMemory = <int, Process>{}; // address, process
  static var runningProcessCount = <String, int>{}; // pid, count

  static void init() {
    for (var i = 0; i < SYS_MAX_PAGES; i++) {
      virtualMemory[i] = null;
    }
  }

  static List<int> getAvailableAddresses() {
    var addresses = List<int>.empty(growable: true);
    for (var k in virtualMemory.keys) {
      if(virtualMemory[k] == null) {
        addresses.add(k);
      }
    }
    return addresses;
  }

  static void addProcessToAddress(Process p, int address) {
    if(!runningProcessCount.containsKey(p.pid)) {
      runningProcessCount.update(p.pid, (value) => 0, ifAbsent: () => 0);
    }
    if(runningProcessCount[p.pid] < p.calculatedPagesToAlloc && runningProcessCount[p.pid] <= PROC_MAX_ALLOCATED_PAGES) {
      virtualMemory.update(address, (value) => p);
      runningProcessCount.update(p.pid, (value) => ++value);
    } else {
      throw Interrupt('''Page fault: This process is already using the maximum 
      number of allowed pages ($PROC_MAX_ALLOCATED_PAGES).''', p);
    }

    // virtualMemory = virtualMemory.map((key, val) {
    //   if (key == address && val == null) {
    //     return MapEntry(key, p);
    //   } else {
    //     return MapEntry(key, val);
    //   }
    // });
  }

  static report() {

  }

  static void toHtml() {
    var virtualMemoryDiv = querySelector('#virtualMemory');
    virtualMemoryDiv.children = [];
    MMU.virtualMemory.forEach((k, v) {
      var memoryPageDiv = DivElement();
      if (v != null) {
        memoryPageDiv.style.background = '${v.color}';
        var pAddr = ParagraphElement();
        pAddr.text = k.toString();
        var pPid = ParagraphElement();
        pPid.text = v.shortPid;
        memoryPageDiv.children.addAll([pAddr, pPid]);
      } else {
        var pAddr = ParagraphElement();
        pAddr.text = k.toString();
        var pPid = ParagraphElement();
        pPid.text = 'LIVRE';
        memoryPageDiv.children.addAll([pAddr, pPid]);
      }
      virtualMemoryDiv.append(memoryPageDiv);
    });
  }

}