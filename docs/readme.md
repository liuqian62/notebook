# docs

这个目录集中放仓库的整理规则、维护说明和辅助文档。

## 这组文档解决什么问题

- 想快速理解整个仓库怎么组织：看 [仓库地图](./仓库地图.md)
- 想知道日常怎么维护：看 [仓库维护](./仓库维护.md)
- 想按统一风格继续补文档：看 [文档整理约定](./文档整理约定.md)
- 想写新的 README 或索引页：看 [README 写作备忘](./README写作备忘.md)

## 首次阅读顺序

1. [仓库地图](./仓库地图.md)
2. [仓库维护](./仓库维护.md)
3. [文档整理约定](./文档整理约定.md)
4. [README 写作备忘](./README写作备忘.md)

## 文档索引

| 文件 | 作用 | 适合什么时候看 |
| --- | --- | --- |
| [仓库地图](./仓库地图.md) | 说明一级目录分工和整体整理思路 | 刚接触仓库时 |
| [仓库维护](./仓库维护.md) | 说明已有检查脚本、维护动作和建议频率 | 准备整理或提交前 |
| [文档整理约定](./文档整理约定.md) | 记录 README、正文、图片、链接等约定 | 新增或修改文档时 |
| [README 写作备忘](./README写作备忘.md) | 汇总 Markdown/README 写作技巧和片段 | 需要写入口页时 |

## 仓库维护入口

- 根目录协作说明：[`../CONTRIBUTING.md`](../CONTRIBUTING.md)
- Markdown 本地链接检查脚本：[`../scripts/check-markdown-links.ps1`](../scripts/check-markdown-links.ps1)
- GitHub Actions 工作流：[`../.github/workflows/markdown-links.yml`](../.github/workflows/markdown-links.yml)

## 约定更新方式

- 规则类内容优先更新到 [文档整理约定](./文档整理约定.md)
- 操作步骤、检查流程优先更新到 [仓库维护](./仓库维护.md)
- 目录职责变化时，同时更新 [仓库地图](./仓库地图.md) 和根 [readme.md](../readme.md)
