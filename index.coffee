express = require('express')

class YS_Words
	constructor: ->
		@app = express()

		@init_config()
		@init_routes()

		@app.listen(@config.port)
		console.log('ys_words start on port: ' + @config.port)

	init_config: ->
		@config = {
			port: 7000
		}

	init_routes: ->
		@app.get('/', @get_all_words)

	get_all_words: (req, res) ->
		res.send('ok')


ys_words = new YS_Words()