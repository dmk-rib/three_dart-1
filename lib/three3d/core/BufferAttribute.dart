part of three_core;

class BufferAttribute extends BaseBufferAttribute {
  String type = "BufferAttribute";
  final _vector = Vector3.init();
  final _vector2 = Vector2(null, null);

  bool isBufferAttribute = true;

  BufferAttribute(arrayList, itemSize, [bool normalized = false]) {
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

  get length => count;

  set needsUpdate(bool value) {
    if (value == true) version++;
  }

  setUsage(value) {
    usage = value;

    return this;
  }

  copy(source) {
    name = source.name;
    array = source.array.clone();
    itemSize = source.itemSize;
    count = source.count;
    normalized = source.normalized;
    type = source.type;
    usage = source.usage;

    return this;
  }

  copyAt(index1, attribute, index2) {
    index1 *= itemSize;
    index2 *= attribute.itemSize;

    for (var i = 0, l = itemSize; i < l; i++) {
      array[index1 + i] = attribute.array[index2 + i];
    }

    return this;
  }

  copyArray(array) {
    this.array = array;

    return this;
  }

  copyColorsArray(colors) {
    var array = this.array;
    var offset = 0;

    for (var i = 0, l = colors.length; i < l; i++) {
      var color = colors[i];

      if (color == null) {
        print('THREE.BufferAttribute.copyColorsArray(): color is null $i');
        color = Color(0, 0, 0);
      }

      array[offset++] = color.r;
      array[offset++] = color.g;
      array[offset++] = color.b;
    }

    return this;
  }

  copyVector2sArray(vectors) {
    var array = this.array;
    var offset = 0;

    for (var i = 0, l = vectors.length; i < l; i++) {
      var vector = vectors[i];

      if (vector == null) {
        print('THREE.BufferAttribute.copyVector2sArray(): vector is null $i');
        vector = Vector2(null, null);
      }

      array[offset++] = vector.x;
      array[offset++] = vector.y;
    }

    return this;
  }

  copyVector3sArray(vectors) {
    var array = this.array;
    var offset = 0;

    for (var i = 0, l = vectors.length; i < l; i++) {
      var vector = vectors[i];

      if (vector == null) {
        print('THREE.BufferAttribute.copyVector3sArray(): vector is null $i');
        vector = Vector3.init();
      }

      array[offset++] = vector.x;
      array[offset++] = vector.y;
      array[offset++] = vector.z;
    }

    return this;
  }

  copyVector4sArray(vectors) {
    var array = this.array;
    var offset = 0;

    for (var i = 0, l = vectors.length; i < l; i++) {
      var vector = vectors[i];

      if (vector == null) {
        print('THREE.BufferAttribute.copyVector4sArray(): vector is null $i');
        vector = Vector4.init();
      }

      array[offset++] = vector.x;
      array[offset++] = vector.y;
      array[offset++] = vector.z;
      array[offset++] = vector.w;
    }

    return this;
  }

  applyMatrix3(m) {
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

  applyMatrix4(Matrix4 m) {
    for (var i = 0, l = count; i < l; i++) {
      _vector.x = getX(i);
      _vector.y = getY(i);
      _vector.z = getZ(i);

      _vector.applyMatrix4(m);

      setXYZ(i, _vector.x, _vector.y, _vector.z);
    }
  }

  applyNormalMatrix(m) {
    for (var i = 0, l = count; i < l; i++) {
      _vector.x = getX(i);
      _vector.y = getY(i);
      _vector.z = getZ(i);

      _vector.applyNormalMatrix(m);

      setXYZ(i, _vector.x, _vector.y, _vector.z);
    }

    return this;
  }

  transformDirection(m) {
    for (var i = 0, l = count; i < l; i++) {
      _vector.x = getX(i);
      _vector.y = getY(i);
      _vector.z = getZ(i);

      _vector.transformDirection(m);

      setXYZ(i, _vector.x, _vector.y, _vector.z);
    }

    return this;
  }

  set(value, {int offset = 0}) {
    array[offset] = value;

    return this;
  }

  getX(int index) {
    return getAt(index * itemSize);
  }

  setX(int index, x) {
    array[index * itemSize] = x;

    return this;
  }

  getY(int index) {
    return getAt(index * itemSize + 1);
  }

  setY(int index, y) {
    array[index * itemSize + 1] = y;

    return this;
  }

  getZ(int index) {
    return getAt(index * itemSize + 2);
  }

  setZ(int index, z) {
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

  setW(int index, w) {
    array[index * itemSize + 3] = w;

    return this;
  }

  setXY(int index, x, y) {
    index *= itemSize;

    array[index + 0] = x;
    array[index + 1] = y;

    return this;
  }

  setXYZ(int index, num x, num y, num z) {
    int _idx = index * itemSize;

    array[_idx + 0] = x.toDouble();
    array[_idx + 1] = y.toDouble();
    array[_idx + 2] = z.toDouble();
  }

  setXYZW(int index, x, y, z, w) {
    index *= itemSize;

    array[index + 0] = x;
    array[index + 1] = y;
    array[index + 2] = z;
    array[index + 3] = w;

    return this;
  }

  onUpload(callback) {
    onUploadCallback = callback;

    return this;
  }

  clone() {
    if (type == "BufferAttribute") {
      return BufferAttribute(array, itemSize, false).copy(this);
    } else if (type == "Float32BufferAttribute") {
      return Float32BufferAttribute(array, itemSize, false)
          .copy(this);
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
  String type = "Int8BufferAttribute";

  Int8BufferAttribute(array, itemSize, [bool normalized = false])
      : super(array, itemSize, normalized) {}
}

class Uint8BufferAttribute extends BufferAttribute {
  String type = "Uint8BufferAttribute";
  Uint8BufferAttribute(array, itemSize, [bool normalized = false])
      : super(array, itemSize, normalized) {}
}

class Uint8ClampedBufferAttribute extends BufferAttribute {
  String type = "Uint8ClampedBufferAttribute";
  Uint8ClampedBufferAttribute(array, itemSize, [bool normalized = false])
      : super(array, itemSize, normalized) {}
}

class Int16BufferAttribute extends BufferAttribute {
  String type = "Int16BufferAttribute";
  Int16BufferAttribute(array, itemSize, [bool normalized = false])
      : super(array, itemSize, normalized) {}
}

// Int16BufferAttribute.prototype = Object.create( BufferAttribute.prototype );
// Int16BufferAttribute.prototype.constructor = Int16BufferAttribute;

class Uint16BufferAttribute extends BufferAttribute {
  String type = "Uint16BufferAttribute";
  Uint16BufferAttribute(array, itemSize, [bool normalized = false])
      : super(array, itemSize, normalized) {}
}

class Int32BufferAttribute extends BufferAttribute {
  String type = "Int32BufferAttribute";
  Int32BufferAttribute(array, itemSize, [bool normalized = false])
      : super(array, itemSize, normalized) {}
}

class Uint32BufferAttribute extends BufferAttribute {
  String type = "Uint32BufferAttribute";
  Uint32BufferAttribute(array, itemSize, [bool normalized = false])
      : super(array, itemSize, normalized) {}
}

class Float16BufferAttribute extends BufferAttribute {
  String type = "Float16BufferAttribute";
  Float16BufferAttribute(array, itemSize, [bool normalized = false])
      : super(array, itemSize, normalized) {}
}

class Float32BufferAttribute extends BufferAttribute {
  String type = "Float32BufferAttribute";

  Float32BufferAttribute(array, itemSize, [bool normalized = false])
      : super(array, itemSize, normalized) {}
}

class Float64BufferAttribute extends BufferAttribute {
  String type = "Float64BufferAttribute";
  Float64BufferAttribute(array, itemSize, [bool normalized = false])
      : super(array, itemSize, normalized) {}
}
