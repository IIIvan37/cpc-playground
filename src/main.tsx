// IMPORTANT: This must be the FIRST import to patch addEventListener
// before CPCEC can register its keyboard listeners
import '@/lib/cpcec-keyboard-patch'

import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import React from 'react'
import ReactDOM from 'react-dom/client'
import { BrowserRouter } from 'react-router-dom'
import App from '@/app'
import '@/styles/global.css'

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 5, // 5 minutes
      gcTime: 1000 * 60 * 30, // 30 minutes
      retry: 1,
      refetchOnWindowFocus: false
    }
  }
})

// Capture share ID early before Supabase cleans URL params (detectSessionInUrl)
const shareId = new URLSearchParams(globalThis.location.search).get('share')
if (shareId) {
  sessionStorage.setItem('pendingShareId', shareId)
}

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <QueryClientProvider client={queryClient}>
      <BrowserRouter>
        <App />
      </BrowserRouter>
    </QueryClientProvider>
  </React.StrictMode>
)
