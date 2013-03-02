(function() {

  window.DEBUG = true;

  require.config({
    deps: ['main'],
    shim: {
      'jquery-ui': {
        exports: '$',
        deps: ['jquery']
      }
    },
    paths: {
      jquery: 'vendor/jquery',
      'jquery-ui': 'vendor/jquery-ui',
      snoise: 'vendor/simplex-noise',
      seedrandom: 'vendor/seedrandom'
    }
  });

  require(['jquery-ui', 'app'], function($, App) {
    if (DEBUG) {
      console.log("Legends loaded ...");
    }
    return window.App = new App();
  });

}).call(this);
