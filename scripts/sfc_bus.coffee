_       = require 'lodash'
cheerio = require 'cheerio'
request = require 'request'

stops =
  "湘南台":
    "湘南台駅発 慶応大学行": "http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000801156-1/rt:0/nid:00129893/dts:1403028000"
    "本館前発 湘南台駅行": "http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000800141-1/rt:0/nid:00129986/dts:1403028000"
    "慶応大学発 湘南台駅行": "http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000800141-2/rt:0/nid:00129985/dts:1403028000"
  "辻堂":
    "慶応大学発 辻堂駅行": "http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000801121-2/rt:0/nid:00129985/dts:1403028000"
    "本館前発 辻堂駅行": "http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000801121-1/rt:0/nid:00129986/dts:1403028000"
    "辻堂駅発 SFC行": "http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000800267-1/rt:0/nid:00129934/dts:1403028000"


## 路線名で検索
getScheduleOfLines = (line, callback = ->) ->
  unless stops.hasOwnProperty line
    callback "#{line}、そんな名前の路線知らない"
    return
  for name, url of stops[line]
    do (name, url) ->
      getScheduleOfBusStop url, (err, schedule) ->
        callback err, {name: name, schedule: schedule}


getScheduleOfBusStop = (url, callback = ->) ->
  request url, (err, res, body) ->
    if err
      callback err
      return
    $ = cheerio.load(body)
    schedule = {}
    for selector in ['tr.row1', 'tr.row2']
      $(selector).each (i, tr) ->
        hour = $(tr).children('th').text() - 0
        tds = $(tr).children('td')
        for day, index in ['平日', '土曜', '休日']
          minutes = $(tds.get(index)).html().match(/>\d+</g)?.map (i) -> i.replace(/[><]/g,'') - 0
          unless schedule[hour]
            schedule[hour] = {}
          schedule[hour][day] = minutes
    callback null, schedule

getDay = ->
  return switch new Date().getDay()
    when 0 then "休日"
    when 6 then "土曜"
    else "平日"


module.exports = (robot) ->
  robot.respond /(バス|bus)\s+(.+)/i, (msg) ->
    where = msg.match[2]
    getScheduleOfLines where, (err, res) ->
      if err
        msg.send err
        return
      hour = new Date().getHours()+3
      response = "#{res.name} #{getDay()}"
      for h in [hour, hour+1]
        minutes = res.schedule[h]?[getDay()]?.map (i) ->
          "#{i}分"
        .join(' ') or 'なし'
        response += "\n#{h}時:  #{minutes}"
      msg.send response
