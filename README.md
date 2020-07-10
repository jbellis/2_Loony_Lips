# Loony Lips, Astra Edition
 
This is a demo porting GameDevTV's Loony Lips game for the Godot engine to load data from an Astra database using the REST API.
 
Loony Lips is GameDev.tv's guide to the free and open source Godot game engine.  Learn the free to use, free to modify, free to create engine with one of the most successful online game develeopment educational groups out there.

## Changes from the json-based Loony Lips

set_random_story in LoonyLips.gd is the main change, where we load a random story from Astra over REST.

migrate.py and connect.py show how to load the original stories.json into Astra, this time over CQL.  The schema definition is found in loony.cql.

## How To Build / Compile
This is a Godot project. If you're familiar with source control, then "clone this repo". Otherwise download the contents and place them in an empty folder that's in a convenient place.  Open Godot, ``Import Project`` and navigate to the folder you just made.  select ``project.godot`` and you're good to go.

No compiling necessary, just click the Run button!
