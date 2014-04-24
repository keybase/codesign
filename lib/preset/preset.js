// Generated by IcedCoffeeScript 1.7.1-b
(function() {
  var GitPreset, GlobBase, PresetBase, constants, exports, fs, iced, path, preset, __iced_k, __iced_k_noop,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  iced = require('iced-coffee-script/lib/coffee-script/iced').runtime;
  __iced_k = __iced_k_noop = function() {};

  fs = require('fs');

  path = require('path');

  constants = require('./constants');

  PresetBase = require('./preset_base').PresetBase;

  GlobBase = (function(_super) {
    __extends(GlobBase, _super);

    function GlobBase(working_subpath, glob_list) {
      this.glob_list = glob_list;
      this.working_subpath = working_subpath;
    }

    GlobBase.prototype.handle = function(root_dir, path_to_file, cb) {};

    GlobBase.from_file = function(root_dir, subpath_to_file) {
      var fname, glob_list, working_subpath, ___iced_passed_deferral, __iced_deferrals, __iced_k;
      __iced_k = __iced_k_noop;
      ___iced_passed_deferral = iced.findDeferral(arguments);
      working_subpath = path.dirname(subpath_to_file);
      fname = path.join(root_dir, subpath_to_file);
      (function(_this) {
        return (function(__iced_k) {
          __iced_deferrals = new iced.Deferrals(__iced_k, {
            parent: ___iced_passed_deferral,
            filename: "/Users/chris/git/keybase/dir-summarize/src/preset/preset.iced",
            funcname: "GlobBase.from_file"
          });
          PresetBase.file_to_array(fname, __iced_deferrals.defer({
            assign_fn: (function() {
              return function() {
                return glob_list = arguments[0];
              };
            })(),
            lineno: 27
          }));
          __iced_deferrals._fulfill();
        });
      })(this)((function(_this) {
        return function() {
          return new GlobBase(working_subpath, glob_list);
        };
      })(this));
    };

    return GlobBase;

  })(PresetBase);

  GitPreset = (function(_super) {
    __extends(GitPreset, _super);

    function GitPreset() {
      var globs;
      globs = {};
    }

    GitPreset.prototype.handle = function(root_dir, path_to_file, cb) {};

    GitPreset.prototype.glob_from_dir = function() {};

    return GitPreset;

  })(PresetBase);

  preset = {};

  preset['none'] = {
    ignore: function(d, cb) {
      return cb([]);
    }
  };

  preset['dropbox'] = {
    ignore: function(d, cb) {
      return cb(['.dropbox.cache', '.dropbox']);
    }
  };

  preset['git'] = {
    ignore: function(d, cb) {
      var ig, ___iced_passed_deferral, __iced_deferrals, __iced_k;
      __iced_k = __iced_k_noop;
      ___iced_passed_deferral = iced.findDeferral(arguments);
      (function(_this) {
        return (function(__iced_k) {
          __iced_deferrals = new iced.Deferrals(__iced_k, {
            parent: ___iced_passed_deferral,
            filename: "/Users/chris/git/keybase/dir-summarize/src/preset/preset.iced"
          });
          glob_file_to_arr(path.join(d, '.gitignore'), __iced_deferrals.defer({
            assign_fn: (function() {
              return function() {
                return ig = arguments[0];
              };
            })(),
            lineno: 64
          }));
          __iced_deferrals._fulfill();
        });
      })(this)((function(_this) {
        return function() {
          ig.push('.git/');
          return cb(ig);
        };
      })(this));
    }
  };

  preset['kb'] = {
    ignore: function(d, cb) {
      var ig, ___iced_passed_deferral, __iced_deferrals, __iced_k;
      __iced_k = __iced_k_noop;
      ___iced_passed_deferral = iced.findDeferral(arguments);
      (function(_this) {
        return (function(__iced_k) {
          __iced_deferrals = new iced.Deferrals(__iced_k, {
            parent: ___iced_passed_deferral,
            filename: "/Users/chris/git/keybase/dir-summarize/src/preset/preset.iced"
          });
          glob_file_to_arr(path.join(d, '.kbignore'), __iced_deferrals.defer({
            assign_fn: (function() {
              return function() {
                return ig = arguments[0];
              };
            })(),
            lineno: 70
          }));
          __iced_deferrals._fulfill();
        });
      })(this)((function(_this) {
        return function() {
          return cb(ig);
        };
      })(this));
    }
  };

  preset['smart'] = {
    ignore: function(d, cb) {
      var ig1, ig2, ig3, r, ___iced_passed_deferral, __iced_deferrals, __iced_k;
      __iced_k = __iced_k_noop;
      ___iced_passed_deferral = iced.findDeferral(arguments);
      (function(_this) {
        return (function(__iced_k) {
          __iced_deferrals = new iced.Deferrals(__iced_k, {
            parent: ___iced_passed_deferral,
            filename: "/Users/chris/git/keybase/dir-summarize/src/preset/preset.iced"
          });
          preset['kb'].ignore(d, __iced_deferrals.defer({
            assign_fn: (function() {
              return function() {
                return ig1 = arguments[0];
              };
            })(),
            lineno: 76
          }));
          preset['git'].ignore(d, __iced_deferrals.defer({
            assign_fn: (function() {
              return function() {
                return ig2 = arguments[0];
              };
            })(),
            lineno: 77
          }));
          preset['dropbox'].ignore(d, __iced_deferrals.defer({
            assign_fn: (function() {
              return function() {
                return ig3 = arguments[0];
              };
            })(),
            lineno: 78
          }));
          __iced_deferrals._fulfill();
        });
      })(this)((function(_this) {
        return function() {
          var _i, _j, _len, _len1;
          for (_i = 0, _len = ig2.length; _i < _len; _i++) {
            r = ig2[_i];
            ig1.push(r);
          }
          for (_j = 0, _len1 = ig3.length; _j < _len1; _j++) {
            r = ig3[_j];
            ig1.push(r);
          }
          return cb(ig1);
        };
      })(this));
    }
  };

  exports = {
    preset: preset
  };

  module.exports = preset;

}).call(this);