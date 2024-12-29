# Knowledge Base API Documentation

This documentation covers the implementation of a Knowledge Base API built using n8n workflows. The API supports operations to create, delete, list, upload, and retrieve documents within a knowledge base.

---

## Overview

![image](https://github.com/user-attachments/assets/d2e05b0a-43a9-49bd-817a-fff577439a3b)


### Components:
- **MinIO S3**: Used for storing folders and files.
- **PostgreSQL**: Database for metadata storage and query operations.
- **OpenAI Embeddings**: For processing and embedding document content.
- **Webhooks**: API endpoints for interaction.

### Key Features:
- Create and delete knowledge bases.
- List knowledge base entries with pagination.
- Upload documents to specific knowledge bases.
- Embed documents using OpenAI APIs.
- Retrieve embedded chunks for querying.

### Supported File Types
- **Documents**: `text/html`, `text/plain`, `application/pdf`, `text/csv`
- **Audio**: `audio/mpeg`, `audio/ogg`, `audio/wav`
- **Images**: `image/jpeg`, `image/png`

---

## Endpoints

### 1. Create Knowledge Base
**Path:** `/create-knowledge-base`  
**Method:** `POST`  
**Description:** Creates a new folder in S3 and inserts metadata into the PostgreSQL database.

**Workflow:**
1. Validate that the `name` field exists in the request body.
2. Create a folder in the S3 bucket.
3. Store metadata (e.g., folder name) in the PostgreSQL database.
4. Respond with a success message.

**Response Codes:**
- `200`: Knowledge base created successfully.
- `400`: Missing required fields.

---

### 2. Delete Knowledge Base
**Path:** `/delete-knowledge-base`  
**Method:** `DELETE`  
**Description:** Deletes a folder from S3 and removes associated metadata from PostgreSQL.

**Workflow:**
1. Validate the `id` field in the query parameters.
2. Retrieve the folder path from PostgreSQL.
3. Delete the folder from S3.
4. Remove metadata from PostgreSQL.
5. Respond with a success or failure message.

**Response Codes:**
- `200`: Knowledge base deleted successfully.
- `400`: Invalid or missing ID.

---

### 3. List Knowledge Bases
**Path:** `/list-knowledge-base`  
**Method:** `GET`  
**Description:** Retrieves a list of knowledge base entries with pagination.

**Workflow:**
1. Extract `limit` and `offset` from the request body (defaults to `10` and `0`, respectively).
2. Query PostgreSQL to fetch knowledge base entries sorted by `created_at`.
3. Return the result.

**Response Codes:**
- `200`: Successfully retrieved entries.

---

### 4. Upload Document
**Path:** `/knowledge-base/upload-document`  
**Method:** `POST`  
**Description:** Uploads a document to a specified knowledge base and stores metadata.

**Workflow:**
1. Validate required fields: `knowledgeBaseId` and binary data.
2. Check MIME type for supported formats (e.g., `pdf`, `jpeg`, `txt`).
3. Save the document in S3 under the corresponding folder.
4. Insert metadata into PostgreSQL (e.g., file name, URL, status).
5. Respond with a success message.

**Response Codes:**
- `200`: Document uploaded successfully.
- `400`: Missing required fields or unsupported file type.

---

### 5. Embed Document
**Path:** `/embedding-document`  
**Method:** `POST`  
**Description:** Processes and embeds a document for searchability.

**Workflow:**
1. Update the document's status to `processing` in PostgreSQL.
2. Segment content based on type:
   - **Documents**: Split text into chunks by characters or paragraphs.
   - **Audio**: Transcribe audio to text, then split.
   - **Images**: Extract descriptive metadata.
3. Generate embeddings using OpenAI.
4. Store embeddings in PostgreSQL with PGVector.
5. Update the document status to `completed`.

**Response Codes:**
- `200`: Document embedding completed.
- `400`: Missing required fields.

---

### 6. Retrieve Embedded Chunks
**Path:** `/retrieval`  
**Method:** `POST`  
**Description:** Fetches relevant embedded document chunks based on a query.

**Workflow:**
1. Validate the `knowledgeBaseId` and `query` fields.
2. Query the PGVector table to retrieve top relevant chunks.
3. Return the retrieved chunks.

**Response Codes:**
- `200`: Retrieval successful.
- `400`: Missing required fields.
