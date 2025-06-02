class KosImageModel {
  int? id;
  String? message;
  List<KosImage>? data;
  KosImageModel({
    this.id,
    this.message,
    this.data,
  });

  KosImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    if (json['data'] != null) {
      data = <KosImage>[];
      json['data'].forEach((v) {
        data!.add(KosImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class KosImage {
  int? imageId;
  int? kosId;
  String? imageUrl;

  KosImage({
    this.imageId,
    this.kosId,
    this.imageUrl,
  });

  KosImage.fromJson(Map<String, dynamic> json) {
    imageId = json['image_id'];
    kosId = json['kos_id'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_id'] = imageId;
    data['kos_id'] = kosId;
    data['image_url'] = imageUrl;
    return data;
  }
  
}