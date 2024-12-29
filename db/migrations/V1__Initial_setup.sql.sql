CREATE EXTENSION "vector";

CREATE TABLE knowledgebase (
  id serial4 NOT NULL,
  path_name text NOT NULL,
  description text NULL,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
  CONSTRAINT knowledgebase_pkey PRIMARY KEY (id)
);

CREATE TYPE status AS ENUM ('pending', 'processing', 'completed', 'failed');

CREATE TABLE "document" (
  id serial4 NOT NULL,
  fk_knowledgebase int4 NOT NULL,
  "name" text NOT NULL,
  url text NOT NULL,
  "status" "status" DEFAULT 'pending' :: status NULL,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
  CONSTRAINT document_pkey PRIMARY KEY (id),
  CONSTRAINT document_fk_knowledgebase_fkey FOREIGN KEY (fk_knowledgebase) REFERENCES knowledgebase(id) ON DELETE CASCADE
);

CREATE TABLE embeddings (
  id serial4 NOT NULL,
  "content" text NOT NULL,
  embedding public.vector NULL,
  metadata jsonb NULL,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
  CONSTRAINT embeddings_pkey PRIMARY KEY (id)
);