# Description:
#   Hubot is very attentive (ping hubot)
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#
# Author:
#   zivtech

module.exports = (robot) ->
  robot.hear /beep$/i, (msg) ->
    msg.send "boop"