import 'package:quiver/core.dart';

const String _jsonTagId = "id";
const String _jsonTagName = "name";
const String _jsonTagColor = "color";

class Tag {
  String id;
  String name;
  String color;

  Tag({this.id, this.name, this.color});

  factory Tag.fromMap(Map<String, dynamic> map) => Tag(
        id: map[_jsonTagId],
        name: map[_jsonTagName],
        color: map[_jsonTagColor],
      );

  Map<String, dynamic> toMap() =>
      {_jsonTagId: id, _jsonTagColor: color, _jsonTagName: name};

  bool operator ==(o) => o is Tag && o.name == name && o.id == id && o.color == o.color;
  
  int get hashCode => hash3(name.hashCode, id.hashCode, color.hashCode);
}