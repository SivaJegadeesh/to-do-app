import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/main.dart'; // 👈 update this import

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp()); // 👈 use correct class name
    expect(find.text('📝 My To-Do List'), findsOneWidget);
  });
}
