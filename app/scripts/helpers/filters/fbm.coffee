define [
  'helpers/filter'
], (Filter) ->
  class Filter.fBm extends Filter

    # Number of filter passes
    ocataves: 128

    # http://en.wikipedia.org/wiki/Hurst_exponent
    hurst: 10

    # http://en.wikipedia.org/wiki/Lacunarity
    lacunarity: 2

    # A higher number indicates a wider distribution of calculated values
    gain: 0.65

    # Run the fBm on a value at xy using noiseFunction
    run: (sample, x, y) ->
      frequency = 1.0 / @hurst
      amplitude = @gain
      for i in [0..@octaves] by 1
        sample += @noiseEngine[@noiseFunc](x * frequency, y * frequency) * amplitude
        frequency *= @lacunarity
        amplitude *= @gain
      sample



