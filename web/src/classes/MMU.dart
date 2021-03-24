import 'dart:html';

import '../Globals.dart';
import 'Process.dart';

class MMU {
  static var virtualMemory = <int, Process>{};

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

  static addProcessToAddress(Process p, int address) {
    // if (MMU.getAvailableAddresses().length === 0) {
    virtualMemory = virtualMemory.map((key, val) {
      if (key == address && val == null) {
        return MapEntry(key, p);
      } else {
        return MapEntry(key, val);
      }
    });
    // } else {
    //   throw new Interrupt('Page fault', 'There are no available pages in virtual memory.', p)
    // }
  }

  static report() {

  }

  static void toHtml() {
    var virtualMemoryDiv = querySelector('#virtualMemory');
    MMU.virtualMemory.forEach((k, v) {
      var memoryPageDiv = DivElement();
      if (v != null) {
        memoryPageDiv.style.background = '${v.color}';
        var pAddr = ParagraphElement();
        pAddr.text = k.toString();
        var pPid = ParagraphElement();
        pPid.text = v.pid.substring(1, 8);
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