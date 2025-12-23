import type { Project } from '../entities/project.entity'

/**
 * Filter criteria for searching projects
 */
export type ProjectFilterCriteria = Readonly<{
  query: string
  userId?: string
}>

/**
 * Searchable project data used for filtering
 */
export type SearchableProject = Readonly<{
  project: Project
  authorName: string
}>

/**
 * Filter projects by search query
 * Matches against: project name, author name, tags, description
 */
export function filterProjects(
  projects: readonly SearchableProject[],
  criteria: ProjectFilterCriteria
): readonly SearchableProject[] {
  const query = criteria.query.trim().toLowerCase()

  if (!query) {
    return projects
  }

  return projects.filter((item) => {
    const { project, authorName } = item

    // Search in project name
    if (project.name.value.toLowerCase().includes(query)) {
      return true
    }

    // Search in author name
    if (authorName.toLowerCase().includes(query)) {
      return true
    }

    // Search in tags
    if (project.tags.some((tag) => tag.toLowerCase().includes(query))) {
      return true
    }

    // Search in description
    if (project.description?.toLowerCase().includes(query)) {
      return true
    }

    return false
  })
}
