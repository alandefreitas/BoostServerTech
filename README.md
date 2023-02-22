# BoostServerTech

Boost Server Technology demonstration

# Building and installing

## Build

This project doesn't require any special command-line flags to build.

Here are the steps for building in release mode with a single-configuration
generator, like the Unix Makefiles one:

```sh
cmake -S . -B build -D CMAKE_BUILD_TYPE=Release
cmake --build build
```

Here are the steps for building in release mode with a multi-configuration
generator, like the Visual Studio ones:

```sh
cmake -S . -B build -D CMAKE_TOOLCHAIN_FILE=/path/to/vcpkg/scripts/buildsystems/vcpkg.cmake
cmake --build build --config Release
```

Here are the steps for using vcpkg to download any required dependencies:

```sh
cmake -S . -B build -D CMAKE_BUILD_TYPE=Release -D CMAKE_TOOLCHAIN_FILE=/path/to/vcpkg/scripts/buildsystems/vcpkg.cmake
cmake --build build
```

Please note that both the build command accepts a `-j` flag to specify
the number of jobs to use, which should ideally be specified to the number of
threads your CPU has. You may also want to add that to your preset using the
`jobs` property, see the [presets documentation][1] for more details.

## Dependencies

For a list of dependencies, please refer to [vcpkg.json](vcpkg.json).

## Install

This project doesn't require any special command-line flags to install. As a prerequisite, the project has to be built
with the above commands already.

The below commands require at least CMake 3.15 to run, because that is the version in which [Install a Project][2] was
added.

Here is the command for installing the release mode artifacts with a single-configuration generator, like the Unix
Makefiles one:

```sh
cmake --install build
```

Here is the command for installing the release mode artifacts with a multi-configuration generator, like the Visual
Studio ones:

```sh
cmake --install build --config Release
```

[1]: https://cmake.org/download/

[2]: https://cmake.org/cmake/help/latest/manual/cmake.1.html#install-a-project

# Licensing

```
Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
```