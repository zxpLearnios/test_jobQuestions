//
//  TestMemoryDiskCache.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/5/8.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//
/*
 内存缓存 常见第三方
 通常一个缓存是由内存缓存和磁盘缓存组成，内存缓存提供容量小但高速的存取功能，磁盘缓存提供大容量但低速的持久化存储。相对于磁盘缓存来说，内存缓存的设计要更简单些，下面是我调查的一些常见的内存缓存。
 
 NSCache 是苹果提供的一个简单的内存缓存，它有着和 NSDictionary 类似的 API，不同点是它是线程安全的，并且不会 retain key。我在测试时发现了它的几个特点：NSCache 底层并没有用 NSDictionary 等已有的类，而是直接调用了 libcache.dylib，其中线程安全是由 pthread_mutex 完成的。另外，它的性能和 key 的相似度有关，如果有大量相似的 key (比如 "1", "2", "3", ...)，NSCache 的存取性能会下降得非常厉害，大量的时间被消耗在 CFStringEqual() 上，不知这是不是 NSCache 本身设计的缺陷。
 
 TMMemoryCache 是 TMCache 的内存缓存实现，最初由 Tumblr 开发，但现在已经不再维护了。TMMemoryCache 实现有很多 NSCache 并没有提供的功能，比如数量限制、总容量限制、存活时间限制、内存警告或应用退到后台时清空缓存等。TMMemoryCache 在设计时，主要目标是线程安全，它把所有读写操作都放到了同一个 concurrent queue 中，然后用 dispatch_barrier_async 来保证任务能顺序执行。它错误的用了大量异步 block 回调来实现存取功能，以至于产生了很大的性能和死锁问题。
 
 PINMemoryCache 是 Tumblr 宣布不在维护 TMCache 后，由 Pinterest 维护和改进的一个内存缓存。它的功能和接口基本和 TMMemoryCache 一样，但修复了性能和死锁的问题。它同样也用 dispatch_semaphore 来保证线程安全，但去掉了dispatch_barrier_async，避免了线程切换带来的巨大开销，也避免了可能的死锁。
 
 YYMemoryCache 是我开发的一个内存缓存，相对于 PINMemoryCache 来说，我去掉了异步访问的接口，尽量优化了同步访问的性能，用 OSSpinLock 来保证线程安全。另外，缓存内部用双向链表和 NSDictionary 实现了 LRU 淘汰算法，相对于上面几个算是一点进步吧。
 
 
 1、 PINCache： 所存储的对象必须遵循了NSCoding协议
 2.  【在iOS 的数据存储类中，NSCache 和 NSDictionary 类很像，都是通过key值寻找其对应的值。不同的是，在内存不足时，NSCache 会自动释放。
     在很多的app中，要求数据缓存，或者是图片进行缓存，如果直接在沙盒文件当中读取，会出现app前端出现卡顿的现象。
     所以，可以利用NSCache和文件结合的方式，先将文件当中的数据读取到NSCache类当中，前台加载时可以读取NSCache类，如果NSCache 中没有相应的数据，则再从文件当中读取。
     
     功能：
     1、在没有进行网络连接或者是在没有网络数据获取时，首先加载app中存储的数据和图片。
     2、缓存数据的存储为：获取数据——>存放到NSCache——>写入到文件当中 ，为了不阻碍主线程的运行，文件存储在子线程当中
     3、缓存数据的读取为：判断NSCache 中是否有缓存数据——>（若没有缓存数据）读取文件当中的数据
 】

 
 
 */

#import "TestMemoryDiskCache.h"
#import "PINCache.h"

@interface TestMemoryDiskCache () <NSCacheDelegate>
@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) NSString *key;
/**内存缓存：NSCache是线程安全的，在多线程操作中，不需要对NSCache加锁*/
@property (nonatomic, strong) NSCache *cache;

@end
@implementation TestMemoryDiskCache

-(void)viewDidLoad{
    [super viewDidLoad];
    
    _key = @"save_key";
    _cache = [[NSCache alloc] init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(30, 100, 250, 300)];
    _imgV.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_imgV];
    
    // 因为每次通过xcode在模拟器上运行同一个app时，app在内存里的位置是不一样的，故无法获取到上次存储到内存里的值。在真机上，是完全ok的，因为真机上不会再次运行。
//    [_cache setObject:@"------------" forKey:@"saveStr_key"];
    
    
    
    [self doTest];
}


-(void)doTest{
    
    // 0.
//    NSString *str = (NSString *)[_cache objectForKey:@"saveStr_key"];
    
    UIImage *img = [UIImage imageNamed:@"0"];
    // 1. 存储方式1--PINCache：会同时在内存和磁盘里各存一份。clean后（运行在模拟器上时）仍可以获取，删除应用后，所存储的信息会被删除。
//    [[PINCache sharedCache] setObject:img forKey:_key block:nil];
    
    // 2. 存储方式2--PINMemoryCache（内存存储）：因为每次通过xcode在模拟器上运行同一个app时，app在内存里的位置是不一样的，故无法获取到上次存储到内存里的值。在真机上，是完全ok的，因为真机上不会再次运行。
//        [[PINMemoryCache sharedCache] setObject:img forKey:_key block:nil];
    
    // 3. 存储方式3--PINDiskCache（磁盘存储）：删除应用，若为真机则原存储的信息会全部删除；若为模拟器，要想使再次安装同一个应用后无法获取原先存储的信息，最好再clean一下。
//        [[PINDiskCache sharedCache] setObject:img forKey:_key block:nil];
    
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // block不是主线程，故须切换至主线程刷新UI
    
    __block __weak typeof(_imgV) wImgV = _imgV;
    
    // PINCache存储时，必须用PINCache来获取所存储的对象
//    [[PINCache sharedCache] objectForKey:_key block:^(PINCache * _Nonnull cache, NSString * _Nonnull key, id  _Nullable object) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIImage *img = (UIImage *)object;
//            if (img) {
//                wImgV.image = img;
//            }
//        });
//    }];
    
    // PINMemoryCache存储，必须用PINMemoryCache来获取所存储的对象
    [[PINMemoryCache sharedCache] objectForKey:_key block:^(PINMemoryCache * _Nonnull cache, NSString * _Nonnull key, id  _Nullable object) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *img = (UIImage *)object;
            if (img) {
                wImgV.image = img;
            }
        });
    }];
    
    // PINDiskCache存储，必须用PINDiskCache来获取所存储的对象
//    [[PINDiskCache sharedCache] objectForKey:_key block:^(PINDiskCache * _Nonnull cache, NSString * _Nonnull key, id<NSCoding>  _Nullable object, NSURL * _Nullable fileURL) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIImage *img = (UIImage *)object;
//            if (img) {
//                wImgV.image = img;
//            }
//        });
//    }];
    
}

#pragma mark - NSCacheDelegate 当开启回收过程的时候回调用(用于测试的时候用-----开发中不能用)
-(void)cache:(NSCache *)cache willEvictObject:(id)obj{
    
}

@end
