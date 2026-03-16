import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/main.dart';

void main() {
  group('TodoItem', () {
    test('toJson converts item to map correctly', () {
      final item = TodoItem(title: 'Buy milk', isDone: true);
      final json = item.toJson();

      expect(json['title'], 'Buy milk');
      expect(json['isDone'], true);
    });

    test('fromJson creates item from map correctly', () {
      final json = {'title': 'Walk the dog', 'isDone': false};
      final item = TodoItem.fromJson(json);

      expect(item.title, 'Walk the dog');
      expect(item.isDone, false);
    });

    test('round-trip serialization preserves data', () {
      final original = TodoItem(title: 'Study Flutter', isDone: true);
      final restored = TodoItem.fromJson(original.toJson());

      expect(restored.title, original.title);
      expect(restored.isDone, original.isDone);
    });
  });

  group('TodoStorage', () {
    test('loadTodos returns empty list when no data stored', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storage = TodoStorage(prefs);

      final todos = storage.loadTodos();

      expect(todos, isEmpty);
    });

    test('saveTodos and loadTodos persist items with state', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storage = TodoStorage(prefs);

      final items = [
        TodoItem(title: 'Task 1', isDone: false),
        TodoItem(title: 'Task 2', isDone: true),
      ];
      await storage.saveTodos(items);

      final loaded = storage.loadTodos();

      expect(loaded.length, 2);
      expect(loaded[0].title, 'Task 1');
      expect(loaded[0].isDone, false);
      expect(loaded[1].title, 'Task 2');
      expect(loaded[1].isDone, true);
    });

    test('saveTodos overwrites previous data', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storage = TodoStorage(prefs);

      await storage.saveTodos([TodoItem(title: 'Old task')]);
      await storage.saveTodos([TodoItem(title: 'New task')]);

      final loaded = storage.loadTodos();

      expect(loaded.length, 1);
      expect(loaded[0].title, 'New task');
    });

    test('loadTodos correctly reads pre-existing SharedPreferences data',
        () async {
      final preExisting = jsonEncode([
        {'title': 'Existing item', 'isDone': true},
      ]);
      SharedPreferences.setMockInitialValues({'todo_items': preExisting});
      final prefs = await SharedPreferences.getInstance();
      final storage = TodoStorage(prefs);

      final loaded = storage.loadTodos();

      expect(loaded.length, 1);
      expect(loaded[0].title, 'Existing item');
      expect(loaded[0].isDone, true);
    });
  });
}
