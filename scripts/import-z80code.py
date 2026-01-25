#!/usr/bin/env python3
"""
Import z80code.json projects into CPC Playground Supabase database.

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
OUTPUT_FILE = "supabase/snippets/import-z80code-projects.sql"
OWNER_USER_ID = "bd6a166d-e0bf-4374-94c3-5222e517d75c"


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


def generate_sql(projects: list, output_file: str, owner_id: str):
    """Generate SQL insert statements."""
    
    sql_lines = [
        "-- Auto-generated import script for z80code.json projects",
        f"-- Generated: {datetime.now().isoformat()}",
        f"-- Total projects to import: {len(projects)}",
        "",
        "-- Run this script in Supabase SQL Editor",
        "",
        "-- First, ensure the 'z80code' tag exists",
        "INSERT INTO tags (name) VALUES ('z80code') ON CONFLICT (name) DO NOTHING;",
        "",
    ]
    
    for i, project in enumerate(projects):
        name = escape_sql(project['name'])
        author = escape_sql(project['author'])
        code = escape_sql(project['code'])
        created_at = project['created_at']
        updated_at = project['updated_at']
        
        # Description includes author
        description = f"Imported from z80code. Original author: {author}"
        description = escape_sql(description)
        
        sql_lines.append(f"-- Project {i+1}: {project['name']} by {project['author']}")
        sql_lines.append("DO $$")
        sql_lines.append("DECLARE")
        sql_lines.append("  project_uuid uuid := gen_random_uuid();")
        sql_lines.append("  tag_uuid uuid;")
        sql_lines.append("BEGIN")
        sql_lines.append(f"  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)")
        sql_lines.append(f"  VALUES (")
        sql_lines.append(f"    project_uuid,")
        sql_lines.append(f"    '{owner_id}'::uuid,")
        sql_lines.append(f"    '{name}',")
        sql_lines.append(f"    '{description}',")
        sql_lines.append(f"    'public',")
        sql_lines.append(f"    false,")
        sql_lines.append(f"    false,")
        sql_lines.append(f"    '{created_at}'::timestamptz,")
        sql_lines.append(f"    '{updated_at}'::timestamptz")
        sql_lines.append(f"  );")
        sql_lines.append(f"")
        sql_lines.append(f"  INSERT INTO project_files (project_id, name, content, is_main, \"order\")")
        sql_lines.append(f"  VALUES (")
        sql_lines.append(f"    project_uuid,")
        sql_lines.append(f"    'main.asm',")
        sql_lines.append(f"    '{code}',")
        sql_lines.append(f"    true,")
        sql_lines.append(f"    0")
        sql_lines.append(f"  );")
        sql_lines.append(f"")
        sql_lines.append(f"  -- Add z80code tag")
        sql_lines.append(f"  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';")
        sql_lines.append(f"  INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);")
        sql_lines.append("END $$;")
        sql_lines.append("")
    
    sql_lines.append(f"-- Import complete: {len(projects)} projects")
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(sql_lines))
    
    print(f"Generated SQL file: {output_file}")
    print(f"Total projects: {len(projects)}")


def main():
    print(f"Reading {INPUT_FILE}...")
    projects = parse_projects(INPUT_FILE)
    
    print(f"Found {len(projects)} projects matching criteria:")
    print(f"  - group = 'public'")
    print(f"  - assembler != 'sjasmplus'")
    print(f"  - non-empty code")
    print()
    
    if not projects:
        print("No projects to import!")
        return
    
    # Show sample
    print("Sample projects:")
    for p in projects[:5]:
        print(f"  - {p['name']} by {p['author']}")
    if len(projects) > 5:
        print(f"  ... and {len(projects) - 5} more")
    print()
    
    generate_sql(projects, OUTPUT_FILE, OWNER_USER_ID)


if __name__ == "__main__":
    main()
