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
    ]
    ratio: 0.1

module.exports = (robot) ->

  for name, data of config
    robot.logger.info "configure reply bot: #{name}"
    do (data) ->
      for regex in data.hear
        robot.hear regex, (msg) ->
          return if (data.ratio or 1) < Math.random()
          who = msg.message.user.name
          text = _.sample data.reply
          msg.send "@#{who} #{text}"
