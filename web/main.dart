import 'dart:html';
import 'src/classes/MMU.dart';
import 'src/classes/Process.dart';
void main() {
  try {
    MMU.init();
    try {
      for (var i = 0; i < 5; i++) {
        var p = Process(8000);
        p.run();
      }
    } catch (error) {
      querySelector('.main').text = error.toString();
      
    }
    MMU.toHtml();
    
  } catch (e) {
    querySelector('.main').text = e.toString();
  }
}
