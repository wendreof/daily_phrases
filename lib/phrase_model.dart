class Phrase {
  String? text;
  String? author;

  Phrase({this.text, this.author});

  Phrase.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    author = json['author'];
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['text'] = text;
    data['author'] = author;
    return data;
  }
}
