module.exports = (robot) ->

  robot.router.post "/hubot/deploy", (req, res) ->
    robot.send {room: "#news"}, "デプロイされた"
