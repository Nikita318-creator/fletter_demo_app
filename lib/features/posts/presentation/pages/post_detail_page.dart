import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/DI/injection.dart';
import '../bloc/post_detail/post_detail_bloc.dart';
import '../bloc/post_detail/post_detail_event.dart';
import '../bloc/post_detail/post_detail_state.dart';

class PostDetailPage extends StatelessWidget {
  final int postId;

  const PostDetailPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PostDetailBloc>()..add(FetchPostDetailEvent(postId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Post Details')),
        body: BlocBuilder<PostDetailBloc, PostDetailState>(
          builder: (context, state) {
            return switch (state) {
              PostDetailInitial() || PostDetailLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              PostDetailError(message: final msg) => Center(child: Text(msg)),
              PostDetailData(post: final post) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Author: ${post.authorName ?? 'Unknown'}',
                      style: Theme.of(
                        context,
                      ).textTheme.subtitle1?.copyWith(color: Colors.grey[700]),
                    ),
                    const Divider(height: 32),
                    Text(
                      post.body,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(
                          post.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                        label: Text(
                          post.isFavorite
                              ? 'Remove from Favorites'
                              : 'Add to Favorites',
                        ),
                        onPressed: () {
                          context.read<PostDetailBloc>().add(
                            ToggleFavoriteEvent(post),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            };
          },
        ),
      ),
    );
  }
}
