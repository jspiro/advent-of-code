chalk = require 'chalk'
debug = require 'debug'

# Provides amortized O(1) lookup of numeric values for words and digits.
numbers = {
  'zero': '0', 'one': '1', 'two': '2', 'three': '3', 'four': '4',
  'five': '5', 'six': '6', 'seven': '7', 'eight': '8', 'nine': '9',
  '0': '0', '1': '1', '2': '2', '3': '3', '4': '4',
  '5': '5', '6': '6', '7': '7', '8': '8', '9': '9'
}

# Find all numbers in the string, words and digits;
# remove all non-numeric characters from the string.
preprocess = (input) ->
  debug('preprocess:input') chalk.bold input

  left = 0
  output = ''
  while left < input.length
    for right in [left..input.length]
      slice = input[left..right]
      debug('preprocess:check') "#{left}, #{right}: #{slice}"

      numericValue = numbers[slice]
      if numericValue?
        debug('preprocess:found') "#{slice}: #{numericValue}"
        output += numericValue
        left += 1
        break

      if right == input.length
        left += 1

  debug('preprocess:output') chalk.bold output
  output


exports.solvers = [
  (calibrations) ->
    sum = 0
    for calibration in calibrations
      calibration = preprocess calibration
      nums = calibration.match /[0-9]/g
      continue unless nums?.length
      [first, ..., last] = nums
      sum += parseInt "#{first}#{last ? first}"
    sum

  (calibrations) ->
    sum = 0
    for calibration in calibrations
      calibration = preprocess calibration
      first = last = undefined
      for c in calibration when '0' <= c <= '9'
        last = c
        first = last unless first?
      sum += parseInt "#{first ? 0}#{last ? 0}"
    sum

  (calibrations) ->
    sum = 0
    for calibration in calibrations
      calibration = preprocess calibration
      calibration = calibration.split ''
      first = 10 * ((calibration.find(          (c) -> '0' <= c <= '9') ? 0) - '0')
      last  =  1 * ((calibration.reverse().find((c) -> '0' <= c <= '9') ? 0) - '0')
      sum += first + last
    sum

  (calibrations) ->
    sum = 0
    for calibration in calibrations
      first = last = 0
      calibration = preprocess calibration
      for c in calibration when '0' <= c <= '9'
        first = c - '0'
        break
      for i in [calibration.length - 1..0] when '0' <= calibration[i] <= '9'
        last = calibration[i] - '0'
        break
      sum += (first * 10) + last
    sum
]
