# Python 环境与工具速查

这份笔记整理常用的 Python 环境配置、依赖安装和工具入口，适合做速查页。

## 入门资料

- [Python 基础](https://www.runoob.com/python3/python3-tutorial.html)
- [Python 100 Days](https://www.bookstack.cn/read/Python-100-Days/README.md)

## 虚拟环境

```bash
conda create -n rich python=3.7
conda activate rich
conda deactivate rich
conda remove -n rich --all
```

## requirements

安装方式：

```bash
pip install -r requirements.txt
```

示例依赖：

```txt
pytest==6.2.5
pytest-json-report==1.4.1
pytest-metadata==1.11.0
pytest-ordering==0.6
PyTestReport==0.2.1
python-dateutil==2.8.2
```

安装较慢时可参考：

- [requirements 安装过慢的处理](https://blog.csdn.net/weixin_42455006/article/details/121957633?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522164964070016780271982907%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=164964070016780271982907&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~rank_v31_ecpm-3-121957633.142^v7^article_score_rank,157^v4^control&utm_term=%E5%AE%89%E8%A3%85requirements.txt%E5%A4%AA%E6%85%A2&spm=1018.2226.3001.4187)

```bash
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple/
```

## 常用专题

- [mmdetection](./mmdetection.md)
- [Python 图形界面示例](https://github.com/liuqian62/loopmark)

## OpenCV

- [OpenCV 中文官方文档](https://woshicver.com/)
- [OpenCV 4.0 中文文档](https://opencv.apachecn.org/#/)

## pyecharts

- [pyecharts 中文文档](https://gallery.pyecharts.org/#/README)
- [pyecharts GitHub](https://github.com/pyecharts/pyecharts)
- [pyecharts 图库](https://github.com/pyecharts/pyecharts-gallery)

## 后续整理建议

- 如果新增的是环境类内容，优先继续补到这份速查页
- 如果新增的是某个库或框架的深度笔记，优先拆成独立文件

