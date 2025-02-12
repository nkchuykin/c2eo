<img src="https://www.yegor256.com/images/books/elegant-objects/cactus.svg" height="100px" />

This is a translator of C/C++ to [EOLANG](https://www.eolang.org).
The 1st step is C to [EOLANG](https://www.eolang.org) S2S compiler.


# C2EO

Semantic-preserving translation of C programs to EOLANG programs.

- #### [Document with C2EO transform examples](./doc/transformExamples.md)

- #### [Project for playing with examples](./eolang/main)

- #### [Tests](./scripts/readme.md)

## 1. Install LLVM + CLANG
```bash
$ wget https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-12.0.1.tar.gz
$ mkdir llvm-clang
$ tar -C llvm-clang -xvf llvmorg-12.0.1.tar.gz
```

&nbsp;
## 2. Build LLVM + CLANG
```bash
$ cd llvm-clang
$ # rm -rf build
$ mkdir build && cd $_
$ cmake --no-warn-unused-cli -DBUILD_SHARED_LIBS:STRING=ON -DLLVM_TARGETS_TO_BUILD:STRING=X86 \
  -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE "-DLLVM_ENABLE_PROJECTS:STRING=clang;compiler-rt" \
  -DCMAKE_BUILD_TYPE:STRING=Debug -DLLVM_OPTIMIZED_TABLEGEN:STRING=ON \
  -DLLVM_USE_SPLIT_DWARF:STRING=ON -DLLVM_USE_LINKER:STRING=gold ../llvm -G Ninja
$ cmake --build . --config Debug --target all -j 10 -- -j1 -l 2
```

&nbsp;
## 3. Install C2EO
```bash
$ cd ../..
$ git clone https://github.com/kreofil/C2EO-draft.git c2eo
```

&nbsp;
## 4. Configuration C2EO

> Set `PATH_TO_LLVM_SOURCE` variable to the LLVM+CLANG directory when invoking CMake;

> Set `-DCMAKE_BUILD_TYPE` variable to the Debug state, if you want to output the values of all global variables (works only for ../kam/src);

```bash
$ cd c2eo
$ # rm -rf build
$ mkdir build && cd $_
$ cmake -DCMAKE_BUILD_TYPE=Debug -DPATH_TO_LLVM_SOURCE=~/path/to/llvm-clang/ \
  -DCMAKE_DEPENDS_USE_COMPILER=FALSE -G "CodeBlocks - Unix Makefiles" ../al/src
$ cmake --build . --target c2eo -- -j 6
```

&nbsp;
## 5. Run

> Use `--` at the end of command below to skip all errors;

> Use `-d` to set the path to output directory;

```bash
$ ./c2eo file-name.c -- -d path/
```
