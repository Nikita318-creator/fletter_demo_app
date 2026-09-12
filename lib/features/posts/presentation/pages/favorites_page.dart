import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/DI/injection.dart';
import '../../../../core/router/app_router.dart';
import '../bloc/favorites/favorites_bloc.dart';
import '../bloc/favorites/favorites_event.dart';
import '../bloc/favorites/favorites_state.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FavoritesBloc>()..add(const FetchFavoritesEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Favorites')),
        body: BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            return switch (state) {
              FavoritesInitial() || FavoritesLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              FavoritesEmpty() => RefreshIndicator(
                onRefresh: () async {
                  context.read<FavoritesBloc>().add(
                    const FetchFavoritesEvent(),
                  );
                },
                child: ListView(
                  children: const [
                    SizedBox(height: 200),
                    Center(child: Text('No favorite posts yet')),
                  ],
                ),
              ),
              FavoritesError(message: final msg) => Center(child: Text(msg)),
              FavoritesData(posts: final posts) => RefreshIndicator(
                onRefresh: () async {
                  context.read<FavoritesBloc>().add(
                    const FetchFavoritesEvent(),
                  );
                },
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return ListTile(
                      title: Text(
                        post.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        post.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.favorite, color: Colors.red),
                      onTap: () async {
                        await context.push(
                          AppRoutes.postDetail,
                          extra: post.id,
                        );
                        if (context.mounted) {
                          context.read<FavoritesBloc>().add(
                            const FetchFavoritesEvent(),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            };
          },
        ),
      ),
    );
  }
}
