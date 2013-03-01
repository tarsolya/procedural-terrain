define [
  'jquery'
], ($) ->
  class Canvas
    constructor: ({@id, @width, @height}={}) ->
      try
        canvas = document.createElement('canvas');
        canvas.width = @width || window.innerWidth
        canvas.height = @height || window.innerHeight
        $('header').after(canvas)
        @context = canvas.getContext('2d')
        @image = @context.getImageData(0, 0, canvas.width, canvas.height)
        @width = @image.width
        @height = @image.height
        @buffer = @image.data
        $('header').after(canvas)
      catch e
        console.log "Canvas initialization failed: #{e}" if DEBUG
      console.log "Canvas initialized (#{@width}, #{@height}) ..." if DEBUG

    draw: (x, y, r, g, b, a = 255) ->
      offset = (x + y * @width) * 4
      [cr, cg, cb, ca] = [offset, offset + 1, offset + 2, offset + 3]
      [@buffer[cr], @buffer[cg], @buffer[cb], @buffer[ca]] = [r, g, b, a]

    render: (map) ->
      console.log "Rendering map (#{@width}, #{@height}) ..." if DEBUG
      for x in [0..@width-1] by 1
        for y in [0..@height-1] by 1
          value = map[x][y]
          if value <= 0.15
            [r, g, b] = [50, 50, 125 + ((value * 0.5 + 0.5) * 130)]
          else if value > 0.15 and value <= 0.2
            [r, g, b] = [75, 125, 200 + ((value * 0.5 + 0.5) * 55)]
          else if value > 0.2 and value <= 0.25
            r = g = 150 + ((value * 0.5 + 0.5) * 100)
            b = 50
          else if value > 0.25 and value <= 1.1
            [r, g, b] = [50, 45 + ((value * 0.5 + 0.5) * 130), 50]
          else if value > 1.1 and value <= 1.27
            r = g = b = 50 + ((value * 0.5 + 0.5) * 80)
          else
            r = g = b = 200 + ((value * 0.5 + 0.5) * 30)
          @draw(x, y, r, g, b)

      @context.putImageData(@image, 0, 0)

