import React, { useState } from 'react'
import { createRoot } from 'react-dom/client'

function App() {
  const [msg, setMsg] = useState('')

  const callHello = async () => {
    setMsg('Calling /api/hello ...')
    try {
      const res = await fetch('/api/hello')
      const text = await res.text()
      setMsg(text)
    } catch (e) {
      setMsg('Error calling backend: ' + (e?.message ?? String(e)))
    }
  }

  return (
    <div style={{ fontFamily: 'system-ui, Arial', padding: 24, maxWidth: 720 }}>
      <h1>Hello React + Spring Boot</h1>
      <button onClick={callHello} style={{ padding: '10px 14px', fontSize: 16, cursor: 'pointer' }}>
        Call /api/hello
      </button>
      <p style={{ marginTop: 16, whiteSpace: 'pre-wrap' }}>{msg}</p>
    </div>
  )
}

createRoot(document.getElementById('root')).render(<App />)
