fs = require 'fs'

exports.load = (loaded) ->
	fs.readFile('words.txt', 'utf-8', (err, data) ->
		words = data.toString().split("\n\n")

		arr = []
		for s in words
			if s == '' then continue
			arr.push s
				.replace(/^(\n+)/g, '')
				.replace(/(\n+)$/g, '')

		loaded(arr)
	)