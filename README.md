# 増井研Hubot

[![Build Status](https://travis-ci.org/masuilab/slack-hubot.svg?branch=master)](https://travis-ci.org/masuilab/slack-hubot)


### ソースコード
- https://github.com/masuilab/slack-hubot

### herokuで運用中

- http://masuilab-hubot.herokuapp.com/
- @TakumiBaba @shokai が管理している


## DEVELOP

1. `npm install`でライブラリをインストール
2. `scripts/`ディレクトリにプラグインを書く
3. `bin/hubot`実行、ローカルでチャットを起動する
4. コマンドを入力して動作確認

- [Scriptingガイド](https://github.com/github/hubot/blob/master/docs/scripting.md)


## LINT & TEST

    % npm test
    # or
    % grunt


## DEPLOY

CIが通ったmasterブランチが自動デプロイされます


### プルリクください

- masuilab/slack-hubotにブランチ切ってプルリク
- 自分のリポジトリにcloneしてプルリク

どっちでも良い


### 自分でデプロイしたい
管理者にきいてコラボレーターに入れてもらってください。


### masuilab-hubotとは別にインスタンス建ててデプロイする

    % heroku create
    % git push heroku master

    % heroku config:set NODE_ENV=production
    % heroku config:add TZ=Asia/Tokyo
    % heroku addons:add redistogo:nano

