
import 'dart:html';

import 'Process.dart';

class Interrupt implements Exception {
  String message;
  Process p;

  Interrupt(this.message, this.p);

  static void toHtml(Interrupt interrupt) {
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