-- Reconstructed SQLite contract consumed by src/parsers/opencode.ts.
-- OpenCode owns the database; mytokens opens it read-only.
CREATE TABLE session (
  id TEXT PRIMARY KEY,
  directory TEXT
);

CREATE TABLE message (
  id TEXT PRIMARY KEY,
  session_id TEXT,
  data TEXT NOT NULL,
  FOREIGN KEY (session_id) REFERENCES session(id)
);

CREATE INDEX idx_message_session_id ON message(session_id);
CREATE INDEX idx_message_role ON message(json_extract(data, '$.role'));
