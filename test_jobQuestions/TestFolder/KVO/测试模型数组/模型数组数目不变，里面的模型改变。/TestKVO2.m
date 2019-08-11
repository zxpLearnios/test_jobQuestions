//
//  TestKVO2.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2027/4/29.
//  Copyright © 2027年 Jingnan Zhang. All rights reserved.


#import "TestKVO2.h"
#import "TestKVOCell.h"

@interface TestKVO2 ()
@property (nonatomic, strong) TestViewModel2 *viewModel;

@end

@implementation TestKVO2

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"TestKVOCell" bundle:nil] forCellReuseIdentifier:@"TestKVOCell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更新模型数据" style:UIBarButtonItemStylePlain target:self action:@selector(itemClick:)];
    
    // 初始化
    self.viewModel = [TestViewModel2 initWithViewController:self];
    
    // 添加模型数据
    TestKVOModel2 *model = [[TestKVOModel2 alloc] init];
    model.phone = @"130 1301 3013";
    TestKVOModel2 *model1 = [[TestKVOModel2 alloc] init];
    model1.phone = @"140 1401 4014";
    TestKVOModel2 *model2 = [[TestKVOModel2 alloc] init];
    model2.phone = @"150 1501 5015";
    
    [self.viewModel.models addObject:model];
    [self.viewModel.models addObject:model1];
    [self.viewModel.models addObject:model2];
    
    
    NSLog(@"旧的数组 %@," , self.viewModel.models);
    
}

-(void)itemClick:(UIBarButtonItem *)item{
    
    // 更新模型数组里的数据（某一条数据或全部的数据）
    TestKVOModel2 *model = [[TestKVOModel2 alloc] init];
    model.phone = @"130 1223 5490";
    TestKVOModel2 *model1 = [[TestKVOModel2 alloc] init];
    model1.phone = @"130 1223 5491";
    TestKVOModel2 *model2 = [[TestKVOModel2 alloc] init];
    model2.phone = @"130 1223 5492";
    
    NSMutableArray *models = [self.viewModel mutableArrayValueForKeyPath:@"models"];
    if (models != nil) {
        [models exchangeObjectAtIndex:0 withObjectAtIndex:2];
//        [models replaceObjectAtIndex:0 withObject:model];
    }
    
    NSLog(@"新的数组 %@," , models);
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([object isKindOfClass:[TestViewModel2 class]]) {
        [self.tableView reloadData];
    }
    
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TestKVOCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestKVOCell" forIndexPath:indexPath];
    // 根据控制器获取到的数据，获取的数据赋给viewmodel的models，这里根据viewmodel的models来设置即可
    TestKVOModel2 *ml = self.viewModel.models[indexPath.row];
    cell.nameLab.text = ml.phone;
    
    if (indexPath.row % 2 == 0){
        cell.contentView.backgroundColor = [UIColor grayColor];
    }
    return cell;
}



/**不移除监听可能会crash*/
-(void)dealloc{
    [self.viewModel removeObserver:self forKeyPath:@"models" context:nil];
}

@end






/**23423*/
@implementation TestViewModel2

-(NSMutableArray<TestKVOModel2 *> *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

+(instancetype)initWithViewController:(TestKVO2 *)vc{
    TestViewModel2 *viewModel = [[TestViewModel2 alloc] init];
    
    // 2/ 注册监听
    [viewModel addObserver:vc forKeyPath:@"models" options:NSKeyValueObservingOptionNew context:nil];
    
    return viewModel;
}


@end



/** 下面这个必须写 */
@implementation TestKVOModel2 : NSObject


-(void)doesNotRecognizeSelector:(SEL)aSelector{
    NSLog(@"TestKVOModel未实现%s方法", __func__);
}

@end
