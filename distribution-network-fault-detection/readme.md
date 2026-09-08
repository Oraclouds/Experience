# 配电网单相接地故障检测仿真
Distribution Network Single-Line-to-Ground Fault Detection Simulation

## 项目背景
配电网中单相接地故障是最常见的故障类型之一，快速准确的故障检测对
保障供电可靠性至关重要。本项目基于 MATLAB/Simulink (Specialized 
Power Systems) 搭建了一个辐射状配电网模型，模拟单相接地故障场景，
并设计了基于零序电流的故障检测方法。

## 系统结构
- 三相电源 → 变压器（Yg/Yg）→ 馈线（PI Section Line）→ 母线 → 负荷
- 关键测点：馈线侧 V-I Measurement、母线侧 V-I Measurement
- 故障类型：A相接地故障（A-G），故障电阻 10Ω

## 方法
1. 在馈线侧和母线侧分别测量三相瞬时电流 Iabc
2. 通过 Demux + Sum 计算零序电流 3I0 = Ia + Ib + Ic
3. 对比故障前、故障中、故障切除后的零序电流特征

## 结果与分析
- 正常工况下，变压器合闸产生的励磁涌流在约5个周波（0.1s）内衰减至零，
  验证了模型对电磁暂态过程的正确响应
- 故障发生后，零序电流出现明显阶跃变化，验证了零序电流检测方法的有效性
- 故障切除后，系统电压/电流经短暂振荡后恢复至稳态

## 波形展示
### 母线电压，故障前后波形对比
![母线电压波形](./results/V_bus.jpg)

### 馈线电流，故障期间电流突增
![馈线电流波形](./results/I_feeder.jpg)

### 母线电流，与馈线电流趋势一致
![母线电流波形](./results/I_bus.jpg)

### 零序电流，含合闸暂态与故障响应
![零序电流波形](./results/I0_feeder.jpg)

## 技术栈
MATLAB R2025b · Simulink · Simscape Electrical (Specialized Power Systems)

## 后续可扩展方向
- 增加多种中性点接地方式对比（不接地/消弧线圈/小电阻）
- 引入零序电流RMS阈值判断，实现自动故障识别与保护动作
- 扩展为分类模型，探索机器学习在故障类型识别中的应用
