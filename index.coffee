express = require 'express'

load_words = require './lib/load_words'

class YS_Words
	constructor: ->
		@app = express()

		@init_config()
		@load_words()
		@init_routes()

		@app.listen(@config.port)
		console.log('ys_words start on port: ' + @config.port)

	init_config: ->
		@config = {
			port: 7000
		}

	load_words: ->
		load_words.load((words) ->
			@words = words
			@words_json = JSON.stringify(words)
		)

	init_routes: ->
		@app.get('/all', @get_all_words)

		@app.get('/words', @get_random_words)		

	get_all_words: (req, res) ->
		res.send(@words_json)

	get_random_words: (req, res) ->
		nth = Math.floor(Math.random() * @words.length)
		s = @words[nth]
		res.send(s)


ys_words = new YS_Words()