# 増井研Hubot

### ソースコード
- https://github.com/masuilab/slack-hubot

### herokuで運用中

- http://masuilab-hubot.herokuapp.com/
- @TakumiBaba @shokai が管理している


## DEVELOP

1. `scripts/`ディレクトリにプラグインを書く
2. `bin/hubot`実行、ローカルで起動する
3. コマンドを入力して動作確認

- [scripting guide](https://github.com/github/hubot/blob/master/docs/scripting.md)


## DEPLOY

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

