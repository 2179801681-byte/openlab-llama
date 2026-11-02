# openlab-llama

OpenLab 2026 笔试第 3 题：从源码编译 llama.cpp 并在本地运行 Gemma 4 E2B。

## 实验环境

- Windows 11，Visual Studio Build Tools 18，MSVC 19.51
- CMake 4.4，Ninja
- llama.cpp commit `785322d`，版本 `0.8.0-dev`
- 模型：Gemma 4 E2B IT，GGUF，Q4_0，2.65GB
- 后端：CPU（AVX512）

## 目录结构

```text
openlab-llama/
├─ logs/       # build_log.txt、对话与参数实验日志
├─ scripts/    # 编译与运行脚本
├─ models/     # 本地模型（不提交）
├─ notes/      # 参数说明与实验记录
└─ src/        # llama.cpp 源码（嵌套仓库，不提交）
```

## 构建

在 PowerShell 中执行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build.ps1
```

脚本会加载 MSVC 环境，依次执行 CMake configure 和 build，并把完整输出写入
`logs/build_log.txt`。该文件不得删改或截断。

## 运行

模型放到 `models/gemma-4-E2B-it-Q4_0.gguf`，然后：

```powershell
cd build\bin
.\llama-cli.exe -m ..\..\models\gemma-4-E2B-it-Q4_0.gguf `
  -p "用一句话介绍你自己" -n 200 -t 8 -ngl 0 -st `
  --no-display-prompt --reasoning off
```

本次 CPU 实测结果：

- 模型回答的第一句话：我是一个由 Google DeepMind 开发的大型语言模型，名为 Gemma 4。
- Prompt 处理速度：81.8 tokens/s
- 生成速度：16.2 tokens/s

完整输出见 `logs/run-cpu.txt`。

## 参数实验

- `-n`：最多生成的新 token 数。
- `-t`：生成阶段使用的 CPU 线程数。
- `-ngl`：卸载到显存的层数。

把 `-t` 改为 1 后程序仍可运行，但生成速度会下降。

把 `-ngl` 设为 9999 时，本次纯 CPU 构建不会崩溃，而是忽略该参数并输出：

```text
warning: no usable GPU found, --gpu-layers option will be ignored
```

完整输出见 `logs/run-ngl9999.txt`。如果构建时启用了 CUDA 或 Vulkan，
显存不足则会在加载模型时分配失败并退出。

## 注意

- `build_log.txt` 必须完整保留，不得删改或截断。
- 模型文件体积较大，已在 `.gitignore` 中排除。
