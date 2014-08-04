# Description:
#   Gyazz更新通知
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
  room: "#news"
  header: ":star:"
  interval: 60000

timeout_cids = {}

module.exports = (robot) ->

  robot.router.post '/hubot/gyazz-webhook', (req, res) ->
    url   = req.body.url
    wiki  = req.body.wiki
    title = req.body.title
    text  = req.body.text
    unless wiki? and title? and text? and url?
      res.status(400).send 'bad request'
      return

    res.send 'ok'

    debug key = "#{url}/#{wiki}/#{title}"

    clearTimeout timeout_cids[key]
    timeout_cids[key] = setTimeout ->
      notify url, wiki, title, text
    , config.interval


  notify = (url, wiki, title, text) ->
    url = "#{url}/#{wiki}/#{title}".replace(' ', '%20')
    cache = robot.brain.get url
    robot.brain.set url, text

    unless cache?.length > 0
      debug notify_text = "#{config.header} 《新規》#{url} 《#{wiki}》\n#{text}"
      robot.send {room: config.room}, notify_text
    else
      addeds = []
      for block in Diff.diffLines cache, text
        if block.added
          addeds.push block.value.trim()
      if addeds.length < 1
        return
      debug notify_text = "#{config.header} 《更新》#{url} 《#{wiki}》\n#{addeds.join('\n')}"
      robot.send {room: config.room}, notify_text
