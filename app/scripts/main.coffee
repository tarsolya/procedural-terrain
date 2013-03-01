window.DEBUG = true
require.config
  shim: {}
  paths:
    jquery: 'vendor/jquery.min'
    snoise: 'vendor/simplex-noise'
    seedrandom: 'vendor/seedrandom'

require [
  'jquery',
  'app'
], ($, App) ->
  console.log "Legends loaded ..." if DEBUG
  window.App = new App()
