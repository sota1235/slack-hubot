request = require 'request'
async = require 'async'
url = "http://node-linda-base.herokuapp.com"

spaces = ["delta", "iota", "tau", "masuilab", "shokai"]

say = (space, str, callback = ->) ->
  post_data = {
    url: "#{url}/#{space}",
    form: {tuple: JSON.stringify({type: "say", value: str})}
  }
  request.post post_data, callback

module.exports = (robot) ->
  robot.respond /([a-z_\-]+) say ([^\s]+)/i, (msg) ->
    space = msg.match[1]
    str = msg.match[2]
    say space, str, (err, res) ->
      if err
        msg.send "#{space}に「#{str}」って言うの失敗した"
        return
      msg.send "#{space}に「#{str}」って言っといてやったわ、感謝しなさい"

  robot.respond /say ([^\s]+)/i, (msg) ->
    str = msg.match[1]
    async.map spaces, (space, callback) ->
      say space, str, callback
    , (err, res) ->
      if err
        msg.send "#{spaces.join('と')}に「#{str}」って言うの失敗した"
        return
      msg.send "#{spaces.join('と')}に「#{str}」って言っといてやったわ、感謝しなさい"
