import 'package:go_router/go_router.dart';

import '../../presentation/pages/favorites_page.dart';
import '../../presentation/pages/post_detail_page.dart';
import '../../presentation/pages/posts_list_page.dart';

abstract final class AppRoutes {
  static const posts = '/';
  static const postDetail = '/post-detail';
  static const favorites = '/favorites';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.posts,
  routes: [
    GoRoute(
      path: AppRoutes.posts,
      builder: (context, state) => const PostsListPage(),
    ),
    GoRoute(
      path: AppRoutes.postDetail,
      builder: (context, state) {
        final postId = state.extra as int;
        return PostDetailPage(postId: postId);
      },
    ),
    GoRoute(
      path: AppRoutes.favorites,
      builder: (context, state) => const FavoritesPage(),
    ),
  ],
);
