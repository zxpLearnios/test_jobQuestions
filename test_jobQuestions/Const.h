//
//  Const.h
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/6.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Const : NSObject
/**
 *  documentPath
 */
+(NSString *)documentPath;

+ (double)availableMemory;
+ (double)usedMemory;
@end


/*   Xcode8代码注释快捷键为command + option + /。
 
 
 1. assign用于 ‘基本数据类型’、‘枚举’、‘结构体’ 等非OC对象类型
 
 2. viewDidUnload: ios6之前，控制器的view被释放并置为nil时会触发，比如：发生内存警告时（ios6之前），不是由于dealloc调用
 
 3. 图片下载由 NSURLConnection 来做.  将图片保存到 SDImageCache 中，内存缓存和硬盘缓存同时保存。写文件到硬盘也在以单独 NSInvocationOperation 完成，避免拖慢主线程。 另外，SDImageCache 在初始化的时候会注册一些消息通知，在内存警告或退到后台的时候清理内存图片缓存，应用结束的时候清理过期图片。
    在iOS 8之前，SDWebImage默认的最大同时下载图片数为6张，也就是最多开6个线程，这是为什么呢？其实这是一个经验的问题，框架的开发者总结出我们常遇到的页面最大图片数目不会超过6-7张，但是外国人对于7这个数字又有些敏感，所以索性就设置成了6。当然，我们可以根据自己的需要修改这个值的
 
 
 4. AFN:  NSURLSession相对于平时通信中的会话，但本身却不会进行网络数据传输，它会穿件多个NSURLSessionTask去执行每次的网络请求
 
 NSURLSession的行为取决于三个方面。包括NSURLSession的类型、NSURLSessionTask的类型和在创建task时APP是否处于前端
 
 NSURLSession有两种获取数据的方式：在代理方法中返回数据，，通过block回调返回数据。
 
 NSURLSession对象的销毁，有两种销毁模式：
 
 - (void)invalidateAndCancel 取消该Session中的所有Task，销毁所有delegate、block和Session自身，调用后Session不能再复用。
 
 - (void)finishTasksAndInvalidate 会立即返回，但不会取消已启动的task，而是当这些task完成时，调用delegate
 
 这里有个地方需要注意，即：NSURLSession对象对其delegate都是强引用的，只有当Session对象invalidate， 才会释放delegate，否则会出现memory leak。
 
 使用Session加速网络访问速度，使用同一个Session中的task访问数据，不用每次都实现三次握手，复用之前服务器和客户端之间的网络链接，从而加快访问速度。
 
 5. AFN和SDWebimage 在图片缓存上的区别：
    SDWebImage 中的图片缓存 在memory上使用的是 NSCache,在disk 是则用到的是  NSFileManager。AFNetWorking 的图片缓存，在在memory上使用的是 NSCache，没有磁盘缓存。
 sdwebimage： 把图片url用MD5 加密成文件名
 
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
 
 7.1 ： 类方法和实例方法的区别
 静态方法在程序开始时生成内存,实例方法在程序运行中生成内存，
 所以静态方法可以直接调用,实例方法要先成生实例,通过实例调用方法，静态速度很快，但是多了会占内存。
 静态内存是连续的,因为是在程序开始时就生成了,而实例申请的是离散的空间,所以当然没有静态方法快，
 而且静态内存是有限制的，太多了程序会启动不了。
 
 8. performSelector:withObject:函数可以直接调用这个消息。但是perform相关的这些函数，有一个局限性，其参数数量不能超过2个,否则要做很麻烦的处理，与之相对，NSInvocation也是一种消息调用的方法，并且它的参数没有限制。这两种直接调用对象消息的方法，在IOS4.0之后，大多被block结构所取代，只有在很老的兼容性系统中才会使用，简单用法总结如下：
 
 9. 将可能发生异常的代码，放入@try{可能发生异常的代码} @catch{捕获异常，异常的名字、原因、详细信息} @finally{不管是否有异常，在（可能发生异常的代码）执行完后，都会进入这里}。 Test14里有
 
 10.  __block typeof(self) wSelf = self;    typeof(a) 获取a的类型并返回, 用weakself作为self，防止在block内圆使用self时出现内存泄漏。
 
 11.  & 位运算符。 如 if (options & SDWebImageAvoidAutoSetImage) {}表示若options参数是SDWebImageAvoidAutoSetImage，则执行{}
 
 12.. weak 的实现原理可以概括一下三步：
 
     1、初始化时：runtime会调用objc_initWeak函数，初始化一个新的weak指针指向对象的地址。
     
     2、添加引用时：objc_initWeak函数会调用 objc_storeWeak() 函数， objc_storeWeak() 的作用是更新指针指向，创建对应的弱引用表。
     
     3、释放时，调用clearDeallocating函数。clearDeallocating函数首先根据对象地址获取所有weak指针地址的数组，然后遍历这个数组把其中的数据设为nil，最后把这个entry从weak表中删除，最后清理对象的记录。
     
     下面将开始详细介绍每一步：
     
     1、初始化时：runtime会调用objc_initWeak函数，objc_initWeak函数会初始化一个新的weak指针指向对象的地址。
     
     示例代码：
     {
     NSObject *obj = [[NSObject alloc] init];
     id __weak obj1 = obj;
     }
     当我们初始化一个weak变量时，runtime会调用 NSObject.mm 中的objc_initWeak函数。这个函数在Clang中的声明如下：
     
     1
     id objc_initWeak(id *object, id value);
     而对于 objc_initWeak() 方法的实现
     id objc_initWeak(id *location, id newObj) {
     // 查看对象实例是否有效
     // 无效对象直接导致指针释放
     if (!newObj) {
     *location = nil;
     return nil;
     }
     // 这里传递了三个 bool 数值
     // 使用 template 进行常量参数传递是为了优化性能
     return storeWeakfalse// old/, true/new/, true crash>
    (location, (objc_object*)newObj);
    }
    可以看出，这个函数仅仅是一个深层函数的调用入口，而一般的入口函数中，都会做一些简单的判断（例如 objc_msgSend 中的缓存判断），这里判断了其指针指向的类对象是否有效，无效直接释放，不再往深层调用函数。否则，object将被注册为一个指向value的__weak对象。而这事应该是objc_storeWeak函数干的。

    注意：objc_initWeak函数有一个前提条件：就是object必须是一个没有被注册为__weak对象的有效指针。而value则可以是null，或者指向一个有效的对象。
 
 
    // 13. 苹果开发者总数的区别：
 苹果对开发者主要分为3类：个人、组织（公司、企业）、教育机构。
    即：1、个人（Individual）
    2、组织（Organizations）  
        组织类又分为2个小类：
        （1）公司（Company）（2）企业（Enterprise）3、教育机构（Educational Institutions）
    我们经常最关注的是个人、公司、企业这3类，公司和企业都属于“组织”大类，下面对这3个做下简单对比：
        1、个人（Individual）：
        （1）费用：99美元一年
        （2）App Store上架：是
        （3）最大uuid支持数：100
        （4）协作人数：1人（开发者自己）  说明：“个人”开发者可以申请升级“公司”，可以通过拨打苹果公司客服电话（400 6701 855）来咨询和办理。
        2、公司（Company）：
        （1）费用：99美元一年
        （2）App Store上架：是
        （3）最大uuid支持数：100（4）协作人数：多人       允许多个开发者进行协作开发，比个人多一些帐号管理的设置，可设置多个Apple ID，分4种管理级别的权限。说明：申请时需要填写公司的邓白氏编码（DUNS Number）。
        3、企业 （Enterprise）
        （1）费用：299美元一年
        （2）App Store上架：否         即该账号开发应用不能发布到App Store，只能企业内部应用。
        （3）最大uuid支持数：不限制
        （4）协作人数：多人。费用：299美元一年说明：需要注意的是，企业账号开发的应用不能上线App Store，适合那些不希望公开发布应用的企业。同样，申请时也需要公司的邓白氏编码（DUNS Number）。
 
 
  13.1  开发者账号共享： 
 
 
 // 14.
     我们团队之前用的是Umeng，现在已经逐步切换到Bugly。
     
     我们切换的主要原因是：
     界面UI较Umeng舒服很多；
     统计Crash信息更加多维度，更加符合我们实际需要（Umeng的太单一）；
     能够检测到ANR问题 （Umeng做不到）；
     支持Crash日报以及Crash警报提醒功能（Umeng不支持）；
     一些问题：查看运营数据中的留存总要loading很久，望改进。
    互及细节上的确还有许多地方值得优化，依然希望Bugly团队能把移动端crash这块做精做强，
 // 15.  数据持久化：
    1. plist只能用数组(NSArray)或者字典(NSDictionary)进行读取，由于属性列表本身不加密，所以安全性几乎可以说为零。因为，属性列表正常用于存储少量的并且不重要的数据。
 
    2. NSUserDefaults的单例对象，我们可以获取这个单例来存储少量的数据，它会将输出存储在.plist格式的文件中。其优点是像字典一样的赋值方式方便简单，但缺点是无法存储自定义的数据
    3. 对象归档：NSKeyArchive  轻量级存储的持久化方案，数据归档是进行加密处理的，数据在经过归档处理会转换成二进制数据，所以安全性要远远高于属性列表。另外使用归档方式，我们可以将复杂的对象写入文件中，并且不管添加多少对象，将对象写入磁盘的方式都是一样的
 
 
 16. runtime ：  关于数组越界目前大概有两种方式，一种是通过分类添加安全的索引方法，第二种就是Runtime实现，第一种如果是个人开发比较建议，如果是团队开发很难得到保证和推动，关于Runtime处理数组越界网上有人说是在iOS7及以上有软键盘输入的地方按Home键退出，会出现崩溃，测试过两台手机iOS8.1和iOS9.3暂时没有出现问题，如果之后出现问题会更新文章。
    
 Runtime解决数据越界及字典key或value为nil的情况，主要通过Runtime的方法交换实现
 
 
 17. 因为try catch无法捕获UncaughtException，而oc中大部分crash如：内存溢出、野指针等都是无法捕获的，而能捕获的只是像数组越界之类（这真心需要catch么？），所以try catch对于oc来说，比较鸡肋。
 
 18.  苹果禁止热更新，可能设计到的第三方框架\SDK有： JSPatch、weex、个推（第三方推送）、友盟、RN(react native)等。RN好像可以使用
 
 
 
 
 
 */



