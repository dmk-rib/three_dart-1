part of three_objects;

class Bone extends Object3D {
  String _type = 'Bone';
  bool _isBone = true;

  @override
  String get type => _type;
  @override
  set type(String type) => _type = type;

  @override
  bool get isBone => _isBone;
  @override
  set isBone(bool isBone) => _isBone = isBone;

  Bone() : super();

  @override
  Bone clone([bool? recursive]) {
    final bone = Bone();
    bone.copy(this, recursive);
    return bone;
  }
}
