# scripts

这个目录放仓库维护脚本，尽量保持“小而明确”，每个脚本只做一件事。

## 当前脚本列表

| 脚本 | 用途 |
| --- | --- |
| [check-markdown-links.ps1](./check-markdown-links.ps1) | 检查仓库内 Markdown 相对链接是否失效 |

## `check-markdown-links.ps1` 用途

- 扫描仓库里的 `.md` 文件
- 提取相对路径形式的 Markdown 链接
- 忽略 `http(s)`、`mailto:` 和页内锚点
- 输出不存在的本地目标路径

## 本地运行方式

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\check-markdown-links.ps1
```

如果要指定检查根目录，可以传入 `-Root` 参数：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\check-markdown-links.ps1 -Root .\slamNotes
```

## 典型输出说明

- 输出 `No broken local markdown links found.`：说明本地相对链接检查通过
- 输出 `Broken local markdown links:`：说明存在失效的相对链接，需要按文件和目标路径逐项修复

## 新增脚本时的约定

- 优先用描述性的名字，例如 `check-xxx.ps1`
- 默认支持在仓库根目录直接执行
- 如果脚本会被持续复用，记得同步更新这里和 [仓库维护](../docs/仓库维护.md)
