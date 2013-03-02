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

      # Controls
      $('.ui-slider').each (i, slider) ->
        $el = $(slider)
        controlName = $el.data('control')
        controlValue = canvas.getValue(controlName)
        $outlet = $("span[data-value=#{controlName}]")
        $outlet.text(controlValue)
        $el.slider
          value: parseFloat(controlValue)
          min: if $el.data('min') then parseFloat($el.data('min')) else 0.0
          max: if $el.data('max') then parseFloat($el.data('max')) else 1.0
          step: if $el.data('step') then parseFloat($el.data('step')) else 0.01
          change: (e, ui) ->
            $outlet.text(ui.value)
            canvas.setValue(controlName, ui.value)
            canvas.render(map)

      # Canvas position
      $canvas = $(canvas.getCanvas())
      $canvas.on 'mousemove', (e) ->
        pos = canvas.getPosition(e)
        $('#canvas_x').text(pos.x)
        $('#canvas_y').text(pos.y)

      # Apply
      $('#apply').on 'click', (e) ->
        canvas.render(map)

