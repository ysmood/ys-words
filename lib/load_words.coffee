request = require 'request'

notebook_url = 'https://www.evernote.com/shard/s76/sh/a26821ce-b7ea-4671-8ccd-57268d0f22c7/6b380a1918325a2757823309560e7e9b'

filter_words = (body) ->
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

exports.load = (loaded) ->
	request(notebook_url, (err, res, body) ->
		if err
			console.log(err)

		words = filter_words(body)

		loaded(words)
	)
