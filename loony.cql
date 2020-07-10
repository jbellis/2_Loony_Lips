CREATE TABLE stories (
  id uuid PRIMARY KEY,
  story text,
  prompts list<text>
);
