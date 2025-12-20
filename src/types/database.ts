export interface Database {
  public: {
    Tables: {
      projects: {
        Row: {
          id: string
          user_id: string
          name: string
          description: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          user_id: string
          name: string
          description?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          name?: string
          description?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      project_files: {
        Row: {
          id: string
          project_id: string
          name: string
          content: string
          is_main: boolean
          order: number
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          project_id: string
          name: string
          content: string
          is_main?: boolean
          order?: number
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          project_id?: string
          name?: string
          content?: string
          is_main?: boolean
          order?: number
          created_at?: string
          updated_at?: string
        }
      }
    }
  }
}
