# Description:
#   None
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
#   cgarvis

module.exports = (robot) ->
  robot.respond /^(sweet|dude)!/i, (msg) ->
    switch msg.match[1].toLowerCase()
      when "sweet" then msg.send "Dude!"
      when "dude" then msg.send "Sweet!"
