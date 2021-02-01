代码编辑思路

1. 执行`linkage_budget.m`可以得到整个Telesat星座与不同地面站，代码还会执行链路预算，得到链路预算矩阵的三个不同方向的映射截面

2. 执行`more_linkage_budget.m`可以得到当地面站为汽车、飞机、轮船、导弹等非静止目标时的链路分析

3. 执行`select_modulation.m`可以修正卫星通信过程中的调制解调方式

4. 执行`concatenate.m`可以得到Telesat星座各卫星在当前时刻的LLA信息，便于全球天线增益图的绘制

5. 执行`graph3.m`可以得到全球天线增益图

6. 执行`acc.m`可以获得某时刻的可见性分析

   