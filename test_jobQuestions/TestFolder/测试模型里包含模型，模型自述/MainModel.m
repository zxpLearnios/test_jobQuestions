
#import "MainModel.h"

@implementation MainModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"idno" :@"id",
             @"name" :@"name",
             @"city" :@"city",
             };
    
}


+(instancetype)initWithJsonDic:(id)dic{
    MainModel *model = [MainModel mj_objectWithKeyValues:dic];
    return model;
}
@end

@implementation CityModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"idno" :@"id",
             @"name" :@"name",
             };
    
}

+(instancetype)initWithJsonDic:(id)dic{
    CityModel *model = [CityModel mj_objectWithKeyValues:dic];
    return model;
}

@end
