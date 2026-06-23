-- 1. Create water reports table
CREATE TABLE IF NOT EXISTS public.water_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    reporter_name VARCHAR(100),
    is_anonymous BOOLEAN DEFAULT FALSE NOT NULL,
    location_name VARCHAR(255) NOT NULL,
    province VARCHAR(100) NOT NULL,
    district VARCHAR(100) NOT NULL,
    subdistrict VARCHAR(100) NOT NULL,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    fluorescence_level VARCHAR(50) NOT NULL, -- 'normal' or 'decreased'
    contamination_status VARCHAR(50) NOT NULL, -- 'safe' or 'contaminated'
    ppm_estimate VARCHAR(50), -- e.g. "0", "0.5", "1.0", "5.0+", "Unknown"
    notes TEXT,
    photo_url TEXT
);

-- 2. Create comments table
CREATE TABLE IF NOT EXISTS public.comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    report_id UUID REFERENCES public.water_reports(id) ON DELETE CASCADE, -- NULL for general comments
    commenter_name VARCHAR(100),
    is_anonymous BOOLEAN DEFAULT FALSE NOT NULL,
    comment_text TEXT NOT NULL
);

-- 3. Storage bucket setup for uploaded photos
INSERT INTO storage.buckets (id, name, public) 
VALUES ('water-photos', 'water-photos', true)
ON CONFLICT (id) DO NOTHING;

-- 4. Enable Row Level Security (RLS) policies for public insert/read
ALTER TABLE public.water_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public read water_reports" ON public.water_reports FOR SELECT USING (true);
CREATE POLICY "Allow public insert water_reports" ON public.water_reports FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow public read comments" ON public.comments FOR SELECT USING (true);
CREATE POLICY "Allow public insert comments" ON public.comments FOR INSERT WITH CHECK (true);

-- Enable public storage access
CREATE POLICY "Allow public read storage" ON storage.objects FOR SELECT USING (bucket_id = 'water-photos');
CREATE POLICY "Allow public insert storage" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'water-photos');
