import { PROC_MAX_ALLOCATED_PAGES, SYS_MAX_PAGES } from "../Global";
import { Interrupt } from "./Interrupt";
import { Process } from "./Process";
import { physicalMemory } from "./RAM";

export abstract class MMU {
  static virtualMemory: typeof physicalMemory
  processCount: [{ pid: string, count: number }]

  static init() {
    for (let i = 0; i < SYS_MAX_PAGES; i++) {
      if (!MMU.virtualMemory) {
        MMU.virtualMemory = [{ address: i, process: undefined }]
      } else {
        MMU.virtualMemory.push({ address: i, process: undefined })
      }
    }
  }

  static getAvailableAddresses() {
    return MMU.virtualMemory.map((e) => {
      if (!e.process) {
        return e.address
      }
    })
  }

  static addProcessToAddress(p: Process, address: number) {
    MMU.virtualMemory.forEach((e) => {
      if (e.address === address && e.process === undefined) {
        e.process = p
      }
    })
  }

  static report() {

  }
  // addProcess(p: Process) {
  //   if (!this.processCount) {
  //     this.virtualMemory.push(p)
  //     this.processCount = [{ pid: p.pid, count: 1 }]
  //   }
  //   if (!this.processCount.find((e) => e.pid === p.pid)) {
  //     this.virtualMemory.push(p)
  //     this.processCount.push({ pid: p.pid, count: 1 })
  //   } else {
  //     this.processCount.forEach((e) => {
  //       if (e.pid === p.pid) {
  //         if (e.count < PROC_MAX_ALLOCATED_PAGES) {
  //           this.virtualMemory.push(p)
  //           e.count++
  //         } else {
  //           throw new Interrupt('Couldn\'t allocate virtual page for process.',
  //             'This process already has the maximum number of allowed allocated pages in the virtual memory.',
  //             p)
  //         }
  //       }
  //     })
  //   }
  // }

}