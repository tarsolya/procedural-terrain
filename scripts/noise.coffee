define [
  'jquery',
  'snoise',
  'seedrandom'
], ($, SimplexNoise) ->
  class Noise
    octaves: 128
    hgrid: 10
    lacunarity: 2
    gain: 0.65
    zoom: 256
    x: 0
    y: -256

    constructor: (seed) ->
      @prng = Math.seedrandom(seed)
      @simplex = new SimplexNoise(@prng.random)

    simplex2D: (width, height) ->
      console.log "Rendering simplex noise (#{width}, #{height}) ..." if DEBUG
      map = []

      for x in [0..width] by 1
        map.push []
        for y in [0..height] by 1
          freq = 1.0 / @hgrid
          amplitude = @gain
          sample = @simplex.noise2D((@x + x)/@zoom, (@y + y)/@zoom)
          for o in [0..@octaves] by 1
            sample += (@simplex.noise2D(((@x + x)/@zoom) * freq, ((@y + y)/@zoom) * freq) * amplitude)
            freq *= @lacunarity
            amplitude *= @gain
          map[x].push(sample)
      return map

    smooth: (map) ->
      width = map.length - 1
      height = map[0].length - 1
      console.log "Smoothing noise (#{width}x#{height}) ..." if DEBUG
      for x in [0..width] by 1
        for y in [0..length] by 1
          average = 0.0
          times = 0.0

          if (x - 1) >= 0
            average += map[y][x - 1]
            times += 1

          if (x + 1) < 255
            average += map[y][x + 1]
            times += 1

          if (y - 1) >= 0
            average += map[y - 1][x]
            times += 1

          if (y + 1) < 255
            average += map[y + 1][x]
            times += 1

          if (x - 1) >= 0 and (y - 1) >= 0
            average += map[y - 1][x - 1]
            times += 1

          if (x + 1) < 256 and (y - 1) >= 0
            average += map[y - 1][x + 1]
            times += 1

          if (x - 1) >= 0 and (y + 1) < 256
            average += map[y + 1][x - 1]
            times += 1

          if (x + 1) < 256 and (y + 1) < 256
            average += map[y + 1][x + 1]
            times += 1

          average += map[y][x]
          times += 1
          average /= times
          map[y][x] = average
      return map


