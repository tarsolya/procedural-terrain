define [
  'jquery-ui',
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

      # Waterline
      $('#waterline_value').text(canvas.waterline)
      $sliders = $('#waterline')
      $sliders.slider
        value: parseFloat(canvas.waterline)
        min: -2
        max: 2
        step: 0.02
        change: (e, ui) ->
          $('#waterline_value').text(ui.value)
          canvas.setWaterline(parseFloat(ui.value))
          canvas.render(map)

      # Shallows offset
      $('#shallows_offset').text(canvas.shallows)
      $sliders = $('#shallows')
      $sliders.slider
        value: parseFloat(canvas.shallows)
        min: 0.0
        max: 1
        step: 0.01
        change: (e, ui) ->
          $('#shallows_offset').text(ui.value)
          canvas.setShallowsOffset(parseFloat(ui.value))
          canvas.render(map)

      # Shoreline offset
      $('#shoreline_offset').text(canvas.shoreline)
      $sliders = $('#shoreline')
      $sliders.slider
        value: parseFloat(canvas.shoreline)
        min: 0.0
        max: 0.20
        step: 0.01
        change: (e, ui) ->
          $('#shoreline_offset').text(ui.value)
          canvas.setShorelineOffset(parseFloat(ui.value))
          canvas.render(map)

      # Plains offset
      $('#plains_offset').text(canvas.plains)
      $sliders = $('#plains')
      $sliders.slider
        value: parseFloat(canvas.plains)
        min: 0.0
        max: 2.00
        step: 0.05
        change: (e, ui) ->
          $('#plains_offset').text(ui.value)
          canvas.setPlainsOffset(parseFloat(ui.value))
          canvas.render(map)

      # Mountains offset
      $('#mountains_offset').text(canvas.mountains)
      $sliders = $('#mountains')
      $sliders.slider
        value: parseFloat(canvas.mountains)
        min: 0.0
        max: 2.00
        step: 0.05
        change: (e, ui) ->
          $('#mountains_offset').text(ui.value)
          canvas.setMountainsOffset(parseFloat(ui.value))
          canvas.render(map)

      $canvas = $(canvas.getCanvas())
      $canvas.on 'mousemove', (e) ->
        pos = canvas.getPosition(e)
        $('#canvas_x').text(pos.x)
        $('#canvas_y').text(pos.y)

      $('#apply').on 'click', (e) ->
        canvas.render(map)

