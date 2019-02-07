library firebase_demo_ng.item;

const String jsonTagText = "text";
const String jsonTagTitle = "title";
const String jsonTagImgUrl = "img_url";
const String jsonTagId = "key";

class Note {
  String id;
  String text;
  String title;
  String imageUrl;

  Note({this.text, this.title, this.imageUrl, this.id});

  factory Note.fromMap(Map<String, dynamic> map ) => Note(
    text: map[jsonTagText],
    title: map[jsonTagTitle],
    imageUrl: map[jsonTagImgUrl],
    id: map[jsonTagId]
  );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> jsonMap = {
      jsonTagId: id,
      jsonTagText: text,
      jsonTagTitle: title,
      jsonTagImgUrl: imageUrl
    };
    return jsonMap;
  }
}
