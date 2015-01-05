# Description:
#   Gyazz更新通知
#   /hubot/gyazz-webhook へのPOSTリクエストを受信
#
# Dependencies:
#   "diff":  "*"
#   "debug": "*"
#
# Author:
#   @shokai

Diff = require 'diff'
debug = require('debug')('hubot:gyazz-notify')

config =
  room: "news"
  header: ":star:"
  interval: 60000

timeout_cids = {}

module.exports = (robot) ->

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


  notify = (url, wiki, title, text, room) ->
    url = "#{url}/#{wiki}/#{title}".replace /[\s<>]/g, (c) -> encodeURI(c)
    cache = robot.brain.get url
    robot.brain.set url, text

    unless cache?.length > 0
      text = remove_gyazz_markup(text).trim()
      debug notify_text = "#{config.header} 《新規》#{url} 《#{wiki}/#{title}》\n#{text}"
      robot.send {room: room}, notify_text
    else
      addeds = []
      for block in Diff.diffLines cache, text
        if block.added
          addeds.push remove_gyazz_markup block.value.trim()
      if addeds.length < 1
        return
      debug notify_text = "#{config.header} 《更新》#{url} 《#{wiki}/#{title}》\n#{addeds.join('\n')}"
      robot.send {room: room}, notify_text


remove_gyazz_markup = (str, left='【', right='】') ->
  str.split(/(\[{2,3}[^\[\]]+\]{2,3}]|[\r\n]+)/).map (i) ->
    if /(\[{2,3}(.+)\]{2,3})/.test i
      if /\[{2,3}(https?:\/\/.+)\]{2,3}/.test i
        return i.replace(/\[{2,3}/g, " ").replace(/\]{2,3}/g, " ")
      else
        return i.replace(/\[{2,3}/g, left).replace(/\]{2,3}/g, right)
    return i
  .join ''
