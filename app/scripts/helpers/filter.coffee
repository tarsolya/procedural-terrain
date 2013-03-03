define [
], ->
  class Filter

    # Noise engine
    noiseEngine: null

    # Setup options for the filter
    setup: (options) ->
      for k, v of options
        this[k] = v

    # Run the filter for xy coords
    run: (x, y) -> 0.0

