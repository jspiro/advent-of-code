{ expect } = require 'chai'

{ solvers, Rectangle, NumberRectangle, SymbolRectangle } = require './lib'

for solver, index in solvers
  describe "solver #{index}", ->
    it 'should work', ->
      expect(solver("""
      467..114..
      ...*......
      ..35..633.
      ......#...
      617*......
      .....+.58.
      ..592.....
      ......755.
      ...$.*....
      .664.598..
      """.split("\n"))).to.equal 4361

describe 'Rectangle', ->
  it 'should overlap with', ->
    rect1 = new Rectangle(0, 0, 2, 1)
    rect2 = new Rectangle(1, 0, 4, 2)
    expect(rect1.overlaps(rect2)).to.be.true
    expect(rect2.overlaps(rect1)).to.be.true

  it 'should not overlap with', ->
    rect1 = new Rectangle(0, 0, 1, 1)
    rect2 = new Rectangle(1, 0, 4, 2)
    expect(rect1.overlaps(rect2)).to.be.false
    expect(rect2.overlaps(rect1)).to.be.false

  it 'should return true when rectangles overlap', ->
    rect1 = new Rectangle(0, 0, 5, 5)
    rect2 = new Rectangle(3, 3, 5, 5)
    expect(rect1.overlaps(rect2)).to.be.true
    expect(rect2.overlaps(rect1)).to.be.true

  it 'should return false when rectangles do not overlap', ->
    rect1 = new Rectangle(0, 0, 5, 5)
    rect2 = new Rectangle(6, 6, 5, 5)
    expect(rect1.overlaps(rect2)).to.be.false
    expect(rect2.overlaps(rect1)).to.be.false

  it 'should return false when rectangles share an edge', ->
    rect1 = new Rectangle(0, 0, 5, 5)
    rect2 = new Rectangle(5, 0, 5, 5)
    expect(rect1.overlaps(rect2)).to.be.false
    expect(rect2.overlaps(rect1)).to.be.false

  it 'should return true when one rectangle is completely inside the other', ->
    rect1 = new Rectangle(0, 0, 10, 10)
    rect2 = new Rectangle(2, 2, 5, 5)
    expect(rect1.overlaps(rect2)).to.be.true
    expect(rect2.overlaps(rect1)).to.be.true

  it 'should detect full overlap', ->
      rect1 = new Rectangle(0, 0, 4, 4)
      rect2 = new Rectangle(1, 1, 2, 2)
      expect(rect1.overlaps(rect2)).to.be.true
      expect(rect2.overlaps(rect1)).to.be.true

  it 'should detect partial overlap', ->
    rect1 = new Rectangle(0, 0, 3, 3)
    rect2 = new Rectangle(2, 2, 3, 3)
    expect(rect1.overlaps(rect2)).to.be.true
    expect(rect2.overlaps(rect1)).to.be.true

  it 'should detect edge touch', ->
    rect1 = new Rectangle(0, 0, 2, 2)
    rect2 = new Rectangle(2, 0, 2, 2)
    expect(rect1.overlaps(rect2)).to.be.false
    expect(rect2.overlaps(rect1)).to.be.false

  it 'should detect corner touch', ->
    rect1 = new Rectangle(0, 0, 2, 2)
    rect2 = new Rectangle(2, 2, 2, 2)
    expect(rect1.overlaps(rect2)).to.be.false
    expect(rect2.overlaps(rect1)).to.be.false

  it 'should detect no overlap', ->
    rect1 = new Rectangle(0, 0, 2, 2)
    rect2 = new Rectangle(3, 3, 2, 2)
    expect(rect1.overlaps(rect2)).to.be.false
    expect(rect2.overlaps(rect1)).to.be.false

  it 'should detect overlap with itself', ->
    rect1 = new Rectangle(0, 0, 2, 2)
    expect(rect1.overlaps(rect1)).to.be.true

  it 'should handle negative coordinates', ->
    rect1 = new Rectangle(-2, -2, 3, 3)
    rect2 = new Rectangle(-1, -1, 3, 3)
    expect(rect1.overlaps(rect2)).to.be.true
    expect(rect2.overlaps(rect1)).to.be.true

describe 'NumberRectangle', ->
  describe 'constructor', ->
    it 'should set the number to 0 and width to 0', ->
      rectangle = new NumberRectangle(1, 2)
      expect(rectangle.number).to.equal 0
      expect(rectangle.width).to.equal 0

  describe 'addDigit', ->
    it 'should update the number and width', ->
      rectangle = new NumberRectangle(1, 2)
      rectangle.addDigit(5)
      expect(rectangle.number).to.equal 5
      expect(rectangle.width).to.equal 1

describe 'SymbolRectangle', ->
  describe 'constructor', ->
    it 'should set the symbol and dimensions', ->
      rectangle = new SymbolRectangle('X', 2, 5)
      expect(rectangle.symbol).to.equal 'X'
      expect(rectangle.x).to.equal 1
      expect(rectangle.y).to.equal 4
      expect(rectangle.width).to.equal 3
      expect(rectangle.height).to.equal 3

describe 'Intersection', ->
  it 'should return true when NumberRectangle and SymbolRectangle intersect', ->
    numberRect = new NumberRectangle(0, 0)
    numberRect.addDigit 1
    symbolRect = new SymbolRectangle('X', 1, 0)
    expect(numberRect.overlaps(symbolRect)).to.be.true
    expect(symbolRect.overlaps(numberRect)).to.be.true

  it 'should return false when NumberRectangle and SymbolRectangle do not intersect', ->
    numberRect = new NumberRectangle(0, 0)
    symbolRect = new SymbolRectangle('X', 3, 3)
    expect(numberRect.overlaps(symbolRect)).to.be.false
    expect(symbolRect.overlaps(numberRect)).to.be.false

  it 'should return true when SymbolRectangles intersect', ->
    symbolRect1 = new SymbolRectangle('X', 0, 0)
    symbolRect2 = new SymbolRectangle('Y', 1, 1)
    expect(symbolRect1.overlaps(symbolRect2)).to.be.true
    expect(symbolRect2.overlaps(symbolRect1)).to.be.true

  it 'should return false when SymbolRectangles do not intersect', ->
    symbolRect1 = new SymbolRectangle('X', 0, 0)
    symbolRect2 = new SymbolRectangle('Y', 3, 3)
    expect(symbolRect1.overlaps(symbolRect2)).to.be.false
    expect(symbolRect2.overlaps(symbolRect1)).to.be.false
