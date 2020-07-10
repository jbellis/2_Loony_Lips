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
    var uuid = Uuid.v4()
    print(uuid)
    var url = "https://49f3af70-d613-4697-9554-73daf8970550-us-east1.apps.astra.datastax.com/api/rest/v1/keyspaces/demo/tables/stories/rows/query"
    var payload = "{\"filters\":[{\"value\":[\"%s\"],\"columnName\":\"id\",\"operator\":\"gt\"}],\"pageSize\":1}" % [uuid]
    var headers = [
        'accept: application/json',
        'x-cassandra-token: 1c8bbdf6-6771-4783-9139-dc1c1dc2e22d',
        'x-cassandra-request-id: X-Cassandra-Request-Id',
        'content-type: application/json'
    ]

    $HTTPRequest.connect("request_completed", self, "_on_request_completed")
    $HTTPRequest.request(url, headers, true, HTTPClient.METHOD_POST, payload)

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
