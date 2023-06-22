# HPC_week_11
## Homework for the 10th week

### 12 System on Chip

#### 12.1 Android

##### 12.1.1 Text to android
The following instructions were used to push a text file from the home system to the SoC remote directory:

```log
echo "this is a test text" >> test.txt
adb -s 3000a4df push test.txt /data/local/tmp/sven
adb -s 3000a4df shell "cat /data/local/tmp/sven/test.txt"
```

##### 12.1.2 Hello World from Android
The following commands were used while logged on to the host system to cross compile a simple program that prints "hello from android", push the executable to the android SoC and execute it:

```log
aarch64-linux-android33-clang++ hello_world.cpp -o hello_world.out
adb -s 3000a4df push hello_world.out /data/local/tmp/sven 
adb -s 3000a4df shell "LD_LIBRARY_PATH=/data/local/tmp/sven ./data/local/tmp/sven/hello_world.out"
```

##### 12.1.3 Logs from Android
The command `adb -s 3000a4df logcat` opens the log window of the device with the ID 3000a4df.

#### 12.2 CPU

##### 12.2.2 Benchark of ASIMD Microkernels (Section 1)
After the upload of the code from [Section 1](https://scalable.uni-jena.de/opt/hpc/chapters/assignment_neoverse_v1.html) to the host system, cross compilation like in 12.1.2 at first we run into trouble. The terminal complains, because the library `libomp.so` is not found. It must be provided from the host system to the destination system SoC in a specified path with the following commands:

- Find it in the host system in the cross compiler directory: `find /opt/software/sdk/ndk/25.2.9519653/toolchains/llvm | grep libomp.so`
- Upload it to the destination system: `adb -s 3000a4df push /opt/software/sdk/ndk/25.2.9519653/toolchains/llvm/prebuilt/linux-x86_64/lib64/clang/14.0.7/lib/linux/aarch64/libomp.so /data/local/tmp/sven`

After this the program from section 1 can be executed after crosscompilation and push to the SoC system.

The following benchmark results could be observed:

**Core 0**
Operation | FP32/64 | Time [s] | FP32 GFLOPs
------------- | ------------- | ------------- | -------------
VMUL | FP32 | 75.29 | 7.97
VMUL | FP64 | 75.29 | 3.98
FMUL | FP32 | 37.65 | 3.98
FMUL | FP64 | 37.64 | 3.98

**Core 1**
Operation | FP32/64 | Time [s] | FP32 GFLOPs
------------- | ------------- | ------------- | -------------
VMUL | FP32 | 37.57 | 15.97
VMUL | FP64 | 37.57 | 7.99
FMUL | FP32 | 37.57 | 3.99
FMUL | FP64 | 37.56 | 4.00

**Core 2**
Operation | FP32/64 | Time [s] | FP32 GFLOPs
------------- | ------------- | ------------- | -------------
VMUL | FP32 | 37.56 | 15.98
VMUL | FP64 | 37.55 | 7.99
FMUL | FP32 | 37.55 | 4.00
FMUL | FP64 | 37.56 | 4.00

**Core 3**
Operation | FP32/64 | Time [s] | FP32 GFLOPs
------------- | ------------- | ------------- | -------------
VMUL | FP32 | 26.98 | 22.24
VMUL | FP64 | 26.97 | 11.12
FMUL | FP32 | 26.97 | 5.56
FMUL | FP64 | 26.98 | 5.56

**Core 4**
Operation | FP32/64 | Time [s] | FP32 GFLOPs
------------- | ------------- | ------------- | -------------
VMUL | FP32 | 26.97 | 22.25
VMUL | FP64 | 26.97 | 11.12
FMUL | FP32 | 26.97 | 5.56
FMUL | FP64 | 26.97 | 5.56

**Core 6**
Operation | FP32/64 | Time [s] | FP32 GFLOPs
------------- | ------------- | ------------- | -------------
VMUL | FP32 | 26.92 | 22.29
VMUL | FP64 | 26.92 | 11.15
FMUL | FP32 | 26.92 | 5.57
FMUL | FP64 | 26.92 | 5.57

**Core 7**
Operation | FP32/64 | Time [s] | FP32 GFLOPs
------------- | ------------- | ------------- | -------------
VMUL | FP32 | 11.8331 | 50.7053
VMUL | FP64 | 11.8338 | 25.3511
FMUL | FP32 | 11.8337 | 12.68
FMUL | FP64 | 11.8352 | 12.67

##### 12.2.3 Benchmark of Section 6.2 Microkernels

From 12.2.2 it is derivable which cores are the prime core (ID7), the performance cores (ID 3-6) and the efficiency cores (ID 0-2). This can again be validated by the following benchmark of the GEMM with M=16, N=6, K=1 from [Section 6.2](https://scalable.uni-jena.de/opt/hpc/chapters/assignment_building_blocks.html#ch-assembly-building-blocks-unrolled).
Unfortunately it was not possible to pin non of the threads to core 5 and the error message "taskset: failed to set 25652's affinity: Invalid argument" kept showing up. This is reather irrelevant, because we have benchmarks from the other performance cores. Anyways it is a strange behavior.

**Core 0**
Core | # of Executions | Time [s] | average duration | GFLOPs
------------- | ------------- | ------------- | ------------- | -------------
0 | 750000000 | 38.23 | 5.09696e-08 | 3.77
1 | 750000000 | 42.07 | 5.60891e-08 | 3.42
2 | 1500000000 | 84.15 | 5.61019e-08 | 3.42
3 | 1500000000 | 10.47 | 6.98164e-09 | 27.50
4 | 1500000000 | 10.53 | 7.02082e-09 | 27.35
5 | N/A | N/A | N/A | N/A
6 | 1500000000 | 11.65 | 7.76402e-09 | 24.73
7 | 1500000000 | 8.38 | 5.58378e-09 | 34.39

