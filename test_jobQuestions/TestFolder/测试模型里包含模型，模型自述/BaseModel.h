
#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface BaseModel : NSObject



/**交由子类实现*/
+(instancetype)initWithJsonDic:(id)dic;
@end
