# Description:
#   Gyazz更新通知
#   /hubot/gyazz-webhook へのPOSTリクエストを受信
#   起動時にgyazzの更新ページをチェックしにいく
#
# Dependencies:
#   "diff":  "*"
#   "debug": "*"
#   "request": "*"
#   "feedparser": "*"
#
# Author:
#   @shokai

Diff = require 'diff'
debug = require('debug')('hubot:gyazz-notify')
request = require 'request'
FeedParser = require 'feedparser'
require 'string.prototype.repeat'

config =
  room: "news"
  header: ":star:"
  interval: 60000

icons =  # key=gyazz, value=slack icon
  shokai: 'shokai'
  増井: 'masui'
  nekobato: 'nekobato'
  napo: 'napo'
  satake: 'satake'
  geta6: 'geta6'
  nikezono: 'eyeglasses'
  keroxp: 'keroxp'
  ytanaka: 'ytanaka'

timeout_cids = {}

module.exports = (robot) ->

  ## wait for slack connection
  cid = setInterval ->
    return if typeof robot?.send isnt 'function'
    clearInterval cid
    url = 'http://gyazz.masuilab.org'
    wiki = '増井研'
    gyazz = new Gyazz url
    max_pages = 30
    count = 0
    gyazz.get_page_list wiki, (err, title) ->
      if err
        return debug err
      count += 1
      if count > max_pages
        return
      do (count) ->
        setTimeout ->
          debug "checking(#{count}) #{title}"
          gyazz.get_page wiki, title, (err, page) ->
            if err
              return debug err
            text = page.data.join '\n'
            notify url, wiki, title, text, config.room
        , count * 5000
  , 1000


  robot.router.post '/hubot/gyazz-webhook', (req, res) ->
    url   = req.body.url
    wiki  = req.body.wiki
    title = req.body.title
    text  = req.body.text
    room  = req.query.room or config.room
    unless wiki?.length > 0 and title?.length > 0 and text? and url?.length > 0
      res.status(400).send 'bad request'
      return

    res.send 'ok'

    debug key = "#{url}/#{wiki}/#{title}"

    clearTimeout timeout_cids[key]
    timeout_cids[key] = setTimeout ->
      notify url, wiki, title, text, room
    , config.interval


  notify = (base_url, wiki, title, text, room) ->
    url = "#{base_url}/#{wiki}/#{title}".replace /[\s<>]/g, (c) -> encodeURI(c)
    cache = robot.brain.get "gyazz_#{url}"
    robot.brain.set "gyazz_#{url}", text

    unless cache?.length > 0
      text = expand_uploadfile_fullpath text, "#{base_url}/upload"
      text = replace_gyazz_icon text
      text = remove_gyazz_markup(text).trim()
      debug notify_text = "#{config.header} 《新規》#{url} 《#{wiki}/#{title}》\n#{text}"
      robot.send {room: room}, notify_text
    else
      addeds = []
      for block in Diff.diffLines cache, text
        if block.added
          block = block.value.trim()
          block = expand_uploadfile_fullpath block, "#{base_url}/upload"
          block = replace_gyazz_icon block
          block = remove_gyazz_markup block
          addeds.push block
      if addeds.length < 1
        return
      debug notify_text = "#{config.header} 《更新》#{url} 《#{wiki}/#{title}》\n#{addeds.join('\n')}"
      robot.send {room: room}, notify_text

expand_uploadfile_fullpath = (str, updir) ->
  str.replace /\[\[([a-z0-9]{32}\.[^\s\]]+)/g, "[[#{updir}/$1"

replace_gyazz_icon = (str) ->
  for gyazz, slack of icons
    str = str.replace(new RegExp("\\[\\[#{gyazz}\\.icon\\]\\]", "g"), " :#{slack}: ")
    reg = new RegExp "\\[\\[#{gyazz}\\.icon[\\*x]([1-9][0-9]*)(|\\.[0-9]+)\\]\\]", "g"
    str = str.replace reg, (src, p1, p2) ->
      ' ' + ":#{slack}:".repeat(p1-0) + ' '
  return str

remove_gyazz_markup = (str, left='【', right='】') ->
  str.split(/(\[{2,3}[^\[\]]+\]{2,3}]|[\r\n]+)/).map (i) ->
    if /(\[{2,3}(.+)\]{2,3})/.test i
      if /\[{2,3}(https?:\/\/.+)\]{2,3}/.test i
        return i.replace(/\[{2,3}/g, " ").replace(/\]{2,3}/g, " ")
      else
        return i.replace(/\[{2,3}/g, left).replace(/\]{2,3}/g, right)
    return i
  .join ''


Gyazz = class Gyazz

  constructor: (@url) ->

  get_page_list: (wiki_name, callback = ->) ->
    feedparser = new FeedParser
    req = request
      method: 'GET'
      uri: encodeURI "#{@url}/#{wiki_name}/rss.xml"
      timeout: 10000
      headers:
        'User-Agent': 'hubot'
      auth: if process.env.GYAZZ_PASS and process.env.GYAZZ_USER
        user: process.env.GYAZZ_USER
        pass: process.env.GYAZZ_PASS

    req.on 'error', (err) ->
      callback err

    req.on 'response', (res) ->
      if res.statusCode isnt 200
        return callback "statusCode: #{res.statusCode}"
      this.pipe feedparser

    feedparser.on 'error', (err) ->
      callback err

    feedparser.on 'data', (chunk) ->
      callback null, chunk.title

  get_page: (wiki_name, page_name, callback = ->) ->
    request
      method: 'GET'
      uri: encodeURI "#{@url}/#{wiki_name}/#{page_name}/json"
      timeout: 10000
      headers:
        'User-Agent': 'hubot'
      auth: if process.env.GYAZZ_PASS and process.env.GYAZZ_USER
        user: process.env.GYAZZ_USER
        pass: process.env.GYAZZ_PASS
    , (err, res, body) ->
      if err
        return debug err
      if res.statusCode isnt 200
        return debug "statusCode: #{res.statusCode}"
      try
        page = JSON.parse body
      catch
        return callback "json parse error"
      callback null, page
