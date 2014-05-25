###

The main entrance of this project.

###

express = require 'express'
_ = require 'underscore'

grab_words = require './lib/grab_words'


class YS_Words
	constructor: ->
		@app = express()

		@status = 'initializing'

		@init_config()
		@init_routes()

		@load_words(->
			@status = 'ok'
		)

		@app.listen(@config.port)
		console.log('ys_words start on port: ' + @config.port)

		@auto_grab()

	init_config: ->
		@config = require './config.json'

		# Enable the CORS.
		@app.all('*', (req, res, next) =>
			res.header("Access-Control-Allow-Origin", @config.allowed_origin)
			res.header("Access-Control-Allow-Headers", "X-Requested-With")
			next()
		)

	load_words: (loaded) =>
		grab_words.load(@config.notebook_url, (words) =>
			# Cache the words for better performance.
			@words = words

			@words_json = JSON.stringify(words)

			try
				@words_json_br = JSON.stringify(
					words.map (s) ->
						s.replace(/\n/g, '<br />')
				)
			catch e
				console.log e

			if loaded then loaded()
		)

	init_routes: ->
		@app.get('/status', @get_app_status)

		# GET /all:/br
		@app.get(/\/all(\/br)?/, @get_all_words)

		# GET /words:mount
		@app.get(/\/words(\d+)?/, @get_random_words)

		@app.get('/update', @update_words)

	get_app_status: (req, res) ->
		res.send(@status)

	get_all_words: (req, res) =>
		if req.params[0] == '/br'
			res.send(@words_json_br)
		else
			res.send(@words_json)

	get_random_words: (req, res) =>
		if req.params[0]
			mount = parseInt(req.params[0])
		else
			# Return only a string.
			res.send(
				@words[_.random(@words.length)]
			)
			return

		threads = []

		# Randomly choose some unique numbers.
		nums = [0 ... @words.length]
		for i in [0 ... mount]
			nth = nums[_.random(nums.length - 1)]
			threads.push @words[nth]

			nums = _.without(nums, nth)

		res.json(threads)

	update_words: (req, res) =>
		@load_words(->
			res.send('Update Done')
		)

	# Auto download from Evernote in specified frequency.
	auto_grab: ->
		# If interval is 0, no auto-grab.
		if @config.auto_grab_frq == 0
			return

		setInterval(
			@load_words,
			@config.auto_grab_frq * 1000 * 60
		)


ys_words = new YS_Words()