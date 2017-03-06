# Description:
#   encodeされたURLを日本語に戻す
#
# Author:
#   @shokai

module.exports = (robot) ->

  robot.hear /(https?:\/\/[^ \r\n]+)/i, (msg) ->

    who = msg.message.user.name
    url = msg.match[1]
    url_decoded = decodeURI(url).replace /[ <>]/g, (c) -> encodeURI c
    return if url is url_decoded
    msg.send "@#{who} 日本語でおｋ\n`#{url_decoded}`"
