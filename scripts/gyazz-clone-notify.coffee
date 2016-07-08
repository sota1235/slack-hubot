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
      text = "#{config.header} #{att.title_link}\n"
      text += att.text.trim() if att.text
      robot.send {room}, text
