# python相关

这个目录主要放 Python 环境、常用库和工具类笔记。

## 目录导航

- [mmdetection](./mmdetection.md)

## 使用说明

- 当前这个 `readme.md` 既是入口页，也保留了一部分速查内容
- 如果后面继续增加新主题，建议按“一个主题一篇笔记”的方式继续拆分

---

## python 相关笔记

[python基础](https://www.runoob.com/python3/python3-tutorial.html)  
[python100天](https://www.bookstack.cn/read/Python-100-Days/README.md)  

### 虚拟环境配置
```bash
conda create -n rich python=3.7  #创建环境
conda activate rich  #激活环境
conda deactivate rich  #退出环境
conda remove -n rich --all  #删除环境
```
### requirements
```
pip install -r requirements.txt
```
例如
```
pytest==6.2.5
pytest-json-report==1.4.1
pytest-metadata==1.11.0
pytest-ordering==0.6
PyTestReport==0.2.1
python-dateutil==2.8.2
```
* [解决安装缓慢的问题](https://blog.csdn.net/weixin_42455006/article/details/121957633?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522164964070016780271982907%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=164964070016780271982907&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~rank_v31_ecpm-3-121957633.142^v7^article_score_rank,157^v4^control&utm_term=%E5%AE%89%E8%A3%85requirements.txt%E5%A4%AA%E6%85%A2&spm=1018.2226.3001.4187)

```bash
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple/ --trusted-host pypi.douban.com
```

* [python图形界面示例](https://github.com/liuqian62/loopmark)
### [mmdetection](./mmdetection.md)
### OpenCV 教程
* [OpenCV中文官方文档](https://woshicver.com/)
* [OpenCV 4.0 中文文档](https://opencv.apachecn.org/#/)

### pyecharts
* [pyecharts 中文文档](https://gallery.pyecharts.org/#/README)
* [pyecharts GitHub](https://github.com/pyecharts/pyecharts)
* [pyecharts 图库](https://github.com/pyecharts/pyecharts-gallery)




