import 'package:flutter/material.dart';

import 'models/cart_model.dart';
import 'pages/cart_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final CartModel _cart = CartModel();
  int _currentIndex = 0;

  List<Widget> get _pages => [
    const HomePage(),
    CartPage(onSwitchToHome: () => setState(() => _currentIndex = 0)),
  ];

  @override
  void dispose() {
    _cart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CartModelScope(
      cart: _cart,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mağaza',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF5F5F7),
          colorSchemeSeed: const Color(0xFF1D1D1F),
          brightness: Brightness.light,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF5F5F7),
            foregroundColor: Color(0xFF1D1D1F),
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Color(0xFF1D1D1F),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        home: ListenableBuilder(
          listenable: _cart,
          builder: (context, _) => Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              backgroundColor: Colors.white,
              selectedItemColor: const Color(0xFF1D1D1F),
              unselectedItemColor: Colors.grey.shade400,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Ana Sayfa',
                ),
                BottomNavigationBarItem(
                  icon: Badge(
                    isLabelVisible: _cart.totalItems > 0,
                    label: Text('${_cart.totalItems}'),
                    child: const Icon(Icons.shopping_bag_outlined),
                  ),
                  activeIcon: Badge(
                    isLabelVisible: _cart.totalItems > 0,
                    label: Text('${_cart.totalItems}'),
                    child: const Icon(Icons.shopping_bag),
                  ),
                  label: 'Sepet',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CartModelScope extends InheritedNotifier<CartModel> {
  const CartModelScope({
    super.key,
    required CartModel cart,
    required super.child,
  }) : super(notifier: cart);

  static CartModel of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CartModelScope>();
    assert(scope != null, 'No CartModelScope found in context');
    return scope!.notifier!;
  }
}
