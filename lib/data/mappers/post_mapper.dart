import '../../domain/entities/post_entity.dart';
import '../models/post_dto.dart';

extension PostDtoMapper on PostDto {
  PostEntity toEntity({String? authorName, bool isFavorite = false}) {
    return PostEntity(
      id: id,
      userId: userId,
      title: title,
      body: body,
      authorName: authorName,
      isFavorite: isFavorite,
    );
  }
}

extension PostEntityMapper on PostEntity {
  PostDto toDto() {
    return PostDto(
      id: id,
      userId: userId,
      title: title,
      body: body,
    );
  }
}