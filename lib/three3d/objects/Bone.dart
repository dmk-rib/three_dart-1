part of three_objects;

class Bone extends Object3D {
  Bone() : super() {
    type = 'Bone';
    isBone = true;
  }

  @override
  Bone clone([bool? recursive]) {
    return Bone()..copy(this, recursive);
  }
}
