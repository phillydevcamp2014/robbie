# Description:
#   Grabs a random color from colourlovers
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot color
#
# Author:
#   lablayers

getColor = (msg) ->
  msg.http('http://www.colourlovers.com/api/colors/random?format=json')
    .get() (err, res, body) ->
      results = JSON.parse(body)
      if results.error
        msg.send "error"
        return
      msg.send "Here's a badge URL: #{results[0].badgeUrl}"

module.exports = (robot) ->
  robot.respond /color$/i, (msg) ->
    getColor(msg)
