fs = require 'fs'
cheerio = require 'cheerio'

body = fs.readFileSync 'out.txt', 'utf8'

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

words = filter_words body

console.log words