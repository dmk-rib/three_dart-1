part of three_objects;

var _basePosition = Vector3.init();

var _skinIndex = Vector4.init();
var _skinWeight = Vector4.init();

var _vector = Vector3.init();
var _matrix = Matrix4();

class SkinnedMesh extends Mesh {
  bool isSkinnedMesh = true;
  String bindMode = "attached";
  Matrix4? bindMatrix = Matrix4();
  Matrix4 bindMatrixInverse = Matrix4();
  Skeleton? skeleton;
  String type = "SkinnedMesh";

  SkinnedMesh(geometry, material) : super(geometry, material) {}

  clone([bool? recursive]) {
    return SkinnedMesh(geometry!, material).copy(this, recursive);
  }

  copy(Object3D source, [bool? recursive]) {
    super.copy(source);

    SkinnedMesh source1 = source as SkinnedMesh;

    bindMode = source1.bindMode;
    bindMatrix!.copy(source1.bindMatrix!);
    bindMatrixInverse.copy(source1.bindMatrixInverse);

    skeleton = source1.skeleton;

    return this;
  }

  bind(skeleton, Matrix4? bindMatrix) {
    this.skeleton = skeleton;

    if (bindMatrix == null) {
      updateMatrixWorld(true);

      this.skeleton!.calculateInverses();

      bindMatrix = matrixWorld;
    }

    this.bindMatrix!.copy(bindMatrix);
    bindMatrixInverse.copy(bindMatrix).invert();
  }

  pose() {
    skeleton!.pose();
  }

  normalizeSkinWeights() {
    var vector = Vector4.init();

    var skinWeight = geometry!.attributes["skinWeight"];

    for (var i = 0, l = skinWeight.count; i < l; i++) {
      vector.x = skinWeight.getX(i);
      vector.y = skinWeight.getY(i);
      vector.z = skinWeight.getZ(i);
      vector.w = skinWeight.getW(i);

      var scale = 1.0 / vector.manhattanLength();

      if (scale != double.infinity) {
        vector.multiplyScalar(scale);
      } else {
        vector.set(1, 0, 0, 0); // do something reasonable

      }

      skinWeight.setXYZW(i, vector.x, vector.y, vector.z, vector.w);
    }
  }

  updateMatrixWorld([bool force = false]) {
    super.updateMatrixWorld(force);

    if (bindMode == 'attached') {
      bindMatrixInverse.copy(matrixWorld).invert();
    } else if (bindMode == 'detached') {
      bindMatrixInverse.copy(bindMatrix!).invert();
    } else {
      print('THREE.SkinnedMesh: Unrecognized bindMode: ${bindMode}');
    }
  }

  boneTransform(index, target) {
    var skeleton = this.skeleton;
    var geometry = this.geometry!;

    _skinIndex.fromBufferAttribute(
        geometry.attributes["skinIndex"], index);
    _skinWeight.fromBufferAttribute(
        geometry.attributes["skinWeight"], index);

    _basePosition.copy(target).applyMatrix4(bindMatrix!);

    target.set(0, 0, 0);

    for (var i = 0; i < 4; i++) {
      var weight = _skinWeight.getComponent(i);

      if (weight != 0) {
        var boneIndex = _skinIndex.getComponent(i).toInt();

        _matrix.multiplyMatrices(skeleton!.bones[boneIndex].matrixWorld,
            skeleton.boneInverses[boneIndex]);

        target.addScaledVector(
            _vector.copy(_basePosition).applyMatrix4(_matrix), weight);
      }
    }

    return target.applyMatrix4(bindMatrixInverse);
  }

  getValue(name) {
    if (name == "bindMatrix") {
      return bindMatrix;
    } else if (name == "bindMatrixInverse") {
      return bindMatrixInverse;
    } else {
      return super.getValue(name);
    }
  }
}
