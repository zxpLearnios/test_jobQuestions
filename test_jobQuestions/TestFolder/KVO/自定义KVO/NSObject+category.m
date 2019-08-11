//
//  NSObject+category.m
//  test_jobQuestions
//
//  Created by 张净南 on 2018/9/21.
//  Copyright © 2018年 Jingnan Zhang. All rights reserved.
//

#import "NSObject+category.h"
#import <objc/runtime.h>
#import <objc/message.h>


@interface PrivateKVOAssistClass: NSObject
/// 存放监听key值的数组
@property(nonatomic,strong)NSMutableArray *observerKeyArray;
@end
@implementation PrivateKVOAssistClass

- (instancetype)init
{
    if (self = [super init]) {
        self.observerKeyArray = [NSMutableArray array];
    }
    return self;
}

@end


/// 定义一个带一个参数类型的IMP指针,用来记录setter方法. 至少为2个参数， self, _cmd
typedef void (*KVOSetterIMP)(id,SEL,...);
/// 子类的前缀
static NSString *const childClassPrefix = @"NSKvoObserverChild_";
/// 存辅助类的key值
static char *kvoAssistInstancekey = "NSKvoAssistInstance";

@implementation NSObject (category)

// MARK: 生成set方法
static NSString *setterForGetter(NSString *getter){
    if (getter.length <= 0) {
        return nil;
    }
    
    NSString *firstLetter = [[getter substringToIndex:1] uppercaseString];
    NSString *remainingLetters = [getter substringFromIndex:1];
    NSString *setter = [NSString stringWithFormat:@"set%@%@:",firstLetter,remainingLetters];
    return setter;
    
}


- (void)ns_addObserverForKey:(NSString *)key block:(void (^)(NSDictionary *valueInfo))valueChangedBlock
{
    // 获取setter方法名
    NSString *selectorName = [NSString stringWithFormat:@"set%@:",key.capitalizedString];
    // 这2句不行，监听不了某些写法的属性
//    SEL setterSelector = NSSelectorFromString(selectorName);
//
//    // 记录被监听者的setter方法的IMP指针
//    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    
    
    SEL setterSelector = NSSelectorFromString(setterForGetter(key));
    // 看self或super是否有此方法
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    
    // 若此key不存在则直接返回
    if (!setterMethod) {
        NSLog(@"没有%@的set方法", key);
        return;
    }
    
    // 动态创建一个类,继承自调用者的类
    // 子类的类名
    NSString *childClassName = NSStringFromClass([self class]);
    if (![childClassName hasPrefix:childClassPrefix])
    {
        childClassName = [NSString stringWithFormat:@"%@%@",childClassPrefix,NSStringFromClass([self class])];
    } else {
        setterMethod = class_getInstanceMethod(class_getSuperclass([self class]),setterSelector);
    }
    
    //获取被监听属性的数据类型
    NSString *methodType = [NSString stringWithUTF8String:method_getTypeEncoding(setterMethod)];
    //NSLog(@"%@",methodType);//v20@0:8i16 //
    methodType = [methodType componentsSeparatedByString:@"@0:8"].lastObject;
    
    NSString *valueType = [methodType substringToIndex:methodType.length - 2];
    // 判断需要创建的中间类是否存在
    Class kvoChildClass = objc_getClass(childClassName.UTF8String);
    if (!kvoChildClass) {
        // 创建类
        kvoChildClass = objc_allocateClassPair([self class], childClassName.UTF8String, 0);
        // 向系统注册此类
        objc_registerClassPair(kvoChildClass);
    }
    // 使当前类的isa指针指向新创建的类
    object_setClass(self, kvoChildClass);
    // 利用私有辅助类来存储key值，此类为self的在runtime时加的一个属性
    PrivateKVOAssistClass *kvoAssistInstance = objc_getAssociatedObject(self, kvoAssistInstancekey);
    if (!kvoAssistInstance) {
        kvoAssistInstance = [[PrivateKVOAssistClass alloc]init];
        // 为self新加属性KVOAssistInstance，可以通过key:kvoAssistInstancekey来获取
        objc_setAssociatedObject(self, kvoAssistInstancekey, kvoAssistInstance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [kvoAssistInstance.observerKeyArray addObject:@{valueType:key}];
    
    
    KVOSetterIMP superSetterIMP = (KVOSetterIMP)method_getImplementation(setterMethod);
    // 子类的setter方法
    __weak typeof(self)weakself = self;
    // 根据valueType的映射类型来判断监听参数的类型,并重写子类的setter方法
    IMP childSetValue = nil;
    if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(int)]]) {
        
        childSetValue = imp_implementationWithBlock(^(id _self, int newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值//@"こうさか ほのか"
            (*superSetterIMP)(_self,setterSelector,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, @(newValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":@(newValue)};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
            //            !valueChangedBlock?:1;valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(unsigned int)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,unsigned int newValue) {
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSelector,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, @(newValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":@(newValue)};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(short)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,short newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSelector,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, @(newValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":@(newValue)};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(unsigned short)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,unsigned short newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSelector,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, @(newValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":@(newValue)};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(float)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,float newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSelector,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, @(newValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":@(newValue)};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(float)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,float newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSelector,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, @(newValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":@(newValue)};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(double)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,double newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSelector,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, @(newValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":@(newValue)};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(long)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,long newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSelector,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, @(newValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":@(newValue)};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(unsigned long)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,unsigned long newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSelector,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, @(newValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":@(newValue)};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(char)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,char newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSelector,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, @(newValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":@(newValue)};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(BOOL)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,BOOL newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSelector,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, @(newValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":@(newValue)};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(Boolean)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,Boolean newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSelector,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, @(newValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":@(newValue)};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(CGRect)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,CGRect newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSelector,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, [NSValue valueWithCGRect:newValue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":[NSValue valueWithCGRect:newValue]};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(CGPoint)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,CGPoint newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSelector,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, [NSValue valueWithCGPoint:newValue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":[NSValue valueWithCGPoint:newValue]};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(CGSize)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,CGSize newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSelector,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, [NSValue valueWithCGSize:newValue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":[NSValue valueWithCGSize:newValue]};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(NSRange)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,NSRange newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSelector,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, [NSValue valueWithRange:newValue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":[NSValue valueWithRange:newValue]};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(UIEdgeInsets)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,UIEdgeInsets newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSelector,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, [NSValue valueWithUIEdgeInsets:newValue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":[NSValue valueWithUIEdgeInsets:newValue]};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(CGVector)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,CGVector newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSelector,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, [NSValue valueWithCGVector:newValue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":[NSValue valueWithCGVector:newValue]};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(UIOffset)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,UIOffset newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSelector,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, [NSValue valueWithUIOffset:newValue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":[NSValue valueWithUIOffset:newValue]};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(id)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,id newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSelector,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, newValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            if (!newValue) {
                newValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":newValue};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    //给子类添加setter方法
    class_replaceMethod(kvoChildClass, setterSelector, childSetValue, [NSString stringWithFormat:@"v@:%@",valueType].UTF8String);
}

- (void)ns_removeAllObserver
{
    if (![NSStringFromClass([self class]) hasPrefix:childClassPrefix])return;
    objc_removeAssociatedObjects(self);
    // 将isa指针指向父类
    object_setClass(self, class_getSuperclass([self class]));
}

- (void)ns_removeObserverForKey:(NSString *)key
{
    if (![NSStringFromClass([self class]) hasPrefix:childClassPrefix]) return;
    PrivateKVOAssistClass *KVOAssistInstance = objc_getAssociatedObject(self, kvoAssistInstancekey);
    /**
     *  防止重复移除监听
     */
    if (!KVOAssistInstance.observerKeyArray.count) {
        [self ns_removeAllObserver];
        return;
    }
    // 获取被监听者的类
    Class superClass = class_getSuperclass([self class]);
    // 获取setter方法名
    NSString *selectorName = [NSString stringWithFormat:@"set%@:",key.capitalizedString];
    IMP superSetterIMP = class_getMethodImplementation(superClass, NSSelectorFromString(selectorName));
    //获取被监听key属性的数据类型
    NSString *methodType = [NSString stringWithUTF8String:method_getTypeEncoding(class_getInstanceMethod(superClass, NSSelectorFromString(selectorName)))];
    methodType = [methodType componentsSeparatedByString:@"@0:8"].lastObject;
    NSString *valueType = [methodType substringToIndex:methodType.length - 2];
    
    class_replaceMethod([self class], NSSelectorFromString(selectorName), superSetterIMP, [NSString stringWithFormat:@"v@:%@",valueType].UTF8String);
    [KVOAssistInstance.observerKeyArray removeObject:@{valueType:key}];
    //判断移除后数组是否为空,为空即移除所监听
    if (!KVOAssistInstance.observerKeyArray.count) {
        [self ns_removeAllObserver];
        return;
    }
}
@end

