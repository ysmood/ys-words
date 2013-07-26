# Overview

A quotes service. It will grab the public note of Evernote,
then returns specified quotes to http requests.

The quotes in the note should be separated by an empty line.
Configure the public note's url in the `config.json` file.

# API
All APIs are based on http request.

* `GET /all:/br`

  RETURN: `json`
  
  Return all quotes in json format. If the `br` param is not given,
  all the `\n` symbol in the returned string will be replaced with `<br />`.

* `GET /words:mount`

  RETURN: `json` or `string`
  
  Return specified mount of random unique threads of words.
  Such as `/words12` will return 12 threads.
  If no `mount` given, it will return a single string.

* `GET /update`

  RETURN: `string`
  
  Trigger the server to grab note from the Evernote.
  It will return `Update Done` if nothing goes wrong.


# FreeBSD Licensed

Jul 2013 ys