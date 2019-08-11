//
//  TesrKVOVC.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/19.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

//  在 MVC 设计架构下的项目，KVO机制很适合实现mode模型和view视图之间的通讯。

#import "TestKVO1.h"
#import "TestKVOCell.h"

@interface TestKVO1 ()
@property (nonatomic, strong) TestViewModel1 *viewModel;

@end

@implementation TestKVO1

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"TestKVOCell" bundle:nil] forCellReuseIdentifier:@"TestKVOCell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加模型数据" style:UIBarButtonItemStylePlain target:self action:@selector(itemClick:)];
    
    // 初始化
    self.viewModel = [TestViewModel1 initWithViewController:self];
    

}

-(void)itemClick:(UIBarButtonItem *)item{
    
    NSString *dateStr = [NSString stringWithFormat:@"%d",arc4random()%100];
    
    TestKVOModel1 *model = [[TestKVOModel1 alloc] init];
    model.phone = dateStr;
    // 这样做，不能被KVO观察到
//    [self.viewModel.models addObject:model];
    // 这样可以被观察到  ,这里用ValueForKeyPath 是获取不到属性的
    [[self.viewModel mutableArrayValueForKeyPath:@"models"] addObject:model];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([object isKindOfClass:[TestViewModel1 class]]) {
        [self.tableView reloadData];
    }
    
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.models.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TestKVOCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestKVOCell" forIndexPath:indexPath];
    // 根据控制器获取到的数据，获取的数据赋给viewmodel的models，这里根据viewmodel的models来设置即可
    TestKVOModel1 *ml = self.viewModel.models[indexPath.row];
    cell.nameLab.text = ml.phone;
    return cell;
}



/**不移除监听可能会crash*/
-(void)dealloc{
    [self.viewModel removeObserver:self forKeyPath:@"models" context:nil];
}

@end






/**23423*/
@implementation TestViewModel1

-(NSMutableArray<TestKVOModel1 *> *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

+(instancetype)initWithViewController:(TestKVO1 *)vc{
    TestViewModel1 *viewModel = [[TestViewModel1 alloc] init];
    
    // 2/ 注册监听
    [viewModel addObserver:vc forKeyPath:@"models" options:NSKeyValueObservingOptionNew context:nil];
    
    return viewModel;
}


@end



/** 下面这个必须写 */
@implementation TestKVOModel1 : NSObject


-(void)doesNotRecognizeSelector:(SEL)aSelector{
    NSLog(@"TestKVOModel未实现%s方法", __func__);
}

@end



