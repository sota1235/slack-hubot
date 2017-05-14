# embed gyazo png image

debug = require('debug')('hubot:gyazo-expand')

module.exports = (robot) ->

  expanded_urls = {}

  robot.adapter.client?.on? 'raw_message', (msg) ->
    return unless msg.type is 'message' and msg.subtype is 'message_changed'
    return unless channel = robot.adapter.client.getChannelByID(msg.channel).name
    return unless msg.message.attachments instanceof Array
    for att in msg.message.attachments
      if !att.image_url and /^https?:\/\/gyazo.com\/[a-z\d]{32}$/.test att.from_url
        unless expanded_urls["#{msg.message.ts}_#{att.from_url}"]
          debug att.from_url
          robot.send {room: channel}, "#{att.from_url}.png"
          expanded_urls["#{msg.message.ts}_#{att.from_url}"] = true
