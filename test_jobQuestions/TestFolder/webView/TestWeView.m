//
//  TestWeView.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/9/4.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  信息介绍：http://www.jianshu.com/p/6ba2507445e4

#import "TestWeView.h"

@interface TestWeView () <WKNavigationDelegate >

@end

@implementation TestWeView


-(instancetype)init{
    if (!self) {
        self = [super init];
    }
    return self;
}


-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{

}



@end
