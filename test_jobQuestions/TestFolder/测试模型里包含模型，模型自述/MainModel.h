
#import <Foundation/Foundation.h>
#import "BaseModel.h"

@class CityModel;

@interface MainModel : BaseModel
@property (nonatomic, strong) CityModel *city;
@property (nonatomic, assign) int idno;
@property (nonatomic, copy) NSString *name;

@end

@interface CityModel : BaseModel
@property (nonatomic, assign) int idno;
@property (nonatomic, copy) NSString *name;

@end
