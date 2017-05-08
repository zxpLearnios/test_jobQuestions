//
//  LearnSDWebImage.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/21.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//
/*
 1. 一、SDWebImage架构
 
 先上SDWebImage架构图
 
 
 
 
 注意：SDWebImage最新版本SDWebImageDownloaderOperation类里面网络下载已经改为基于NSUrlSession来实现了，而不是基于NSURLConnection
 
 上面的架构图一目了然的，下面分布来说明整个架构运转的机制
 
 自顶向下调用过程
 
 1、应用程序调用UIImageView (WebCache)类别的各种sd_setImageWithURL版本方法，最终都会调用到自己的方法- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock
 
 2、1中的调用接着路由到SDWebImageManager类实例方法- (id)downloadImageWithURL:(NSURL *)url options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionWithFinishedBlock)completedBlock; 本方法首先会根据传入的url查看内存或者本地磁盘（先查内存再查本地）有没有相对应的图片，如果有并且SDWebImageOptions参数不为SDWebImageRefreshCached，则直接把UIImage返回给上层调用；否则直接进行下面3中的操作
 
 3、SDWebImageDownloader实例方法- (id)downloadImageWithURL:(NSURL *)url options:(SDWebImageDownloaderOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageDownloaderCompletedBlock)completedBlock 调用SDWebImageDownloaderOperation类的initWithRequest方法生成对象operation，并加入到downloadQueue操作队列中
 
 4、SDWebImageDownloaderOperation类是执行真正下载过程的任务类，NSURLConnection执行网络下载动作，该类实现了NSURLConnectionDataDelegate协议(SDWebImage最新版本网络下载已经改为NSUrlSession来实现了)
 
 自底向下回调过程
 1、在收到网络下行数据时，SDWebImageDownloaderOperation类实现的协议方法- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data会得到调用
 
 2、SDWebImageDownloaderOperation通过progressBlock按照顺序从SDWebImageDownloader->SDWebImageManager->UIImageView (WebCache)依次报告下载进度，如果中间没有网络错误，下载完成会通过completedBlock告诉上层；否则也会通过completedBlock告诉上层，错误信息在参数error中
 
 3、下载完成后，调用SDImageCache进行相应的缓存，先缓存到内存中，再缓存到磁盘。SDImageCache支持设置最大缓存大小，最大缓存天数，SDImageCache会在iOS App收到内存警告清理内存缓存，进入后台或者App结束时进行磁盘缓存清理
 
 二、使用SDWebImage遇到的坑
 在使用sd_setImageWithURL下载图片的时候，由于SDWebImage缓存机制使用的url的MD5判断是否有缓存，如果我们使用- (void)sd_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock来下载图片，后台更新了图片，客户端是拿不到这个新的图片的。解决方案有两种：
 
 1、自己后台在更新图片的时候顺便把图片的url也更新一下
 
 2、调用带有SDWebImageOptions参数的方法比如- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options传SDWebImageRefreshCached参数
 
*/

#import "LearnSDWebImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>

@interface LearnSDWebImage ()

@end
@implementation LearnSDWebImage

-(void)doTest{
    
    UIView *container = [[UIView alloc] initWithFrame:kbounds];
    container.backgroundColor = [UIColor whiteColor];
    
    NSArray *urls = @[@"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg"
                      , @"https://c2.staticflickr.com/4/3345/5832660048_55f8b0935b.jpg",
                      @"http://7xk68o.com1.z0.glb.clouddn.com/1.jpg",
                      @"http://7xk68o.com1.z0.glb.clouddn.com/2.jpg"
                      ,@"http://7xk68o.com1.z0.glb.clouddn.com/3.jpg",
                      @"http://7xk68o.com1.z0.glb.clouddn.com/4.jpg"
                      ];
    
    UIImage *placeholderImg = [UIImage imageNamed:@"2"];
    
    for (int i = 0; i < urls.count; i++) {
        
        CGFloat width = 100;
        CGFloat x = i%3 * width + 5;
        CGFloat y = i/3 * width + 15;
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, width)];
        
        NSURL *url = [NSURL URLWithString:urls[i]];
        
        [container addSubview:imgV];
        
        // 添加默认进度
//        [imgV sd_setShowActivityIndicatorView:YES];
//        [imgV sd_setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [imgV sd_setImageWithURL:url placeholderImage:placeholderImg options:SDWebImageCacheMemoryOnly];
    }
    
    
    [kwindow addSubview:container];
    
}

@end

