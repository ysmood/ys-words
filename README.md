# Overview

A quotes service. It will grab the public note of Evernote,
then returns specified quotes to http requests.

The quotes in the note should be separated by an empty line.
Configure the public note url in the 'config.json' file.

# API
All APIs are based on http request.

* **GET /all:/br**

  TYPE: **json**
  
  Return all quotes in json format. If the 'br' param is not given,
  all the '\n' symbol in the returned string will be replaced with '&lt;br />'.

* **GET /words:mount**

  TYPE: **json**
  
  Return specified mount of random unique threads of words.
  Such as '/words12' will return 12 threads.

* **GET /update**

  TYPE: **string**
  
  Triger the server to grab note from the Evernote.


# FreeBSD Licensed

Jul 2013 ys