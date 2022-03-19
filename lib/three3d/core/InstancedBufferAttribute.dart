part of three_core;

class InstancedBufferAttribute extends BufferAttribute {
  late num meshPerAttribute;
  bool isInstancedBufferAttribute = true;
  String type = "InstancedBufferAttribute";

  InstancedBufferAttribute(array, int itemSize,
      [bool normalized = false, this.meshPerAttribute = 1])
      : super(array, itemSize, normalized) {
    // if ( normalized is num ) {
    //   meshPerAttribute = normalized;
    //   normalized = false;
    //   print( 'THREE.InstancedBufferAttribute: The constructor now expects normalized as the third argument.' );
    // }
  }

  @override
  BufferAttribute copy(BufferAttribute source) {
    super.copy(source);
    
    if (source is InstancedBufferAttribute) {
      meshPerAttribute = source.meshPerAttribute;
    }
    return this;
  }

  toJSON() {
    var data = super.toJSON();

    data.meshPerAttribute = meshPerAttribute;

    data.isInstancedBufferAttribute = true;

    return data;
  }
}
