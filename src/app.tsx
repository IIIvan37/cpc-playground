import { Route, Routes } from 'react-router-dom'
import { CrtEffect } from '@/components/crt-effect'
import { MainLayout, RootLayout } from '@/components/layout'
import { ThemeProvider } from '@/components/theme/theme-provider'
import { ErrorBoundary } from '@/components/ui/error-boundary'
import { ToastContainer } from '@/components/ui/toast'
import { ExplorePage } from '@/pages/explore'
import { ResetPasswordPage } from '@/pages/reset-password'

export default function App() {
  return (
    <ErrorBoundary fullPage>
      <ThemeProvider>
        <CrtEffect />
        <Routes>
          <Route element={<RootLayout />}>
            <Route path='/' element={<MainLayout />} />
            <Route path='/explore' element={<ExplorePage />} />
            <Route path='/reset-password' element={<ResetPasswordPage />} />
          </Route>
        </Routes>
        <ToastContainer />
      </ThemeProvider>
    </ErrorBoundary>
  )
}
