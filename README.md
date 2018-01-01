# VoiceKit

语音控制计算机的实验性项目. 前提假设是, 在语音识别控制计算机的过程中, 语音识别仅仅理解为与键盘类似的输入设备, 这样就降低了语音识别系统对语义处理准确性的要求, 而用指令性的语音来弥补. 即便如此, 语音识别文本的准确性也极大的影响了控制效果. 现阶段此项目也不能完全代替键盘和鼠标, 只能作为实验性的辅助.
目前只支持`Mac`, 但通过添加配置文件和scripts应该可以很容易的扩展到其他平台.

## 原理
主要分两部分, 语音识别端(client)和指令处理端(server). 本项目是指令处理端, 负责接收语音识别的结果(文本), 根据文本内容控制计算机, 需要运行在被控计算机上. Client只需要把语音识别结果的文本以HTTP POST请求的方式提交给Server即可.

本项目(Server)分为以下几块:
1. HTTP Server, 负责接收HTTP请求.
2. Engine负责解析文本, 调用相应控制脚本
3. Engine的模式扩展, 目前有normal和insert两个模式, insert负责语音录入, normal负责其他的情况
4. Engine的Application扩展, 对每个Application(比如Chrome)可以定义自己特有的语音指令

HTTP Server接受到请求后, 新建一个Engine实例, Engine实例在初始化的时候会探测当前用户正在使用的app, 根据app找到相应的扩展, 同时也会找到当前模式的扩展, 加载到引擎实例当中. 然后Engine解析收到的请求文本, 在加载的扩展中找到相应的脚本, 调用脚本完成对计算机的控制.

模式扩展和app扩展, 都是以module的形式存在, 用extend的方式加载到Engine实例当中.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/liangjingyang/voice_kit.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
