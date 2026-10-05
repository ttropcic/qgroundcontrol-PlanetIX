# QGC Custom Build Setup

## Build and version settings for Windows

The following versions/settings are used to build the custom QGroundControl Windows application:

1. **Qt:** v6.6.3 — MSVC2019_64bit
2. **Qt Creator:** v13.0.2
3. **GStreamer:** v1.28.7 — MSVC x86_64

## Build and version settings for Linux

The Linux build uses the same repository, source-code changes, and general development tools. The main difference is the Qt kit/compiler used for the build:

1. **Qt:** v6.6.3 — GCC 64bit
2. **Qt Creator:** v13.0.2
3. **GStreamer:** 1.28.7

## Repository

Clone the custom QGroundControl repository and the required submodules:

```powershell
git clone --recursive --branch custom_ui_PlanetIX https://github.com/ttropcic/qgroundcontrol-PlanetIX.git
```

## Changes to the source code

### 1. `src\MAVLink\LibEvents\CMakeLists.txt`

The libevents dependency is pinned to a specific commit instead of tracking the current `main` branch.

```cmake
include(FetchContent)

FetchContent_Declare(libevents
    GIT_REPOSITORY https://github.com/mavlink/libevents.git
    GIT_TAG eab8144cabb96bff03c54af4037c00ed1d90a00f
    SOURCE_SUBDIR libs/cpp
)
```

This commit is used to ensure that the version of libevents used by the build is compatible with this QGroundControl project.

## Qt Creator build settings

### 1. Limit build parallelism

In **Qt Creator → Projects → Build → Build Steps → Tool arguments**, add:

```text
-j1
```

This forces the build system to use a single parallel build job.

## PowerShell / Git configuration

### 1. Check whether Git long-path support is enabled

To check the global Git configuration:

```powershell
git config --global --get core.longpaths
```

To check the system-wide Git configuration:

```powershell
git config --system --get core.longpaths
```

`--global` applies to the current Windows user, while `--system` applies to the system-wide Git configuration.

### 2. Enable Git long-path support

If required, enable it at the user level:

```powershell
git config --global core.longpaths true
```

Alternatively, enable it system-wide:

```powershell
git config --system core.longpaths true
```

The `--system` option may require an elevated PowerShell/Command Prompt.
