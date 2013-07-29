# Overview

A high performance quotes service. It will grab the public note of Evernote,
then returns specified quotes to http requests.

The quotes in the note should be separated by an empty line.
Configure the public note's url in the `config.json` file.

# Setup

 0. Clone the project:

        git clone https://github.com/ysmood/ys-words.git

 0. `cd ys-words`

 0. If you don't want to do any dev on this project,
    you could install dependencies with `--production`:

        npm install --production

 0. Edit the `config.json` file.
    **This is a required step, the default value won't work**.

 0. Launch the service:

        npm start

# Configuration

* `port`

  Which port listened to.

* `notebook_url`

  The public Evernote note's url.

* `auto_grab_frq`

  The frequency of how often the note should be re-grabbed, in minute.

# API
All APIs are based on http request.
You should have some basic knowledge of the [routing expression of Express.js][1].

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

# Debug and Test

Run the server in debug mode: `npm run-script debug`.

Run the auto test cases: `npm test`. Note, you should launch the server before you run the tests.

# FreeBSD Licensed

Jul 2013 ys


  [1]: http://expressjs.com/api.html#app.VERB