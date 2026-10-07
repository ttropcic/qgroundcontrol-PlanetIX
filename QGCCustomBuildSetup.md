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

## Preparing the custom build

The repository contains the QGroundControl custom build example in the root `custom-example` directory.

Before building the custom version, rename:

```text
custom-example
```

to:

```text
custom
```

After renaming the directory, run the `updateqrc.py` script from inside the `custom` directory:

```powershell
cd custom
python updateqrc.py
```

This prepares the resource files used by the custom QGroundControl build.

After this step, open the project in Qt Creator and build it using the configured Qt kit.

For more information about QGroundControl custom builds, see:

[QGroundControl Custom Build Documentation](https://docs.qgroundcontrol.com/Stable_V4.3/en/qgc-dev-guide/custom_build/custom_build.html)

## Adding custom files

Custom files are added inside the `custom` directory.

For example, a custom QML file can be placed in:

```text
custom/res/CustomSafetyComponent.qml
```

When replacing an existing QGroundControl resource, the replacement file must be added to custom.qrc using the resource path that QGC expects.

Depending on the resource being replaced, the original resource may also need to be added to qgroundcontrol.exclusion. The exclusion mechanism does not apply to every QGC resource.

For example:

```xml
<file alias="SafetyComponent.qml">res/CustomSafetyComponent.qml</file>
```

The alias is the resource path that QGroundControl uses. When overriding an existing QGC file, the alias should match the original resource path.

After changing the custom resource configuration, run:

```powershell
cd custom
python updateqrc.py
```

and then rebuild QGroundControl.

### Example 1:

To replace the original `FlyViewBottomRightRowLayout.qml`:

1. Create the custom file:

```text
custom/res/CustomFlyViewBottomRightRowLayout.qml
```

2. Add the original resource to the appropriate exclusion file:

```text
custom/qgroundcontrol.exclusion
```

the alias in custom.qrc must match the resource path of the original QGC file. The other side is the path to the custom file, relative to the custom directory.

```xml
<file alias="QGroundControl/FlightDisplay/FlyViewBottomRightRowLayout.qml">src/FlightDisplay/FlyViewBottomRightRowLayout.qml</file>
```

- QGroundControl/FlightDisplay/FlyViewBottomRightRowLayout.qml is the resource path used by QGC.
- src/FlightDisplay/FlyViewBottomRightRowLayout.qml is the path to the file in the custom directory.

3. Add the custom file to:

> **Note:** Pay attention to where you are adding the file. It needs to be inside the `<qresource prefix="/qml">` section if adding a .qml file

```text
custom/custom.qrc
```

using the original resource name as the alias:

```xml
<file alias="QGroundControl/FlightDisplay/FlyViewBottomRightRowLayout.qml">res/CustomFlyViewBottomRightRowLayout.qml</file>
```

4. Run:

```powershell
python updateqrc.py
```

5. Rebuild QGroundControl.

### Example 2:

Some existing QGC resources cannot be excluded using qgroundcontrol.exclusion.

In this case, the original resource is not removed through the exclusion mechanism. Instead, the replacement can be added directly to custom.qrc using the resource name that QGC expects.
To replace `SafetyComponent.qml`:

1. Create the replacement file:

```text
custom/res/CustomSafetyComponent.qml
```

2. Add the replacement file to:

> **Note:** Pay attention to where you are adding the file. It needs to be inside the `<qresource prefix="/qml">` section if adding a .qml file

```text
custom/custom.qrc
```

using the original resource name as the alias:

```xml
<file alias="SafetyComponent.qml">res/CustomSafetyComponent.qml</file>
```

3. No need to Run:

```powershell
python updateqrc.py
```

4. Rebuild QGroundControl.


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

Test without adding limits beforehand, only add this if the build cannot be made because of insufficient heap memory

In **Qt Creator → Projects → Build → Build Steps → Tool arguments**, add:

```text
-j1
```

This forces the build system to use a single parallel build job.

>**Note:** Gradually test out with more parallel build jobs

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