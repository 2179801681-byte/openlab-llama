# openlab-llama

OpenLab 2026 笔试第 3 题：从源码编译 llama.cpp 并在本地运行 Gemma 4 E2B。

## 目录结构

```text
openlab-llama/
├─ logs/       # build_log.txt 等完整日志
├─ scripts/    # 编译与运行脚本
├─ models/     # 本地模型（不提交）
└─ notes/      # 参数说明与实验记录
```

## 注意

- `build_log.txt` 必须完整保留，不得删改或截断。
- 模型文件体积较大，已在 `.gitignore` 中排除。
