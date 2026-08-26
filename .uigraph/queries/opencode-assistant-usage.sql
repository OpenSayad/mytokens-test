-- Query used by the OpenCode SQLite adapter (modern schema path).
SELECT m.id, m.session_id, m.data,
       NULLIF(s.directory, '') AS workspace_root
FROM message AS m
LEFT JOIN session AS s ON s.id = m.session_id
WHERE json_extract(m.data, '$.role') = 'assistant'
  AND json_extract(m.data, '$.tokens') IS NOT NULL;
