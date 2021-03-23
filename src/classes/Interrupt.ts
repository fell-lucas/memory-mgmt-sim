import { Process } from "./Process";

export class Interrupt implements Error {
  name: string;
  message: string;
  process: Process;
  stack?: string;

  constructor(name: string, msg: string, p: Process) {
    this.name = name
    this.message = msg
    this.process = p
  }
}