
import 'Process.dart';

class Interrupt implements Exception {
  String message;
  Process p;

  Interrupt(this.message, this.p);
}