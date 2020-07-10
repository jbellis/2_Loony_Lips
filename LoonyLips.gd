extends Node2D

var player_words = [] # the words the player chooses
var current_story
var strings # All the text that's displayed to the player

func _ready():
    randomize()
    set_random_story()
    strings = get_from_json("other_strings.json")
    $Blackboard/StoryText.text = strings["intro_text"]
    $Blackboard/TextBox.text = ""


func set_random_story():
    var story_ids = [
        '6d934ec0-4ce4-4f8a-9fc6-75bb07e504c2', 
        'ada0b51b-b07c-4742-94ef-d697fbf67775', 
        '9dbb1d77-a2e9-4169-833b-59266554fc8a',
        '3787865d-95bd-4c56-b98b-8228be4c6aa3',
        '5b143f94-4859-4c97-8107-b64d9149b3a1',
        'e9f1629d-7730-4941-abbb-494ce5ea8848']
    
    var url = "https://49f3af70-d613-4697-9554-73daf8970550-us-east1.apps.astra.datastax.com/api/rest/v1/keyspaces/demo/tables/stories/rows/"

    var headers = [
        'accept: application/json',
        'x-cassandra-token: 1c8bbdf6-6771-4783-9139-dc1c1dc2e22d',
        'x-cassandra-request-id: X-Cassandra-Request-Id',
        'content-type: application/json'
    ]

    $HTTPRequest.connect("request_completed", self, "_on_request_completed")
    $HTTPRequest.request(url + story_ids[randi() % story_ids.size()], headers)

func _on_request_completed(result, response_code, headers, body):
    var json = JSON.parse(body.get_string_from_utf8())
    print(json.result)
    var row = json.result['rows'][0]
    current_story = {'prompt': row['prompts'], 'story': row['story']}
    prompt_player()


func get_from_json(filename):
    var file = File.new() #the file object
    file.open(filename, File.READ) #Assumes the file exists
    var text = file.get_as_text()
    var data = parse_json(text)
    file.close()
    return data


func _on_TextureButton_pressed():
    if is_story_done():
        get_tree().reload_current_scene()
    else:
        var new_text = $Blackboard/TextBox.get_text()
        _on_TextBox_text_entered(new_text)

func _on_TextBox_text_entered(new_text):
    player_words.append(new_text)
    $Blackboard/TextBox.text = ""
    $Blackboard/StoryText.text = ""
    check_player_word_length()

func is_story_done():
    return player_words.size() == current_story.prompt.size()

func prompt_player():
    var next_prompt = current_story["prompt"][player_words.size()]
    $Blackboard/StoryText.text += (strings["prompt"] % next_prompt)

func check_player_word_length():
    if is_story_done():
        tell_story()
    else:
        prompt_player()

func tell_story():
    $Blackboard/StoryText.text = current_story.story % player_words
    $Blackboard/TextureButton/ButtonLabel.text = strings["again"]
    end_game()

func end_game():
    $Blackboard/TextBox.queue_free()
