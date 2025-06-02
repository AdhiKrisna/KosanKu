class KosModel {
  String? status;
  String? message;
  List<Kos>? data;
  KosModel({this.status, this.message, this.data});

  KosModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Kos>[];
      json['data'].forEach((v) {
        data!.add(Kos.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
  
}

class Kos {
  int? id;
  String? kosName;
  String? kosAddress;
  String? kosDescription;
  String? kosRules;
  String? category;
  String? linkGmaps;
  int? ownerKosId;
  int? roomAvailable;
  int? maxPrice;
  int? minPrice;
  String? kosLatitude;
  String? kosLongitude;
  String? createdAt;
  String? updatedAt;
  String? ownerName;
  String? ownerPhone;
  int? ownerUserId;

  Kos({
    this.id,
    this.kosName,
    this.kosAddress,
    this.kosDescription,
    this.kosRules,
    this.category,
    this.linkGmaps,
    this.ownerKosId,
    this.roomAvailable,
    this.maxPrice,
    this.minPrice,
    this.kosLatitude,
    this.kosLongitude,
    this.createdAt,
    this.updatedAt,
    this.ownerName,
    this.ownerPhone,
    this.ownerUserId,
  });

  Kos.fromJson(Map<String, dynamic> json) {
    id = json['kos_id'];
    kosName = json['kos_name'];
    kosAddress = json['kos_address'];
    kosDescription = json['kos_description'];
    kosRules = json['kos_rules'];
    category = json['category'];
    linkGmaps = json['link_gmaps'];
    ownerKosId = json['owner_kos_id'];
    roomAvailable = json['room_available'];
    maxPrice = json['max_price'];
    minPrice = json['min_price'];
    kosLatitude = json['kos_latitude']?.toString();
    kosLongitude = json['kos_longitude']?.toString();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    ownerUserId = json['owner']?['user_id'];
    ownerName = json['owner']?['user_name'];
    ownerPhone = json['owner']?['user_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kos_id'] = id;
    data['kos_name'] = kosName;
    data['kos_address'] = kosAddress;
    data['kos_description'] = kosDescription;
    data['kos_rules'] = kosRules;
    data['category'] = category;
    data['link_gmaps'] = linkGmaps;
    data['owner_kos_id'] = ownerKosId;
    data['room_available'] = roomAvailable;
    data['max_price'] = maxPrice;
    data['min_price'] = minPrice;
    data['kos_latitude'] = kosLatitude;
    data['kos_longitude'] = kosLongitude;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['owner'] = {
      'user_id': ownerUserId,
      'user_name': ownerName,
      'user_phone': ownerPhone,
    };
    return data;
  }
}