// ignore_for_file: public_member_api_docs, sort_constructors_first
class SongsModel {
  String title;
  String description;
  String url;
  String coverurl;
  String? id;
  SongsModel(
      {required this.title,
      required this.description,
      required this.url,
      required this.coverurl,
      this.id = ""});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'url': url,
      'coverurl': coverurl,
      "time": DateTime.now().toIso8601String(),
    };
  }

  SongsModel.fromMap(Map<String, dynamic> map, this.id)
      : title = (map["title"] ?? ''),
        description = (map["description"] ?? ''),
        url = (map["coverurl"] ?? ''),
        coverurl = (map["url"] ?? '');
}
