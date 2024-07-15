import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourcast/domain/weather.dart';
import 'package:tourcast/domain/forecast.dart';

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
    return await openDatabase(path, version: 2, onCreate: (db, newer) async {
      await db.execute('CREATE TABLE cities('
          '  id INTEGER PRIMARY KEY,'
          '  name TEXT,'
          '  timestamp DATETIME DEFAULT CURRENT_TIMESAMP);');
      await db.execute('CREATE TABLE forecasts('
          '  id INTEGER PRIMARY KEY,'
          '  description TEST,'
          '  temperature REAL,'
          '  min         REAL,'
          '  max         REAL,'
          '  city        INTEGER,'
          '  FOREIGN KEY(city) REFERENCES cities(id));');
      await db.execute(
          'ALTER TABLE cities ADD COLUMN forecast INTEGER REFERENCES forecasts(id) DEFAULT NULL;');
    });
  }

  Future<void> saveForecast(String cityName, Forecast forecast) async {
    var dbRef = await db;
    int id = await dbRef.insert('cities', {'name': cityName},
        conflictAlgorithm: ConflictAlgorithm.replace);
    await dbRef.delete('forecasts', where: 'city = ?', whereArgs: [id]);
    for (final weather in forecast.weatherForecast) {
      await dbRef.insert('forecasts', {
        'description': weather.description,
        'temperature': weather.temperature,
        'city': id
      });
    }
  }

  Future<Forecast> getForecast(String cityName) async {
    var dbRef = await db;
    final cityMap =
        await dbRef.rawQuery('SELECT * FROM cities WHERE name = "$cityName";');
    var id = 0;
    for (final city in cityMap) {
      id = city['id']! as int;
    }
    final listMap =
        await dbRef.rawQuery('SELECT * FROM forecasts WHERE city = "$id";');
    final weatherForecast = <Weather>[];
    for (final map in listMap) {
      final w = Weather(
          description: map['description'] as String,
          temperature: map['temperature'] as double);
      weatherForecast.add(w);
    }

    return Forecast(weatherForecast: weatherForecast, time: DateTime.now());
  }

  Future<void> clear() async {
    _db!.delete('cities');
    _db!.delete('forecasts');
  }

  static final provider =
      Provider<LocalWeatherRepository>((ref) => LocalWeatherRepository());
}
