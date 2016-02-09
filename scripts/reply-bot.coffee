# Description:
#   腹が減ったらカレーメシ、のようなリプライをする
#
# Author:
#   @shokai

_ = require 'lodash'

config =
  カレーメシ:
    hear: [
      /カレー/i
      /curry/i
      /(おなか|ハラ|はら|腹)/i
    ]
    reply: [
      'カレーメシ！！'
      'ボーキメシ！！'
      'ジャッスティス！！！'
      'http://www.currymeshi.com'
      'http://gyazo.com/fc6c4a6f74d41ee472948c35d7ab1d45.png'
      'https://www.youtube.com/watch?v=vhSBtoviSKw'
    ]
    ratio: 0.3
  かず:
    hear: [
      /^かず$/i
    ]
    reply: [
      'かずすけ'
      'かずどん'
      'カーズ様'
      'キングカズ'
      'かずお'
      ':kazudon:'
      ':kazusuke:'
      'ガズ皇帝'
      '何度言わせるのよ、このクズ！！'
      '\n:kazudon1-1::kazudon1-2::kazudon1-3::kazudon1-4::kazudon1-5::kazudon1-6::kazudon1-7::kazudon1-8:\n:kazudon2-1::kazudon2-2::kazudon2-3::kazudon2-4::kazudon2-5::kazudon2-6::kazudon2-7::kazudon2-8:\n:kazudon3-1::kazudon3-2::kazudon3-3::kazudon3-4::kazudon3-5::kazudon3-6::kazudon3-7::kazudon3-8:'
    ]
  ちくわ:
    hear: [
      /ちくわ/i
      /竹輪/i
      /筑摩/i
    ]
    reply: [
      'http://tiqav.com/1aM.jpg'
      'http://tiqav.com/1de.jpg'
    ]
  進捗:
    hear: [
      /進捗/i
    ]
    reply: [
      'http://gyazz.com/upload/0812c2f2a5aaa0456243cad84ff93a51.gif'
      'http://gyazz.com/upload/2443a25d349ea480c5d511cfbf39292a.png'
    ]
  PHP:
    hear: [
      /PHP/i
    ]
    reply: [
      'php..ﾏｽﾄﾀﾞｰｲ..'
      '殺せ、PHPだ'
      'PHPを使うものは腹を切って死ぬべきである。詳しくは http://gyazz.com/増井研/PHP を読んで熟知すべし'
      'PHPもいいところあるんですよぉ'
      'sudo rm /usr/bin/php'
      'その、拡張子でPHP使ってる事アピールするの何か意味あるんですか？'
      'PHP is evil'
      'http://gyazo.com/c0e830968217f4c41ab6e0c7ded1a62c.png'
      'http://gyazo.com/358c5cdb80388d51c0c8fac9a3fc08fe.png'
      'https://38.media.tumblr.com/tumblr_lul2zbQ3w41qz5devo1_400.gif'
    ]
  質問:
    hear: [
      /わからない$/
      /わからん/
      /(教|おし)えて/
    ]
    reply: [
      'ぐぐれカス〜'
      'http://gyazo.com/205adeb36e6542c6db29f571452166fa.png'
      'まあ落ち着け http://games.kids.yahoo.co.jp/sports/013.html'
      'コード書けばいいじゃん'
      'hubot 教えて [単語] で調べれるよ'
      'https://gyazo.com/cf539d217b04a907c0a2ebe700479f2a.png'
      'https://gyazo.com/4782005540d5f7f1f08d7b5a2650d0a7.png'
    ]
    ratio: 0.1
  いくつ:
    hear: [
      /いくつ/
      /何個/
    ]
    reply: (msg) -> "#{Math.floor(Math.random()*10)+1}個でじゅうぶんですよ"
    ratio: 1
  shuffle:
    hear: [
      /(.+)$/
    ]
    reply: (msg) ->
      text = msg.match[0]
      if text.length > 3 and text.length < 10
        _.shuffle(text.split('')).join('')
    ratio: 0.005
  gist:
    hear: [
      /gist.github/
    ]
    reply: [
      'ずいぶんとダサいコードを書いているのね'
    ]
    ratio: 0.2
  かずすけ:
    hear: [
      /(.*忘年会.*)$/
      /(.*新年会.*)$/
      /(.*飲み会.*)$/
      /(.*呑み会.*)$/
      /(.*肉.*)$/
    ]
    reply: [
      'かず'
      'かずすけ？'
      'すけかず'
      'かずのすけ'
      '金のホルモン'
      'マルチョウ'
      (msg) -> "かずすけ「#{msg.match[0]}」"
      'はい、湘南台かずすけです'
      'http://blog.naotaco.com/archives/197'
      'http://tabelog.com/kanagawa/A1404/A140405/14018634/'
      'https://www.flickr.com/photos/shokai/8178681503/'
      'https://www.flickr.com/photos/shokai/7575397070/'
      'https://www.flickr.com/photos/shokai/5148760554/'
    ]
    ratio: 0.6
  小竹向原:
    hear: [
      /小竹向原/
      /kotakemukaihara/
      /佐竹/
    ]
    reply: [
      'https://gyazo.com/575ea914c736ee510b90f831775d131d.png'
      'https://gyazo.com/ec5a00201b3ee41de58bb0fe8f827090.png'
      ':kotakemukaihara:'
    ]
    ratio: 0.8

module.exports = (robot) ->

  for name, data of config
    robot.logger.info "configure reply bot: #{name}"
    do (data) ->
      for regex in data.hear
        robot.hear regex, (msg) ->
          return if (data.ratio or 1) < Math.random()
          who = msg.message.user.name
          text = null
          if typeof data.reply is 'function'
            text = data.reply msg
          if data.reply instanceof Array
            text = _.sample data.reply
            if typeof text is 'function'
              text = text msg

          return unless text
          msg.send "@#{who} #{text}"
