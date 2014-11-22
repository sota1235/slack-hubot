# Description:
#   create github issue
#
# Author:
#   @shokai

debug = require('debug')('hubot-github-issue')

module.exports = (robot) ->
  github = require('githubot')(robot)

  ## list issue
  robot.respond /issue$/i, (msg) ->
    debug "get issues list"
    github.get 'https://api.github.com/repos/masuilab/todo/issues', {}, (issues) ->
      issues = issues.sort (a,b) -> a.number > b.number
      texts = ["https://github.com/masuilab/todo/issues"]
      for i in issues
        texts.push "[#{i.number}] #{i.title}"
      debug texts
      msg.send texts.join '\n'

  ## create issue
  robot.respond /issue (.+)$/mi, (msg) ->
    who = msg.message.user.name
    body = msg.match[1]
    debug "create issue #{body}"
    query_param =
      title: body
      body: "#{body}\n\ncreated by #{who} & hubot"
      labels: ["fromHubot"]
    github.post 'https://api.github.com/repos/masuilab/todo/issues', query_param
    , (issue) ->
      text = issue.html_url or "issue create error"
      debug text
      msg.send text

