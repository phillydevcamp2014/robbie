# Description:
#   Displays a random pizza image
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   pizza - Show an Andrew WK pizza image
#
# Author:
#   zivtech

module.exports = (robot) ->
	robot.hear /(pizza)/i, (msg) ->
		images = ["http://www.incrediblethings.com/wp-content/uploads/2012/07/pizza-guitar-andrew-wk-1.jpg",
              "http://25.media.tumblr.com/tumblr_m7pza07A8y1qzpo8yo1_400.jpg",
              "http://fruitguys.com/almanac/wp-content/uploads/2012/01/chris-banana-suit-trans.png"]
		msg.send msg.random images
