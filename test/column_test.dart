//import 'package:flutter_test/flutter_test.dart';
//import 'package:flutter/rendering.dart';
//import 'package:flutter/widgets.dart';
//
//
//
//void main() {
//  testWidgets('Column with default main axis parameters', (WidgetTester tester) async {
//    final Key columnKey = const Key('column');
//    final Key child0Key = const Key('child0');
//    final Key child1Key = const Key('child1');
//    final Key child2Key = const Key('child2');
//
//    // Default is MainAxisSize.max so the Column should be as high as the test: 600.
//    // Default is MainAxisAlignment.start so children so the children's
//    // top edges should be at 0, 100, 200
//    await tester.pumpWidget(new Center(
//        child:
//        new Column(
//            key: columnKey,
//            children: <Widget>[
//              new Container(key: child0Key, width: 100.0, height: 100.0),
//              new Container(key: child1Key, width: 100.0, height: 100.0),
//              new Container(key: child2Key, width: 100.0, height: 100.0),
//            ]
//        )
//    ));
//
//    RenderBox renderBox;
//    BoxParentData boxParentData;
//
//    renderBox = tester.renderObject(find.byKey(columnKey));
//    expect(renderBox.size.width, equals(100.0));
//    expect(renderBox.size.height, equals(600.0));
//
//    renderBox = tester.renderObject(find.byKey(child0Key));
//    expect(renderBox.size.width, equals(100.0));
//    expect(renderBox.size.height, equals(100.0));
//    boxParentData = renderBox.parentData;
//    expect(boxParentData.offset.dy, equals(0.0));
//
//    renderBox = tester.renderObject(find.byKey(child1Key));
//    expect(renderBox.size.width, equals(100.0));
//    expect(renderBox.size.height, equals(100.0));
//    boxParentData = renderBox.parentData;
//    expect(boxParentData.offset.dy, equals(100.0));
//
//    renderBox = tester.renderObject(find.byKey(child2Key));
//    expect(renderBox.size.width, equals(100.0));
//    expect(renderBox.size.height, equals(100.0));
//    boxParentData = renderBox.parentData;
//    expect(boxParentData.offset.dy, equals(200.0));
//  });
//
//}