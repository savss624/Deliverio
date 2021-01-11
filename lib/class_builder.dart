import 'profile.dart';
import 'home.dart';
import 'schedules.dart';
import 'settings.dart';
import 'notifications.dart';
import 'stats.dart';

typedef T Constructor<T>();

final Map<String, Constructor<Object>> _constructors = <String, Constructor<Object>>{};

void register<T>(Constructor<T> constructor) {
  _constructors[T.toString()] = constructor;
}

class ClassBuilder {
  static void registerClasses() {
    register<Home>(() => Home());
    register<Profile>(() => Profile());
    register<Notifications>(() => Notifications());
    register<Stats>(() => Stats());
    register<Schedules>(() => Schedules());
    register<Settings>(() => Settings());
  }

  static dynamic fromString(String type) {
    return _constructors[type]();
  }
}