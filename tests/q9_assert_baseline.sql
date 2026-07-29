\set ON_ERROR_STOP on

DO $$
BEGIN
  IF to_regclass('public.content_items') IS NULL THEN
    RAISE EXCEPTION 'content_items table missing';
  END IF;
  IF to_regclass('public.content_versions') IS NULL THEN
    RAISE EXCEPTION 'content_versions table missing';
  END IF;
  IF to_regclass('public.source_references') IS NULL THEN
    RAISE EXCEPTION 'source_references table missing';
  END IF;
END;
$$;

INSERT INTO content_items (
  canonical_key, content_type, language_code, title, body,
  editorial_status, provenance, rights_status, published_at
) VALUES (
  'test:ta:murugan:001', 'article', 'ta', 'முருகன்',
  '{"text":"தமிழ் உள்ளடக்க சரிபார்ப்பு"}'::jsonb,
  'published', '{"source":"q9-ci"}'::jsonb, 'cleared', now()
) ON CONFLICT (canonical_key) DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM content_items WHERE canonical_key = 'test:ta:murugan:001';
  IF n <> 1 THEN RAISE EXCEPTION 'canonical uniqueness test failed'; END IF;
END;
$$;

DO $$
BEGIN
  BEGIN
    INSERT INTO content_items (canonical_key, content_type, language_code, title, editorial_status)
    VALUES ('test:invalid:published', 'article', 'en-GB', 'Invalid', 'published');
    RAISE EXCEPTION 'published date constraint did not reject invalid row';
  EXCEPTION WHEN check_violation THEN
    NULL;
  END;
END;
$$;
