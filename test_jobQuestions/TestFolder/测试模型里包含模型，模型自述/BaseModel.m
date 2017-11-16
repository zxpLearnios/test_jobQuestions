

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel

/**通过runtime重写description方法使模型居右自述能力 */
-(NSString *)debugDescription{
    return [self description];
}

- (NSString *)description{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        id value = [self valueForKey:name]?:@"nil";
        [dictionary setObject:value forKey:name];
    }
    
    free(properties);
    return [NSString stringWithFormat:@"<%@:%p> -- %@", [self class], self, dictionary];
}

@end
