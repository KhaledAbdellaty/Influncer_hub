//TODO: create a federated package for this
import 'dart:convert';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html';

abstract class CacheService {
  T? get<T>(String key);

  void put<T>(String key, T value, {bool useLocalStorage = true});

  bool has(String key);

  void delete(String key);

  SharedPreferences get sharedPreferences;

  Storage get webSessionStorage;

  static CacheService get instance => Modular.get();
}

enum _CacheType { localStorage, sessionStorage, both, none }

class CacheServiceImpl extends CacheService {
  final SharedPreferences _prefs;
  late _CacheType _cacheType;
  CacheServiceImpl(this._prefs);

  void _checkCache(String key) {
    if (_prefs.containsKey(key)) {
      _cacheType = _CacheType.localStorage;
    } else if (webSessionStorage.containsKey(key)) {
      _cacheType = _CacheType.sessionStorage;
    } else if (_prefs.containsKey(key) && webSessionStorage.containsKey(key)) {
      _cacheType = _CacheType.both;
    } else {
      _cacheType = _CacheType.none;
    }
  }

  @override
  T? get<T>(String key) {
    if (!has(key)) return null;
    if (_cacheType == _CacheType.localStorage || _cacheType == _CacheType.both) {
      return jsonDecode(_prefs.getString(key)!) as T;
    }
    if (_cacheType == _CacheType.sessionStorage) {
      return jsonDecode(webSessionStorage[key]!) as T;
    }
    return null;
  }

  @override
  void put<T>(String key, T value, {bool useLocalStorage = true}) {
    if (useLocalStorage) {
      _prefs.setString(key, json.encode(value));
    } else {
      webSessionStorage[key] = json.encode(value);
    }
  }

  @override
  bool has(String key) {
    _checkCache(key);
    return _prefs.containsKey(key) || webSessionStorage.containsKey(key);
  }

  @override
  void delete(String key) {
    webSessionStorage.remove(key);
    _prefs.remove(key);
  }

  @override
  SharedPreferences get sharedPreferences => _prefs;

  @override
  Storage get webSessionStorage => window.sessionStorage;
}
