# Description:
#   UXと言われたら1000円と返す
#
# Author:
#   @shokai
#   @nikezono

module.exports = (robot) ->

  reply = (msg) ->

    who = msg.message.user.name
    hash = robot.brain.get('ux') or {}
    hash[who] = (hash[who] or 0) + 1
    robot.brain.set 'ux', hash
    msg.send "@#{who} UX#{hash[who]*1000}円"

  robot.respond /募金$/i, (msg) ->
    texts = ["UX募金 ただいまの募金額"]
    for who, count of robot.brain.get('ux')
      texts.push "@#{who} #{count*1000}円" if count > 0
    msg.send texts.join '\n'

  robot.hear /^(.*ux.*)$/i, (msg) ->
    text = msg.match[1]
    unless /ux/i.test text.replace(/https?:\/\/[^\s]*ux[^\s]*/ig, '')
      return
    reply msg

  register_censor = (word) ->
    robot.hear new RegExp( word.split('').join('.*'), 'i' ), reply

  register_censor 'ユザエクスペリエンス'
  register_censor 'ユザ体験'
  register_censor 'ユエックス'
  register_censor 'userexperience'
