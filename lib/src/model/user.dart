const String jsonTagId = "id";
const String jsonTagName = "name";
const String jsonTagEmail = "email";

class User {
  String id;
  String name;
  String email;

  User({this.id, this.name, this.email});

  factory User.fromMap(Map<String, dynamic> map) => User(
        id: map[jsonTagId],
        email: map[jsonTagEmail],
        name: map[jsonTagName],
      );

  Map<String, dynamic> toMap() =>
      {jsonTagId: id, jsonTagEmail: email, jsonTagName: name};
}
