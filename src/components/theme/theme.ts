export const theme = {
  colors: {
    dark: '#000000',
    light: '#00FFFF',
    background: '#0a0a0a',
    foreground: '#A8B5A8',
    accent: '#6B9E6B',
    accentHover: '#5A8A5A',
    accentActive: '#4A7A4A',
    border: '#2a3a2a',
    error: '#f87171',
    errorBg: 'rgba(239, 68, 68, 0.15)',
    errorBorder: 'rgba(239, 68, 68, 0.4)',
    success: '#4ade80',
    successBg: 'rgba(34, 197, 94, 0.15)',
    successBorder: 'rgba(34, 197, 94, 0.4)',
    hover: {
      primary: '#5A8A5A',
      secondary: 'rgba(107, 158, 107, 0.08)'
    },
    pressed: {
      primary: '#3A4A3A',
      secondary: '#2A3A2A'
    },
    focus: {
      ring: '#6B9E6B',
      glow: '#7AAE7A'
    },
    disabled: {
      thumb: '#3A4A3A',
      border: '#4A5A4A',
      range: '#3A4A3A',
      track: '#2A3A2A',
      text: '#5A6A5A'
    }
  },
  font: {
    family: 'JetBrains Mono, Fira Code, Inconsolata, monospace',
    size: {
      xs: 'clamp(0.7rem, 0.8vw, 0.8rem)',
      sm: 'clamp(0.8rem, 1vw, 0.9rem)',
      md: 'clamp(0.9rem, 1.2vw, 1rem)',
      lg: 'clamp(1rem, 1.5vw, 1.13rem)',
      xl: 'clamp(1.13rem, 2vw, 1.25rem)',
      heading: 'clamp(1.25rem, 3vw, 1.5rem)'
    }
  },
  spacing: {
    xs: '0.5rem',
    sm: '0.75rem',
    md: '1rem',
    lg: '1.5rem',
    xl: '2rem'
  },
  radius: {
    none: '0rem',
    sm: '0.25rem',
    md: '0.5rem'
  },
  shadow: {
    glow: '0 0 0.5rem rgba(107, 158, 107, 0.3)',
    inner: 'inset 0 0 0.25rem rgba(107, 158, 107, 0.2)'
  }
}
