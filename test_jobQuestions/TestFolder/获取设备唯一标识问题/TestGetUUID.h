//
//  TestGetUUID.h
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/5/3.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TestGetUUID : NSObject

@end


/*
 1. 、OpenUDID
 在iOS 5发布时，uniqueIdentifier被弃用了，这引起了广大开发者需要寻找一个可以替代UDID，并且不受苹果控制的方案。由此OpenUDID成为了当时使用最广泛的开源UDID替代方案。OpenUDID在工程中实现起来非常简单，并且还支持一系列的广告提供商。
 NSString *openUDID = [OpenUDID value];
 
 OpenUDID利用了一个非常巧妙的方法在不同程序间存储标示符 — 在粘贴板中用了一个特殊的名称来存储标示符。通过这种方法，别的程序（同样使用了OpenUDID）知道去什么地方获取已经生成的标示符（而不用再生成一个新的）。是不是感觉这个就是你想要的，但是，UIPasteboard由共享变为沙盒化了，只对相同的app group可见。所以现在OpenUDID基本只能保证同一个APP的openUDID一样了
 
 
 */
