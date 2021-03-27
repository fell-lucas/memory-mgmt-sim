import 'dart:html';

import '../Globals.dart';
import 'Interrupt.dart';
import 'Process.dart';

class MMU {
  static var virtualMemory = <int, Process>{}; // address, process
  static var runningProcessCount = <String, int>{}; // pid, count
  static int usedPages = 0;

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
      runningProcessCount.update(p.pid, (value) => 1, ifAbsent: () => 1);
    }
    if(runningProcessCount[p.pid] <= p.calculatedPagesToAlloc) {
      if(runningProcessCount[p.pid] <= PROC_MAX_ALLOCATED_PAGES) {
        virtualMemory.update(address, (value) => p);
        runningProcessCount.update(p.pid, (value) => ++value);
        ++MMU.usedPages;
      } else {
        throw Interrupt('''Page fault: This process tried to allocate more than the 
        global limit of allowed pages for each process ($PROC_MAX_ALLOCATED_PAGES).''', p);
      }
    } else {
      throw Interrupt('''Page fault: This process is already using the maximum 
      number of allowed pages for it (${p.calculatedPagesToAlloc}).''', p);
    }
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
        pPid.text = 'FREE';
        memoryPageDiv.children.addAll([pAddr, pPid]);
      }
      virtualMemoryDiv.append(memoryPageDiv);
    });
  }

  static void report(Process process) {
    var reportProcess = querySelector('#reportProcess');
    var reportProcessP = ParagraphElement();
    var reportSection = querySelector('#report');

    var isInMemory = ParagraphElement();
    var hasPages = ParagraphElement();
    var remainingSpace = ParagraphElement();
    var triedToAllocate = ParagraphElement();

    reportProcess.children = [];
    reportSection.children = [];

    reportProcessP.innerHtml = '<b>${process.shortPid}</b>';
    reportProcessP.style.background = process.color;
    reportProcess.children.addAll([reportProcessP]);

    if(MMU.virtualMemory.containsValue(process)) {
      isInMemory.innerHtml = '<b>Is</b> in memory.';
      isInMemory.style.color = 'rgb(0, 100, 0)';

    } else {
      isInMemory.innerHtml = 'Is <b>not</b> in memory.';
      isInMemory.style.color = 'rgb(100, 0, 0)';
    }
    hasPages.innerHtml = 'Has <b>${process.allocatedPages}/${process.calculatedPagesToAlloc}</b> allocated pages.';
    hasPages.style.color = 'rgb(0, 0, 100)';

    if (process.triedToAllocate != -1) {
      triedToAllocate.innerHtml = 'Tried to allocate <b>${process.triedToAllocate}</b> pages';
      triedToAllocate.style.color = 'rgb(0, 0, 100)';
    } else {
      triedToAllocate.innerHtml = 'Didn\'t try to allocate yet.';
      triedToAllocate.style.color = 'rgb(0, 0, 100)';
    }

    remainingSpace.innerHtml = '''<b>${MMU.usedPages}/$SYS_MAX_PAGES</b> used pages. 
    <b>${SYS_MAX_PAGES - MMU.usedPages}</b> free.''';
    if(MMU.usedPages < SYS_MAX_PAGES) {
      remainingSpace.style.color = 'rgb(0, 100, 0)';
    } else {
      remainingSpace.style.color = 'rgb(100, 0, 0)';
      triedToAllocate.innerHtml = 'No free space; can\'t allocate.';
      triedToAllocate.style.color = 'rgb(100, 0, 0)';
    }

    reportSection.style.background = 'rgba(102, 97, 97, 0.219)';
    reportSection.children.addAll([isInMemory, hasPages, triedToAllocate, remainingSpace]);
  }

}