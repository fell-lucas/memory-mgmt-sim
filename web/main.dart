import 'dart:html';
import 'dart:math' as math;
import 'src/classes/MMU.dart';
import 'src/classes/Process.dart';
void main() {
  MMU.init();
  MMU.toHtml();
  var processes = <Process>[];
  void spawnProcess(MouseEvent e) {
    var spawnedProcessesDiv = querySelector('#spawnedProcesses');
    var processDiv = DivElement();
    var processRunBtn = ButtonElement();
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
    processRunBtn.onClick.listen((event) {
      process.run();
      MMU.toHtml();
    });
    processDiv.children.add(processRunBtn);

    spawnedProcessesDiv.append(processDiv);
    processes.add(process);
  }

  querySelector('#spawnProcess').onClick.listen(spawnProcess);

  try {
    // for (var i = 0; i < 50; i++) {
    //   var p = Process(8000);
    //   p.run();
    // }
    
  } catch (error) {
    querySelector('.main').text = error.message;
  }

}
