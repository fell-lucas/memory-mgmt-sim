import 'dart:html';
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
    var process = Process(8000);

    processDiv.text = process.shortPid;
    processDiv.style.background = process.color;
    processDiv.classes.add('individualProcess');

    processRunBtn.text = '>';
    processRunBtn.attributes.addAll({'id': process.pid});
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
