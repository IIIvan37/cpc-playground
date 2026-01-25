-- Cleanup script for z80code imports
-- Run this in Supabase SQL Editor before re-running migrations

-- 1. Delete project_tags associations for z80code projects
DELETE FROM public.project_tags
WHERE project_id IN (
  SELECT id FROM public.projects 
  WHERE description LIKE 'Imported from z80Code.%'
);

-- 2. Delete z80code projects
DELETE FROM public.projects
WHERE description LIKE 'Imported from z80Code.%';

-- 4. Delete z80code-related tags (keep 'z80code' tag if you want)
-- This deletes tags that were created specifically for z80code import
DELETE FROM public.tags
WHERE name IN (
  'z80code', 'demo', 'game', 'sound', 'graphics', 'test', 'tool', 
  'tutorial', 'music', 'intro', 'effect', 'utility', 'lib', 'library',
  'sprite', 'scroll', 'plasma', 'raster', 'overscan', 'hardware',
  'interrupt', 'mode-0', 'mode-1', 'mode-2', 'compression', 'player',
  'loader', 'font', 'print', 'math', 'random', 'input', 'joystick',
  'keyboard', 'crtc', 'gate-array', 'psg', 'ay', 'fdc', 'disk',
  'tape', 'memory', 'bank', 'plus', 'asic', 'dma', 'split',
  'rupture', 'border', 'multicolor', 'mixing', 'tracker', 'converter',
  'editor', 'assembler', 'disassembler', 'debugger', 'emulator',
  'wip', 'finished', 'source', 'binary', 'example', 'template',
  'framework', 'engine', 'system', 'core', 'driver', 'routine',
  'algorithm', 'optimization', 'fast', 'small', 'compatible',
  'amstrad', 'cpc', '464', '6128', 'gx4000', 'z80'
);

-- 5. Remove migration records for z80code imports
DELETE FROM supabase_migrations.schema_migrations
WHERE version LIKE '20260125200%';

-- Verify cleanup
SELECT 'Projects remaining with z80Code description:' as check, 
       COUNT(*) as count 
FROM public.projects 
WHERE description LIKE 'Imported from z80Code.%';

SELECT 'Migration records for 20260125200%:' as check,
       COUNT(*) as count
FROM supabase_migrations.schema_migrations
WHERE version LIKE '20260125200%';
