import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/DI/injection.dart';
import '../../../../core/router/app_router.dart';
import '../bloc/posts_list/posts_list_bloc.dart';
import '../bloc/posts_list/posts_list_event.dart';
import '../bloc/posts_list/posts_list_state.dart';

class PostsListPage extends StatelessWidget {
  const PostsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PostsListBloc>()..add(const FetchPostsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Posts'),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () => context.push(AppRoutes.favorites),
            ),
          ],
        ),
        body: BlocBuilder<PostsListBloc, PostsListState>(
          builder: (context, state) {
            return switch (state) {
              PostsListInitial() || PostsListLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              PostsListEmpty() => const Center(
                  child: Text('No posts found'),
                ),
              PostsListError(message: final msg) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(msg),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<PostsListBloc>().add(const FetchPostsEvent());
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              PostsListData(posts: final posts) => RefreshIndicator(
                  onRefresh: () async {
                    context.read<PostsListBloc>().add(const RefreshPostsEvent());
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
                        trailing: post.isFavorite
                            ? const Icon(Icons.favorite, color: Colors.red)
                            : null,
                        onTap: () {
                          context.push(AppRoutes.postDetail, extra: post.id);
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