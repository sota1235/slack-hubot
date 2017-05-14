# Description:
#   教えて君 の拡張
#
# Author:
#   @shokai

request = require 'request'

get_gyazzpage = (pagename, callback = ->) ->
  url = "http://gyazz.masuilab.org/増井研/#{pagename}"
  request
    method: 'GET'
    url: encodeURI "#{url}/json"
    auth: if process.env.GYAZZ_USER and process.env.GYAZZ_PASS
      user: process.env.GYAZZ_USER
      pass: process.env.GYAZZ_PASS
  , (err, res, body) ->
    if res.statusCode isnt 200
      return callback "status code: #{res.statusCode}"
    try
      page = JSON.parse body
    catch
      return callback "json parse error"
    page.url = url
    callback null, page


remove_gyazz_markup = (str, left='【', right='】') ->
  str.split(/(\[{2,3}[^\[\]]+\]{2,3}]|[\r\n]+)/).map (i) ->
    if /(\[{2,3}(.+)\]{2,3})/.test i
      if /\[{2,3}(https?:\/\/.+)\]{2,3}/.test i
        return i.replace(/\[{2,3}/g, " ").replace(/\]{2,3}/g, " ")
      else
        return i.replace(/\[{2,3}/g, left).replace(/\]{2,3}/g, right)
    return i
  .join ''


module.exports = (robot) ->

  robot.on 'osietekun:ready', (osietekun) ->

    osietekun.on 'response', (msg, res) ->
      for word in res.words
        get_gyazzpage word, (err, page) ->
          if err
            robot.logger.error "get gyazzpage #{word} error - #{JSON.stringify err}"
            return
          if page.data.length > 0
            lines = ["#{page.url} に説明があります (#{page.data.length}行)"]
            lines = lines.concat page.data.splice(0,3).map (line) -> remove_gyazz_markup line
            lines.push '(略)' if page.data.length > 3
            msg.send lines.join '\n'

    osietekun.on 'register:teacher', (msg, query) ->
      get_gyazzpage query.word, (err, page) ->
        if err
          robot.logger.error "get gyazzpage #{query.word} error - #{JSON.stringify err}"
        lines = ["http://gyazz.masuilab.org/増井研/#{query.word} に書いてもいいんだよ"]
        if page.data.length > 0
          lines = lines.concat page.data.splice(0,3).map (line) -> remove_gyazz_markup line
          lines.push '(略)' if page.data.length > 3
        msg.send lines.join '\n'


## for test
if process.argv[1] is __filename
  word = process.argv[2] or 'shokai'
  get_gyazzpage word, (err, page) ->
    console.error err if err
    console.log page
