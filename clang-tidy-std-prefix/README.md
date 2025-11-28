# Clang-Tidy Std:: Prefix Plugin

## Build
```bash
cmake -S . -B build   -DLLVM_DIR=/usr/lib/llvm-18/lib/cmake/llvm   -DClang_DIR=/usr/lib/llvm-18/lib/cmake/clang   -DHAVE_FFI_CALL=
cmake --build build --config Debug
```

## Futás (teszt)
```bash
/usr/bin/clang-tidy-18 -load build/libclangTidyStdPrefixPlugin.so   -checks=-*,std-prefix-fixed-int example/sample.cpp -- -std=c++1
```
