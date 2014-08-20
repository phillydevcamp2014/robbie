# Shows random zombie quotes, factoids, and outbursts from Robbie Bot.
#
# zombie me - Randomly display one of the quotes listed below.

module.exports = (robot) ->
  robot.respond /zombi(e|es)/i, (msg) ->
    msg.send msg.random responses

responses = [
  "It is a truth universally acknowledged that a zombie in possession of brains must be in want of more brains.",
  "This aint' the army, boy. It's every man for himself. Fall behind. Get eaten.",
  "I love zombies. If any monster could Riverdance, it would be zombies.",
  "Blood is really warm, it's like drinking hot chocolate but with more screaming.",
  "This is the way the world ends; not with a bang or a whimper, but with zombies breaking down the back door.",
  "What Hamlet suffers from is a lack of zombies.",
  "The irony of being a zombie is that everything is funny, but you can't smile, because your lips have rotted off.",
  "We will not negotiate with the undead!",
  "Something coming back from the dead was almost always bad news. Movies taught me that. For every one Jesus you get a million zombies.",
  "If you love someone, you're not supposed to want them to come back. Better a peaceful sleep in the earth than the life of a zombie--not really dead but not really alive, either.",
  "You know, surprisingly, they don't sell a lot of brains in the local 24-hour grocery store around the corner from my house.",
  "Nothing is impossible to kill. It's just that sometimes after you kill something you have to keep shooting it until it stops moving.",
  "Zombies can't believe the energy we waste on nonfood pursuits.",
  "Brains, BRAINS, BRains, brains, BRAINS. BRaiNS, brains, Brains, BRAINS, BRains, brains, BRAINS. BRAINS, BRains, brains, BRAINS, brains.",
  "Walking out in the middle of a funeral would be, of course, bad form. So attempting to walk out on one's own is beyond the pale.",
  "Time to nut up or shut up!",
  "You just can't trust anyone. The first girl I let into my life and she tried to eat me.",
  "The first rule of Zombieland: Cardio.",
  "We all are orphans in Zombieland.",
  "Thank God for rednecks!",
  "Where are the fucking Twinkies?",
  "It's amazing how fast the world can go from bad to total shit storm.",
  "Rule 1: Cardio.",
  "Rule 2: Beware of Bathrooms.",
  "Rule 3: Seatbelts.",
  "Rule 4: Doubletap.",
  "Rule 5: No Attachments.",
  "Rule 6: Travel in a Group.",
  "Rule 7: Keep the Dumb Dumbs Close at Hand.",
  "Rule 8: Kill with Efficiency.",
  "Rule 9: Guns Are for Hunting, Not for Zombie Killing.",
  "Rule 10: Be Quiet",
  "Rule 15: Know Your Way out!",
  "Rule 17: Don't Be a Hero.",
  "Rule 18: Limber Up.",
  "Rule 19: Blend in.",
  "Rule 20: Find The Right Shelter.",
  "Rule 21: Zombies cant Climb",
  "Rule 22: Be ruthless",
  "Rule 23: God Bless Rednecks.",
  "Rule 24: No Drinking",
  "Rule 31: Check the Back Seat.",
  "Rule 32: Enjoy the Little Things.",
  "If you could only have one weapon in a zombie apocalypse, what would it be?",
  "If you were in downtown Philly and the zombie apocalypse happened, where would you seek shelter?",
  "You're best bet for a quick weapon is a crowbar. It's light, easy to carry, and deadly.",
  "Although a baseball bat may seem like a good idea, it can easily break and then you'll be a zombie snack.",
  "braaaaiiiiiiiiiiinnnnnnssss",
  "Quick! The zombie apocalypse has just begun. Do you group together with people in this room? Or do you run out of the building knowing that you work better alone?",
  "Who in this room is most likely to become a zombie?",
  "Who in this room is least likely to become a flesh-eating zombie?"
  "If a man ran up to you and you saw that he had been bit by a zombie could you do what was necessary?"
]
