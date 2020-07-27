# 开发需要解决的问题

### 采用objective-c作为桥梁，连接LibTorch C++进行开发

- 安装**cocoapod**以及**Pytorch**环境
- 重写CAR的部分代码，导出含有模型结构的**.pth或.pt**文件。重写的代码无需使用cuda，相当于重新导出模型
- swift+objective-c+LibTorch C++基本语法学习
- 界面设计与实现
- 连接模型进行后续开发