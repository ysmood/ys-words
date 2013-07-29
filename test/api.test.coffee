###

Auto test the APIs.

###

_ = require 'underscore'
request = require 'request'

config = require '../config.json'

host_url = "http://localhost:#{config.port}/"


t_title = (title) ->
	console.log '\nTest the api: ' + title

t_list = []
t_count = 0
t_pass = ->
	t_count++
	console.log "Test #{t_count} / #{t_list.length} pass."

test = ->
	t_list = [
		case_all,
		case_all_br,
		case_random_words,
		case_words_10,
		case_update,
	]

	for t in t_list
		t()

run = ->
	request(host_url + 'status', (err, res, body) ->
		if err
			console.log err
			return

		if body == 'ok'
			test()
		else
			console.log 'Wait for 1 sec, the server is initializing...'
			setTimeout(run, 1000)
	)

case_all = ->
	url = host_url + 'all'

	request(url, (err, res, body) ->
		t_title url
		try
			words = JSON.parse body
			if words.length > 0
				t_pass()
		catch e
			console.log e
	)

case_all_br = ->
	url = host_url + 'all/br'

	request(url, (err, res, body) ->
		t_title url
		try
			words = JSON.parse body
			if words.length > 0 and
			body.indexOf('<br />') > -1
				t_pass()
		catch e
			console.log e
	)

case_random_words = ->
	url = host_url + 'words'

	request(url, (err, res, body) ->
		t_title url
		if _.isString(body) and
		body.length > 0
			t_pass()
	)

case_words_10 = ->
	url = host_url + 'words10'

	request(url, (err, res, body) ->
		t_title url
		try
			words = JSON.parse body
			if _.isArray(words) and
			words.length == 10
				if _.isString(words[_.random(9)])
					t_pass()
		catch e
			console.log e
	)

case_update = ->
	url = host_url + 'update'

	request(url, (err, res, body) ->
		t_title url
		if body == 'Update Done'
			t_pass()
	)

run()
