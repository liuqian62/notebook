# workflows

这个目录存放 GitHub Actions 工作流。

## 当前工作流

| 文件 | 作用 | 触发时机 |
| --- | --- | --- |
| [markdown-links.yml](./markdown-links.yml) | 检查仓库内 Markdown 相对链接是否失效 | `push` 到 `main/master` 或 `pull_request` |

## 维护说明

- 新增工作流时，优先选择低风险、可重复执行的检查
- 如果工作流依赖本地脚本，记得同步更新 [`../../scripts/readme.md`](../../scripts/readme.md)
- 如果工作流会改变仓库维护方式，记得同步更新 [`../../docs/仓库维护.md`](../../docs/仓库维护.md)
