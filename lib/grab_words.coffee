###

The Evernote parser.
Get specified note content.

###

request = require 'request'
cheerio = require 'cheerio'

filter_words = (body) ->
	if not body
		return null

	$ = cheerio.load(body)

	words = $('.ennote').text().match(/[^(\n\n)]+/g)

	return words


max_retry = 5
retry_count = 0

exports.load = (notebook_url, loaded) ->
	request(notebook_url, (err, res, body) ->
		if err
			console.log(err)

		words = filter_words(body)

		# If nothing got, try again a few seconds later.
		if not words and (typeof words.length == 'undefined') and retry_count++ < max_retry
			console.error 'Error, try again later...'
			setTimeout(
				->
					exports.load(notebook_url, loaded)
				,
				1000 * 3
			)
		else
			retry_count = 0

		console.log 'Note grabbed: ' + new Date().toUTCString()

		loaded(words)
	)
