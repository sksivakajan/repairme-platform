import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repairme_customer/app.dart';

double _opacityOf(WidgetTester tester, String text) {
  final render = tester.renderObject<RenderAnimatedOpacity>(
    find.ancestor(of: find.text(text), matching: find.byType(AnimatedOpacity)).first,
  );
  return render.opacity.value;
}

void main() {
  testWidgets('switching tabs fades the old one out and the new one in', (tester) async {
    Widget app(int index) => MaterialApp(
          home: FadeBranches(currentIndex: index, children: const [Text('Home'), Text('Profile')]),
        );

    await tester.pumpWidget(app(0));
    await tester.pump(const Duration(milliseconds: 400));
    expect(_opacityOf(tester, 'Home'), 1);
    expect(_opacityOf(tester, 'Profile'), 0);

    // Go to the later tab (this used to leave it stuck on screen when going back).
    await tester.pumpWidget(app(1));
    await tester.pump(const Duration(milliseconds: 400));
    expect(_opacityOf(tester, 'Profile'), 1);
    expect(_opacityOf(tester, 'Home'), 0);

    await tester.pumpWidget(app(0));
    await tester.pump(const Duration(milliseconds: 400));
    expect(_opacityOf(tester, 'Home'), 1);
    expect(_opacityOf(tester, 'Profile'), 0, reason: 'the Profile tab must fade away when Home is chosen');
  });
}
