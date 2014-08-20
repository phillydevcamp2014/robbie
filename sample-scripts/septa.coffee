# Description
#   Allows Hubot to give you real-time schedule information for trips on 
#   SEPTA's regional rail system.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot next train from <source> to <destination>
#   hubot next <integer> trains from <source> to <destination>
#   hubot stop <stopid> - Returns the next 4 scheduled bus/trolleys at specified station.
#   hubot stop <stopid> <routeid> - Returns only bus/trolleys at station for specified route.
#   hubot stop <stopid> <routeid> <direction i/o> - Returns only inbound/outbound routes
#
# Notes:
#   Station names must match SEPTA's standard. The list of valid station can be 
#   found here - http://opendataphilly.org/opendata/resource/171/septa-next-to-arrive/
#   Stop IDs can be found here: http://www3.septa.org/stops/
#
# Author:
#   eoconnell
#   mheadd
#   zivtech

module.exports = (robot) ->
  robot.respond /next train from (.*) to (.*)/i, (msg) ->
    next_to_arrive msg, escape(msg.match[1]), escape(msg.match[2])
  robot.respond /next ([1-9][0-9]*) trains from (.*) to (.*)/i, (msg) ->
    next_to_arrive msg, escape(msg.match[2]), escape(msg.match[3]), msg.match[1]
  robot.respond /stop( me)?( \d{1,6})( \d{1,6})?( [a-z]{1})?/i, (msg) ->
    stopid = msg.match[2].replace /^\s+/g, ""
    routeid = if msg.match[3]? then msg.match[3].replace /^\s+/g, "" else ""
    direction = if msg.match[4]? then msg.match[4].replace /^\s+/g, "" else ""
    msg.http("http://www3.septa.org/sms/#{stopid}/#{routeid}/#{direction}")
      .get() (error, res, body) ->
        if error
          msg.reply "Unable to fetch data. Got HTTP status #{statusCode}"
        else
          msg.send body

next_to_arrive = (msg, source, destination, limit = 1) ->
  limit = 5 if limit > 5
  url = "http://www3.septa.org/hackathon/NextToArrive"
  msg.http("#{url}/#{source}/#{destination}/#{limit}")
    .get() (err, res, body) ->
      json = JSON.parse body

      if !json.length
        msg.reply "Couldn't find any trains for that route."

      for train in json
        msg.reply "SEPTA train #{train.orig_train} leaves at #{train.orig_departure_time} and arrives at #{train.orig_arrival_time} (#{train.orig_delay})."
