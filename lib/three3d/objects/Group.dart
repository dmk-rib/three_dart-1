part of three_objects;

class Group extends Object3D {
  String _type = 'Group';
  bool isGroup = true;

  @override
  String get type => _type;
  @override
  set type(String type) => _type = type;

  Group() : super();
  Group.fromJSON(Map<String, dynamic> json, Map<String, dynamic> rootJSON)
      : super.fromJSON(json, rootJSON);
}
