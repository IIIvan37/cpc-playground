# Guide d'utilisation des includes

## Vue d'ensemble

Le système multi-fichiers permet maintenant d'utiliser des directives `INCLUDE` pour inclure d'autres fichiers du projet dans votre code assembleur.

## Comment ça fonctionne

1. **Créez un projet** dans la section "MY PROJECTS" (nécessite d'être authentifié)
2. **Ajoutez plusieurs fichiers** `.asm` à votre projet
3. **Marquez un fichier comme "main"** - c'est le fichier qui sera compilé en premier
4. **Utilisez la directive INCLUDE** dans vos fichiers pour inclure d'autres fichiers du projet

## Syntaxe INCLUDE

Dans votre fichier principal (ou dans n'importe quel fichier), utilisez la syntaxe suivante :

```asm
INCLUDE "nomfichier.asm"
```

Le nom du fichier doit correspondre exactement au nom d'un fichier dans votre projet.

## Exemple

### Structure d'un projet

Supposons que vous ayez un projet avec les fichiers suivants :

- **main.asm** (marqué comme fichier principal)
- **routines.asm**
- **data.asm**

### Contenu des fichiers

**routines.asm** :
```asm
; Routine pour effacer l'écran
clear_screen:
    ld hl,#c000
    ld de,#c001
    ld bc,#3fff
    ld (hl),0
    ldir
    ret

; Routine pour attendre une frame
wait_frame:
    ld b,#f5
.vsync:
    in a,(c)
    rra
    jr nc,.vsync
    ret
```

**data.asm** :
```asm
; Données du programme
message:
    db "Hello CPC!",0

colors:
    db 1,6,26,14
```

**main.asm** (fichier principal) :
```asm
    org #4000

    INCLUDE "routines.asm"
    INCLUDE "data.asm"

start:
    call clear_screen
    
    ; Afficher le message
    ld hl,message
    call print_message
    
    call wait_frame
    ret

print_message:
    ; ... code pour afficher le message ...
    ret
```

## Ordre d'inclusion

- Les fichiers sont inclus dans l'ordre où ils apparaissent dans les directives `INCLUDE`
- Vous pouvez inclure un fichier depuis n'importe quel fichier du projet
- Les includes sont récursifs : un fichier inclus peut lui-même inclure d'autres fichiers

## Bonnes pratiques

1. **Organisez votre code** : Séparez les routines, les données et le code principal dans différents fichiers
2. **Nommez vos fichiers clairement** : `routines.asm`, `data.asm`, `sprites.asm`, etc.
3. **Marquez le bon fichier comme main** : Le fichier principal doit être celui qui contient l'organisation de votre programme et les includes
4. **Évitez les inclusions circulaires** : Ne faites pas inclure un fichier A dans un fichier B qui lui-même inclut A

## Avantages

- ✅ **Meilleure organisation** : Séparez votre code en modules logiques
- ✅ **Réutilisabilité** : Créez des bibliothèques de routines réutilisables
- ✅ **Collaboration** : Facilite le travail en équipe sur différents fichiers
- ✅ **Maintenance** : Plus facile de retrouver et modifier du code spécifique

## Limitations actuelles

- Les fichiers doivent tous être dans le même projet (pas de sous-dossiers)
- Le nom du fichier dans la directive INCLUDE doit correspondre exactement au nom du fichier dans le projet
- La compilation se fait toujours à partir du fichier marqué comme "main"

## Compatibilité avec le système local

Si vous utilisez le système de stockage local (ProgramManager), vous travaillez avec un seul fichier. Les includes ne sont disponibles que pour les projets cloud authentifiés.
