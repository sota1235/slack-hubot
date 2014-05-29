request = require 'request'
url = "http://node-linda-base.herokuapp.com"

module.exports = (robot) ->
  robot.hear /([a-z_\-]+) say (.*)/i, (msg) ->
    space = msg.match[1]
    word = msg.match[2]

    post_data = {
      url: "#{url}/#{space}",
      form: {tuple: JSON.stringify({type: "say", value: word})}
    }
    request.post post_data, (req,res) ->
      msg.send word
