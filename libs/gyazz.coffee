## node版gyazzクライアント

FeedParser = require 'feedparser'
request = require 'request'

module.exports = class Gyazz

  constructor: (@url, @auth = {}) ->

  get_pages: (wiki_name, callback = ->) ->
    feedparser = new FeedParser
    req = request
      method: 'GET'
      uri: encodeURI "#{@url}/#{wiki_name}/rss.xml"
      timeout: 10000
      headers:
        'User-Agent': 'hubot'
      auth: @auth if @auth.user and @auth.pass

    req.on 'error', (err) ->
      callback err

    req.on 'response', (res) ->
      if res.statusCode isnt 200
        return callback "statusCode: #{res.statusCode}"
      this.pipe feedparser

    feedparser.on 'error', (err) ->
      callback err

    pages = []

    feedparser.on 'data', (chunk) ->
      if chunk.title?
        pages.push chunk.title

    feedparser.on 'end', ->
      callback null, pages

  get_page: (wiki_name, page_name, callback = ->) ->
    request
      method: 'GET'
      uri: encodeURI "#{@url}/#{wiki_name}/#{page_name}/json"
      timeout: 10000
      headers:
        'User-Agent': 'hubot'
      auth: @auth if @auth.user and @auth.pass
    , (err, res, body) ->
      if err
        return callback err
      if res.statusCode isnt 200
        return callback "statusCode: #{res.statusCode}"
      try
        page = JSON.parse body
      catch
        return callback "json parse error"
      callback null, page

