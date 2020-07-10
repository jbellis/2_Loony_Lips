import json
from connect import session

st = session.prepare('INSERT INTO STORIES (id, story, prompts) VALUES (uuid(), ?, ?)')

obj = json.load(open('stories.json'))
for o in obj:
    session.execute(st, [o['story'], o['prompt']])
