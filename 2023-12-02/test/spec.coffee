{ expect } = require 'chai'

# solvers is an array of different solve functions that should all return the same result
{ solvers } = require '../lib'

for solver, index in solvers
  describe "solver #{index}", ->
    it 'should work', ->
      expect(solver("""
        Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
        """.split("\n"), { red: 12, green: 13, blue: 14 })
      ).to.equal(
        4 * 2 * 6 +
        1 * 3 * 4 +
        20 * 13 * 6 +
        14 * 3 * 15 +
        6 * 3 * 2
      )

    it 'should return 0 for empty input', ->
      expect(solver([])).to.equal 0
