{ expect } = require 'chai'

{ solvers, ScratcherCard } = require './lib'

for solver, index in solvers
  describe "solver #{index}", ->
    it 'should work', ->
      expect(solver("""
      Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
      Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
      Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
      Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
      Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
      Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
      """.split("\n"))).to.equal 30

describe 'ScratcherCard', ->
  describe 'getPointValue', ->
    it 'should return the correct points', ->
      card = new ScratcherCard()
      card.addWinningNumber 1
      card.addWinningNumber 2
      card.addWinningNumber 3
      card.addScratchedNumber 4
      expect(card.getPointValue()).to.equal 0
      card.addScratchedNumber 3
      expect(card.getPointValue()).to.equal 1
      card.addScratchedNumber 2
      expect(card.getPointValue()).to.equal 2
      card.addScratchedNumber 1
      expect(card.getPointValue()).to.equal 4
