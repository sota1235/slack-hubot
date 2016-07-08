# Description:
#   New Gyazz notification
#
# Author:
#   @shokai

config =
  room: "news"
  header: ":sake:"

module.exports = (robot) ->
  robot.router.post '/gyazz-update', (req, res) ->
    {text, attachments, mrkdwn, username} = req.body
    unless text && attachments && attachments.length > 0 && mrkdwn && username
      return res.status(400).send 'bad request'
    room = req.query.room or config.room
    res.end 'ok'

    for att in attachments
      if att.title_link
        text = "#{config.header} #{att.title_link}\n"
        text += replace_slackMarkup(att.text.trim()) if att.text
        robot.send {room}, text
      if att.image_url
        robot.send {room}, att.image_url


replace_slackMarkup = (str) ->
  str.replace /<([^<>\|]+)\|([^<>\|]+)>/g, (_, url, title) ->
    return url if url is title
    return "【#{title}】 "if /https?:\/\/gyazz-clone/.test(url)
    url = url.replace(/ /g, '%20') if /https?:\/\/.+/.test(url)
    return url + ' ' + title
