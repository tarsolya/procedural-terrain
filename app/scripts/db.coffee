define [
  'jquery'
], ($) ->
  class Db
    constructor: ->
      try
        if not window.openDatabase
          console.log "Databases are not supported in this browser"
        else
          shortName = 'Legends'
          version = '1.0'
          displayName = 'Legends DB'
          maxSize = 1024 * 1024 * 32 # 32 MB
          @db = openDatabase(shortName, version, displayName, maxSize);

          errorHandler = (error) -> console.log "DB error: ",error
          nullHandler = (message) ->

          @db.transaction (t) ->
            t.executeSql(
              'CREATE TABLE IF NOT EXISTS maps(seed VARCHAR NOT NULL PRIMARY KEY, data TEXT)',
              [],
              nullHandler,
              errorHandler)

      catch e
        console.log "Database initialization failed: #{e}" if DEBUG

      @store = (seed, map, nullHandler, errorHandler) ->
        @db.transaction (t) ->
          t.executeSql('INSERT INTO maps (seed, data) VALUES (?, ?)', [seed, map], nullHandler, errorHandler)

      @load = (seed, selectHandler, errorHandler) ->
        @db.transaction (t) ->
          t.executeSql('SELECT data FROM maps WHERE seed == ?', [seed], selectHandler, errorHandler)

      @exists = (seed, selectHandler, errorHandler) ->
        @db.transaction (t) ->
          t.executeSql('SELECT count(*) FROM maps WHERE seed == ?', [seed], selectHandler, errorHandler)





