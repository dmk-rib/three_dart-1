part of three_core;

class BufferAttribute extends BaseBufferAttribute {
  String type = "BufferAttribute";
  final _vector = Vector3.init();
  final _vector2 = Vector2(null, null);

  bool isBufferAttribute = true;

  BufferAttribute(arrayList, int itemSize, [bool normalized = false]) {
    if (arrayList is NativeArray) {
      array = arrayList;
    } else if (arrayList is Uint8List) {
      array = Uint8Array.from(arrayList);
    } else if (arrayList is Uint16List) {
      array = Uint16Array.from(arrayList);
    } else if (arrayList is Uint32List) {
      array = Uint32Array.from(arrayList);
    } else if (arrayList is Float32List) {
      array = Float32Array.from(arrayList);
    } else if (arrayList is List) {
      // 确认 正确的BufferAttribute 使用了正确的List 类型 默认 Float32
      print(
          " BufferAttribute type: $type ${this} arrayList is ${arrayList.runtimeType} need confirm ? ");
      array = Float32Array.from(arrayList);
    } else {
      throw ("BufferAttribute  arrayList: ${arrayList.runtimeType} is need support ....  ");
    }

    this.itemSize = itemSize;
    count = array != null ? (array.length / itemSize).toInt() : 0;
    this.normalized = normalized == true;

    usage = StaticDrawUsage;
    updateRange = {"offset": 0, "count": -1};

    version = 0;
  }

  int get length => count;

  set needsUpdate(bool value) {
    if (value == true) version++;
  }

  BufferAttribute setUsage(int value) {
    usage = value;

    return this;
  }

  BufferAttribute copy(BufferAttribute source) {
    name = source.name;
    array = source.array.clone();
    itemSize = source.itemSize;
    count = source.count;
    normalized = source.normalized;
    type = source.type;
    usage = source.usage;

    return this;
  }

  BufferAttribute copyAt(num index1, BufferAttribute attribute, num index2) {
    index1 *= itemSize;
    index2 *= attribute.itemSize;

    for (var i = 0, l = itemSize; i < l; i++) {
      array[index1 + i] = attribute.array[index2 + i];
    }

    return this;
  }

  BufferAttribute copyArray(array) {
    this.array = array;

    return this;
  }

  BufferAttribute copyColorsArray(List<Color> colors) {
    var array = this.array;
    var offset = 0;

    for (var i = 0, l = colors.length; i < l; i++) {
      var color = colors[i];
      array[offset++] = color.r;
      array[offset++] = color.g;
      array[offset++] = color.b;
    }

    return this;
  }

  BufferAttribute copyVector2sArray(List<Vector2> vectors) {
    var array = this.array;
    var offset = 0;

    for (var i = 0, l = vectors.length; i < l; i++) {
      var vector = vectors[i];
      array[offset++] = vector.x;
      array[offset++] = vector.y;
    }

    return this;
  }

  BufferAttribute copyVector3sArray(List<Vector3> vectors) {
    var array = this.array;
    var offset = 0;

    for (var i = 0, l = vectors.length; i < l; i++) {
      var vector = vectors[i];
      array[offset++] = vector.x;
      array[offset++] = vector.y;
      array[offset++] = vector.z;
    }

    return this;
  }

  BufferAttribute copyVector4sArray(List<Vector4> vectors) {
    var array = this.array;
    var offset = 0;

    for (var i = 0, l = vectors.length; i < l; i++) {
      var vector = vectors[i];
      array[offset++] = vector.x;
      array[offset++] = vector.y;
      array[offset++] = vector.z;
      array[offset++] = vector.w;
    }

    return this;
  }

  BufferAttribute applyMatrix3(Matrix3 m) {
    if (itemSize == 2) {
      for (var i = 0, l = count; i < l; i++) {
        _vector2.fromBufferAttribute(this, i);
        _vector2.applyMatrix3(m);

        setXY(i, _vector2.x, _vector2.y);
      }
    } else if (itemSize == 3) {
      for (var i = 0, l = count; i < l; i++) {
        _vector.fromBufferAttribute(this, i);
        _vector.applyMatrix3(m);

        setXYZ(i, _vector.x, _vector.y, _vector.z);
      }
    }

    return this;
  }

  void applyMatrix4(Matrix4 m) {
    for (var i = 0, l = count; i < l; i++) {
      _vector.x = getX(i);
      _vector.y = getY(i);
      _vector.z = getZ(i);

      _vector.applyMatrix4(m);

      setXYZ(i, _vector.x, _vector.y, _vector.z);
    }
  }

  BufferAttribute applyNormalMatrix(m) {
    for (var i = 0, l = count; i < l; i++) {
      _vector.x = getX(i);
      _vector.y = getY(i);
      _vector.z = getZ(i);

      _vector.applyNormalMatrix(m);

      setXYZ(i, _vector.x, _vector.y, _vector.z);
    }

    return this;
  }

  BufferAttribute transformDirection(Matrix4 m) {
    for (var i = 0, l = count; i < l; i++) {
      _vector.x = getX(i);
      _vector.y = getY(i);
      _vector.z = getZ(i);

      _vector.transformDirection(m);

      setXYZ(i, _vector.x, _vector.y, _vector.z);
    }

    return this;
  }

  BufferAttribute set(value, {int offset = 0}) {
    array[offset] = value;

    return this;
  }

  getX(int index) {
    return getAt(index * itemSize);
  }

  BufferAttribute setX(int index, x) {
    array[index * itemSize] = x;

    return this;
  }

  getY(int index) {
    return getAt(index * itemSize + 1);
  }

  BufferAttribute setY(int index, y) {
    array[index * itemSize + 1] = y;

    return this;
  }

  getZ(int index) {
    return getAt(index * itemSize + 2);
  }

  BufferAttribute setZ(int index, z) {
    array[index * itemSize + 2] = z;

    return this;
  }

  getW(int index) {
    return getAt(index * itemSize + 3);
  }

  getAt(int index) {
    if (index < array.length) {
      return array[index];
    } else {
      return null;
    }
  }

  BufferAttribute setW(int index, w) {
    array[index * itemSize + 3] = w;

    return this;
  }

  BufferAttribute setXY(int index, x, y) {
    index *= itemSize;

    array[index + 0] = x;
    array[index + 1] = y;

    return this;
  }

  void setXYZ(int index, num x, num y, num z) {
    int _idx = index * itemSize;

    array[_idx + 0] = x.toDouble();
    array[_idx + 1] = y.toDouble();
    array[_idx + 2] = z.toDouble();
  }

  BufferAttribute setXYZW(int index, x, y, z, w) {
    index *= itemSize;

    array[index + 0] = x;
    array[index + 1] = y;
    array[index + 2] = z;
    array[index + 3] = w;

    return this;
  }

  BufferAttribute onUpload(callback) {
    onUploadCallback = callback;

    return this;
  }

  BufferAttribute clone() {
    if (type == "BufferAttribute") {
      return BufferAttribute(array, itemSize, false).copy(this);
    } else if (type == "Float32BufferAttribute") {
      return Float32BufferAttribute(array, itemSize, false).copy(this);
    } else if (type == "Uint8BufferAttribute") {
      return Uint8BufferAttribute(array, itemSize, false).copy(this);
    } else if (type == "Uint16BufferAttribute") {
      return Uint16BufferAttribute(array, itemSize, false).copy(this);
    } else {
      throw ("BufferAttribute type: $type clone need support ....  ");
    }
  }

  toJSON() {
    // print(" BufferAttribute to JSON todo  ${this.array.runtimeType} ");

    // return {
    // 	"itemSize": this.itemSize,
    // 	"type": this.array.runtimeType.toString(),
    // 	"array": this.array.sublist(0),
    // 	"normalized": this.normalized
    // };

    var data = {
      "itemSize": itemSize,
      "type": array.runtimeType.toString(),
      "array": array.sublist(0),
      "normalized": normalized
    };

    if (name != null) data["name"] = name;
    if (usage != StaticDrawUsage) data["usage"] = usage;
    if (updateRange?["offset"] != 0 || updateRange?["count"] != -1) {
      data["updateRange"] = updateRange;
    }

    return data;
  }
}

class Int8BufferAttribute extends BufferAttribute {
  @override
  String get type => "Int8BufferAttribute";

  Int8BufferAttribute(Int8List array, int itemSize, [bool normalized = false])
      : super(array, itemSize, normalized);
}

class Uint8BufferAttribute extends BufferAttribute {
  @override
  String get type => "Uint8BufferAttribute";
  Uint8BufferAttribute(Uint8List array, int itemSize, [bool normalized = false])
      : super(array, itemSize, normalized);
}

class Uint8ClampedBufferAttribute extends BufferAttribute {
  @override
  String get type => "Uint8ClampedBufferAttribute";
  Uint8ClampedBufferAttribute(Uint8List array, int itemSize,
      [bool normalized = false])
      : super(array, itemSize, normalized);
}

class Int16BufferAttribute extends BufferAttribute {
  @override
  String get type => "Int16BufferAttribute";
  Int16BufferAttribute(Int16List array, int itemSize, [bool normalized = false])
      : super(array, itemSize, normalized);
}

// Int16BufferAttribute.prototype = Object.create( BufferAttribute.prototype );
// Int16BufferAttribute.prototype.constructor = Int16BufferAttribute;

class Uint16BufferAttribute extends BufferAttribute {
  @override
  String get type => "Uint16BufferAttribute";
  Uint16BufferAttribute(Uint16List array, int itemSize,
      [bool normalized = false])
      : super(array, itemSize, normalized);
}

class Int32BufferAttribute extends BufferAttribute {
  @override
  String get type => "Int32BufferAttribute";
  Int32BufferAttribute(Int32List array, int itemSize, [bool normalized = false])
      : super(array, itemSize, normalized);
}

class Uint32BufferAttribute extends BufferAttribute {
  @override
  String get type => "Uint32BufferAttribute";
  Uint32BufferAttribute(Uint32List array, int itemSize,
      [bool normalized = false])
      : super(array, itemSize, normalized);
}

class Float16BufferAttribute extends BufferAttribute {
  @override
  String get type => "Float16BufferAttribute";
  Float16BufferAttribute(array, int itemSize, [bool normalized = false])
      : super(array, itemSize, normalized);
}

class Float32BufferAttribute extends BufferAttribute {
  @override
  String get type => "Float32BufferAttribute";

  Float32BufferAttribute(Float32List array, int itemSize,
      [bool normalized = false])
      : super(array, itemSize, normalized);
}

class Float64BufferAttribute extends BufferAttribute {
  @override
  String get type => "Float64BufferAttribute";
  Float64BufferAttribute(Float64List array, int itemSize,
      [bool normalized = false])
      : super(array, itemSize, normalized);
}
