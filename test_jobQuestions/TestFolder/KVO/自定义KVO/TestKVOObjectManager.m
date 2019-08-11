//
//  TestKVOObjectManager.m
//  test_jobQuestions
//
//  Created by 张净南 on 2018/9/21.
//  Copyright © 2018年 Jingnan Zhang. All rights reserved.
//

#import "TestKVOObjectManager.h"
#import "NSObject+category.h"
#import "TestCustomeKvoObject.h"

static TestKVOObjectManager *tm = nil;
static NSString *kvoProperty = @"ivaName";
//static CustomKVOObject *_kvoObj;
@interface TestKVOObjectManager()
//@property (class, nonatomic, strong) CustomKVOObject *kvoObj;
@property (nonatomic, strong) TestCustomeKvoObject *kvoObj;
@end

@implementation TestKVOObjectManager

+(instancetype)shared {
    if (tm == nil) {
        tm = [[TestKVOObjectManager alloc] init];
    }
    return tm;
}

//+(void)setKvoObj:(CustomKVOObject *)kvoObj {
//    _kvoObj = kvoObj;
//}
//
//+(CustomKVOObject *)kvoObj {
//    return _kvoObj;
//}


-(TestCustomeKvoObject *)kvoObj {
    if (!_kvoObj) {
        _kvoObj = [[TestCustomeKvoObject alloc] init];
    }
    return _kvoObj;
}

-(void)doTest {
    
    [self.kvoObj ns_addObserverForKey: @"kvoName" block:^(NSDictionary *valueInfo) {
        NSLog(@"收到kvo监听了");
    }];
    
//    [self.kvoObj addObserver:self forKeyPath:kvoProperty options:NSKeyValueObservingOptionNew context:nil];
    
//    [self.kvoObj ns_addObserver:self forKeyPath:kvoProperty options: (NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld) context:nil];
//    [self.kvoObj addObserver:self forKeyPath:kvoProperty options: (NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld) context:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.kvoObj.kvoName = @"则通过呼吸";
        [self.kvoObj setValue:@"qw35t5ff" forKey: kvoProperty];
    });
}

+(void)doClassTest {
//    [self.kvoObj addObserver:self forKeyPath:kvoProperty options: (NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld) context:nil];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.kvoObj.kvoName = @"则通过呼吸";
//    });
}


//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//
//    if ([keyPath isEqual: kvoProperty]) {
//        NSLog(@"自定义kvo实现了对%@的监听", keyPath);
//    }
//
//}

- (void)dealloc
{
    NSLog(@"TestKVOObjectManager dealloc");
}

@end
