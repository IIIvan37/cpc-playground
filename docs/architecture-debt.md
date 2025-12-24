# Architecture Technical Debt

> Last updated: December 24, 2025

## Overview

This document tracks the architectural inconsistencies between the defined principles (see [architecture.md](./architecture.md) and [component-style-guide.md](./component-style-guide.md)) and the current implementation.

## Current State Summary

| Layer | Conformity | Notes |
|-------|------------|-------|
| **Domain** | ✅ 100% | Entities, Value Objects, Repository interfaces |
| **Use Cases** | ✅ 100% | Factory functions, proper DI |
| **Infrastructure** | ✅ ~91% | Repositories well isolated |
| **Store** | ✅ 100% | State-only atoms, no action duplication |
| **Presentation** | ⚠️ ~60% | Inconsistent patterns, missing tests |

---

## ✅ Resolved Issues

### 1. Store/Hooks Duplication (RESOLVED)

**Problem:** ~~Action atoms in `src/store/projects.ts` (~782 lines) duplicate the functionality of hooks.~~

**Resolution:** 
- Removed all action atoms from `projects.ts` (now ~90 lines)
- Migrated all components to use hooks instead of action atoms
- Store now contains only state atoms and derived atoms
- Hooks are enriched to update Jotai state when needed

**Components migrated:**
- `explore.tsx` → `useCreateProject`
- `file-browser.tsx` → `useCreateFile`, `useDeleteFile`, `useSetMainFile`, `useFetchDependencyFiles`
- `use-auto-save-file.ts` → `useUpdateFile`
- `use-project-from-url.ts` → `useFetchProject`
- `toolbar.tsx` → `useGetProjectWithDependencies`

---

## 🔴 Critical Issues

### 1. Missing Container Tests

**Problem:** 13 container components have no tests.

| Component | Missing Test |
|-----------|--------------|
| `auth-modal` | `auth-modal.test.tsx` |
| `console-panel` | `console-panel.test.tsx` |
| `code-editor` | `code-editor.test.tsx` |
| `emulator-canvas` | `emulator-canvas.test.tsx` |
| `app-header` | `app-header.test.tsx` |
| `main-layout` | `main-layout.test.tsx` |
| `toolbar` | `toolbar.test.tsx` |
| `root-layout` | `root-layout.test.tsx` |
| `program-manager` | `program-manager.test.tsx` |
| `file-browser` | `file-browser.test.tsx` |
| `project-settings-modal` | `project-settings-modal.test.tsx` |
| `resizable-sidebar` | `resizable-sidebar.test.tsx` |
| `user-profile` | `user-profile.test.tsx` |

**Impact:** Business logic in containers is untested (~98% coverage is misleading - it's concentrated on domain/use-cases).

---

### 2. Missing Hook Tests

**Problem:** 15 out of 16 hooks have no tests.

| Hook | Purpose |
|------|---------|
| `use-assembler` | RASM compilation |
| `use-auth` | Authentication |
| `use-auto-save-file` | Auto-save logic |
| `use-dependencies` | Project dependencies |
| `use-emulator` | CPCEC emulator |
| `use-fetch-visible-projects` | Explore page |
| `use-files` | File CRUD |
| `use-project-from-url` | URL loading |
| `use-project-settings` | Project settings |
| `use-projects` | Project CRUD |
| `use-refresh-projects` | Project refresh |
| `use-shared-code` | Share URL handling |
| `use-shares` | User shares |
| `use-tags` | Project tags |
| `use-user-profile` | User profile |

**Only tested:** `use-use-case` ✅

---

## 🟡 Moderate Issues

### ~~3. Direct Supabase Call in Component~~ ✅ RESOLVED

~~**Location:** `src/components/user/user-profile/user-profile.tsx:43`~~

**Resolution:** Now uses `useAuth().signOut()` instead of direct Supabase call.

---

### ~~4. Hooks Not Using useUseCase Pattern~~ ✅ ANALYZED

**Analysis:** These hooks are intentionally different from `useUseCase` pattern:

| Hook | Pattern | Justification |
|------|---------|---------------|
| `useAuth` | State + Listener | Manages auth atom, subscribes to auth changes |
| `useUserProfile` | State + Auto-fetch | Auto-fetches on user change, manages profile state |
| `useSharedCode` | Side-effect | URL/sessionStorage parsing, one-time effect |

These hooks combine multiple concerns (state, effects, use-cases) that don't fit the simple `useUseCase` pattern. They correctly use container use-cases internally.

---

### 5. Missing Container/View Separation

| Component | Has View File | Status |
|-----------|---------------|--------|
| `markdown-preview` | ✅ Yes (inline) | Already separated |
| `crt-effect` | N/A | Purely presentational |
| `root-layout` | N/A | Purely presentational |
| `reset-password` (page) | ✅ Yes | Separated |
| `read-only-project-banner` | ✅ Yes | Separated |
| `theme-provider` | N/A | No UI |

**Note:** UI primitives (button, input, checkbox, etc.) are exempted as they are purely presentational by nature.

---

## 🟢 What's Working Well

- **Domain layer**: Complete with entities, value objects, repository interfaces
- **Use cases**: All using factory function pattern with proper DI
- **Infrastructure**: Repositories properly isolated
- **Test coverage**: ~98% on domain and use-cases
- **View components**: Well tested with `.view.test.tsx` files

---

## Remediation Plan

### ~~Phase 1: Eliminate Store/Hooks Duplication~~ ✅ COMPLETED

~~1. Audit all components using action atoms~~
~~2. Migrate to hooks~~
~~3. Remove action atoms from `projects.ts`~~
~~4. Keep atoms for state only (read-only)~~

**Completed:** December 24, 2025

---

### ~~Phase 2: Fix Direct Violations~~ ✅ COMPLETED

~~1. Fix `user-profile.tsx` Supabase call~~
~~2. Migrate `useAuth`, `useUserProfile`, `useSharedCode` to `useUseCase`~~

**Resolution:**
- Fixed `user-profile.tsx` to use `useAuth().signOut()`
- Analyzed hooks: `useUseCase` pattern not applicable (documented above)

**Completed:** December 24, 2025

---

### ~~Phase 3: Apply Container/View Pattern~~ ✅ COMPLETED

~~Create `.view.tsx` files for:~~
~~- `markdown-preview`~~ (already has inline separation)
~~- `crt-effect`~~ (purely presentational, N/A)
~~- `root-layout`~~ (purely presentational, N/A)
~~- `reset-password`~~
~~- `read-only-project-banner`~~

**Resolution:** 
- `reset-password` and `read-only-project-banner` now have View components
- `markdown-preview` already had inline View (exported for testing)
- `crt-effect` and `root-layout` are purely presentational (no logic to separate)

**Completed:** December 24, 2025

---

### Phase 4: Presentation Layer Tests ⏱️ Medium Priority

Priority order:
1. `auth-modal` (authentication flow)
2. `file-browser` (file management)
3. `project-settings-modal` (settings)
4. `user-profile` (profile management)
5. Critical hooks (`useAuth`, `useProjects`, `useFiles`)

**Estimated effort:** 3-5 days

---

## Progress Tracking

| Phase | Status | Completion |
|-------|--------|------------|
| Phase 1 | ✅ Completed | 100% |
| Phase 2 | ✅ Completed | 100% |
| Phase 3 | ✅ Completed | 100% |
| Phase 4 | 🔴 Not started | 0% |
