define [
  'seedrandom',
  'snoise',
  'helpers/noise'
], (SeedRandom, SimplexNoise, Noise) ->
  class Noise.Simplex extends Noise
    methods:
      '2d': 'noise2D'

    constructor: (seed) ->
      @prng = Math.seedrandom(seed)
      @engine = new SimplexNoise(@prng.random)

    point2D: (x, y) ->
      value = @engine.noise2D(x, y)
      @filter(value, x, y)

    chunk2D: (x, y, width, height, zoom) ->
      chunk = []
      for i in [x..width] by 1
        chunk.push []
        for j in [y..height] by 1
          value = @point2D(i/zoom, j/zoom)
          chunk[i][j] = value
      @postProcess(chunk)

