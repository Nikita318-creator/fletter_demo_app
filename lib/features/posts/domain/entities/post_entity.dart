class PostEntity {
  final int id;
  final int userId;
  final String title;
  final String body;
  final String? authorName;
  final bool isFavorite;

  const PostEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.authorName,
    this.isFavorite = false,
  });

  PostEntity copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
    String? authorName,
    bool? isFavorite,
  }) {
    return PostEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      authorName: authorName ?? this.authorName,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}