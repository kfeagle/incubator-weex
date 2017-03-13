##概述

**GCanvas4Weex**

GCanvas Weex Plugin ( GCanvas的Weex插件 ），为Weex提供了GCanvas的2D和3D的图形渲染能力。GCanvas4Weex是对GCanvas的Weex插件的实现。




**GCanvas**

G-Canvas是托管了HTML5 Canvas，将HTML5的Canvas API通过Bridge的方式映射成Native实现。G-Canvas是在移动app内对HTML5 canvas元素进行渲染加速，提供给用户优异的交互体验的解决方案。G-Canvas能够兼容标准HTML5 canvas的API，同样的代码可以在移动app（android/iOS）内或浏览器内运行，实现跨平台。同时G-Canvas也支持DOM与CSS渲染、本地资源访问和物理引擎等。

![](http://tbdocs.alibaba-inc.com/download/attachments/223349202/G-Canvas%E6%9E%B6%E6%9E%84.png?version=6&modificationDate=1421065966000)


##接入

* pod依赖

```
pod 'GCanvas4Weex', '1.0.0.1'

```


* 注册模块

```

[WXSDKEngine registerModule:@"gcanvas" withClass:NSClassFromString(@"WXGCanvasModule")];
[WXSDKEngine registerComponent:@"gcanvas" withClass:NSClassFromString(@"WXGCanvasComponent")];
```

##测试g2-mobile demo的方法
* 在canvas_demo/g2_mobile目录下运行 npm install
* 运行 weex debug demo.we, 扫码开启调试功能，打开RemoteDebug  
* 扫码打开demo.we页面
* 修改demo.we 中的如下代码，将foo1 修改为foo2，foo3, foo4, foo5, foo6等值，
应该会触发hot refreash， 页面上会显示其它的case

```
    module.exports={
        methods:{
          render:function(){

             foo1();

          }
         }
```         





