util = require 'util'

chalk = require 'chalk'
debug = require 'debug'

inspect = (obj) ->
  debug('lib:inspect') util.inspect obj, {
    showHidden: true, depth: null, colors: true
  }

parseLine = (line) ->
  [_, gameNumber, sets] = line.split /Game |: /
  gameNumber = parseInt gameNumber
  game = { id: gameNumber, red: 0, green: 0, blue: 0 }
  for set in sets.split /; /
    for cubes in set.split /, /
      [amount, color] = cubes.split /\s/
      game[color] = Math.max game[color], parseInt(amount)
  debug('lib:game') game
  game

parseLines = (input) ->
  games = []
  for line in input when line.length
    debug('lib:line') line
    games.push parseLine line
  games

exports.solvers = [
  (input, requirements) ->
    games = parseLines input
    possibleGames = games.reduce((prev, game) ->
      for color, amount of requirements
        return prev if game[color] > amount
      prev + game.id
    , 0)
]
