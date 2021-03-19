import Head from 'next/head'
import styles from '../styles/Home.module.css'

export default function Home() {
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
