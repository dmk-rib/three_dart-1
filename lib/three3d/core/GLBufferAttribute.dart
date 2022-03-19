part of three_core;

class GLBufferAttribute extends BaseBufferAttribute {
  bool isGLBufferAttribute = true;

  GLBufferAttribute(buffer, String type, itemSize, elementSize, count)
      : super() {
    this.buffer = buffer;
    this.type = type;
    this.itemSize = itemSize;
    this.elementSize = elementSize;
    this.count = count;

    version = 0;
  }

  set needsUpdate(bool value) {
    if (value == true) version++;
  }

  setBuffer(buffer) {
    this.buffer = buffer;

    return this;
  }

  setType(String type, elementSize) {
    this.type = type;
    this.elementSize = elementSize;

    return this;
  }

  setItemSize(itemSize) {
    this.itemSize = itemSize;

    return this;
  }

  setCount(count) {
    this.count = count;

    return this;
  }
}
