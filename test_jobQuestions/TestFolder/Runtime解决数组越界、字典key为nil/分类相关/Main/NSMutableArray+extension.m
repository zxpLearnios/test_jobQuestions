

#import "NSMutableArray+extension.h"
#import <objc/runtime.h>

@implementation NSMutableArray (extension)

//+ (void)load {
//    Method fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:));
//    Method toMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(ex_objectAtIndex:));
//    method_exchangeImplementations(fromMethod, toMethod);
//}
//
// // 为了避免和系统的方法冲突，我一般都会在swizzling方法前面加前缀
//- (id)ex_objectAtIndex:(NSUInteger)index {
//    // 判断下标是否越界，如果越界就进入异常拦截
//    if (self.count-1 < index) {
//        @try {
//            return [self ex_objectAtIndex:index];
//        }
//        @catch (NSException *exception) {
//            // 在崩溃后会打印崩溃信息。
//            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
//            NSLog(@"%@", [exception callStackSymbols]);
//            
//            
//            return nil;
//        }
//        @finally {
//        }
//    } // 如果没有问题，则正常进行方法调用
//    else {
//        return [self ex_objectAtIndex:index];
//    }
//}



@end
