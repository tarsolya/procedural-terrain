(function() {

  define(['jquery', 'snoise', 'seedrandom'], function($, SimplexNoise) {
    var Noise;
    return Noise = (function() {

      Noise.prototype.octaves = 128;

      Noise.prototype.hgrid = 10;

      Noise.prototype.lacunarity = 2;

      Noise.prototype.gain = 0.65;

      Noise.prototype.zoom = 256;

      Noise.prototype.x = 0;

      Noise.prototype.y = -256;

      function Noise(seed) {
        this.prng = Math.seedrandom(seed);
        this.simplex = new SimplexNoise(this.prng.random);
      }

      Noise.prototype.simplex2D = function(width, height) {
        var amplitude, freq, map, o, sample, x, y, _i, _j, _k, _ref;
        if (DEBUG) {
          console.log("Rendering simplex noise (" + width + ", " + height + ") ...");
        }
        map = [];
        for (x = _i = 0; _i <= width; x = _i += 1) {
          map.push([]);
          for (y = _j = 0; _j <= height; y = _j += 1) {
            freq = 1.0 / this.hgrid;
            amplitude = this.gain;
            sample = this.simplex.noise2D((this.x + x) / this.zoom, (this.y + y) / this.zoom);
            for (o = _k = 0, _ref = this.octaves; _k <= _ref; o = _k += 1) {
              sample += this.simplex.noise2D(((this.x + x) / this.zoom) *  freq, ((this.y + y) / this.zoom) *  freq) *  amplitude;
              freq *= this.lacunarity;
              amplitude *= this.gain;
            }
            map[x].push(sample);
          }
        }
        return map;
      };

      Noise.prototype.smooth = function(map) {
        var average, height, times, width, x, y, _i, _j;
        width = map.length - 1;
        height = map[0].length - 1;
        if (DEBUG) {
          console.log("Smoothing noise (" + width + "x" + height + ") ...");
        }
        for (x = _i = 0; _i <= width; x = _i += 1) {
          for (y = _j = 0; _j <= length; y = _j += 1) {
            average = 0.0;
            times = 0.0;
            if ((x - 1) >= 0) {
              average += map[y][x - 1];
              times += 1;
            }
            if ((x + 1) < 255) {
              average += map[y][x + 1];
              times += 1;
            }
            if ((y - 1) >= 0) {
              average += map[y - 1][x];
              times += 1;
            }
            if ((y + 1) < 255) {
              average += map[y + 1][x];
              times += 1;
            }
            if ((x - 1) >= 0 && (y - 1) >= 0) {
              average += map[y - 1][x - 1];
              times += 1;
            }
            if ((x + 1) < 256 && (y - 1) >= 0) {
              average += map[y - 1][x + 1];
              times += 1;
            }
            if ((x - 1) >= 0 && (y + 1) < 256) {
              average += map[y + 1][x - 1];
              times += 1;
            }
            if ((x + 1) < 256 && (y + 1) < 256) {
              average += map[y + 1][x + 1];
              times += 1;
            }
            average += map[y][x];
            times += 1;
            average /= times;
            map[y][x] = average;
          }
        }
        return map;
      };

      return Noise;

    })();
  });

}).call(this);
