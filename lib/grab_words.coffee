###

The Evernote parser.
Get specified note content.

###

request = require 'request'

filter_words = (body) ->
	if not body
		return null

	# Extract the main part of page.
	m = body.match(/"ennote">([\s\S]*?)<a class="save-button/)
	if m.length < 2
		console.log 'Nothing found on this page.'
	else
		body = m[1]

	# Remove unnecessary symbols.
	body = body.replace(/&quot;/g, '')
	body = body.replace(/<\/?div>/g, '')

	arr = body.split('<br/>')

	words = []
	for s in arr
		s = s
			.replace(/^([\n\s]+)/g, '')
			.replace(/([\n\s]+)$/g, '')

		if s != ''
			words.push s

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
