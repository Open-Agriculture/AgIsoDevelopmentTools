#include <cstdint>

uint8_t g1 = 0;       // bad
std::uint16_t g2 = 0; // ok

struct S {
  int32_t a;          // bad
  std::uint64_t b;    // ok
};

int main() {
  using namespace std;
  uint32_t x = 0;      // bad
  std::int8_t y = 0; // ok
  return x + y;
}
