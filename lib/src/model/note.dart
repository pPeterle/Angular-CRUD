library firebase_demo_ng.item;

const String jsonTagText = "text";
const String jsonTagTitle = "title";
const String jsonTagImgUrl = "img_url";
const String jsonTagKey = "key";

class Note {
  String key;
  String text;
  String title;
  String imageUrl;

  Note({this.text, this.title, this.imageUrl, this.key});

  factory Note.fromMap(Map<String, dynamic> map ) => Note(
    text: map[jsonTagText],
    title: map[jsonTagTitle],
    imageUrl: map[jsonTagImgUrl],
    key: map[jsonTagKey]
  );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> jsonMap = {
      jsonTagKey: key,
      jsonTagText: text,
      jsonTagTitle: title,
      jsonTagImgUrl: imageUrl
    };
    return jsonMap;
  }
}
