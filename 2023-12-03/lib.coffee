util = require 'util'

chalk = require 'chalk'
debug = require 'debug'

inspect = (obj) ->
  debug('lib:inspect') util.inspect obj, {
    showHidden: true, depth: null, colors: true
  }

class Rectangle
  constructor: (@x = 0, @y = 0, @width = 0, @height = 0) ->

  toString: ->
    "Rectangle(x: #{@x}, y: #{@y}, width: #{@width}, height: #{@height})"

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

class NumberRectangle extends Rectangle
  constructor: (x, y) ->
    # Height is always 1 for a number rectangle.
    super x, y, 0, 1
    @number = 0

  toString: ->
    "NumberRectangle(x: #{@x}, y: #{@y}, number: #{@number})"

  addDigit: (digit) ->
    @number = @number * 10 + digit
    @width += 1

exports.Rectangle = Rectangle

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
    symbols.push new Rectangle(x - 1, lineNumber - 1, 3, 3)
    debug('lib:sym') c, x, lineNumber
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
