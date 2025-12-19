import { CrtEffect } from '@/components/crt-effect'
import { MainLayout } from '@/components/layout/main-layout'
import { ThemeProvider } from '@/components/theme/theme-provider'

export default function App() {
  return (
    <ThemeProvider>
      <CrtEffect />
      <MainLayout />
    </ThemeProvider>
  )
}
