export class CPU {
  private registerBase: number
  private registerLimit: number

  constructor(rb: number, rl: number) {
    this.registerBase = rb
    this.registerLimit = rl
  }
}