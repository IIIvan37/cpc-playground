-- Add thumbnail_path column to projects table
ALTER TABLE projects
ADD COLUMN thumbnail_path text;

-- Create storage bucket for project thumbnails
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'thumbnails',
  'thumbnails',
  true,
  1048576, -- 1MB limit
  ARRAY['image/png', 'image/jpeg', 'image/webp']
)
ON CONFLICT (id) DO NOTHING;

-- Storage policies for thumbnails bucket

-- Allow authenticated users to upload thumbnails to their own folder
CREATE POLICY "Users can upload their own thumbnails"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'thumbnails'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Allow authenticated users to update their own thumbnails
CREATE POLICY "Users can update their own thumbnails"
ON storage.objects
FOR UPDATE
TO authenticated
USING (
  bucket_id = 'thumbnails'
  AND (storage.foldername(name))[1] = auth.uid()::text
)
WITH CHECK (
  bucket_id = 'thumbnails'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Allow authenticated users to delete their own thumbnails
CREATE POLICY "Users can delete their own thumbnails"
ON storage.objects
FOR DELETE
TO authenticated
USING (
  bucket_id = 'thumbnails'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Allow anyone to view thumbnails (public bucket)
CREATE POLICY "Anyone can view thumbnails"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'thumbnails');
