define [
  'jquery',
  'underscore'
], ($, _) ->
  class Noise
    engine: null
    seed: ''
    methods:
      '2d': () -> []
    filters: []
    postProcessors: []

    addFilter: (id, filterFunction) -> @filters.push [id, filterFunction]
    removeFilter: (id) -> @filters = _.reject @filters, (filter) -> filter[0] is id
    addPostProcessor: (id, postProcessorFunction) -> @postProcessors.push [id, postProcessorFunction]
    removePostProcessor: (id) -> @postProcessors = _.reject @postProcessors, (processor) -> processor[0] is id

    point2D: (x, y) -> 0.0
    chunk2D: (x, y, width, height) -> []

    filter: (value, x, y) ->
      for filter in @filters
        value = filter[1].run(value, x, y)
      value

    postProcess: (chunk) ->
      for proc in @postProcessors
        chunk = proc[1].run(chunk)
      chunk

