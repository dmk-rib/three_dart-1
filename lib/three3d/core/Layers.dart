part of three_core;

class Layers {
  int mask = 1 | 0;

  Layers();

  set(channel) {
    mask = (1 << channel | 0) >> 0;
  }

  enable(channel) {
    mask = mask | (1 << channel | 0);
  }

  enableAll() {
    mask = 0xffffffff | 0;
  }

  toggle(channel) {
    mask ^= 1 << channel | 0;
  }

  disable(channel) {
    mask &= ~(1 << channel | 0);
  }

  disableAll() {
    mask = 0;
  }

  bool test(layers) {
    return (mask & layers.mask) != 0;
  }

  isEnabled(channel) {
    return (mask & (1 << channel | 0)) != 0;
  }
}
