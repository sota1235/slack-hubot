# Description:
#   Gyazz更新通知
#
# Dependencies:
#   "diff": "*"
#
# Author:
#   @shokai

Diff = require 'diff'

config =
  slack:
    room: "#news"
    header: ":star:"

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

    url = "#{url}/#{wiki}/#{title}".replace(' ', '%20')
    cache = robot.brain.get url
    robot.brain.set url, text

    unless cache?.length > 0
      notify_text = "#{config.slack.header} 《新規》#{url} 《#{req.body.wiki}》\n#{text}"
      robot.send {room: config.slack.room}, notify_text
    else
      addeds = []
      for block in Diff.diffLines cache, text
        if block.added
          addeds.push block.value.trim()
      if addeds.length < 1
        return
      notify_text = "#{config.slack.header} 《更新》#{url} 《#{req.body.wiki}》\n#{addeds.join('\n')}"
      robot.send {room: config.slack.room}, notify_text
