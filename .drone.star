local triggers =
{
    branch: ["master", "develop", "feature/*"]
};


def generate_posix_steps(image, environment):
    steps = []

    # Environment step
    s = {
        name: "everything",
        image: image,
        environment: environment,
        commands: []
    }

    # Apt packages step
    # vcpkg cache step
    # vcpkg install step
    # Boost Clone step
    # boost.buffers patch step
    # boost.http_proto patch step
    # boost.http_io patch step
    # Get CPU cores step
    # Configure step
    # Build step
    # Install step

    # [
    #     'set -e',
    #     'wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -',
    # ] +
    # (if sources !=[] then[('apt-add-repository "' + source + '"') for source in sources] else []) +
    # (
    #     if packages != "" then['apt-get update', 'apt-get -y install ' + packages] else[]) +
    # [
    #     'export LIBRARY=' + library,
    #     './.drone/drone.sh',
    #     ]

    return steps


local
linux_job(name, image, environment, packages="", sources=[], arch="amd64") =
{
    name: name,
    kind: "pipeline",
    type: "docker",
    trigger: triggers,
    platform:
        {
            os: "linux",
            arch: arch
        },
    steps: generate_posix_steps(image, environment)
};

local
macos_job(name, environment, xcode_version="12.2", osx_version="catalina", arch="amd64") =
{
    name: name,
    kind: "pipeline",
    type: "exec",
    trigger: triggers,
    platform: {
        "os": "darwin",
        "arch": arch
    },
    node: {
        "os": osx_version
    },
    steps: [
        {
            name: "everything",
            environment: environment + {
                "DEVELOPER_DIR": "/Applications/Xcode-" + xcode_version + ".app/Contents/Developer"},
            commands:
                [
                    'export LIBRARY=' + library,
                    './.drone/drone.sh',
                ]
        }
    ]
};


def generate_windows_steps(image, environment):
    steps = [
        {
            name: "everything",
            image: image,
            environment: environment,
            commands:
                [
                    'cmd /C .drone\\\\drone.bat ' + library,
                ]
        }
    ]
    return steps


local
windows_pipeline(name, image, environment, arch="amd64") =
{
    name: name,
    kind: "pipeline",
    type: "docker",
    trigger: triggers,
    platform:
        {
            os: "windows",
            arch: arch
        },
    "steps": generate_windows_steps(image, environment)
};

[
    linux_job(
        "Linux 14.04 GCC 4.4",
        "cppalliance/droneubuntu1404:1",
        {TOOLSET: 'gcc', COMPILER: 'g++-4.4', CXXSTD: '98,0x'},
        "g++-4.4",
        ["ppa:ubuntu-toolchain-r/test"],
    ),

    linux_job(
        "Linux 14.04 GCC 4.6 32/64",
        "cppalliance/droneubuntu1404:1",
        {TOOLSET: 'gcc', COMPILER: 'g++-4.6', CXXSTD: '98,0x', ADDRMD: '32,64'},
        "g++-4.6-multilib",
        ["ppa:ubuntu-toolchain-r/test"],
    ),

    linux_job(
        "Linux 14.04 GCC 4.7 32/64",
        "cppalliance/droneubuntu1404:1",
        {TOOLSET: 'gcc', COMPILER: 'g++-4.7', CXXSTD: '98,0x', ADDRMD: '32,64'},
        "g++-4.7-multilib",
        ["ppa:ubuntu-toolchain-r/test"],
    ),

    linux_job(
        "Linux 14.04 GCC 4.8* 32/64",
        "cppalliance/droneubuntu1404:1",
        {TOOLSET: 'gcc', COMPILER: 'g++', CXXSTD: '03,11', ADDRMD: '32,64'},
    ),

    linux_job(
        "Linux 14.04 GCC 4.9 32/64",
        "cppalliance/droneubuntu1404:1",
        {TOOLSET: 'gcc', COMPILER: 'g++-4.9', CXXSTD: '03,11', ADDRMD: '32,64'},
        "g++-4.9-multilib",
        ["ppa:ubuntu-toolchain-r/test"],
    ),

    linux_job(
        "Linux 16.04 GCC 5* 32/64",
        "cppalliance/droneubuntu1604:1",
        {TOOLSET: 'gcc', COMPILER: 'g++', CXXSTD: '03,11,14', ADDRMD: '32,64'},
    ),

    linux_job(
        "Linux 18.04 GCC 6 32/64",
        "cppalliance/droneubuntu1804:1",
        {TOOLSET: 'gcc', COMPILER: 'g++-6', CXXSTD: '03,11,14', ADDRMD: '32,64'},
        "g++-6-multilib",
    ),

    linux_job(
        "Linux 18.04 GCC 7* 32/64",
        "cppalliance/droneubuntu1804:1",
        {TOOLSET: 'gcc', COMPILER: 'g++', CXXSTD: '03,11,14,17', ADDRMD: '32,64'},
    ),

    linux_job(
        "Linux 18.04 GCC 8 32/64",
        "cppalliance/droneubuntu1804:1",
        {TOOLSET: 'gcc', COMPILER: 'g++-8', CXXSTD: '03,11,14,17', ADDRMD: '32,64'},
        "g++-8-multilib",
    ),

    linux_job(
        "Linux 20.04 GCC 9* 32/64",
        "cppalliance/droneubuntu2004:1",
        {TOOLSET: 'gcc', COMPILER: 'g++', CXXSTD: '03,11,14,17,2a', ADDRMD: '32,64'},
    ),

    linux_job(
        "Linux 20.04 GCC 9* ARM64",
        "cppalliance/droneubuntu2004:multiarch",
        {TOOLSET: 'gcc', COMPILER: 'g++', CXXSTD: '03,11,14,17,2a'},
        arch="arm64",
    ),

    linux_job(
        "Linux 20.04 GCC 9* S390x",
        "cppalliance/droneubuntu2004:multiarch",
        {TOOLSET: 'gcc', COMPILER: 'g++', CXXSTD: '03,11,14,17,2a'},
        arch="s390x",
    ),

    linux_job(
        "Linux 20.04 GCC 10 32/64",
        "cppalliance/droneubuntu2004:1",
        {TOOLSET: 'gcc', COMPILER: 'g++-10', CXXSTD: '03,11,14,17,20', ADDRMD: '32,64'},
        "g++-10-multilib",
    ),

    linux_job(
        "Linux 22.04 GCC 11* 32/64",
        "cppalliance/droneubuntu2204:1",
        {TOOLSET: 'gcc', COMPILER: 'g++', CXXSTD: '03,11,14,17,2a', ADDRMD: '32,64'},
    ),

    linux_job(
        "Linux 22.04 GCC 12 32 ASAN",
        "cppalliance/droneubuntu2204:1",
        {TOOLSET: 'gcc', COMPILER: 'g++-12', CXXSTD: '03,11,14,17,20,2b', ADDRMD: '32'} + asan,
        "g++-12-multilib",
    ),

    linux_job(
        "Linux 22.04 GCC 12 64 ASAN",
        "cppalliance/droneubuntu2204:1",
        {TOOLSET: 'gcc', COMPILER: 'g++-12', CXXSTD: '03,11,14,17,20,2b', ADDRMD: '64'} + asan,
        "g++-12-multilib",
    ),

    linux_job(
        "Linux 16.04 Clang 3.5",
        "cppalliance/droneubuntu1604:1",
        {TOOLSET: 'clang', COMPILER: 'clang++-3.5', CXXSTD: '03,11'},
        "clang-3.5",
    ),

    linux_job(
        "Linux 16.04 Clang 3.6",
        "cppalliance/droneubuntu1604:1",
        {TOOLSET: 'clang', COMPILER: 'clang++-3.6', CXXSTD: '03,11,14'},
        "clang-3.6",
    ),

    linux_job(
        "Linux 16.04 Clang 3.7",
        "cppalliance/droneubuntu1604:1",
        {TOOLSET: 'clang', COMPILER: 'clang++-3.7', CXXSTD: '03,11,14'},
        "clang-3.7",
    ),

    linux_job(
        "Linux 16.04 Clang 3.8",
        "cppalliance/droneubuntu1604:1",
        {TOOLSET: 'clang', COMPILER: 'clang++-3.8', CXXSTD: '03,11,14'},
        "clang-3.8",
    ),

    linux_job(
        "Linux 18.04 Clang 3.9",
        "cppalliance/droneubuntu1804:1",
        {TOOLSET: 'clang', COMPILER: 'clang++-3.9', CXXSTD: '03,11,14'},
        "clang-3.9",
    ),

    linux_job(
        "Linux 18.04 Clang 4.0",
        "cppalliance/droneubuntu1804:1",
        {TOOLSET: 'clang', COMPILER: 'clang++-4.0', CXXSTD: '03,11,14'},
        "clang-4.0",
    ),

    linux_job(
        "Linux 18.04 Clang 5.0",
        "cppalliance/droneubuntu1804:1",
        {TOOLSET: 'clang', COMPILER: 'clang++-5.0', CXXSTD: '03,11,14,1z'},
        "clang-5.0",
    ),

    linux_job(
        "Linux 18.04 Clang 6.0",
        "cppalliance/droneubuntu1804:1",
        {TOOLSET: 'clang', COMPILER: 'clang++-6.0', CXXSTD: '03,11,14,17'},
        "clang-6.0",
    ),

    linux_job(
        "Linux 20.04 Clang 7",
        "cppalliance/droneubuntu2004:1",
        {TOOLSET: 'clang', COMPILER: 'clang++-7', CXXSTD: '03,11,14,17'},
        "clang-7",
    ),

    linux_job(
        "Linux 20.04 Clang 8",
        "cppalliance/droneubuntu2004:1",
        {TOOLSET: 'clang', COMPILER: 'clang++-8', CXXSTD: '03,11,14,17'},
        "clang-8",
    ),

    linux_job(
        "Linux 20.04 Clang 9",
        "cppalliance/droneubuntu2004:1",
        {TOOLSET: 'clang', COMPILER: 'clang++-9', CXXSTD: '03,11,14,17,2a'},
        "clang-9",
    ),

    linux_job(
        "Linux 20.04 Clang 10",
        "cppalliance/droneubuntu2004:1",
        {TOOLSET: 'clang', COMPILER: 'clang++-10', CXXSTD: '03,11,14,17,2a'},
        "clang-10",
    ),

    linux_job(
        "Linux 20.04 Clang 11",
        "cppalliance/droneubuntu2004:1",
        {TOOLSET: 'clang', COMPILER: 'clang++-11', CXXSTD: '03,11,14,17,2a'},
        "clang-11",
    ),

    linux_job(
        "Linux 20.04 Clang 12",
        "cppalliance/droneubuntu2004:1",
        {TOOLSET: 'clang', COMPILER: 'clang++-12', CXXSTD: '03,11,14,17,2a'},
        "clang-12",
    ),

    linux_job(
        "Linux 22.04 Clang 13",
        "cppalliance/droneubuntu2204:1",
        {TOOLSET: 'clang', COMPILER: 'clang++-13', CXXSTD: '03,11,14,17,20'},
        "clang-13",
    ),

    linux_job(
        "Linux 22.04 Clang 14 UBSAN",
        "cppalliance/droneubuntu2204:1",
        {TOOLSET: 'clang', COMPILER: 'clang++-14', CXXSTD: '03,11,14,17,20,2b'} + ubsan,
        "clang-14",
    ),

    linux_job(
        "Linux 22.04 Clang 14 ASAN",
        "cppalliance/droneubuntu2204:1",
        {TOOLSET: 'clang', COMPILER: 'clang++-14', CXXSTD: '03,11,14,17,20,2b'} + asan,
        "clang-14",
    ),

    linux_job(
        "Linux 22.04 Clang 15",
        "cppalliance/droneubuntu2204:1",
        {TOOLSET: 'clang', COMPILER: 'clang++-15', CXXSTD: '03,11,14,17,20,2b'},
        "clang-15",
        ["deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-15 main"],
    ),

    macos_job(
        "MacOS 10.15 Xcode 12.2 UBSAN",
        {TOOLSET: 'clang', COMPILER: 'clang++', CXXSTD: '03,11,14,1z'} + ubsan,
    ),

    macos_job(
        "MacOS 10.15 Xcode 12.2 ASAN",
        {TOOLSET: 'clang', COMPILER: 'clang++', CXXSTD: '03,11,14,1z'} + asan,
    ),

    macos_job(
        "MacOS 12.4 Xcode 13.4.1 UBSAN",
        {TOOLSET: 'clang', COMPILER: 'clang++', CXXSTD: '03,11,14,17,20,2b'} + ubsan,
        xcode_version="13.4.1", osx_version="monterey", arch="arm64",
    ),

    macos_job(
        "MacOS 12.4 Xcode 13.4.1 ASAN",
        {TOOLSET: 'clang', COMPILER: 'clang++', CXXSTD: '03,11,14,17,20,2b'} + asan,
        xcode_version="13.4.1", osx_version="monterey", arch="arm64",
    ),

    windows_pipeline(
        "Windows VS2015 msvc-14.0",
        "cppalliance/dronevs2015",
        {TOOLSET: 'msvc-14.0', CXXSTD: '14,latest'},
    ),

    windows_pipeline(
        "Windows VS2017 msvc-14.1",
        "cppalliance/dronevs2017",
        {TOOLSET: 'msvc-14.1', CXXSTD: '14,17,latest'},
    ),

    windows_pipeline(
        "Windows VS2019 msvc-14.2",
        "cppalliance/dronevs2019",
        {TOOLSET: 'msvc-14.2', CXXSTD: '14,17,20,latest'},
    ),

    windows_pipeline(
        "Windows VS2022 msvc-14.3",
        "cppalliance/dronevs2022:1",
        {TOOLSET: 'msvc-14.3', CXXSTD: '14,17,20,latest'},
    ),
]
