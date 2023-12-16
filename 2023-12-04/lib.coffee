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
  card.getWinningMatches().length

parseLines = (input) ->
  cards = []
  for line, lineNumber in input when line.length
    cards.push { card: lineNumber + 1, matches: parseLine lineNumber, line }

  i = 0
  while i < cards.length
    card = cards[i]
    # console.log "Processing #{JSON.stringify card}"
    for j in [card.card...card.card + card.matches]
      bonusCard = cards[j]
      # console.log "Adding bonus #{JSON.stringify bonusCard}"
      cards.push bonusCard
    i++
  cards.length

exports.solvers = [
  (input, requirements) ->
    points = parseLines input
    debug('lib:points') points
    points
]
