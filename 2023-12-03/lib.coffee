util = require 'util'

chalk = require 'chalk'
debug = require 'debug'

inspect = (obj) ->
  debug('lib:inspect') util.inspect obj, {
    showHidden: true, depth: null, colors: true
  }

exports.Rectangle = class Rectangle
  constructor: (@x = 0, @y = 0, @width = 0, @height = 0) ->

  toString: ->
    "Rectangle(l: #{@left().toString().padStart(4)}, " +
    "r: #{@right().toString().padStart(4)}, " +
    "t: #{@top().toString().padStart(4)}, " +
    "b: #{@bottom().toString().padStart(4)})"

  left: -> @x
  right: -> @x + @width
  top: -> @y
  bottom: -> @y + @height

  overlaps: (other) ->
    return false if @left() >= other.right()
    return false if @right() <= other.left()
    return false if @top() >= other.bottom()
    return false if @bottom() <= other.top()
    true

exports.NumberRectangle = class NumberRectangle extends Rectangle
  constructor: (x, y) ->
    # Height is always 1 for a number rectangle.
    super x, y, 0, 1
    @number = 0

  toString: ->
    "#{@number.toString().padStart 4} -> #{super.toString()}"

  addDigit: (digit) ->
    @number = @number * 10 + digit
    @width += 1

exports.SymbolRectangle = class SymbolRectangle extends Rectangle
  constructor: (@symbol, centerX, centerY) ->
    # Height and width are always 3 for a symbol rectangle.
    super centerX - 1, centerY - 1, 3, 3

  toString: ->
    "#{@symbol.padStart 4} -> #{super.toString()}"

isNumber = (c) -> '0' <= c <= '9'

parseLine = (lineNumber, line) ->
  debug('lib:parseLine') lineNumber, line
  numbers = []
  symbols = []

  currentNumber = null
  for c, x in line
    # If we're in a number, add the digit.
    if isNumber c
      currentNumber ?= new NumberRectangle(x, lineNumber)
      currentNumber.addDigit parseInt c
      continue

    # We're no longer in a number, terminate the last number.
    if currentNumber?
      debug('lib:num') currentNumber.toString()
      numbers.push currentNumber
      currentNumber = null

    # Skip dots.
    continue if c is '.'

    # Add the symbol.
    symbols.push new SymbolRectangle(c, x, lineNumber)
    debug('lib:sym') symbols[symbols.length - 1].toString()

  { numbers, symbols }

parseLines = (input) ->
  numberRects = []
  symbolRects = []

  # Parse the input into number and symbol rectangles.
  for line, lineNumber in input when line.length
    debug('lib:line') line
    { numbers, symbols } = parseLine lineNumber, line
    numberRects = numberRects.concat numbers
    symbolRects = symbolRects.concat symbols

  # Filter in numbers that overlap with symbols and return them.
  numberRects.filter((rect) ->
    for symbolRect in symbolRects
      return true if rect.overlaps symbolRect
    false
  ).map (rect) -> rect.number

exports.solvers = [
  (input, requirements) ->
    numbers = parseLines input
    debug('lib:numbers') numbers
    numbers.reduce (total, n) -> total + n
]
