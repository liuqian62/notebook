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

* 2.A+B(2)

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

* 3.A+B(3)

输入：`输入包括两个正整数a,b(1 <= a, b <= 10^9),输入数据有多组, 如果输入为0 0则结束输入`  
输出：`输出a+b的结果`

```cpp
#include<iostream>
using namespace std;
int main(){
    int a,b;
    while(cin>>a>>b){
        if(a==0&&b==0) break;
        cout<<a+b<<endl;
    }
    return 0;
}
```

* 4.A+B(4)

输入：`输入数据包括多组。
每组数据一行,每行的第一个整数为整数的个数n(1 <= n <= 100), n为0的时候结束输入。
接下来n个正整数,即需要求和的每个正整数。`  
输出：`每组数据输出求和的结果`

```cpp
#include<iostream>
using namespace std;
int main(){
    int a,t;
    int sum=0;
    while(1){
        cin>>t;
        if(t==0) break;
        while(--t>=0){
            cin>>a;
            sum+=a;
        }
        cout<<sum<<endl;
        sum=0;
    }
    return 0;
}
```
* 5.A+B(5)

输入：`输入的第一行包括一个正整数t(1 <= t <= 100), 表示数据组数。
接下来t行, 每行一组数据。
每行的第一个整数为整数的个数n(1 <= n <= 100)。
接下来n个正整数, 即需要求和的每个正整数。`  
输出：`每组数据输出求和的结果`

```cpp
#include<iostream>
using namespace std;
int main(){
    int t,n;
    cin>>t;
    while(--t>=0){
        cin>>n;
        int sum=0, a;
        while(--n>=0){
            cin>>a;
            sum+=a;
        }
        cout<<sum<<endl;
    }    
    return 0;
}
```
* 6.A+B(6)

输入：`输入数据有多组, 每行表示一组输入数据。
每行的第一个整数为整数的个数n(1 <= n <= 100)。
接下来n个正整数, 即需要求和的每个正整数。`  
输出：`每组数据输出求和的结果`

```cpp
#include<iostream>
using namespace std;
int main(){
    int a,t;
    while(cin>>t){
        int sum=0;
        while(--t>=0){
            cin>>a;
            sum+=a;
        }
        cout<<sum<<endl;
    }
    return 0;
}
```
