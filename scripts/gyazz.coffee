# Description:
#   Gyazz更新通知
#
# Author:
#   @shokai

config =
  slack:
    room: "#news"
    header: ":star:"

module.exports = (robot) ->

  robot.router.post '/hubot/gyazz-webhook', (req, res) ->
    res.send 'ok'
    wiki = req.body.wiki
    title = req.body.title

    url = "#{req.body.url}/#{wiki}/#{title}".replace(' ', '%20')
    text = "#{config.slack.header} 《更新》#{url} 《#{req.body.wiki}》"
    robot.send {room: config.slack.room}, text
