import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/products_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/products/:category',
      builder: (context, state) {
        final category = state.pathParameters['category']!;
        return ProductsScreen(category: category);
      },
    ),
  ],
);