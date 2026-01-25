#!/usr/bin/env python3
"""Analyze z80code.json to find available fields."""

import json

# Analyser les champs disponibles
fields = {}
with open('z80code.json', 'r') as f:
    for i, line in enumerate(f):
        if 'mongoexport' in line:
            continue
        try:
            obj = json.loads(line.strip())
            for k in obj.keys():
                if k not in fields:
                    fields[k] = 0
                fields[k] += 1
        except:
            pass

print('Champs disponibles dans z80code.json:')
for k, v in sorted(fields.items(), key=lambda x: -x[1]):
    print(f'  {k}: {v} projets')

# Compter les projets public avec desc/cat
with_desc = 0
with_cat = 0
public_count = 0
with open('z80code.json', 'r') as f:
    for line in f:
        if 'mongoexport' in line:
            continue
        try:
            obj = json.loads(line.strip())
            if obj.get('group') == 'public':
                public_count += 1
                if obj.get('desc'):
                    with_desc += 1
                if obj.get('cat'):
                    with_cat += 1
        except:
            pass

print(f'\nProjets publics: {public_count}')
print(f'  - avec description (desc): {with_desc}')
print(f'  - avec categorie (cat): {with_cat}')

# Exemples de catégories
cats = {}
with open('z80code.json', 'r') as f:
    for line in f:
        if 'mongoexport' in line:
            continue
        try:
            obj = json.loads(line.strip())
            if obj.get('group') == 'public' and obj.get('cat'):
                cat = obj.get('cat')
                if cat not in cats:
                    cats[cat] = 0
                cats[cat] += 1
        except:
            pass

print(f'\nCategories trouvees:')
for c, v in sorted(cats.items(), key=lambda x: -x[1]):
    print(f'  {c}: {v}')
