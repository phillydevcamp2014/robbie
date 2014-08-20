# Description:
#   Grab random recent pearls of wisdom from http://stuff-jody-says.tumblr.com/ 
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   jody me - Grab a random quote from the most recent page of the http://stuff-jody-says.tumblr.com/ rss feed. 
#
# URLS:
#   None
#
# Author:
#   zivtech

module.exports = (robot) ->

  robot.respond /(jody me)/i, (msg) ->
    request = require('request')
    FeedParser = require('feedparser')
    parser = new FeedParser()

    request.get 'http://stuff-jody-says.tumblr.com/rss', (error, response, body) ->
      quotes = []
      parser.parseString body, (error, meta, articles) ->
        article = msg.random articles
        msg.send "(jody) #{article.description}"
