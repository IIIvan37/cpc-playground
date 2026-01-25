#!/usr/bin/env python3
"""
Import z80code.json projects into CPC Playground Supabase database.
Generates multiple migration files for batched import.

Filters:
- Only "public" group projects
- Excludes sjasmplus assembler projects
- Adds author to project description
"""

import json
import sys
import re
from datetime import datetime

# Configuration
INPUT_FILE = "z80code.json"
OUTPUT_DIR = "supabase/migrations"
OWNER_USER_ID = "bd6a166d-e0bf-4374-94c3-5222e517d75c"
BATCH_SIZE = 25  # Projects per migration file
BASE_TIMESTAMP = 20260125200000  # Starting timestamp for migrations


def slugify(name: str) -> str:
    """Convert name to URL-friendly slug."""
    slug = name.lower()
    slug = re.sub(r'[^a-z0-9\s-]', '', slug)
    slug = re.sub(r'[\s_]+', '-', slug)
    slug = re.sub(r'-+', '-', slug)
    return slug.strip('-')[:50]


def escape_sql(text: str) -> str:
    """Escape single quotes for SQL."""
    if text is None:
        return ""
    return text.replace("'", "''")


def timestamp_to_date(ts: float) -> str:
    """Convert millisecond timestamp to ISO date string."""
    if ts is None:
        return datetime.now().isoformat()
    try:
        return datetime.fromtimestamp(ts / 1000).isoformat()
    except:
        return datetime.now().isoformat()


def parse_projects(input_file: str) -> list:
    """Parse NDJSON file and filter projects."""
    projects = []
    
    with open(input_file, 'r', encoding='utf-8') as f:
        for i, line in enumerate(f):
            # Skip header line (mongoexport command)
            if i == 0 and 'mongoexport' in line:
                continue
            
            line = line.strip()
            if not line:
                continue
            
            try:
                obj = json.loads(line)
            except json.JSONDecodeError as e:
                print(f"Warning: Skipping invalid JSON on line {i+1}: {e}", file=sys.stderr)
                continue
            
            # Filter: only public group
            group = obj.get('group', '')
            if group != 'public':
                continue
            
            # Filter: exclude sjasmplus
            assembler = obj.get('buildOptions', {}).get('assembler', '')
            if assembler == 'sjasmplus':
                continue
            
            # Extract data
            project = {
                'original_id': obj.get('_id', ''),
                'name': obj.get('name', 'Untitled'),
                'code': obj.get('code', ''),
                'author': obj.get('author', 'Unknown'),
                'created_at': timestamp_to_date(obj.get('date')),
                'updated_at': timestamp_to_date(obj.get('timestamp') or obj.get('date')),
            }
            
            # Skip empty code
            if not project['code'].strip():
                continue
            
            projects.append(project)
    
    return projects


def generate_project_sql(project: dict, index: int, owner_id: str) -> list:
    """Generate SQL for a single project."""
    name = escape_sql(project['name'])
    author = escape_sql(project['author'])
    code = escape_sql(project['code'])
    created_at = project['created_at']
    updated_at = project['updated_at']
    
    # Description includes author
    description = f"Imported from z80code. Original author: {author}"
    description = escape_sql(description)
    
    lines = [
        f"-- Project {index+1}: {project['name']} by {project['author']}",
        "DO $$",
        "DECLARE",
        "  project_uuid uuid := gen_random_uuid();",
        "  tag_uuid uuid;",
        "BEGIN",
        f"  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)",
        f"  VALUES (",
        f"    project_uuid,",
        f"    '{owner_id}'::uuid,",
        f"    '{name}',",
        f"    '{description}',",
        f"    'public',",
        f"    false,",
        f"    false,",
        f"    '{created_at}'::timestamptz,",
        f"    '{updated_at}'::timestamptz",
        f"  );",
        f"",
        f"  INSERT INTO project_files (project_id, name, content, is_main, \"order\")",
        f"  VALUES (",
        f"    project_uuid,",
        f"    'main.asm',",
        f"    '{code}',",
        f"    true,",
        f"    0",
        f"  );",
        f"",
        f"  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';",
        f"  IF tag_uuid IS NOT NULL THEN",
        f"    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);",
        f"  END IF;",
        "END $$;",
        "",
    ]
    return lines


def generate_batch_migration(projects: list, batch_num: int, start_idx: int, owner_id: str) -> str:
    """Generate SQL migration for a batch of projects."""
    timestamp = BASE_TIMESTAMP + batch_num
    
    lines = [
        f"-- Migration: Import z80code projects batch {batch_num + 1}",
        f"-- Projects {start_idx + 1} to {start_idx + len(projects)}",
        f"-- Generated: {datetime.now().isoformat()}",
        "",
    ]
    
    # Only add tag creation in first batch
    if batch_num == 0:
        lines.extend([
            "-- Ensure the 'z80code' tag exists",
            "INSERT INTO tags (name) VALUES ('z80code') ON CONFLICT (name) DO NOTHING;",
            "",
        ])
    
    for i, project in enumerate(projects):
        lines.extend(generate_project_sql(project, start_idx + i, owner_id))
    
    return "\n".join(lines)


def main():
    print(f"Reading projects from {INPUT_FILE}...")
    projects = parse_projects(INPUT_FILE)
    print(f"Found {len(projects)} projects to import")
    
    # Calculate batches
    num_batches = (len(projects) + BATCH_SIZE - 1) // BATCH_SIZE
    print(f"Will create {num_batches} migration files with up to {BATCH_SIZE} projects each")
    
    # Generate migration files
    import os
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    for batch_num in range(num_batches):
        start_idx = batch_num * BATCH_SIZE
        end_idx = min(start_idx + BATCH_SIZE, len(projects))
        batch_projects = projects[start_idx:end_idx]
        
        timestamp = BASE_TIMESTAMP + batch_num
        filename = f"{timestamp}_import_z80code_batch_{batch_num + 1:02d}.sql"
        filepath = os.path.join(OUTPUT_DIR, filename)
        
        sql_content = generate_batch_migration(batch_projects, batch_num, start_idx, OWNER_USER_ID)
        
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(sql_content)
        
        print(f"Created {filename} ({len(batch_projects)} projects)")
    
    print(f"\nDone! Created {num_batches} migration files in {OUTPUT_DIR}")
    print("Run 'npx supabase db push' to apply migrations")


if __name__ == "__main__":
    main()
