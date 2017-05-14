# Description:
#   UXと言われたら1000円と返す
#
# Commands:
#   hubot 募金
#
# Author:
#   @shokai
#   @nikezono

## 除外する単語
ignores = [
  /https?:\/\/[^\s]*ux[^\s]*/ig
  /flux/ig
  /linux/ig
]

module.exports = (robot) ->

  reply = (msg) ->

    who = msg.message.user.name
    hash = robot.brain.get('ux') or {}
    hash[who] = (hash[who] or 0) + 1
    robot.brain.set 'ux', hash
    msg.send "@#{who} UX#{hash[who]*1000}円"

  robot.respond /募金$/i, (msg) ->
    texts = ["UX募金 ただいまの募金額"]
    counts = []
    for who, count of robot.brain.get('ux')
      count = count-0
      continue if count < 1
      counts.push
        text: "@#{who} #{count*1000}円"
        count: count
    counts.sort (a,b) ->
      a.count < b.count
    .forEach (i) ->
      texts.push i.text

    msg.send texts.join '\n'

  robot.hear /^(.*ux.*)$/i, (msg) ->
    text = msg.match[1]
    for reg in ignores
      text = text.replace reg, '_'
    return unless /ux/i.test text
    reply msg

  register_censor = (word) ->
    robot.hear new RegExp( word.split('').join('.*'), 'i' ), reply

  register_censor 'ユザエクスペリエンス'
  register_censor 'ユザ体験'
  register_censor 'ユエックス'
  register_censor 'userexperience'
