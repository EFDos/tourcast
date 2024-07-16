import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourcast/domain/weather.dart';
import 'package:tourcast/domain/forecast.dart';

/// [LocalWeatherRepository]
/// Persists weather forecast data in relation to cities.
/// Also used to check the last weather data update.
class LocalWeatherRepository {
  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await _initDatabase();
      return _db!;
    }
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'weather.db');
    return await openDatabase(path, version: 1, onCreate: (db, newer) async {
      await db.execute('CREATE TABLE cities('
          '  id INTEGER PRIMARY KEY,'
          '  name TEXT,'
          '  timestamp INTEGER(4) DEFAULT 0);');
      await db.execute('CREATE TABLE forecasts('
          '  id INTEGER PRIMARY KEY,'
          '  description TEXT,'
          '  temperature REAL,'
          '  min         REAL,'
          '  max         REAL,'
          '  condition   INTEGER,'
          '  city        INTEGER,'
          '  FOREIGN KEY(city) REFERENCES cities(id));');
      await db.execute(
          'ALTER TABLE cities ADD COLUMN forecast INTEGER REFERENCES forecasts(id) DEFAULT NULL;');
    });
  }

  /// Save [forecast] in relation to [cityName]
  Future<void> saveForecast(String cityName, Forecast forecast) async {
    var dbRef = await db;
    int id = await dbRef.insert('cities',
        {'name': cityName, 'timestamp': DateTime.now().millisecondsSinceEpoch},
        conflictAlgorithm: ConflictAlgorithm.replace);
    await dbRef.delete('forecasts', where: 'city = ?', whereArgs: [id]);
    for (final weather in forecast.weatherForecast) {
      await dbRef.insert('forecasts', {
        'description': weather.description,
        'temperature': weather.temperature,
        'min': weather.min,
        'max': weather.max,
        'condition': weather.conditionId,
        'city': id
      });
    }
  }

  /// Get [DateTime] from last weather data update
  Future<DateTime?> getLastUpdate(String cityName) async {
    var dbRef = await db;
    final cityMap =
        await dbRef.rawQuery('SELECT * FROM cities WHERE name = "$cityName";');

    if (cityMap.isEmpty || cityMap[0]['timestamp'] is! int) {
      return null;
    }

    var timestamp = cityMap[0]['timestamp'] as int;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Get [Forecast] in relation to [cityName]
  Future<Forecast> getForecast(String cityName) async {
    var dbRef = await db;
    final cityMap =
        await dbRef.rawQuery('SELECT * FROM cities WHERE name = "$cityName";');

    if (cityMap.isEmpty || cityMap[0]['id'] is! int) {
      return const Forecast(weatherForecast:[]);
    }
    var id = cityMap[0]['id']! as int;

    final listMap =
        await dbRef.rawQuery('SELECT * FROM forecasts WHERE city = "$id";');
    final weatherForecast = <Weather>[];
    for (final map in listMap) {
      final w = Weather(
          description: map['description'] as String,
          temperature: map['temperature'] as double,
          min: map['min'] as double,
          max: map['max'] as double,
          conditionId: map['condition'] as int);
      weatherForecast.add(w);
    }

    return Forecast(weatherForecast: weatherForecast);
  }

  /// Clear Database
  Future<void> clear() async {
    _db!.delete('cities');
    _db!.delete('forecasts');
  }

  static final provider =
      Provider<LocalWeatherRepository>((ref) => LocalWeatherRepository());
}
