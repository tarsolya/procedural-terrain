define [
  'jquery'
], ($) ->
  class World
    layers: []

    constructor: (seed) ->
      @seed = seed

