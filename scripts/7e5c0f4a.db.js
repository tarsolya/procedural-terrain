(function() {

  define(['jquery'], function($) {
    var Db;
    return Db = (function() {

      function Db() {
        var displayName, errorHandler, maxSize, nullHandler, shortName, version;
        try {
          if (!window.openDatabase) {
            console.log("Databases are not supported in this browser");
          } else {
            shortName = 'Legends';
            version = '1.0';
            displayName = 'Legends DB';
            maxSize = 1024 *  1024 *  32;
            this.db = openDatabase(shortName, version, displayName, maxSize);
            errorHandler = function(error) {
              return console.log("DB error: ", error);
            };
            nullHandler = function(message) {};
            this.db.transaction(function(t) {
              return t.executeSql('CREATE TABLE IF NOT EXISTS maps(seed VARCHAR NOT NULL PRIMARY KEY, data TEXT)', [], nullHandler, errorHandler);
            });
          }
        } catch (e) {
          if (DEBUG) {
            console.log("Database initialization failed: " + e);
          }
        }
        this.store = function(seed, map, nullHandler, errorHandler) {
          return this.db.transaction(function(t) {
            return t.executeSql('INSERT INTO maps (seed, data) VALUES (?, ?)', [seed, map], nullHandler, errorHandler);
          });
        };
        this.load = function(seed, selectHandler, errorHandler) {
          return this.db.transaction(function(t) {
            return t.executeSql('SELECT data FROM maps WHERE seed == ?', [seed], selectHandler, errorHandler);
          });
        };
        this.exists = function(seed, selectHandler, errorHandler) {
          return this.db.transaction(function(t) {
            return t.executeSql('SELECT count(*) FROM maps WHERE seed == ?', [seed], selectHandler, errorHandler);
          });
        };
      }

      return Db;

    })();
  });

}).call(this);
