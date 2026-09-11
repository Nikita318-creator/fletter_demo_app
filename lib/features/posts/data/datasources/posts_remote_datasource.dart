import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/post_dto.dart';
import '../models/user_dto.dart';

abstract interface class PostsRemoteDataSource {
  Future<List<PostDto>> getPosts();
  Future<PostDto> getPost(int id);
  Future<UserDto> getUser(int id);
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  final DioClient _client;

  PostsRemoteDataSourceImpl(this._client);

  @override
  Future<List<PostDto>> getPosts() async {
    final response = await _client.dio.get('/posts');
    final list = response.data as List;
    return list.map((e) => PostDto.fromJson(e)).toList();
  }

  @override
  Future<PostDto> getPost(int id) async {
    final response = await _client.dio.get('/posts/$id');
    return PostDto.fromJson(response.data);
  }

  @override
  Future<UserDto> getUser(int id) async {
    final response = await _client.dio.get('/users/$id');
    return UserDto.fromJson(response.data);
  }
}
