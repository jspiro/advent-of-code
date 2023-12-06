{ expect } = require 'chai'

# solvers is an array of different solve functions that should all return the same result
{ solvers } = require '../lib'

for solver, index in solvers
  describe "solver #{index}", ->
    it 'should return 142', ->
      expect(solver([
        "1abc2"
        "pqr3stu8vwx"
        "a1b2c3d4e5f"
        "treb7uchet"
      ])).to.equal 142

    it 'should return 0 for empty input', ->
      expect(solver([])).to.equal 0

    it 'should correctly sum single digits', ->
      expect(solver(['1', '2', '3'])).to.equal 66

    it 'should correctly sum first and last digits in each string', ->
      expect(solver(['123', '456', '789'])).to.equal 138

    it 'should handle strings with no digits', ->
      expect(solver(['abc', 'def', 'ghi'])).to.equal 0

    it 'should handle leading zeros', ->
      expect(solver(['0a1b2c', '03d4', '05'])).to.equal 11

    it 'should handle mixed digit and non-digit characters', ->
      expect(solver(['a1b2c', '3d4', '5'])).to.equal 101

    it 'should ignore non-digit characters in strings', ->
      expect(solver(['x1z', 'a2b', 'c3d'])).to.equal 66
