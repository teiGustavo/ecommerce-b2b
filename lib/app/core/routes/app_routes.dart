import 'package:ecommerce_b2b/app/core/routes/app_pages.dart';
import 'package:ecommerce_b2b/app/presentation/layouts/main_layout.dart';
import 'package:ecommerce_b2b/app/presentation/pages/home_page.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: AppPage.home.path,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        // Envolve todas as páginas internas dentro do layout lateral fixo
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
          path: AppPage.home.path,
          builder: (context, state) => const HomePage(),
        ),
      ],
    ),
  ],
);
