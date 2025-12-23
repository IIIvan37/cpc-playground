import { Outlet } from 'react-router-dom'
import { AppHeader } from '../app-header/app-header'
import styles from './root-layout.module.css'

/**
 * Root layout component that wraps all pages
 * Provides the common AppHeader across the application
 */
export function RootLayout() {
  return (
    <div className={styles.layout}>
      <AppHeader />
      <Outlet />
    </div>
  )
}
