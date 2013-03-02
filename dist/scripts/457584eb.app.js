(function() {

  define(['jquery-ui', 'canvas', 'noise', 'db'], function($, Canvas, Noise, Db) {
    var App;
    return App = (function() {

      function App() {
        var $canvas, $sliders, canvas, db, dbErrorHandler, map, mapGenerator, mapLoader, noise, saveHandler, seed;
        if (DEBUG) {
          console.log('Legends running ...');
        }
        seed = 'Extracirkulár kobold geci';
        noise = new Noise(seed);
        canvas = new Canvas({
          id: '#c',
          width: 500,
          height: 500
        });
        db = new Db;
        map = null;
        dbErrorHandler = function(t, error) {
          return console.log("DB error: ", error);
        };
        saveHandler = function() {
          if (DEBUG) {
            return console.log("Stored map for seed: " + seed);
          }
        };
        mapGenerator = function() {
          map = noise.smooth(noise.simplex2D(canvas.width, canvas.height));
          db.store(seed, JSON.stringify(map), saveHandler, dbErrorHandler);
          return canvas.render(map);
        };
        mapLoader = function(t, results) {
          var row;
          if (results.rows.length > 0) {
            row = results.rows.item(0);
            map = JSON.parse(row['data']);
            if (DEBUG) {
              console.log("Map loaded for seed: " + seed);
            }
            return canvas.render(map);
          } else {
            return mapGenerator();
          }
        };
        db.load(seed, mapLoader, dbErrorHandler);
        $('#waterline_value').text(canvas.waterline);
        $sliders = $('#waterline');
        $sliders.slider({
          value: parseFloat(canvas.waterline),
          min: -2,
          max: 2,
          step: 0.02,
          change: function(e, ui) {
            $('#waterline_value').text(ui.value);
            canvas.setWaterline(parseFloat(ui.value));
            return canvas.render(map);
          }
        });
        $('#shallows_offset').text(canvas.shallows);
        $sliders = $('#shallows');
        $sliders.slider({
          value: parseFloat(canvas.shallows),
          min: 0.0,
          max: 1,
          step: 0.01,
          change: function(e, ui) {
            $('#shallows_offset').text(ui.value);
            canvas.setShallowsOffset(parseFloat(ui.value));
            return canvas.render(map);
          }
        });
        $('#shoreline_offset').text(canvas.shoreline);
        $sliders = $('#shoreline');
        $sliders.slider({
          value: parseFloat(canvas.shoreline),
          min: 0.0,
          max: 0.20,
          step: 0.01,
          change: function(e, ui) {
            $('#shoreline_offset').text(ui.value);
            canvas.setShorelineOffset(parseFloat(ui.value));
            return canvas.render(map);
          }
        });
        $('#plains_offset').text(canvas.plains);
        $sliders = $('#plains');
        $sliders.slider({
          value: parseFloat(canvas.plains),
          min: 0.0,
          max: 2.00,
          step: 0.05,
          change: function(e, ui) {
            $('#plains_offset').text(ui.value);
            canvas.setPlainsOffset(parseFloat(ui.value));
            return canvas.render(map);
          }
        });
        $('#mountains_offset').text(canvas.mountains);
        $sliders = $('#mountains');
        $sliders.slider({
          value: parseFloat(canvas.mountains),
          min: 0.0,
          max: 2.00,
          step: 0.05,
          change: function(e, ui) {
            $('#mountains_offset').text(ui.value);
            canvas.setMountainsOffset(parseFloat(ui.value));
            return canvas.render(map);
          }
        });
        $canvas = $(canvas.getCanvas());
        $canvas.on('mousemove', function(e) {
          var pos;
          pos = canvas.getPosition(e);
          $('#canvas_x').text(pos.x);
          return $('#canvas_y').text(pos.y);
        });
        $('#apply').on('click', function(e) {
          return canvas.render(map);
        });
      }

      return App;

    })();
  });

}).call(this);
