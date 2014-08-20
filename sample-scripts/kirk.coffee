# Description:
#   Grab random recent pearls of wisdom from http://www.rikeripsum.com/ipsum/words.txt
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   kirk me - Grab a random quote from the list at http://www.rikeripsum.com/ipsum/words.txt
#
# URLS:
#   None
#
# Author:
#   zivtech

module.exports = (robot) ->
  robot.respond /(kirk me)/i, (msg) ->
    msg.http('http://www.rikeripsum.com/ipsum/words.txt')
      .get() (err, res, body) ->
        quotes = body.split "\n"
        quote = msg.random quotes
        while quote == ''
          quote = msg.random quotes
        msg.send msg.random(['(kirk)', '(kirkyell)']) + ' ' + quote
