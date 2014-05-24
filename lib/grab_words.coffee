###

The Evernote parser.
Get specified note content.

###

request = require 'request'
cheerio = require 'cheerio'
fs = require 'fs'


filter_words = (body) ->
	if not body
		return null

	br = '@@@BR@@@'

	body = body.replace /<div><br\/><\/div>/g, br

	$ = cheerio.load(body)

	$note = $('.ennote')

	words = $note.text().split(br).map (el) ->
		el = el.replace /\t/g, ''
		el = el.replace /^(\n+)/, ''
		el = el.replace /(\n+)$/, ''
		el = el.replace /\n+/g, '\n'

	return words


max_retry = 5
retry_count = 0

exports.load = (notebook_url, loaded) ->
	request(notebook_url, {
		headers: {
			"Referer": notebook_url
			"User-Agent": 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.114'
		}
		qs: {
			'content': ''
		}
	}, (err, res, body) ->

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
