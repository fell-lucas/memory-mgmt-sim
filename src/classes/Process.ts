import { PROC_MAX_ALLOCATED_PAGES, SYS_PAGE_SIZE } from "../Global"
import { v4 as uuidv4 } from 'uuid'
import { MMU } from "./MMU"

export class Process {
  pid: string
  sizeInMemory: number

  constructor(sizeInMemory: number) {
    this.sizeInMemory = sizeInMemory
    // this.virtualPages = Math.floor((SYS_PAGE_SIZE + sizeInMemory) / SYS_PAGE_SIZE)
    this.pid = uuidv4()
  }

  run() {
    const memoryAddresses = guessMemoryAddress()
    for (let i = 0; i < memoryAddresses.length; i++) {
      MMU.addProcessToAddress(this, memoryAddresses[i])
    }
  }
}

function guessMemoryAddress() {
  let availableAddresses = MMU.getAvailableAddresses()
  const howManyPages = Math.floor(Math.random()
    * (availableAddresses.length > PROC_MAX_ALLOCATED_PAGES
      ? PROC_MAX_ALLOCATED_PAGES
      : availableAddresses.length)) + 1
  let chosenAddresses: number[] = []
  for (let i = 0; i < howManyPages; i++) {
    const idx = Math.floor(Math.random() * availableAddresses.length)
    console.log(availableAddresses[idx])
    chosenAddresses.push(availableAddresses[idx])
    availableAddresses.splice(idx, 1)
  }
  return chosenAddresses
}
