define [
  'jquery',
  'canvas',
  'noise',
  'db'
], ($, Canvas, Noise, Db) ->

  class App
    constructor: ->
      console.log 'Legends running ...' if DEBUG
      seed = 'Extracirkulár kobold geci'

      noise = new Noise(seed)
      canvas = new Canvas id: '#c', width: 500, height: 500
      db = new Db

      map = null
      dbErrorHandler = (t, error) -> console.log "DB error: ", error
      saveHandler = () -> console.log "Stored map for seed: #{seed}" if DEBUG

      mapGenerator = ->
        map = noise.smooth(noise.simplex2D(canvas.width, canvas.height))
        db.store seed, JSON.stringify(map), saveHandler, dbErrorHandler
        canvas.render(map)

      mapLoader = (t, results) ->
        if results.rows.length > 0
          row = results.rows.item(0)
          map = JSON.parse(row['data'])
          console.log "Map loaded for seed: #{seed}" if DEBUG
          canvas.render(map)
        else
          mapGenerator()

      db.load(seed, mapLoader, dbErrorHandler)
