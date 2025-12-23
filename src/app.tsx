import { Route, Routes } from 'react-router-dom'
import { CrtEffect } from '@/components/crt-effect'
import { MainLayout, RootLayout } from '@/components/layout'
import { ThemeProvider } from '@/components/theme/theme-provider'
import { ExplorePage } from '@/pages/explore'
import { ResetPasswordPage } from '@/pages/reset-password'

export default function App() {
  return (
    <ThemeProvider>
      <CrtEffect />
      <Routes>
        <Route element={<RootLayout />}>
          <Route path='/' element={<MainLayout />} />
          <Route path='/explore' element={<ExplorePage />} />
          <Route path='/reset-password' element={<ResetPasswordPage />} />
        </Route>
      </Routes>
    </ThemeProvider>
  )
}
