part of three_core;

var _vector = new Vector3.init();

class InterleavedBufferAttribute extends BaseBufferAttribute {
  InterleavedBuffer? data;
  int itemSize;
  int offset;
  bool normalized;
  bool isInterleavedBufferAttribute = true;
  String type = "InterleavedBufferAttribute";

  InterleavedBufferAttribute(
      this.data, this.itemSize, this.offset, this.normalized)
      : super();

  get count {
    return data!.count;
  }

  get array {
    return data!.array;
  }

  set needsUpdate(value) {
    data!.needsUpdate = value;
  }

  applyMatrix4(m) {
    for (var i = 0, l = data!.count; i < l; i++) {
      _vector.x = getX(i);
      _vector.y = getY(i);
      _vector.z = getZ(i);

      _vector.applyMatrix4(m);

      setXYZ(i, _vector.x, _vector.y, _vector.z);
    }

    return this;
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

  setX(index, x) {
    data!.array[index * data!.stride + offset] = x;

    return this;
  }

  setY(index, y) {
    data!.array[index * data!.stride + offset + 1] = y;

    return this;
  }

  setZ(index, z) {
    data!.array[index * data!.stride + offset + 2] = z;

    return this;
  }

  setW(index, w) {
    data!.array[index * data!.stride + offset + 3] = w;

    return this;
  }

  getX(index) {
    return data!.array[index * data!.stride + offset];
  }

  getY(index) {
    return data!.array[index * data!.stride + offset + 1];
  }

  getZ(index) {
    return data!.array[index * data!.stride + offset + 2];
  }

  getW(index) {
    return data!.array[index * data!.stride + offset + 3];
  }

  setXY(index, x, y) {
    index = index * data!.stride + offset;

    data!.array[index + 0] = x;
    data!.array[index + 1] = y;

    return this;
  }

  setXYZ(index, x, y, z) {
    index = index * data!.stride + offset;

    data!.array[index + 0] = x;
    data!.array[index + 1] = y;
    data!.array[index + 2] = z;

    return this;
  }

  setXYZW(index, x, y, z, w) {
    index = index * data!.stride + offset;

    data!.array[index + 0] = x;
    data!.array[index + 1] = y;
    data!.array[index + 2] = z;
    data!.array[index + 3] = w;

    return this;
  }

  // clone ( data ) {

  // 	if ( data == null ) {

  // 		print( 'THREE.InterleavedBufferAttribute.clone(): Cloning an interlaved buffer attribute will deinterleave buffer data!.' );

  // 		var array = [];

  // 		for ( var i = 0; i < this.count; i ++ ) {

  // 			var index = i * this.data!.stride + this.offset;

  // 			for ( var j = 0; j < this.itemSize; j ++ ) {

  // 				array.add( this.data!.array[ index + j ] );

  // 			}

  // 		}

  // 		return new BufferAttribute(array, this.itemSize, this.normalized );

  // 	} else {

  // 		if ( data!.interleavedBuffers == null ) {

  // 			data!.interleavedBuffers = {};

  // 		}

  // 		if ( data!.interleavedBuffers[ this.data!.uuid ] == null ) {

  // 			data!.interleavedBuffers[ this.data!.uuid ] = this.data!.clone( data );

  // 		}

  // 		return new InterleavedBufferAttribute( data!.interleavedBuffers[ this.data!.uuid ], this.itemSize, this.offset, this.normalized );

  // 	}

  // }

  toJSON(data) {
    if (data == null) {
      print(
          'THREE.InterleavedBufferAttribute.toJSON(): Serializing an interlaved buffer attribute will deinterleave buffer data!.');

      var array = [];

      for (var i = 0; i < count; i++) {
        var index = i * this.data!.stride + offset;

        for (var j = 0; j < itemSize; j++) {
          array.add(this.data!.array[index + j]);
        }
      }

      // deinterleave data and save it as an ordinary buffer attribute for now

      return {
        "itemSize": itemSize,
        "type": this.array.runtimeType.toString(),
        "array": array,
        "normalized": normalized
      };
    } else {
      // save as true interlaved attribtue

      data.interleavedBuffers ??= {};

      if (data.interleavedBuffers[this.data!.uuid] == null) {
        data.interleavedBuffers[this.data!.uuid] = this.data!.toJSON(data);
      }

      return {
        "isInterleavedBufferAttribute": true,
        "itemSize": itemSize,
        "data": this.data!.uuid,
        "offset": offset,
        "normalized": normalized
      };
    }
  }
}
