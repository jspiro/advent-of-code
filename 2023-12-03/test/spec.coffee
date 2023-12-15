{ expect } = require 'chai'

# solvers is an array of different solve functions that should all return the same result
{ solvers, Rectangle } = require '../lib'

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

describe 'rectangle', ->
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
