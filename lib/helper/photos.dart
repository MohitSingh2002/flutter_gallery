class Photos {

  int id;
  String photoname;

  Photos({this.id, this.photoname});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'photoname': photoname,
    };
    return map;
  }

  Photos.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    photoname = map['photoname'];
  }

}
