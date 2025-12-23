import React from 'react'
import ReactDOM from 'react-dom/client'
import { BrowserRouter } from 'react-router-dom'
import App from '@/app'
import '@/styles/global.css'

// Capture share ID early before Supabase cleans URL params (detectSessionInUrl)
const shareId = new URLSearchParams(globalThis.location.search).get('share')
if (shareId) {
  sessionStorage.setItem('pendingShareId', shareId)
}

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </React.StrictMode>
)
