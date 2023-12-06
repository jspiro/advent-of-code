exports.solvers = [
  (calibrations) ->
    sum = 0
    for calibration in calibrations
      nums = calibration.match /[0-9]/g
      continue unless nums?.length
      [first, ..., last] = nums
      sum += parseInt "#{first}#{last ? first}"
    sum

  (calibrations) ->
    sum = 0
    for calibration in calibrations
      first = last = undefined
      for c in calibration when '0' <= c <= '9'
        last = c
        first = last unless first?
      sum += parseInt "#{first ? 0}#{last ? 0}"
    sum

  (calibrations) ->
    sum = 0
    for calibration in calibrations
      calibration = calibration.split ''
      first = 10 * ((calibration.find(          (c) -> '0' <= c <= '9') ? 0) - '0')
      last  =  1 * ((calibration.reverse().find((c) -> '0' <= c <= '9') ? 0) - '0')
      sum += first + last
    sum

  (calibrations) ->
    sum = 0
    for calibration in calibrations
      first = last = 0
      for c in calibration when '0' <= c <= '9'
        first = c - '0'
        break
      for i in [calibration.length - 1..0] when '0' <= calibration[i] <= '9'
        last = calibration[i] - '0'
        break
      sum += (first * 10) + last
    sum
]
