import Head from 'next/head'
import { Interrupt } from '../classes/Interrupt'
import { MMU } from '../classes/MMU'
import { Process } from '../classes/Process'
import styles from '../styles/Home.module.css'

export default function Home() {
  MMU.init()
  const p1 = new Process(8000)
  const p2 = new Process(8000)
  const p3 = new Process(8000)
  const p4 = new Process(8000)
  p1.run()
  // try {
  //   mmu.addProcess(p1)
  //   mmu.addProcess(p2)
  //   mmu.addProcess(p3)
  //   mmu.addProcess(p4)
  //   mmu.addProcess(p1)
  //   mmu.addProcess(p1)
  //   mmu.addProcess(p1)
  //   mmu.addProcess(p1)
  //   mmu.addProcess(p1)
  // } catch (error) {
  //   console.log(error)
  // }


  console.log(MMU.virtualMemory)
  // console.log(mmu.processCount)

  return (
    <div className={styles.container}>
      <Head>
        <title>Memory Management Simulation</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
      </main>

      <footer className={styles.footer}>
        <a
          href="https://github.com/fell-lucas"
          target="_blank"
          rel="noopener noreferrer"
        >
          Made by Lucas Fell
        </a>
      </footer>
    </div>
  )
}
