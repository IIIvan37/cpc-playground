import { Route, Routes } from 'react-router-dom'
import { CrtEffect } from '@/components/crt-effect'
import { MainLayout } from '@/components/layout'
import { ThemeProvider } from '@/components/theme/theme-provider'
import { ResetPasswordPage } from '@/pages/reset-password'

export default function App() {
  return (
    <ThemeProvider>
      <CrtEffect />
      <Routes>
        <Route path='/' element={<MainLayout />} />
        <Route path='/reset-password' element={<ResetPasswordPage />} />
      </Routes>
    </ThemeProvider>
  )
}
