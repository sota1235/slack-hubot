## node版gyazzクライアント

FeedParser = require 'feedparser'
request = require 'request'
Promise = require 'bluebird'

module.exports = class Gyazz

  constructor: (@url, @auth = {}) ->

  get_pages: (wiki_name) ->
    return new Promise (resolve, reject) =>
      feedparser = new FeedParser
      req = request
        method: 'GET'
        uri: encodeURI "#{@url}/#{wiki_name}/rss.xml"
        timeout: 10000
        headers:
          'User-Agent': 'hubot'
        auth: @auth if @auth.user and @auth.pass

      req.on 'error', (err) ->
        reject err

      req.on 'response', (res) ->
        if res.statusCode isnt 200
          return reject "statusCode: #{res.statusCode}"
        this.pipe feedparser

      feedparser.on 'error', (err) ->
        reject err

      pages = []

      feedparser.on 'data', (chunk) ->
        if chunk.title?
          pages.push chunk.title

      feedparser.on 'end', ->
        resolve pages

  get_page: (wiki_name, page_name) ->
    return new Promise (resolve, reject) =>
      request
        method: 'GET'
        uri: encodeURI "#{@url}/#{wiki_name}/#{page_name}/json"
        timeout: 10000
        headers:
          'User-Agent': 'hubot'
        auth: @auth if @auth.user and @auth.pass
      , (err, res, body) ->
        if err
          return reject err
        if res.statusCode isnt 200
          return reject "statusCode: #{res.statusCode}"
        try
          page = JSON.parse body
        catch
          return reject "json parse error"
        resolve page

