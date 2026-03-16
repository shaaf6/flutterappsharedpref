# ToDo List App

A Flutter ToDo List application that uses the `shared_preferences` plugin to persist todo items locally on the device.

## What the Project Does

This app lets users manage a simple todo list with the following features:

- **Add** new todo items via a text field
- **Toggle** items as done/undone using checkboxes (completed items show a strikethrough)
- **Delete** items from the list
- **Persist** all todo items and their done/undone state using `shared_preferences`, so the list survives app restarts

## Architecture

- **`TodoItem`** - Model class representing a single todo with a `title` and `isDone` state, with JSON serialization support
- **`TodoStorage`** - Storage layer that saves and loads the todo list to/from `SharedPreferences` as a JSON-encoded string
- **`TodoPage`** - The main UI widget that ties everything together

## Running Tests

```bash
flutter test
```

The test suite includes unit tests for:
- `TodoItem` JSON serialization and deserialization
- `TodoStorage` save/load operations with `SharedPreferences`
