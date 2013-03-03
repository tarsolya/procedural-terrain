define [
  'helpers/filter'
], (Filter) ->
  class Filter.Smooth extends Filter

    # Run the smoothing filter on a 2d chunk of values
    run: (chunk) ->
      width = chunk.length - 1
      height = chunk[0].length - 1
      console.log "Smoothing noise (#{width}x#{height}) ..." if DEBUG
      for x in [0..width] by 1
        for y in [0..length] by 1
          average = 0.0
          times = 0.0

          if (x - 1) >= 0
            average += chunk[y][x - 1]
            times += 1

          if (x + 1) < 255
            average += chunk[y][x + 1]
            times += 1

          if (y - 1) >= 0
            average += chunk[y - 1][x]
            times += 1

          if (y + 1) < 255
            average += chunk[y + 1][x]
            times += 1

          if (x - 1) >= 0 and (y - 1) >= 0
            average += chunk[y - 1][x - 1]
            times += 1

          if (x + 1) < 256 and (y - 1) >= 0
            average += chunk[y - 1][x + 1]
            times += 1

          if (x - 1) >= 0 and (y + 1) < 256
            average += chunk[y + 1][x - 1]
            times += 1

          if (x + 1) < 256 and (y + 1) < 256
            average += chunk[y + 1][x + 1]
            times += 1

          average += chunk[y][x]
          times += 1
          average /= times
          chunk[y][x] = average
      chunk

