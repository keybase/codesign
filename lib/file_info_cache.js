// Generated by IcedCoffeeScript 1.7.1-c
(function() {
  var FileInfo, InfoCollection, LockTable, XPlatformHash, constants, crypto, fs, ic, iced, item_types, path, utils, __iced_k, __iced_k_noop;

  iced = require('iced-runtime').iced;
  __iced_k = __iced_k_noop = function() {};

  path = require('path');

  fs = require('fs');

  crypto = require('crypto');

  LockTable = require('iced-utils').lock.Table;

  utils = require('./utils');

  XPlatformHash = require('./x_platform_hash');

  constants = require('./constants');

  item_types = require('./constants').item_types;

  FileInfo = (function() {
    function FileInfo(full_path) {
      this._BINARY_BYTE_STUDY = 8000;
      this.full_path = full_path;
      this.err = null;
      this.lstat = null;
      this.stat = null;
      this._hash = {};
      this._link_hash = {};
      this._is_binary = null;
      this._dir_contents = null;
      this._locks = new LockTable();
      this._init_done = false;
      this.link = null;
      this.possible_win_link = null;
      this.item_type = null;
    }

    FileInfo.prototype.init = function(cb) {
      var ___iced_passed_deferral, __iced_deferrals, __iced_k;
      __iced_k = __iced_k_noop;
      ___iced_passed_deferral = iced.findDeferral(arguments);
      (function(_this) {
        return (function(__iced_k) {
          __iced_deferrals = new iced.Deferrals(__iced_k, {
            parent: ___iced_passed_deferral,
            filename: "/Users/max/src/keybase/codesign/src/file_info_cache.iced",
            funcname: "FileInfo.init"
          });
          fs.lstat(_this.full_path, __iced_deferrals.defer({
            assign_fn: (function(__slot_1, __slot_2) {
              return function() {
                __slot_1.err = arguments[0];
                return __slot_2.lstat = arguments[1];
              };
            })(_this, _this),
            lineno: 45
          }));
          __iced_deferrals._fulfill();
        });
      })(this)((function(_this) {
        return function() {
          _this.stat = _this.lstat;
          (function(__iced_k) {
            if (!_this.err) {
              (function(__iced_k) {
                __iced_deferrals = new iced.Deferrals(__iced_k, {
                  parent: ___iced_passed_deferral,
                  filename: "/Users/max/src/keybase/codesign/src/file_info_cache.iced",
                  funcname: "FileInfo.init"
                });
                _this._x_platform_type_check(__iced_deferrals.defer({
                  lineno: 48
                }));
                __iced_deferrals._fulfill();
              })(__iced_k);
            } else {
              return __iced_k();
            }
          })(function() {
            _this._init_done = true;
            return cb();
          });
        };
      })(this));
    };

    FileInfo.prototype.check_init = function() {
      if (!this._init_done) {
        throw new Error("Init not done on " + this.full_path);
      }
    };

    FileInfo.prototype.hash = function(alg, encoding, cb) {
      var fd, h, k, lock, ___iced_passed_deferral, __iced_deferrals, __iced_k;
      __iced_k = __iced_k_noop;
      ___iced_passed_deferral = iced.findDeferral(arguments);
      this.check_init();
      k = "" + alg + "|" + encoding;
      (function(_this) {
        return (function(__iced_k) {
          __iced_deferrals = new iced.Deferrals(__iced_k, {
            parent: ___iced_passed_deferral,
            filename: "/Users/max/src/keybase/codesign/src/file_info_cache.iced",
            funcname: "FileInfo.hash"
          });
          _this._locks.acquire(k, __iced_deferrals.defer({
            assign_fn: (function() {
              return function() {
                return lock = arguments[0];
              };
            })(),
            lineno: 62
          }), true);
          __iced_deferrals._fulfill();
        });
      })(this)((function(_this) {
        return function() {
          (function(__iced_k) {
            if ((!_this.err) && (_this._hash[k] == null)) {
              h = new XPlatformHash({
                alg: alg,
                encoding: encoding
              });
              fd = fs.createReadStream(_this.full_path);
              (function(__iced_k) {
                __iced_deferrals = new iced.Deferrals(__iced_k, {
                  parent: ___iced_passed_deferral,
                  filename: "/Users/max/src/keybase/codesign/src/file_info_cache.iced",
                  funcname: "FileInfo.hash"
                });
                h.hash(fd, __iced_deferrals.defer({
                  assign_fn: (function(__slot_1, __slot_2, __slot_3) {
                    return function() {
                      __slot_1.err = arguments[0];
                      return __slot_2[__slot_3] = arguments[1];
                    };
                  })(_this, _this._hash, k),
                  lineno: 66
                }));
                __iced_deferrals._fulfill();
              })(__iced_k);
            } else {
              return __iced_k();
            }
          })(function() {
            lock.release();
            return cb(_this.err, _this._hash[k]);
          });
        };
      })(this));
    };

    FileInfo.prototype.link_hash = function(alg, encoding, cb) {
      var err, k, lock, ___iced_passed_deferral, __iced_deferrals, __iced_k;
      __iced_k = __iced_k_noop;
      ___iced_passed_deferral = iced.findDeferral(arguments);
      this.check_init();
      k = "" + alg + "|" + encoding + "|link_hash";
      (function(_this) {
        return (function(__iced_k) {
          __iced_deferrals = new iced.Deferrals(__iced_k, {
            parent: ___iced_passed_deferral,
            filename: "/Users/max/src/keybase/codesign/src/file_info_cache.iced",
            funcname: "FileInfo.link_hash"
          });
          _this._locks.acquire(k, __iced_deferrals.defer({
            assign_fn: (function() {
              return function() {
                return lock = arguments[0];
              };
            })(),
            lineno: 75
          }), true);
          __iced_deferrals._fulfill();
        });
      })(this)((function(_this) {
        return function() {
          (function(__iced_k) {
            if ((!_this.err) && (_this._link_hash[k] == null)) {
              (function(__iced_k) {
                __iced_deferrals = new iced.Deferrals(__iced_k, {
                  parent: ___iced_passed_deferral,
                  filename: "/Users/max/src/keybase/codesign/src/file_info_cache.iced",
                  funcname: "FileInfo.link_hash"
                });
                (new XPlatformHash({
                  alg: alg,
                  encoding: encoding
                })).hash_str(_this.link, __iced_deferrals.defer({
                  assign_fn: (function(__slot_1, __slot_2) {
                    return function() {
                      err = arguments[0];
                      return __slot_1[__slot_2] = arguments[1];
                    };
                  })(_this._link_hash, k),
                  lineno: 77
                }));
                __iced_deferrals._fulfill();
              })(__iced_k);
            } else {
              return __iced_k();
            }
          })(function() {
            lock.release();
            return cb(_this.err, _this._link_hash[k]);
          });
        };
      })(this));
    };

    FileInfo.prototype.dir_contents = function(cb) {
      var f, fnames, lock, ___iced_passed_deferral, __iced_deferrals, __iced_k;
      __iced_k = __iced_k_noop;
      ___iced_passed_deferral = iced.findDeferral(arguments);
      this.check_init();
      (function(_this) {
        return (function(__iced_k) {
          __iced_deferrals = new iced.Deferrals(__iced_k, {
            parent: ___iced_passed_deferral,
            filename: "/Users/max/src/keybase/codesign/src/file_info_cache.iced",
            funcname: "FileInfo.dir_contents"
          });
          _this._locks.acquire('dir_contents', __iced_deferrals.defer({
            assign_fn: (function() {
              return function() {
                return lock = arguments[0];
              };
            })(),
            lineno: 85
          }), true);
          __iced_deferrals._fulfill();
        });
      })(this)((function(_this) {
        return function() {
          (function(__iced_k) {
            if ((!_this.err) && (_this._dir_contents == null)) {
              (function(__iced_k) {
                __iced_deferrals = new iced.Deferrals(__iced_k, {
                  parent: ___iced_passed_deferral,
                  filename: "/Users/max/src/keybase/codesign/src/file_info_cache.iced",
                  funcname: "FileInfo.dir_contents"
                });
                fs.readdir(_this.full_path, __iced_deferrals.defer({
                  assign_fn: (function(__slot_1) {
                    return function() {
                      __slot_1.err = arguments[0];
                      return fnames = arguments[1];
                    };
                  })(_this),
                  lineno: 87
                }));
                __iced_deferrals._fulfill();
              })(function() {
                return __iced_k(typeof fnames !== "undefined" && fnames !== null ? _this._dir_contents = (function() {
                  var _i, _len, _results;
                  _results = [];
                  for (_i = 0, _len = fnames.length; _i < _len; _i++) {
                    f = fnames[_i];
                    if (f !== '.') {
                      _results.push(f);
                    }
                  }
                  return _results;
                })() : void 0);
              });
            } else {
              return __iced_k();
            }
          })(function() {
            lock.release();
            return cb(_this.err, _this._dir_contents);
          });
        };
      })(this));
    };

    FileInfo.prototype.get_link = function() {
      this.check_init();
      return this.link;
    };

    FileInfo.prototype.is_binary = function() {
      this.check_init();
      return this._is_binary;
    };

    FileInfo.prototype.is_user_executable_file = function() {
      this.check_init();
      return this.lstat.isFile() && !!(parseInt(100, 8) & this.lstat.mode);
    };

    FileInfo.prototype._x_platform_type_check = function(cb) {
      var data, lines, ___iced_passed_deferral, __iced_deferrals, __iced_k;
      __iced_k = __iced_k_noop;
      ___iced_passed_deferral = iced.findDeferral(arguments);

      /*
      gets link if it's a symbolic link; however if it is a regular
      file with a single short line in the file, it will save that in
      'possible_win_link' for cross-platform warnings
       */
      (function(_this) {
        return (function(__iced_k) {
          if (_this.lstat.isSymbolicLink()) {
            (function(__iced_k) {
              __iced_deferrals = new iced.Deferrals(__iced_k, {
                parent: ___iced_passed_deferral,
                filename: "/Users/max/src/keybase/codesign/src/file_info_cache.iced",
                funcname: "FileInfo._x_platform_type_check"
              });
              fs.readlink(_this.full_path, __iced_deferrals.defer({
                assign_fn: (function(__slot_1, __slot_2) {
                  return function() {
                    __slot_1.err = arguments[0];
                    return __slot_2.link = arguments[1];
                  };
                })(_this, _this),
                lineno: 119
              }));
              __iced_deferrals._fulfill();
            })(function() {
              return __iced_k(_this.item_type = item_types.SYMLINK);
            });
          } else {
            (function(__iced_k) {
              if (_this.stat.isFile()) {
                _this.item_type = item_types.FILE;
                (function(__iced_k) {
                  __iced_deferrals = new iced.Deferrals(__iced_k, {
                    parent: ___iced_passed_deferral,
                    filename: "/Users/max/src/keybase/codesign/src/file_info_cache.iced",
                    funcname: "FileInfo._x_platform_type_check"
                  });
                  _this._binary_check(__iced_deferrals.defer({
                    lineno: 123
                  }));
                  __iced_deferrals._fulfill();
                })(__iced_k);
              } else {
                return __iced_k(_this.stat.isDirectory() ? _this.item_type = item_types.DIR : void 0);
              }
            })(__iced_k);
          }
        });
      })(this)((function(_this) {
        return function() {
          (function(__iced_k) {
            if ((_this.item_type === item_types.FILE) && (_this.stat.size < constants.tweakables.WIN_SYMLINK_MAX_LEN) && (!_this._is_binary)) {
              (function(__iced_k) {
                __iced_deferrals = new iced.Deferrals(__iced_k, {
                  parent: ___iced_passed_deferral,
                  filename: "/Users/max/src/keybase/codesign/src/file_info_cache.iced",
                  funcname: "FileInfo._x_platform_type_check"
                });
                fs.readFile(_this.full_path, {
                  encoding: 'utf8'
                }, __iced_deferrals.defer({
                  assign_fn: (function(__slot_1) {
                    return function() {
                      __slot_1.err = arguments[0];
                      return data = arguments[1];
                    };
                  })(_this),
                  lineno: 129
                }));
                __iced_deferrals._fulfill();
              })(function() {
                data = data.replace(/(^[\s]*)|([\s]*$)/g, '');
                lines = data.split(/[\n\r]+/g);
                return __iced_k(lines.length === 1 ? _this.possible_win_link = lines[0] : void 0);
              });
            } else {
              return __iced_k();
            }
          })(function() {
            return cb();
          });
        };
      })(this));
    };

    FileInfo.prototype._binary_check = function(cb) {
      var b, bytes_read, fd, i, len, ___iced_passed_deferral, __iced_deferrals, __iced_k;
      __iced_k = __iced_k_noop;
      ___iced_passed_deferral = iced.findDeferral(arguments);
      (function(_this) {
        return (function(__iced_k) {
          __iced_deferrals = new iced.Deferrals(__iced_k, {
            parent: ___iced_passed_deferral,
            filename: "/Users/max/src/keybase/codesign/src/file_info_cache.iced",
            funcname: "FileInfo._binary_check"
          });
          fs.open(_this.full_path, 'r', __iced_deferrals.defer({
            assign_fn: (function(__slot_1) {
              return function() {
                __slot_1.err = arguments[0];
                return fd = arguments[1];
              };
            })(_this),
            lineno: 139
          }));
          __iced_deferrals._fulfill();
        });
      })(this)((function(_this) {
        return function() {
          (function(__iced_k) {
            if (!_this.err) {
              len = Math.min(_this.stat.size, _this._BINARY_BYTE_STUDY);
              (function(__iced_k) {
                if (!len) {
                  return __iced_k(_this._is_binary = true);
                } else {
                  b = new Buffer(len);
                  (function(__iced_k) {
                    __iced_deferrals = new iced.Deferrals(__iced_k, {
                      parent: ___iced_passed_deferral,
                      filename: "/Users/max/src/keybase/codesign/src/file_info_cache.iced",
                      funcname: "FileInfo._binary_check"
                    });
                    fs.read(fd, b, 0, len, 0, __iced_deferrals.defer({
                      assign_fn: (function(__slot_1) {
                        return function() {
                          __slot_1.err = arguments[0];
                          return bytes_read = arguments[1];
                        };
                      })(_this),
                      lineno: 146
                    }));
                    __iced_deferrals._fulfill();
                  })(function() {
                    var _i, _ref;
                    if (bytes_read !== len) {
                      console.log("#Requested " + len + " bytes of " + _this.full_path + ", but got " + bytes_read);
                    }
                    _this._is_binary = false;
                    for (i = _i = 0, _ref = b.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
                      if (b.readUInt8(i) === 0) {
                        _this._is_binary = true;
                        break;
                      }
                    }
                    return __iced_k();
                  });
                }
              })(function() {
                (function(__iced_k) {
                  __iced_deferrals = new iced.Deferrals(__iced_k, {
                    parent: ___iced_passed_deferral,
                    filename: "/Users/max/src/keybase/codesign/src/file_info_cache.iced",
                    funcname: "FileInfo._binary_check"
                  });
                  fs.close(fd, __iced_deferrals.defer({
                    assign_fn: (function(__slot_1) {
                      return function() {
                        return __slot_1.err = arguments[0];
                      };
                    })(_this),
                    lineno: 154
                  }));
                  __iced_deferrals._fulfill();
                })(__iced_k);
              });
            } else {
              return __iced_k();
            }
          })(function() {
            return cb();
          });
        };
      })(this));
    };

    return FileInfo;

  })();

  InfoCollection = (function() {
    function InfoCollection() {
      this._locks = new LockTable();
      this._cache = {};
    }

    InfoCollection.prototype.get = function(f, cb) {
      var lock, ___iced_passed_deferral, __iced_deferrals, __iced_k;
      __iced_k = __iced_k_noop;
      ___iced_passed_deferral = iced.findDeferral(arguments);
      f = path.resolve(f);
      (function(_this) {
        return (function(__iced_k) {
          __iced_deferrals = new iced.Deferrals(__iced_k, {
            parent: ___iced_passed_deferral,
            filename: "/Users/max/src/keybase/codesign/src/file_info_cache.iced",
            funcname: "InfoCollection.get"
          });
          _this._locks.acquire(f, __iced_deferrals.defer({
            assign_fn: (function() {
              return function() {
                return lock = arguments[0];
              };
            })(),
            lineno: 172
          }), true);
          __iced_deferrals._fulfill();
        });
      })(this)((function(_this) {
        return function() {
          (function(__iced_k) {
            if (_this._cache[f] == null) {
              _this._cache[f] = new FileInfo(f);
              (function(__iced_k) {
                __iced_deferrals = new iced.Deferrals(__iced_k, {
                  parent: ___iced_passed_deferral,
                  filename: "/Users/max/src/keybase/codesign/src/file_info_cache.iced",
                  funcname: "InfoCollection.get"
                });
                _this._cache[f].init(__iced_deferrals.defer({
                  lineno: 175
                }));
                __iced_deferrals._fulfill();
              })(__iced_k);
            } else {
              return __iced_k();
            }
          })(function() {
            lock.release();
            return cb(_this._cache[f].err, _this._cache[f]);
          });
        };
      })(this));
    };

    return InfoCollection;

  })();

  ic = new InfoCollection();

  module.exports = function(f, cb) {
    return ic.get(f, cb);
  };

}).call(this);
