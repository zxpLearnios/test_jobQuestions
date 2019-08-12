

#import "NSArray+extension.h"
//#import <objc/runtime.h>

//  分类\类目不要重写原类的方法，否则会导致原类的方法无法调用


/** 
 在iOS中NSNumber、NSArray、NSDictionary等这些类都是类簇，一个NSArray的实现可能由多个类组成。
 所以如果想对NSArray进行Swizzling，必须获取到其“真身”进行Swizzling，直接对NSArray进行操作是无效的。
 
 下面列举了NSArray和NSDictionary本类的类名，可以通过Runtime函数取出本类。
 NSArray                __NSArrayI
 NSMutableArray         __NSArrayM
 NSDictionary           __NSDictionaryI
 NSMutableDictionary	__NSDictionaryM
 */

@implementation NSArray (extension)

// Swizzling核心代码
// 需要注意的是，在下面的load方法中，不应该调用父类的load方法。
//+ (void)load {
//    Method fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
//    Method toMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(ex_objectAtIndex:));
//    method_exchangeImplementations(fromMethod, toMethod);
//}
//
//// 为了避免和系统的方法冲突，我一般都会在swizzling方法前面加前缀
//- (id)ex_objectAtIndex:(NSUInteger)index {
//    
//    if (self.count-1 < index) { // 判断下标是否越界，如果越界就进入异常拦截
//        @try {
//            return [self ex_objectAtIndex:index];
//        }
//        
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
//    }else { // 如果没有问题，则正常进行方法调用
//        return [self ex_objectAtIndex:index];
//    }
//}


//---------------------- 分类重写原类方法  ------------------
/// 外部使用[ary contains: obj] 时，这个方法会触发11次之多，天哪
-(BOOL)containsObject:(id)anObject {
    MyLog(@"打印了NSArray+extension的containsObject");
    return NO;
}

@end














