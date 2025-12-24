# CPC Playground

A web-based Amstrad CPC development environment with integrated assembler and emulator.

**Live demo**: [cpc-playground.iiivan.org](https://cpc-playground.iiivan.org)

## Features

- Code editor with Z80 syntax highlighting and error markers
- [RASM](https://github.com/EdouardBERGE/rasm) assembler (WebAssembly)
- [CPCEC](https://github.com/cpcitor/cpcec) emulator (WebAssembly)
- CPC Plus hardware support (sprites, enhanced palette, DMA)
- Multi-file projects with includes and dependencies
- Cloud storage with Supabase authentication
- Reusable code libraries
- Project sharing (public, private, or with specific users)

## Quick Start

```bash
pnpm install
supabase start
pnpm dev
```

## Tech Stack

- React, TypeScript, Vite
- Jotai (state management)
- Supabase (PostgreSQL + Auth)
- Netlify (hosting)

## Credits

- **RASM** by Roudoudou - [GitHub](https://github.com/EdouardBERGE/rasm)
- **CPCEC** by CNGsoft - [GitHub](https://github.com/cpcitor/cpcec)

## License

GPL-3.0 - See [LICENSE](LICENSE)
