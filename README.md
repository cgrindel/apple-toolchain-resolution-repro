# Reproduce Apple toolchain resolution issue on Linux

[Related Slack thread](https://bazelbuild.slack.com/archives/CD3QY5C2X/p1698094428238399)

This repository contains the following:

- An Objc library, `SimpleObjc`, that is marked as only being compatible with MacOS using the
  `target_compatible_with` attribute.
- A Swift binary, `PrintObjcVersion`, that depends on `SimpleObjc`.
- A Swift library, `SimpleSwift`, that has no dependencies and no `target_compatible_with` attribute
  settings.
- A Swift binary, `PrintSwiftVersion`, that depends on `SimpleSwift`.

On MacOS (Sonoma 14.0) using Xcode 15.0.1, running `bazel test //...` succeeds. On linux (Ubuntu
22.04), it fails with the following error:

```
ERROR: /home/chuck/.cache/bazel/_bazel_chuck/1356082df8f6e9e7706552f3fc65582d/external/bazel_tools/tools/cpp/BUILD:58:19: in cc_toolchain_alias rule @bazel_tools//tools/cpp:current_cc_toolchain: 
Traceback (most recent call last):
        File "/virtual_builtins_bzl/common/cc/cc_toolchain_alias.bzl", line 26, column 48, in _impl
        File "/virtual_builtins_bzl/common/cc/cc_helper.bzl", line 219, column 17, in _find_cpp_toolchain
Error in fail: Unable to find a CC toolchain using toolchain resolution. Target: @@bazel_tools//tools/cpp:current_cc_toolchain, Platform: @@apple_support~1.11.1//platforms:darwin_x86_64, Exec platform: @@loca
l_config_platform//:host
ERROR: /home/chuck/.cache/bazel/_bazel_chuck/1356082df8f6e9e7706552f3fc65582d/external/bazel_tools/tools/cpp/BUILD:58:19: Analysis of target '@bazel_tools//tools/cpp:current_cc_toolchain' failed
ERROR: Analysis of target '//Sources/PrintObjcVersion:PrintObjcVersion' failed; build aborted: Analysis failed

```
  
If you add `target_compatible_with = ["@platforms//os:macos"]` to `PrintObjcVersion`, running `bazel
test //...` will succeed on linux.

Because [transitive incompatible targets should be
skipped](https://bazel.build/reference/be/common-definitions#common.target_compatible_with), it
should not be necessary to mark `PrintObjcVersion` with the `target_compatible_with` attribute.
