# Description:
#   Hubot enjoys delicious snacks
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   botsnack - give the bot a food
#
# Author:
#   richo
#   locherm
#   zivtech

responses = [
  "Om nom nom!",
  "That's very nice of you!",
  "Oh thx, have a cookie yourself!",
  "Thank you very much.",
  "Thanks for the treat!",
  ":D",
  "I think I'd rather have drugs..."
  "FOOOOOOOOOOOOOOOOOOOOOD!"
  "Thanks, but why don't you guys ever invite me to lunch?"
  "Pass the mustard?"
  "http://groups.drupal.org/files/marc.robinsone@gmail.com__DrupalComics_botsnack[150dpi].png"
  "YUM!"
  "http://www.youtube.com/watch?v=w6_PtNRYhy0"
  "w00t!  I'm starving!"
  "Howzabout a beer?"
]

module.exports = (robot) ->
  robot.respond /botsnack/i, (msg) ->
    msg.send msg.random responses