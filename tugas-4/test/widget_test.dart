import 'package:flutter_test/flutter_test.dart';
import 'package:kuliner_kita/main.dart';
import 'package:kuliner_kita/ui/view_models/foodview_ui_state.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('FoodView app renders splash and navigates to main screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => FoodViewUiState(),
        child: const FoodViewApp(),
      ),
    );

    // Splash screen stage 0..2
    await tester.pump(const Duration(milliseconds: 2400));
    await tester.pumpAndSettle();

    expect(find.text('Selamat Datang!'), findsOneWidget);
    expect(find.text('Kategori'), findsOneWidget);
    expect(find.text('Top of the Week'), findsOneWidget);
  });
}
