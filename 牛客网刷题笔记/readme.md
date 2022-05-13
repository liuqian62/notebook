# 牛客网刷题笔记
## 在线编程常见输入输出练习 [链接](https://ac.nowcoder.com/acm/contest/5657#question)

* 1.A+B(1)

输入：`输入包括两个正整数a,b(1 <= a, b <= 1000),输入数据包括多组。`  
输出：`输出a+b的结果`

```cpp
#include<iostream>
using namespace std;

int main()
{
    int a,b;
    while(cin>>a>>b){
        if(a<1||a>1000||b<1||b>1000){
            break;
        }
        cout<<a+b<<endl;
    }
}
```

* 1.A+B(2)

输入：`输入第一行包括一个数据组数t(1 <= t <= 100),
接下来每行包括两个正整数a,b(1 <= a, b <= 1000)`  
输出：`输出a+b的结果`

```cpp
#include<iostream>
using namespace std;

int main(){
    int t,a,b;
    cin>>t;
    while(cin>>a>>b){
        cout<<a+b<<endl;
        if(--t==0) break;
    }
    return 0;
}
```
