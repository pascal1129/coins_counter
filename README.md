# coins_counter
基于Matlab和机器视觉的硬币计数系统
Coin counting system based on machine vision and Matlab


## 描述
* 用手机拍摄得到一堆硬币图片(详见coin_images文件夹内的示例图片)，通过机器视觉的相关知识，统计得到各面值硬币的数量和所有硬币的总价值.

* 此版本不带GUI用户界面.


## 目录结构
```
coins_counter
│
├── coin_images             硬币样例图片文件夹，供测试使用
│   ├── 1.jpg               样例图片1
│   ├── 2.jpg               样例图片2
│   ├── ...                 ...
│   └── 6.jpg               样例图片6
│
├── process_standalone.m    可直接运行的独立代码，无用户界面
│
├── result.png              程序运行产生的中间结果展示（实际运行时不生成此图片）
│
└── README.md               说明文档
```

## 运行方式
* 代码编写平台：Matlab R2016a，常见Matlab版本均可运行本代码。

* 打开Matlab，运行process_standalone.m即可，中间结果图片会显示出来，统计结果会以coin_cnt的形式输出，形如[1 2 3]，其中的1 2 3分别表示面值为1元、0.5元、0.1元的硬币数量。

* 目前仅支持人民币，且对强光、复杂背景等不良环境下的支持不好。
