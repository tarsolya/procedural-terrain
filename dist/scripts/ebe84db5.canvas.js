(function() {

  define(['jquery'], function($) {
    var Canvas;
    return Canvas = (function() {

      Canvas.prototype.waterline = 0.15;

      Canvas.prototype.shallows = 0.05;

      Canvas.prototype.shoreline = 0.05;

      Canvas.prototype.plains = 0.80;

      Canvas.prototype.mountains = 0.17;

      function Canvas(_arg) {
        var canvas, _ref;
        _ref = _arg != null ? _arg : {}, this.id = _ref.id, this.width = _ref.width, this.height = _ref.height;
        try {
          canvas = document.createElement('canvas');
          canvas.width = this.width || window.innerWidth;
          canvas.height = this.height || window.innerHeight;
          $('header').after(canvas);
          this.context = canvas.getContext('2d');
          this.image = this.context.getImageData(0, 0, canvas.width, canvas.height);
          this.width = this.image.width;
          this.height = this.image.height;
          this.buffer = this.image.data;
          $('#controls').after(canvas);
        } catch (e) {
          if (DEBUG) {
            console.log("Canvas initialization failed: " + e);
          }
        }
        if (DEBUG) {
          console.log("Canvas initialized (" + this.width + ", " + this.height + ") ...");
        }
        this.draw = function(x, y, r, g, b, a) {
          var ca, cb, cg, cr, offset, _ref1, _ref2;
          if (a == null) {
            a = 255;
          }
          offset = (x + y * this.width) *  4;
          _ref1 = [offset, offset + 1, offset + 2, offset + 3], cr = _ref1[0], cg = _ref1[1], cb = _ref1[2], ca = _ref1[3];
          return _ref2 = [r, g, b, a], this.buffer[cr] = _ref2[0], this.buffer[cg] = _ref2[1], this.buffer[cb] = _ref2[2], this.buffer[ca] = _ref2[3], _ref2;
        };
        this.getCanvas = function() {
          return canvas;
        };
        this.getPosition = function(e) {
          var targ, target, x, y;
          if (!e) {
            e = window.event;
          }
          if (e.target) {
            target = e.target;
          } else if (e.srcElement) {
            target = e.srcElement;
          }
          if (target.nodeType === 3) {
            targ = targ.parentNode;
          }
          x = e.pageX - $(target).offset().left;
          y = e.pageY - $(target).offset().top;
          return {
            x: x,
            y: y
          };
        };
        this.setWaterline = function(val) {
          return this.waterline = val;
        };
        this.setShallowsOffset = function(val) {
          return this.shallows = val;
        };
        this.setShorelineOffset = function(val) {
          return this.shoreline = val;
        };
        this.setPlainsOffset = function(val) {
          return this.plains = val;
        };
        this.setMountainsOffset = function(val) {
          return this.mountains = val;
        };
      }

      Canvas.prototype.render = function(map) {
        var b, g, r, value, x, y, _i, _j, _ref, _ref1, _ref2, _ref3, _ref4;
        if (DEBUG) {
          console.log("Rendering map (" + this.width + ", " + this.height + ") ...");
        }
        for (x = _i = 0, _ref = this.width - 1; _i <= _ref; x = _i += 1) {
          for (y = _j = 0, _ref1 = this.height - 1; _j <= _ref1; y = _j += 1) {
            value = map[x][y];
            if (value <= this.waterline - this.shallows) {
              _ref2 = [50, 50, 125 + ((value * 0.5 + 0.5) * 130)], r = _ref2[0], g = _ref2[1], b = _ref2[2];
            } else if (value > this.waterline - this.shallows && value <= this.waterline) {
              _ref3 = [75, 125, 200 + ((value * 0.5 + 0.5) * 55)], r = _ref3[0], g = _ref3[1], b = _ref3[2];
            } else if (value > this.waterline && value <= this.waterline + this.shoreline) {
              r = g = 150 + ((value * 0.5 + 0.5) * 100);
              b = 50;
            } else if (value > this.waterline + this.shoreline && value <= this.waterline + this.shoreline + this.plains) {
              _ref4 = [50, 45 + ((value * 0.5 + 0.5) * 130), 50], r = _ref4[0], g = _ref4[1], b = _ref4[2];
            } else if (value > this.waterline + this.shoreline + this.plains && value <= this.waterline + this.shoreline + this.plains + this.mountains) {
              r = g = b = 50 + ((value * 0.5 + 0.5) * 80);
            } else {
              r = g = b = 200 + ((value * 0.5 + 0.5) * 30);
            }
            this.draw(x, y, r, g, b);
          }
        }
        return this.context.putImageData(this.image, 0, 0);
      };

      return Canvas;

    })();
  });

}).call(this);
