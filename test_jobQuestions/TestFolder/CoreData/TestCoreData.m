//
//  TestCoreData.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/12.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
/*  目前的问题：1. NSPredicate 如果查询了一个不存在的字段（比如表中有 name 字段，查的 name1）会崩溃，插入和修改不存在的也会崩溃。
    2.而且再插入之前判断表中是否存在重复数据时也遇到问题.
    3.使用了多个线程操作同一个 NSManagedObjectContext对象最好是每个线程用一个NSManagedObjectContext对象 、
    4. NSManagedStoreCoordinator 有缓存数据，需要重新填充 [managedObjectContext setStalenessInterval:0.0]; //强制性从磁盘装载
    5.NSManagedObjectContext 合并政策失败的核心数据是无法完成合并 [managedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];//设置上下文对象合并

*/

#import "TestCoreData.h"
#import <CoreData/CoreData.h>
//#import "PartModel.h"
//#import "PersonModel.h"
#import "Part+CoreDataClass.h"
//#import "Part+CoreDataProperties.h"

#import "Person+CoreDataClass.h"




@interface TestCoreData ()
@property (nonatomic, strong) NSManagedObjectContext *context;
@end

@implementation TestCoreData

-(void)viewDidLoad{
    [super viewDidLoad];
    
}


-(NSManagedObjectContext *)context{
    if (!_context) {
        // 上下文
        _context = [[NSManagedObjectContext alloc] init];
//        [_context setStalenessInterval:0.0]; // 从磁盘重载(可能不支持所有持久化存储类型)
        // 上下文关连数据库  关联的时候，如果本地没有数据库文件，Ｃoreadata自己会创建
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"CoreDataModel" withExtension:@"momd"];
         // //model模型文件 使用下面这个方法,是把一个模型文件对应一个数据库
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
        
//        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        // 持久化存储调度器 把模型链接到本地数据库
        // 持久化，把数据保存到一个文件，而不是内存
        NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        // 告诉Coredata数据库的名字和路径
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
        NSString *sqlitePath = [doc stringByAppendingPathComponent:@"part.sqlite"];
        
        [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:nil];

        _context.persistentStoreCoordinator = store;

    }
    return _context;
}


- (IBAction)addAction:(id)sender {
    [self addPartEntity];
}

- (IBAction)searchAction:(id)sender {
    [self searchPartEntity];
}

- (IBAction)deleteAction:(id)sender {
    [self deletePartEntity];
}


/**
 * 添加
 */
-(void)addPartEntity{

    NSEntityDescription *partDes =  [NSEntityDescription entityForName:@"Part" inManagedObjectContext:self.context];
    NSEntityDescription *personDes =  [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.context];
    
    // 人实体
    Person *personZ = [[Person alloc] initWithEntity:personDes insertIntoManagedObjectContext:self.context];
    Person *personL = [[Person alloc] initWithEntity:personDes insertIntoManagedObjectContext:self.context];
    Person *personW = [[Person alloc] initWithEntity:personDes insertIntoManagedObjectContext:self.context];
    
    // 部门实体
    Part *mainPart = [[Part alloc] initWithEntity:partDes insertIntoManagedObjectContext:self.context];
    Part *lifePart = [[Part alloc] initWithEntity:partDes insertIntoManagedObjectContext:self.context];
    
    // 设置部门与人
    personZ.name = @"张三";
    personZ.age = 17;
    personZ.part = mainPart;
    
    personZ.name = @"李四";
    personZ.age = 17;
    personZ.part = lifePart;
    
    personZ.name = @"王五";
    personZ.age = 20;
    personZ.part = mainPart;
    
    
    mainPart.partId = @"001";
    mainPart.creatDate = [self getDateFromString:@"2011-11"];
    mainPart.partName = @"机要部门";
    mainPart.personAry = [NSSet setWithArray:@[personZ, personW]];
    
    
    mainPart.partId = @"002";
    lifePart.creatDate = [self getDateFromString:@"2010-11"];
    lifePart.partName = @"生活部门";
    lifePart.personAry = [NSSet setWithArray:@[personL]];
    
    
    // 保存
    NSError *saveError;
    
    NSString *idx = @"001";
    // 在表里无任何数据时，使用此句会直接crash
//    if ([self.context existingObjectWithID:idx error:nil]) { // 若已存在此条数据
//        [self.context repl]
//    }
    
    // 插入
//    [self.context insertObject:<#(nonnull NSManagedObject *)#>]
    BOOL isSuccess = [self.context save:&saveError];
    
    if (!isSuccess) {
        [NSException raise:@"访问数据库错误！" format:@"%@", [saveError localizedDescription]];
        NSLog(@"%@", saveError);
    }
    
}

/**
 * 搜索  （模糊查询）
 */
-(void)searchPartEntity{
    
    // 获取请求对象
    NSFetchRequest *fr = [Part fetchRequest];
    // 过滤条件  1.BEGINSWITH：以**开始， 2.ENDSWITH：以**结束   3.CONTAINS   4. partName = %@  5. age <= 20
    fr.predicate = [NSPredicate predicateWithFormat:@"partName CONTAINS %@", @"部门"];
    
    // 每页最多6条
//    fr.fetchLimit = 6;
//    // 分页的起始索引
//    fr.fetchOffset = 12;
    
    
    // 部门排序 按创建日期升序，可知coredata内部很强大
    NSSortDescriptor *dortDes = [NSSortDescriptor sortDescriptorWithKey:@"creatDate" ascending:YES];
    fr.sortDescriptors = @[dortDes];
    
    // 获取结集
    NSError *fetchError;
    NSArray *results = [self.context executeFetchRequest:fr error:&fetchError];
    
    
    for (Part *part in results) {
        NSLog(@"%@ %@", part.partName, [self getDateStrFromDate:part.creatDate]);
    }
    
    if (fetchError) {
        NSLog(@"获取Part失败！--%@", fetchError);
    }
}

/**
 * 删除
 */
-(void)deletePartEntity{
    // 获取请求对象
    NSFetchRequest *request = [Part fetchRequest];
    
    // 过滤条件
//    request.predicate = [NSPredicate predicateWithFormat:@"partName = %@", @"机要部门"];
    
    // 执行请求
    NSArray *parts = [_context executeFetchRequest:request error:nil];
    
    // 删除
    for (Part *pt in parts) {
        [_context deleteObject:pt];
    }
    
    // 保存
    NSError *saveError;
    BOOL isSuccess = [_context save:&saveError];
    if (!isSuccess) {
        NSLog(@"删除失败--%@", saveError);
    }

    
}



// 获取日期
// MM将月份显示为带前导零的数字（例如 01/12/01）
// yyyy 以四位数字格式显示年份
-(NSString *)getDateStrFromDate:(NSDate *)date{
    @autoreleasepool {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyy-MM";
        NSString *dateStr = [df stringFromDate:date];
        return dateStr;
    }
}

-(NSDate *)getDateFromString:(NSString *)dateStr{
    @autoreleasepool {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyy-MM";
        NSDate *date = [df dateFromString:dateStr];
        return date;
    }
    
}


@end


