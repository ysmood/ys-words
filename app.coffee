###

The main entrance of this project.

###

express = require 'express'
_ = require 'underscore'

grab_words = require './lib/grab_words'


class YS_Words
	constructor: ->
		@app = express()

		@init_config()
		@load_words()
		@init_routes()

		@app.listen(@config.port)
		console.log('ys_words start on port: ' + @config.port)

	init_config: ->
		@config = require './config.json'

		# Enable the CORS.
		@app.all('*', (req, res, next) ->
			res.header("Access-Control-Allow-Origin", "*")
			res.header("Access-Control-Allow-Headers", "X-Requested-With")
			next()
		)

	load_words: (loaded) ->
		grab_words.load(@config.notebook_url, (words) ->
			# Cache the words for better performance.
			@words = words

			@words_json = JSON.stringify(words)

			@words_json_br = JSON.stringify(
				words.map (s) ->
					s.replace(/\n/g, '<br />')
			)

			if loaded then loaded()
		)

	init_routes: ->
		# GET /all:/br
		@app.get(/\/all(\/br)?/, @get_all_words)

		# GET /words:mount
		@app.get(/\/words(\d+)?/, @get_random_words)

		@app.get('/update', @update_words)		

	get_all_words: (req, res) ->
		if req.params[0] == '/br'
			res.send(@words_json_br)
		else
			res.send(@words_json)

	get_random_words: (req, res) ->
		threads = []

		if req.params[0]
			mount = parseInt(req.params[0])
		else
			mount = 1
		
		# Randomly choose some unique numbers.
		nums = [0 ... @words.length]
		for i in [0 ... mount]
			nth = nums[_.random(nums.length - 1)]
			threads.push @words[nth]

			nums = _.without(nums, nth)
			
		res.send(threads)

	update_words: (req, res) =>
		@load_words(->
			res.send('Update Done')
		)


ys_words = new YS_Words()