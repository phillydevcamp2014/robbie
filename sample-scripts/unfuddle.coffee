# Description:
#   Allows Hubot to collect and set data from Unfuddle.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   <unfuddle ticket url> - Gets the summary of a ticket.
#   <ticket number> - Respond to #<number> by trying to look up a ticket in the current project and providing
#   unfuddle search <search query> - Searches tickets for the project associated with this room.
#   unfuddle track time <optional date formatted [month]/[day]> #<ticket number> <number of hours in decimal> 
#   unfuddle list projects <optional query> - Provide a list of unfuddle projects and optionally filter by the
#   unfuddle project <project id> - Maps this chat room to a particular unfuddle project.
#   unfuddle forget room - Dissosociate a room from an unfuddle project.
#   I am unfuddle user <user id> - Associates your chat user with a particular user id in unfuddle.
#   forget my unfuddle user - Dissosociate a chat user from an unfuddle user.
#   <description> - Track time to a ticket in this room's project
#
# Author:
#   zivtech

module.exports = (robot) ->

  username = process.env.HUBOT_UNFUDDLE_USER
  password = process.env.HUBOT_UNFUDDLE_PASS
  base = process.env.HUBOT_UNFUDDLE_URL
  url = base + ".unfuddle.com"

  robot.brain.data.unfuddle ?= {}
  robot.brain.data.unfuddle.room ?= {}

  request = require('request')

  # Respond to any ticket link posted into a chat by providing the title.
  robot.hear /.*unfuddle.com.*\/projects\/([0-9]+)\/tickets\/(by_number\/)?([0-9]+)/i, (msg) ->
    projectId = msg.match[1]
    ticketNumber = msg.match[3]
    byNumber = if msg.match[2] then msg.match[2] else ''
    requestUri = "/api/v1/projects/#{projectId}/tickets/#{byNumber}#{ticketNumber}"
    options =
      url: "https://#{username}:#{password}@#{url}#{requestUri}"
      json: true
    request options, (error, response, ticket) ->
      if error or response.statusCode != 200
        msg.send 'Hey buddy, I think you have a typo there...'
        console.log error
        console.log response
      else
        msg.send "Ticket ##{ticket.number}: #{ticket.summary}"

  # Respond to any #<number> by trying to look up a ticket in the current project and providing a link and description
  robot.hear /#([0-9]+)/, (msg) ->
    if msg.message.user.name == 'Jenkins'
      return
    if robot.brain.data.unfuddle.room[msg.message.user.room]
      ticketNumber = msg.match[1]
      projectId = robot.brain.data.unfuddle.room[msg.message.user.room]
      requestUri = "/api/v1/projects/#{projectId}/tickets/by_number/#{ticketNumber}"
      options =
        url: "https://#{username}:#{password}@#{url}#{requestUri}"
        json: true
      request options, (error, response, ticket) ->
        if response.statusCode == 200
          msg.send "Ticket ##{ticketNumber}: #{ticket.summary} - https://#{url}/projects/#{projectId}/tickets/by_number/#{ticketNumber}"
    else
      msg.send 'You haven\'t told me what project to use in this chat room...'

  # Provide a list of unfuddle projects
  projectLister = (msg) ->
    requestUri = "/api/v1/projects"
    options =
      url: "https://#{username}:#{password}@#{url}#{requestUri}"
      json: true
    request options, (error, response, projects) ->
      if response.statusCode == 200
        answers = []
        if msg.match[2]
          query = msg.match[2]
          answers.push "##{project.id}: #{project.title}" for project in projects when (project.title.toLowerCase().lastIndexOf(query.toLowerCase(), 0) == 0)
        else
          answers.push "##{project.id}: #{project.title}" for project in projects
        msg.send answers.join '\n'

  robot.hear /(uf|unfuddle) list projects? ?(.*)/i, projectLister
  robot.hear /(uf|unfuddle) project list? ?(.*)/i, projectLister

  # Allow a chat room to be associated with an unfuddle project by id
  robot.respond /((uf|unfuddle) project )([0-9]+)/i, (msg) ->
    requestUri = "/api/v1/projects/#{msg.match[3]}"
    options =
      url: "https://#{username}:#{password}@#{url}#{requestUri}"
      json: true
    request options, (error, response, body) ->
      if response.statusCode == 200
        robot.brain.data.unfuddle.room[msg.message.user.room] = msg.match[3]
        msg.reply "Ok, from now on I'll remember that room #{msg.message.user.room} is for project #{body.title} (#{msg.match[3]})."
      else
        msg.reply 'Hrm, I didn\'t find a project for that ID.'

  # Search the current project for tickets.
  robot.respond /((uf|unfuddle) search )(.*)/i, (msg) ->
    if robot.brain.data.unfuddle.room[msg.message.user.room]
      projectId = robot.brain.data.unfuddle.room[msg.message.user.room]
      requestUri = '/api/v1/projects/' + projectId + '/search'
      options =
        url: "https://#{username}:#{password}@#{url}#{requestUri}"
        json:
          filter: ['tickets']
          query: msg.match[3]
      request options, (error, response, body) ->
        if response.statusCode == 200
          answers = []
          answers.push "#{ticket.title} - https://#{url}#{ticket.location}" for ticket in body
          msg.send answers.join '\n'
        else
          msg.reply 'Hrm, I didn\'t find any matches in this project...'
    else
      msg.reply 'I forgot again.  What room is this?'

  # Dissosociate a room from an unfuddle project.
  robot.respond /((uf|unfuddle) forget room)/i, (msg) ->
    if robot.brain.data.unfuddle.room[msg.message.user.room]
      robot.brain.data.unfuddle.room[msg.message.user.room] = null
      msg.reply 'I seem to have forgotten what project we were talking about...'

  robot.respond /(i am (uf|unfuddle) user )([0-9]+)/i, (msg) ->
    requestUri = "/api/v1/people/#{msg.match[3]}"
    options =
      url: "https://#{username}:#{password}@#{url}#{requestUri}"
      json: true
    request(options, (error, response, account) ->
      if response.statusCode == 200
        msg.message.user.unfuddleUser = account.username
        msg.message.user.unfuddleId = account.id
        msg.reply "Ok, from now on I'll remember that you are unfuddle user #{account.username} (#{account.id})."
      else
        msg.reply "Hrm, I didn't find a user for that ID."
    )

  # Dissosociate a chat user from an unfuddle user.
  robot.respond /(forget my unfuddle user)/i, (msg) ->
    user = msg.message.user
    user.unfuddleId = null
    user.unfuddleUser = null
    msg.reply "Ok, I have no idea who you are on unfuddle anymore."

  # Track time to a ticket in this room's project
  robot.respond /(uf|unfuddle) (tt|time tracking) (([0-9]+)\/([0-9]+))?.*#([0-9]+) ([0-9]+?[.]?[0-9]*) (.*)/i, (msg) ->
    if msg.message.user.unfuddleId
      personId = msg.message.user.unfuddleId
    else
      msg.reply 'You haven\'t told me your unfuddle user id.'
      return
    if robot.brain.data.unfuddle.room[msg.message.user.room]
      projectId = robot.brain.data.unfuddle.room[msg.message.user.room]
      ticketNumber = msg.match[6]
      hours = msg.match[7]
      description = msg.match[8]
      requestUri = "/api/v1/projects/#{projectId}/tickets/by_number/#{ticketNumber}"
      options =
        url: "https://#{username}:#{password}@#{url}#{requestUri}"
        json: true
      request options, (error, response, ticket) ->
        if response.statusCode == 200
          if ticket.id
            requestUri = '/api/v1/projects/' + projectId + '/tickets/' + ticket.id + '/time_entries'
            date = new Date()
            month = if msg.match[4] then msg.match[4] else date.getUTCMonth() + 1
            if month.toString().length == 1
              month = "0#{month}"
            day = date.getDate()
            day = if msg.match[5] then msg.match[5] else date.getDate()
            if day.toString().length == 1
              day = "0#{day}"
            formattedDate = date.getFullYear() + "-#{month}-#{day}"
            # Yeah, I know this is gross but the unfuddle json api doesn't seem to work properly for posting time.
            body = "<time-entry><date type=\"date\">#{formattedDate}</date><description>#{description}</description><hours type=\"float\">#{hours}</hours><person-id type=\"integer\">#{personId}</person-id><ticket-id type=\"integer\">#{ticket.id}</ticket-id></time-entry>"
            options =
              method: 'POST'
              url: "https://#{username}:#{password}@#{url}#{requestUri}"
              headers:
                'Content-Type': 'application/xml'
                'Accept:': 'application/xml'
              body: body
            request options, (error, response, body) ->
              if response.statusCode == 201
                msg.reply 'I logged you ' + hours + ' on ticket #' + ticketNumber + ' doing ' + description
              else
                msg.reply "Logging time failed!  I don't even know why!?"
        else
          msg.reply 'Hrm, I didn\'t find a project for that ID.'

    else
      msg.reply 'You haven\'t told me what project to use in this chat room...'
