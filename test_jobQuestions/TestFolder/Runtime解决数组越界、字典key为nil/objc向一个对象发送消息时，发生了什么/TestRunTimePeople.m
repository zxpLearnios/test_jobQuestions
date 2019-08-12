//
//  People.m
//  MessageForwarding
//
//  Created by Destiny on 2018/8/17.
//  Copyright © 2018年 Destiny. All rights reserved.
//

#import "TestRunTimePeople.h"
#import <objc/runtime.h>
#import "TestRunTimeMsgForwarding.h"

void speak(id self, SEL _cmd){
    NSLog(@"Now I can speak.");
}

@implementation TestRunTimePeople

id ForwardingTarget_dynamicMethod(id self, SEL _cmd) {
    NSLog(@"没有找到方法:%@",NSStringFromSelector(_cmd));
    return [NSNull null];
}

// 1.
+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    class_addMethod(self.class, sel, (IMP)ForwardingTarget_dynamicMethod, "@@:");
//    [super resolveInstanceMethod:sel];
    return NO; // NO: 即不去处理这个被外部调用的方法，则此时会走方法传递
}

/// 2. 不写也可以，仍然会去调methodSignatureForSelector -> forwardInvocation; 此法若自己重写的话，则一定会被调用的，不论resolveInstanceMethod返回yes或no，做一一般不写此法而有了1即可
- (id)forwardingTargetForSelector:(SEL)aSelector {
//
////    NSString *selStr = NSStringFromSelector(aSelector);
////
////    if ([selStr isEqualToString:@"speak"]) {
////         // 这里返回MsgForwarding类对象，让MsgForwarding类去处理speak消息
////        return [[MsgForwarding alloc] init];
////    }
////
    return nil; //[super forwardingTargetForSelector: aSelector]; // nil,   此句则会去调methodSignatureForSelector -> forwardInvocation
}


/// 3.方法签名, 若调了一个本类未实现的方法，则系统会去调methodSignatureForSelector，若无实现此法，则直接crash，unrocenize selector,,,,；若实现了此法，则立马触发， 此法总是会再去调用forwardInvocation
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {

    if (aSelector == @selector(speak)) {
        return [NSMethodSignature signatureWithObjCTypes:"V@:@"];
    }
    return [super methodSignatureForSelector:aSelector];
}

/// 4 只有当外部调用了本类未实现的方法时才会最终触发此法
- (void)forwardInvocation:(NSInvocation *)anInvocation {
  
    SEL selector = [anInvocation selector];
    // 新建需要转发消息的对象, 可以是多个对象
    TestRunTimeMsgForwarding *msgForwarding = [[TestRunTimeMsgForwarding alloc] init];
//    OtherClass *obj = [[OtherClass alloc] init];
    if ([msgForwarding respondsToSelector:selector]) {
        // 唤醒这个方法
        [anInvocation invokeWithTarget:msgForwarding];
    }
//    if ([obj respondsToSelector:selector]) {
//        // 唤醒这个方法
//        [anInvocation invokeWithTarget:obj];
//    }
}

// 5.
- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"doesNotRecognizeSelector: %@", NSStringFromSelector(aSelector));
    [super doesNotRecognizeSelector:aSelector];
}

@end
