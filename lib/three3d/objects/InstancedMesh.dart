part of three_objects;

var _instanceLocalMatrix = Matrix4();
var _instanceWorldMatrix = Matrix4();

List<Intersection> _instanceIntersects = [];

var _mesh = Mesh(BufferGeometry(), Material());

class InstancedMesh extends Mesh {
  late InstancedBufferAttribute instanceMatrix;
  late BufferAttribute? instanceColor;

  String _type = "InstancedMesh";
  bool _isInstancedMesh = true;

  @override
  String get type => _type;
  @override
  set type(String type) => _type = type;

  @override
  bool get isInstancedMesh => _isInstancedMesh;
  @override
  set isInstancedMesh(bool isInstanced) => _isInstancedMesh = isInstanced;

  InstancedMesh(geometry, material, count) : super(geometry, material) {
    var dl = Float32List(count * 16);
    instanceMatrix = InstancedBufferAttribute(dl, 16, false);
    instanceColor = null;

    this.count = count;

    frustumCulled = false;
  }

  @override
  InstancedMesh copy(Object3D source, [bool? recursive]) {
    super.copy(source);

    InstancedMesh source1 = source as InstancedMesh;

    instanceMatrix.copy(source1.instanceMatrix);

    if (source.instanceColor != null) {
      instanceColor = source.instanceColor!.clone();
    }

    count = source1.count;

    return this;
  }

  getColorAt(index, color) {
    color.fromArray(instanceColor!.array, index * 3);
  }

  getMatrixAt(index, matrix) {
    matrix.fromArray(instanceMatrix.array, index * 16);
  }

  @override
  void raycast(raycaster, intersects) {
    var matrixWorld = this.matrixWorld;
    var raycastTimes = count;

    _mesh.geometry = geometry;
    _mesh.material = material;

    if (_mesh.material == null) return;

    for (var instanceId = 0; instanceId < raycastTimes!; instanceId++) {
      // calculate the world matrix for each instance

      getMatrixAt(instanceId, _instanceLocalMatrix);

      _instanceWorldMatrix.multiplyMatrices(matrixWorld, _instanceLocalMatrix);

      // the mesh represents this single instance

      _mesh.matrixWorld = _instanceWorldMatrix;

      _mesh.raycast(raycaster, _instanceIntersects);

      // process the result of raycast

      for (var i = 0, l = _instanceIntersects.length; i < l; i++) {
        var intersect = _instanceIntersects[i];
        intersect.instanceId = instanceId;
        intersect.object = this;
        intersects.add(intersect);
      }

      _instanceIntersects.length = 0;
    }
  }

  setColorAt(index, color) {
    instanceColor ??= BufferAttribute(
        Float32List((instanceMatrix.count * 3).toInt()), 3, false);

    color.toArray(instanceColor!.array, index * 3);
  }

  setMatrixAt(index, Matrix4 matrix) {
    matrix.toArray(instanceMatrix.array, index * 16);
  }

  @override
  updateMorphTargets() {}

  @override
  dispose() {
    dispatchEvent(Event({"type": "dispose"}));
  }
}
