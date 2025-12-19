# CPC Playground

A web-based Amstrad CPC development environment with integrated assembler and emulator.

🚀 **Live demo**: [cpc-playground.iiivan.org](https://cpc-playground.iiivan.org)

## Features

- **Code Editor** - Write Z80 assembly code with line numbers and error highlighting
- **RASM Assembler** - Compile your code to SNA snapshots using [RASM](http://rasm.music.world) (WebAssembly)
- **CPCEC Emulator** - Run your programs instantly in the [CPCEC](http://cngsoft.no-ip.org/cpcec.htm) emulator (WebAssembly)
- **CPC Plus Support** - Full support for CPC Plus hardware features (sprites, enhanced palette, DMA...)
- **Examples** - Load ready-to-run examples including classic CPC and Plus demos
- **Console Output** - View assembler output, errors with clickable line references

## Quick Start

1. Write your Z80 assembly code in the editor
2. Click **Run** (or press the shortcut) to compile and execute
3. The emulator shows your program running
4. Click on the emulator canvas to capture keyboard input

## Examples

The playground includes several examples:
- **Hello World** - Basic text output
- **Serval Classic Raster Overscan** - Raster effects on classic CPC
- **Serval Plus Raster Overscan** - Raster effects using CPC Plus hardware

## Tech Stack

- React + TypeScript + Vite
- [RASM](http://rasm.music.world) - Z80 cross-assembler (compiled to WebAssembly)
- [CPCEC](http://cngsoft.no-ip.org/cpcec.htm) - Amstrad CPC emulator (compiled to WebAssembly)
- Jotai for state management
- Deployed on Netlify

## Development

```bash
# Install dependencies
pnpm install

# Start dev server
pnpm dev

# Build for production
pnpm build
```

## Credits

- **RASM** by Roudoudou - [rasm.music.world](http://rasm.music.world)
- **CPCEC** by CNGsoft - [cngsoft.no-ip.org](http://cngsoft.no-ip.org/cpcec.htm)

## License

This project is licensed under the **GNU General Public License v3.0** (GPL-3.0), as it incorporates CPCEC which is distributed under GPL-3.0.

See [LICENSE](LICENSE) for details.
