#!/usr/bin/env python3
"""
Import z80code.json projects into CPC Playground Supabase database.
Generates multiple small migration files for batched import.

Features:
- Only "public" group projects
- Excludes sjasmplus assembler projects
- Uses original description (desc) + author
- Creates tags based on category (cat)
- Generates small batches (10 projects) for reliable migration
"""

import json
import sys
import re
import os
from datetime import datetime

# Configuration
INPUT_FILE = "z80code.json"
OUTPUT_DIR = "supabase/migrations"
OWNER_USER_ID = "bd6a166d-e0bf-4374-94c3-5222e517d75c"
BATCH_SIZE = 2  # Very small batches for reliability
BASE_TIMESTAMP = 20260125200000


def escape_sql(text: str) -> str:
    """Escape single quotes for SQL."""
    if text is None:
        return ""
    return text.replace("'", "''")


def normalize_tag(cat: str) -> str:
    """Normalize category to a valid tag name."""
    if not cat:
        return None
    # Lowercase and replace spaces/special chars
    tag = cat.lower().strip()
    tag = re.sub(r'[^a-z0-9\s-]', '', tag)
    tag = re.sub(r'[\s]+', '-', tag)
    tag = re.sub(r'-+', '-', tag)
    tag = tag.strip('-')
    if len(tag) < 2 or len(tag) > 30:
        return None
    return tag


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
            if obj.get('group', '') != 'public':
                continue
            
            # Filter: exclude sjasmplus
            assembler = obj.get('buildOptions', {}).get('assembler', '')
            if assembler == 'sjasmplus':
                continue
            
            # Extract data (use slugname for safe project names)
            project = {
                'original_id': obj.get('_id', ''),
                'name': obj.get('slugname', '') or obj.get('name', 'Untitled'),
                'code': obj.get('code', ''),
                'author': obj.get('author', 'Unknown'),
                'desc': obj.get('desc', ''),  # Original description
                'cat': obj.get('cat', ''),    # Category -> tag
                'created_at': timestamp_to_date(obj.get('date')),
                'updated_at': timestamp_to_date(obj.get('timestamp') or obj.get('date')),
            }
            
            # Skip empty code
            if not project['code'].strip():
                continue
            
            projects.append(project)
    
    return projects


def collect_unique_tags(projects: list) -> set:
    """Collect all unique normalized tags from projects."""
    tags = set()
    tags.add('z80code')  # Always include z80code tag
    
    for project in projects:
        tag = normalize_tag(project.get('cat', ''))
        if tag:
            tags.add(tag)
    
    return tags


def generate_project_sql(project: dict, index: int, owner_id: str) -> list:
    """Generate SQL for a single project."""
    name = escape_sql(project['name'])
    author = escape_sql(project['author'])
    code = escape_sql(project['code'])
    original_desc = project.get('desc', '')
    cat = project.get('cat', '')
    cat_tag = normalize_tag(cat)
    created_at = project['created_at']
    updated_at = project['updated_at']
    
    # Build description: "Imported from z80Code. Author: X. Original description"
    desc_parts = [f"Imported from z80Code. Author: {author}."]
    if original_desc:
        desc_parts.append(original_desc)
    description = escape_sql(" ".join(desc_parts))
    
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
        f"  -- Add z80code tag",
        f"  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';",
        f"  IF tag_uuid IS NOT NULL THEN",
        f"    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);",
        f"  END IF;",
    ]
    
    # Add category tag if valid and different from z80code
    if cat_tag and cat_tag != 'z80code':
        lines.extend([
            f"",
            f"  -- Add category tag: {cat_tag}",
            f"  SELECT id INTO tag_uuid FROM tags WHERE name = '{cat_tag}';",
            f"  IF tag_uuid IS NOT NULL THEN",
            f"    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);",
            f"  END IF;",
        ])
    
    lines.extend([
        "END $$;",
        "",
    ])
    
    return lines


def generate_tags_migration(tags: set) -> str:
    """Generate migration for creating all tags."""
    lines = [
        "-- Migration: Create tags for z80code import",
        f"-- Generated: {datetime.now().isoformat()}",
        f"-- Total tags: {len(tags)}",
        "",
    ]
    
    for tag in sorted(tags):
        lines.append(f"INSERT INTO tags (name) VALUES ('{tag}') ON CONFLICT (name) DO NOTHING;")
    
    return "\n".join(lines)


def generate_batch_migration(projects: list, batch_num: int, start_idx: int, owner_id: str) -> str:
    """Generate SQL migration for a batch of projects."""
    lines = [
        f"-- Migration: Import z80code projects batch {batch_num + 1}",
        f"-- Projects {start_idx + 1} to {start_idx + len(projects)}",
        f"-- Generated: {datetime.now().isoformat()}",
        "",
    ]
    
    for i, project in enumerate(projects):
        lines.extend(generate_project_sql(project, start_idx + i, owner_id))
    
    return "\n".join(lines)


def main():
    print(f"Reading projects from {INPUT_FILE}...")
    projects = parse_projects(INPUT_FILE)
    print(f"Found {len(projects)} projects to import")
    
    # Collect unique tags
    tags = collect_unique_tags(projects)
    print(f"Found {len(tags)} unique tags")
    
    # Calculate batches
    num_batches = (len(projects) + BATCH_SIZE - 1) // BATCH_SIZE
    print(f"Will create {num_batches + 1} migration files (1 for tags + {num_batches} for projects)")
    
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    # Generate tags migration (first)
    tags_filename = f"{BASE_TIMESTAMP}_import_z80code_00_tags.sql"
    tags_filepath = os.path.join(OUTPUT_DIR, tags_filename)
    tags_content = generate_tags_migration(tags)
    with open(tags_filepath, 'w', encoding='utf-8') as f:
        f.write(tags_content)
    print(f"Created {tags_filename} ({len(tags)} tags)")
    
    # Generate project migrations
    for batch_num in range(num_batches):
        start_idx = batch_num * BATCH_SIZE
        end_idx = min(start_idx + BATCH_SIZE, len(projects))
        batch_projects = projects[start_idx:end_idx]
        
        timestamp = BASE_TIMESTAMP + batch_num + 1
        filename = f"{timestamp}_import_z80code_{batch_num + 1:02d}.sql"
        filepath = os.path.join(OUTPUT_DIR, filename)
        
        sql_content = generate_batch_migration(batch_projects, batch_num, start_idx, OWNER_USER_ID)
        
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(sql_content)
        
        print(f"Created {filename} ({len(batch_projects)} projects)")
    
    print(f"\nDone! Created {num_batches + 1} migration files in {OUTPUT_DIR}")
    print("Run 'npx supabase db push' to apply migrations")


if __name__ == "__main__":
    main()
