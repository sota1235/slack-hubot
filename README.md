# 増井研Hubot

[![Circle CI](https://circleci.com/gh/masuilab/slack-hubot.svg?style=svg)](https://circleci.com/gh/masuilab/slack-hubot)


### ソースコード
- https://github.com/masuilab/slack-hubot

### 運用

- Herokuで運用中
  - http://masuilab-hubot2.herokuapp.com
  - @TakumiBaba @shokai @nekobato が管理している
  - コラボレータになりたい人はherokuアカウントを取ってメアド教えてください
- Travis-CIでテスト
  - https://travis-ci.org/masuilab/slack-hubot
  - テスト通ったmasterブランチが自動的にHerokuにデプロイされる

### ログを見る

    % heroku logs --tail


## 開発する

### このhubotにスクリプトを追加する場合

1. `npm install`でライブラリをインストール
2. `scripts/`ディレクトリにプラグインを書く
3. `bin/hubot`実行、ローカルでチャットを起動する
4. コマンドを入力して動作確認

- [Scriptingガイド](https://github.com/github/hubot/blob/master/docs/scripting.md)


### ローカルで起動

debug npmを使っているので、環境変数DEBUGでデバッグメッセージが制御できます

    % DEBUG=hubot* bin/hubot  # shellで実行、slackには接続されない

Slackの[API Token](https://masuilab.slack.com/services)とアダプタを指定して起動すると、ローカルのhubotをSlackに接続できる

    % DEBUG=hubot* HUBOT_SLACK_TOKEN=a1b2cdef-jkl789 bin/hubot -a slack


### npmとして実装し、このhubotにインストールする

`external-scripts.json`と`package.json`を編集し、プルリクください

[hubot-sfc-bus](https://github.com/shokai/hubot-sfc-bus)や[hubot-rss-reader](https://github.com/shokai/hubot-rss-reader)が参考になると思う

## TEST
今のところcoffeelintを通すのみ

    % npm test
    # or
    % grunt


## DEPLOY

Travis-CIでテスト通ったmasterブランチが自動的にHerokuにデプロイされます


### プルリクください

- masuilab/slack-hubotにブランチ切ってプルリク
- 自分のリポジトリにcloneしてプルリク

どっちでも良い


### 自分でHerokuをいじりたい
管理者にきいてコラボレーターに入れてもらってください。


## masuilab-hubotとは別にHeroku建ててデプロイする方法

    % heroku create
    % git push heroku master

    % heroku config:set HEROKU_URL=http://(app_name).herokuapp.com
    % heroku config:set NODE_ENV=production
    % heroku config:add TZ=Asia/Tokyo
    % heroku addons:add mongolab
    % heroku config:set 'DEBUG=*'

### slack設定

slackでhubotのインテグレーションを追加して、tokenをもらう

    % heroku config:set HUBOT_SLACK_TOKEN=(取得したtoken)


### githubotの設定

認証してGitHub APIのtokenをもらう
https://github.com/iangreenleaf/githubot#authentication


    % heroku config:set HUBOT_GITHUB_TOKEN=(取得したtoken)
    % heroku config:set HUBOT_GITHUB_ISSUE_REPO=masuilab/todo
