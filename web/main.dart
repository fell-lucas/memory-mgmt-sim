import 'dart:async';
import 'dart:html';
import 'dart:math' as math;
import 'src/classes/MMU.dart';
import 'src/classes/Process.dart';

var isSimulating = false;
void main() {
  MMU.init();
  MMU.toHtml();
  querySelector('#spawnProcess').onClick.listen(spawnProcess);
  querySelector('#simulate').onClick.listen(simulate);
}
  
void spawnProcess(MouseEvent e) {
  var spawnedProcessesDiv = querySelector('#spawnedProcesses');
  var processDiv = DivElement();
  var divBtns = DivElement();
  var processRunBtn = ButtonElement();
  var processReportBtn = ButtonElement();

  var inputVal;
  try {
    var v = int.parse((querySelector('#processSize') as InputElement).value);
    v <= 0 ? v = 1 : null; 
    inputVal = v;
  } catch (error) {
    inputVal = math.Random().nextInt(23999) + 1;
  }
  var process = Process(inputVal);

  processDiv.text = '${process.shortPid} (${process.sizeInMemory})';
  processDiv.style.background = process.color;
  processDiv.classes.add('individualProcess');

  processRunBtn.text = '>';
  processRunBtn.attributes.addAll({'type': 'run'});
  processRunBtn.onClick.listen((event) {
    process.run();
    MMU.report(process);
    MMU.toHtml();
  });

  processReportBtn.text = '#';
  processReportBtn.onClick.listen((event) {
    MMU.report(process);
  });

  divBtns.classes.add('individualProcessDivBtn');
  divBtns.children.addAll([processRunBtn, processReportBtn]);
  processDiv.children.add(divBtns);

  spawnedProcessesDiv.append(processDiv);
}


void simulate(MouseEvent event) {
  querySelector('#spawnProcess').click();
  var timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
    if(math.Random().nextInt(10) > 7) {
      querySelector('#spawnProcess').click();
    } else {
      var btns = querySelectorAll('button[type="run"]');
      btns[math.Random().nextInt(btns.length)].click();
    }
    if(timer.tick >= 200) {
      timer.cancel();
    }
  });
}
