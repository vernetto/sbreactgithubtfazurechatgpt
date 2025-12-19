import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// Build with relative paths so it works when served by Spring Boot under /
export default defineConfig({
  plugins: [react()],
  base: './'
})
