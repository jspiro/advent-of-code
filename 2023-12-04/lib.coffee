util = require 'util'

chalk = require 'chalk'
debug = require 'debug'

inspect = (obj) ->
  debug('lib:inspect') util.inspect obj, {
    showHidden: true, depth: null, colors: true
  }

exports.ScratcherCard = class ScratcherCard
  constructor: (@winningNumbers = [], @scratchedNumbers = []) ->

  addWinningNumber: (number) ->
    @winningNumbers.push number

  addScratchedNumber: (number) ->
    @scratchedNumbers.push number

  getWinningMatches: ->
    @winningNumbers.filter (n) => @scratchedNumbers.includes n

  getPointValue: ->
    matches = @getWinningMatches().length
    if matches is 0 then 0 else Math.pow 2, (matches - 1)

  toString: ->
    winningNumbers = @winningNumbers.map (n) =>
      if @scratchedNumbers.includes n then chalk.green n else n
    scratchedNumbers = @scratchedNumbers.map (n) =>
      if @winningNumbers.includes n then chalk.green n else n
    pointValue = chalk.magenta @getPointValue()
    "#{winningNumbers.join ' '} | #{scratchedNumbers.join ' '} | #{pointValue}"

parseLine = (lineNumber, line) ->
  debug('lib:parseLine') lineNumber, line
  [ _, winningNumbers, scratchedNumbers ] = line.split /: | \| /g
  winningNumbers = winningNumbers.trim().split(/\s+/g).map (n) -> parseInt n
  scratchedNumbers = scratchedNumbers.trim().split(/\s+/g).map (n) -> parseInt n
  card = new ScratcherCard(winningNumbers.sort(), scratchedNumbers.sort())
  debug("lib:card") "Card #{lineNumber + 1}: #{card.toString()}"
  card.getPointValue()

parseLines = (input) ->
  points = 0
  for line, lineNumber in input when line.length
    points += parseLine lineNumber, line
  points

exports.solvers = [
  (input, requirements) ->
    points = parseLines input
    debug('lib:points') points
    points
]
