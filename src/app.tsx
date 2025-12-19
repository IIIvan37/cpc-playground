import { MainLayout } from '@/components/layout/main-layout'
import { ThemeProvider } from '@/components/theme/theme-provider'

export default function App() {
  return (
    <ThemeProvider>
      <MainLayout />
    </ThemeProvider>
  )
}
