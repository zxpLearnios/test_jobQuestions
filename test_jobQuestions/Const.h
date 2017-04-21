//
//  Const.h
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/6.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Const : NSObject

@end


/*
 1. assign用于 ‘基本数据类型’、‘枚举’、‘结构体’ 等非OC对象类型
 
 2. viewDidUnload: ios6之前，控制器的view被释放并置为nil时会触发，比如：发生内存警告时（ios6之前），不是由于dealloc调用
 
 3. SDWebImage:写文件到硬盘也在以单独 NSInvocationOperation 完成，避免拖慢主线程。 SDImageCache 在初始化的时候会注册一些消息通知，在内存警告或退到后台的时候清理内存图片缓存，应用结束的时候清理过期图片。
 图片下载由 NSURLConnection 来做.  将图片保存到 SDImageCache 中，内存缓存和硬盘缓存同时保存。写文件到硬盘也在以单独 NSInvocationOperation 完成，避免拖慢主线程。 另外，SDImageCache 在初始化的时候会注册一些消息通知，在内存警告或退到后台的时候清理内存图片缓存，应用结束的时候清理过期图片。
    在iOS 8之前，SDWebImage默认的最大同时下载图片数为6张，也就是最多开6个线程，这是为什么呢？其实这是一个经验的问题，框架的开发者总结出我们常遇到的页面最大图片数目不会超过6-7张，但是外国人对于7这个数字又有些敏感，所以索性就设置成了6。当然，我们可以根据自己的需要修改这个值的
 
 
 4. AFN:  NSURLSession相对于平时通信中的会话，但本身却不会进行网络数据传输，它会穿件多个NSURLSessionTask去执行每次的网络请求
 
 NSURLSession的行为取决于三个方面。包括NSURLSession的类型、NSURLSessionTask的类型和在创建task时APP是否处于前端
 
 NSURLSession有两种获取数据的方式：
 
 初始化session时指定delegate，在代理方法中返回数据，需要实现NSURLSession的两个代理方法
 
 初始化Session时未指定delegate的，通过block回调返回数据。
 
 NSURLSession对象的销毁，有两种销毁模式：
 
 - (void)invalidateAndCancel 取消该Session中的所有Task，销毁所有delegate、block和Session自身，调用后Session不能再复用。
 
 - (void)finishTasksAndInvalidate 会立即返回，但不会取消已启动的task，而是当这些task完成时，调用delegate
 
 这里有个地方需要注意，即：NSURLSession对象对其delegate都是强引用的，只有当Session对象invalidate， 才会释放delegate，否则会出现memory leak。
 
 使用Session加速网络访问速度，使用同一个Session中的task访问数据，不用每次都实现三次握手，复用之前服务器和客户端之间的网络链接，从而加快访问速度。
 
 5. FMDB:
 
 
 6. CoreData:
 Undefined: 默认值，参与编译会报错
 Integer 16: 整数，表示范围 -32768 ~ 32767
 Integer 32: 整数，表示范围 -2147483648 ~ 2147483647
 Integer 64: 整数，表示范围 –9223372036854775808 ~ 9223372036854775807
 Float: 小数，通过MAXFLOAT宏定义来看，最大值用科学计数法表示是 0x1.fffffep+127f
 Double: 小数，小数位比Float更精确，表示范围更大
 String: 字符串，用NSString表示
 Boolean: 布尔值，用NSNumber表示
 Date: 时间，用NSDate表示   可以排序
 Binary Data: 二进制，用NSData表示，类似于double
 Transformable: OC对象，用id表示。可以在创建托管对象类文件后，手动改为对应的OC类名。使用的前提是，这个OC对象必须遵守并实现NSCoding协议
 
 每更改一次coreData表，最好删除appclean下并build再运行
 
 7. SQLite : 轻量级的数据库
 
 8. performSelector:withObject:函数可以直接调用这个消息。但是perform相关的这些函数，有一个局限性，其参数数量不能超过2个,否则要做很麻烦的处理，与之相对，NSInvocation也是一种消息调用的方法，并且它的参数没有限制。这两种直接调用对象消息的方法，在IOS4.0之后，大多被block结构所取代，只有在很老的兼容性系统中才会使用，简单用法总结如下：
 
 9. 将可能发生异常的代码，放入@try{可能发生异常的代码} @catch{捕获异常，异常的名字、原因、详细信息} @finally{不管是否有异常，在（可能发生异常的代码）执行完后，都会进入这里}。 Test14里有
 
 10.  __block typeof(self) wSelf = self;    typeof(a) 获取a的类型并返回, 用weakself作为self，防止在block内圆使用self时出现内存泄漏。
 
 11.
 
 
 
 */



