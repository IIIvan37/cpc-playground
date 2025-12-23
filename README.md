# CPC Playground

A web-based Amstrad CPC development environment with integrated assembler and emulator.

🚀 **Live demo**: [cpc-playground.iiivan.org](https://cpc-playground.iiivan.org)

## Features

- **Code Editor** - Write Z80 assembly code with syntax highlighting and error markers
- **RASM Assembler** - Compile your code using [RASM](http://rasm.music.world) (WebAssembly)
- **CPCEC Emulator** - Run programs instantly in [CPCEC](http://cngsoft.no-ip.org/cpcec.htm) (WebAssembly)
- **CPC Plus Support** - Full support for Plus hardware (sprites, enhanced palette, DMA)
- **Multi-file Projects** - Organize code with includes and dependencies
- **Cloud Storage** - Save projects with Supabase authentication
- **Project Libraries** - Create reusable code libraries
- **Sharing** - Public, private, or shared with specific users

## Quick Start

```bash
# Install dependencies
pnpm install

# Start local Supabase
supabase start

# Start dev server
pnpm dev
```

## Documentation

| Document | Description |
|----------|-------------|
| [Architecture](docs/architecture.md) | Clean Architecture, domain model, patterns |
| [Setup Guide](docs/setup.md) | Installation, Supabase, environments |
| [Features](docs/features.md) | Projects, sharing, tags, dependencies, includes |
| [Development](docs/development.md) | CLI commands, migrations, testing |

## Tech Stack

- **Frontend**: React + TypeScript + Vite
- **State**: Jotai
- **Backend**: Supabase (PostgreSQL + Auth)
- **Assembler**: [RASM](http://rasm.music.world) (WebAssembly)
- **Emulator**: [CPCEC](http://cngsoft.no-ip.org/cpcec.htm) (WebAssembly)
- **Hosting**: Netlify

## Credits

- **RASM** by Roudoudou - [Rasm]https://github.com/EdouardBERGE/rasm)
- **CPCEC** by CNGsoft - [CPCEC](https://github.com/cpcitor/cpcec)

## License

GNU General Public License v3.0 (GPL-3.0) - See [LICENSE](LICENSE)
