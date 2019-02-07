const String _jsonTagId = "id";
const String _jsonTagName = "name";
const String _jsonTagEmail = "email";

class User {
  String id;
  String name;
  String email;

  User({this.id, this.name, this.email});

  factory User.fromMap(Map<String, dynamic> map) => User(
        id: map[_jsonTagId],
        email: map[_jsonTagEmail],
        name: map[_jsonTagName],
      );

  Map<String, dynamic> toMap() =>
      {_jsonTagId: id, _jsonTagEmail: email, _jsonTagName: name};
}
