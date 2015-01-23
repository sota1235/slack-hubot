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
      /(教|おし)えて/
    ]
    reply: [
      'ぐぐれカス〜'
      'http://gyazo.com/205adeb36e6542c6db29f571452166fa.png'
    ]
  松岡修造:
    hear: [
      /(辛|つら)い/
      /死にたい/
      /しにたい/
      /(辞|や)めたい/
      /(泣|な)きたい/
      /しんどい/
      /(逃|に)げたい/
    ]
    reply: [
      "じゃんけんの必勝法は、強く握り締めたグーを出すこと！"
      "ダメダメダメ!諦めたら!周りのこと思えよ、応援してる人たちのこと思ってみろって!あともうちょっとのところなんだから!"
      "気にすんなよ！くよくよすんなよ！大丈夫、どうにかなるって！ドントウォーリー！ビーハッピー！"
      "やがて僕のレベルも知らず知らずに上がっていった。なぜなら、僕が戦う相手は、いつも自分より強かったからである！"
      "一所懸命生きていれば、不思議なことに疲れない！"
      "人もテニスも、ラブから始まる!!"
      "褒め言葉よりも苦言に感謝！"
      "僕こそがテニスの王子様!!"
      "独りで苦しんでるんだろう辛いだろう？暗いんだろう？じゃあエースをねらえを歌ってみろよ！！！\nhttps://www.youtube.com/watch?v=2FtI06YX4cg"
      "みんな！！竹になろうよ！ バンブー！！！"
      "崖っぷちありがとう！！最高だ！！"
      "頑張れ頑張れそこだそこだ諦めるな！絶対に頑張れ積極的にポジティヴに頑張れ！！北京だって頑張ってるんだから！！！"
      "頑張れ頑張れそこだそこだ諦めるな！"
      "絶対に頑張れ積極的にポジティヴに頑張れ！！"
      "北京だって頑張ってるんだから！！！"
      "もっと熱くなれよ!!"
      "熱い血燃やしてけよ！"
      "人間熱くなった時が本当の自分に出会えるんだ！！"
      "もっと熱くなれよおおおおおおおおおお！！！"
      "予想外の人生になっても、そのとき、幸せだったらいいんじゃないかな。"
      "勝ち負けなんか、ちっぽけなこと。大事なことは、本気だったかどうかだ！"
      "ナイスボレー、修造！"
      "反省はしろ！後悔はするな！"
      "自分を好きになれ！"
      "ネクストタイム！"
      "緊張してきた。よっしゃあ！！"
      "一番になるっていったよな？日本一なるっつったよな！ぬるま湯なんかつかってんじゃねぇよお前！！"
      "苦しいか？修造！笑え！"
    ]


module.exports = (robot) ->

  for name, data of config
    robot.logger.info "configure reply bot: #{name}"
    do (data) ->
      for regex in data.hear
        robot.hear regex, (msg) ->
          who = msg.message.user.name
          text = _.sample data.reply
          msg.send "@#{who} #{text}"
