define [
  'jquery'
], ($) ->
  class Canvas
    waterline: 0.15
    shallows: 0.05
    shoreline: 0.05
    plains: 0.80
    mountains: 0.17
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
        $('#controls').after(canvas)
      catch e
        console.log "Canvas initialization failed: #{e}" if DEBUG
      console.log "Canvas initialized (#{@width}, #{@height}) ..." if DEBUG

      @draw = (x, y, r, g, b, a = 255) ->
        offset = (x + y * @width) * 4
        [cr, cg, cb, ca] = [offset, offset + 1, offset + 2, offset + 3]
        [@buffer[cr], @buffer[cg], @buffer[cb], @buffer[ca]] = [r, g, b, a]

      @getCanvas = () ->
        canvas

      @getPosition = (e) ->
        e = window.event if not e
        if e.target
          target = e.target
        else if e.srcElement
          target = e.srcElement
        targ = targ.parentNode if target.nodeType == 3
        x = e.pageX - $(target).offset().left
        y = e.pageY - $(target).offset().top
        {x: x, y: y}

      @setWaterline = (val) -> @waterline = val
      @setShallowsOffset = (val) -> @shallows = val
      @setShorelineOffset = (val) -> @shoreline = val
      @setPlainsOffset = (val) -> @plains = val
      @setMountainsOffset = (val) -> @mountains = val
      @setValue = (name, value) -> this[name] = value if this[name]?
      @getValue = (name) -> if this[name]? then this[name] else null

    render: (map) ->
      console.log "Rendering map (#{@width}, #{@height}) ..." if DEBUG
      for x in [0..@width-1] by 1
        for y in [0..@height-1] by 1
          value = map[x][y]
          if value <= @waterline - @shallows
            [r, g, b] = [50, 50, 125 + ((value * 0.5 + 0.5) * 130)]
          else if value > @waterline - @shallows and value <= @waterline
            [r, g, b] = [75, 125, 200 + ((value * 0.5 + 0.5) * 55)]
          else if value > @waterline and value <= @waterline + @shoreline
            r = g = 150 + ((value * 0.5 + 0.5) * 100)
            b = 50
          else if value > @waterline + @shoreline and value <= @waterline + @shoreline + @plains
            [r, g, b] = [50, 45 + ((value * 0.5 + 0.5) * 130), 50]
          else if value > @waterline + @shoreline + @plains and value <= @waterline + @shoreline + @plains + @mountains
            r = g = b = 50 + ((value * 0.5 + 0.5) * 80)
          else
            r = g = b = 200 + ((value * 0.5 + 0.5) * 30)
          @draw(x, y, r, g, b)

      @context.putImageData(@image, 0, 0)

