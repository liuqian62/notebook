# mmdetection
## 教程
* [链接](https://blog.csdn.net/qq_16137569/article/details/121316235)
# 测试程序用时

```bash
python -m torch.distributed.launch --nproc_per_node=1 --master_port=29500 tools/analysis_tools/benchmark.py $cofig $checkpoint --launcher pytorch
```
# 测算模型参数量和计算量
```
git config --global user.name “dawenxun”
git config --global user.email “dawenxun17@163.com”
git init (初始化本地仓库)
git remote add origin git@github.com:open-mmlab/mmdetection.git
( git remote rm origin)
git add .  (提交缓存)
git status
git commit -m “   备注   ”
git pull --rebase origin master (备份远程与本地同步)
or [  git pull + git pull origin master --allow-unrelated-histories 【允许不相关历史提交，并强制合并】]
git push -u origin master （推送）
冲突问题：
git pull --rebase origin master出现冲突，则解决冲突（选择接受或更正）
git add . 后 git rebase --continue 进行git pull --rebase origin master  最后 git push origin master

```
