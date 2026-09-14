class UserDto {
  final int id;
  final String name;

  const UserDto({required this.id, required this.name});

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(id: json['id'] as int, name: json['name'] as String);
  }
}
