//
//  test11.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/5.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  测试hitTestView2
//  这是测试点击事件是如何一步步寻找到 （响应级别最高的view，最靠近用户手指或最靠近屏幕的view，最应该第一个去响应点击事件的view）第一响应者；而响应者链主要是结束事件如何由第一响应者一步步的进行传递

/**
 1. hit-test view------> 我的理解是：当你点击了屏幕上的某个view，这个动作由硬件层传导到操作系统，然后又从底层封装成一个事件（Event）顺着view的层级往上传导，一直要找到含有这个点击点且层级最高（文档说是最低，我理解是逻辑上最靠近手指）的view来响应事件，这个view就是hit-test view.
 2. 决定谁hit-test view是通过不断递归调用view中的 - (UIView *)hitTest: withEvent: 方法和 -(BOOL)pointInside: withEvent: 方法来实现的
 
 3. 可以用来解决如下问题：扩大UIButton的响应热区、 子view超出了父view的bounds响应事件、 ScrollView page滑动
 
 4. 点击Dview则， 2017-04-05 15:51:16.920 test_jobQuestions[6223:1104098] 进入A_View---hitTest withEvent ---
 2017-04-05 15:51:16.921 test_jobQuestions[6223:1104098] A_view--- pointInside withEvent ---
 2017-04-05 15:51:16.921 test_jobQuestions[6223:1104098] A_view--- pointInside withEvent --- isInside:1
 2017-04-05 15:51:16.921 test_jobQuestions[6223:1104098] 进入C_View---hitTest withEvent ---
 2017-04-05 15:51:16.921 test_jobQuestions[6223:1104098] C_view--- pointInside withEvent ---
 2017-04-05 15:51:16.921 test_jobQuestions[6223:1104098] C_view--- pointInside withEvent --- isInside:1
 2017-04-05 15:51:16.921 test_jobQuestions[6223:1104098] 进入D_View---hitTest withEvent ---
 2017-04-05 15:51:16.921 test_jobQuestions[6223:1104098] D_view--- pointInside withEvent ---
 2017-04-05 15:51:16.921 test_jobQuestions[6223:1104098] D_view--- pointInside withEvent --- isInside:0
 2017-04-05 15:51:16.921 test_jobQuestions[6223:1104098] 离开D_View--- hitTest withEvent ---hitTestView:(null)
 2017-04-05 15:51:16.921 test_jobQuestions[6223:1104098] 进入D_View---hitTest withEvent ---
 2017-04-05 15:51:16.921 test_jobQuestions[6223:1104098] D_view--- pointInside withEvent ---
 2017-04-05 15:51:16.922 test_jobQuestions[6223:1104098] D_view--- pointInside withEvent --- isInside:1
 2017-04-05 15:51:16.922 test_jobQuestions[6223:1104098] 离开D_View--- hitTest withEvent ---hitTestView:<TesthitTestViewD: 0x7fcff4c3c870; frame = (15 21; 230 56); autoresize = RM+BM; layer = <CALayer: 0x7fcff4c19c60>>
 2017-04-05 15:51:16.922 test_jobQuestions[6223:1104098] 离开C_View--- hitTest withEvent ---hitTestView:<TesthitTestViewD: 0x7fcff4c3c870; frame = (15 21; 230 56); autoresize = RM+BM; layer = <CALayer: 0x7fcff4c19c60>>
 2017-04-05 15:51:16.922 test_jobQuestions[6223:1104098] 离开A_View--- hitTest withEvent ---hitTestView:<TesthitTestViewD: 0x7fcff4c3c870; frame = (15 21; 230 56); autoresize = RM+BM; layer = <CALayer: 0x7fcff4c19c60>>
 ----------------      第二次调用    ------------------------
 2017-04-05 15:51:16.923 test_jobQuestions[6223:1104098] 进入A_View---hitTest withEvent ---
 2017-04-05 15:51:16.923 test_jobQuestions[6223:1104098] A_view--- pointInside withEvent ---
 2017-04-05 15:51:16.923 test_jobQuestions[6223:1104098] A_view--- pointInside withEvent --- isInside:1
 2017-04-05 15:51:16.923 test_jobQuestions[6223:1104098] 进入C_View---hitTest withEvent ---
 2017-04-05 15:51:16.923 test_jobQuestions[6223:1104098] C_view--- pointInside withEvent ---
 2017-04-05 15:51:16.923 test_jobQuestions[6223:1104098] C_view--- pointInside withEvent --- isInside:1
 2017-04-05 15:51:16.923 test_jobQuestions[6223:1104098] 进入D_View---hitTest withEvent ---
 2017-04-05 15:51:16.923 test_jobQuestions[6223:1104098] D_view--- pointInside withEvent ---
 2017-04-05 15:51:16.924 test_jobQuestions[6223:1104098] D_view--- pointInside withEvent --- isInside:0
 2017-04-05 15:51:16.924 test_jobQuestions[6223:1104098] 离开D_View--- hitTest withEvent ---hitTestView:(null)
 2017-04-05 15:51:16.924 test_jobQuestions[6223:1104098] 进入D_View---hitTest withEvent ---
 2017-04-05 15:51:16.924 test_jobQuestions[6223:1104098] D_view--- pointInside withEvent ---
 2017-04-05 15:51:16.924 test_jobQuestions[6223:1104098] D_view--- pointInside withEvent --- isInside:1
 2017-04-05 15:51:16.924 test_jobQuestions[6223:1104098] 离开D_View--- hitTest withEvent ---hitTestView:<TesthitTestViewD: 0x7fcff4c3c870; frame = (15 21; 230 56); autoresize = RM+BM; layer = <CALayer: 0x7fcff4c19c60>>
 2017-04-05 15:51:16.924 test_jobQuestions[6223:1104098] 离开C_View--- hitTest withEvent ---hitTestView:<TesthitTestViewD: 0x7fcff4c3c870; frame = (15 21; 230 56); autoresize = RM+BM; layer = <CALayer: 0x7fcff4c19c60>>
 2017-04-05 15:51:16.924 test_jobQuestions[6223:1104098] 离开A_View--- hitTest withEvent ---hitTestView:<TesthitTestViewD: 0x7fcff4c3c870; frame = (15 21; 230 56); autoresize = RM+BM; layer = <CALayer: 0x7fcff4c19c60>>
 
 -------------   最后才是touchesBegan  touchesMove touchesEnd   ------------
 2017-04-05 15:51:16.925 test_jobQuestions[6223:1104098] D_touchesBegan
 2017-04-05 15:51:17.010 test_jobQuestions[6223:1104098] D_touchesEnded
 
 5. 由4知： 一是发现touchesBegan、touchesMoved、touchesEnded这些方法都是发生在找到hit-test view之后，因为touch事件是针对能响应事件的确定的某个view，比如你手指划出了scrollview的范围，只要你不松手继续滑动，scrollview依然会响应滑动事件继续滚动；二是寻找hit-test view的事件链传导了两遍，而且两次的调用堆栈是不同的，这点我有点搞不懂，为啥需要两遍，查阅了很多资料也不知道原因，发现真机和模拟器以及不同的系统版本之间还会有些区别（此为真机iOS9。
 
    那最高层（逻辑最靠近手指的）view是view subviews数组的最后一个元素，只要寻找是从数组的第一个元素开始遍历，hit-test view的逻辑依然是有效的。
    找到hit-test view后，它会有最高的优先权去响应逐级传递上来的Event，如它不能响应就会传递给它的superview，依此类推，一直传递到UIApplication都无响应者，这个Event就会被系统丢弃了。
 
 顺序为：[进入A]-->[A_view--- pointInside withEven] ---> [A_view--- pointInside withEvent ------ isInside:1] --> [C,D 的和A的类比即可] --> [离开D]--> [离开C]--> [离开E]。(因E在D之后添加，故这里不会进入E；若E在D之前添加，则，在应将上述变为[C,E 的和A的类比即可]) --> [离开E] --> [D的和A的类比即可] --> [离开D]--> [离开C]）

5.1 若D的userInterface或enable为NO，则点击事件会交由C去响应，此时C变成了hitTestView了。 若将C的userInterface或enable为NO，则点击事件会遍历A的子viewB和C到C时发现他不可与用户交互，会马上离开C，到B时发现B虽然可与用户交互但B不包含点击点，故会离开B，之后再离开A。
   最重要的：这里A有子viewB和C，C有子viewD和E，B和C的进入顺序以及D和E的进入顺序或有可能是B\C  D\E只进入了一个（此时已经找到HitTestView了），都是根据子view的添加顺序的（净测试，越后添加的子view越是先遍历之即先进入之）。  即使是点击屏幕的其他地方（非此view的区域，此view也会被调用，先进入之后发现它不包含此点，会立即离开，都是循环2遍）,鼠标移入屏幕的任何地方或点击屏幕的任何地方（当然包括移入自己）都会触发此循环
 
 6. 如果HitTestView不能处理该事件，则该事件就会交付给view响应者链的上一级处理，直到系统找到一个能够处理该事件的对象。 例如点击D，且D不可与用户交互，则事件会交由D的上一级C处理。  
 
 7. 响应者链：一系列的响应者对象。 事件会交由第一响应者去响应，若其不响应，则会沿着链向上一级传递。一般第一响应者是一个View对象或其子类对象（如按钮、label、imgV等等），若其不响应，则会沿着链向上一级传递，传给其控制器对象（若存在），然后传给父view（若存在），。。。然后传给window，然后传给application，若过程中有响应，则立马停止传递。响应者链[appDelegate]--[UIApplication]--[UIViewController]--[UIView]--[UIbutton]
 
 8. 在iOS中，能够响应事件的对象都是UIResponder的子类对象。UIResponder提供了四个用户点击的回调方法，分别对应用户点击开始、移动、点击结束以及取消点击，其中只有在程序强制退出或者来电时，取消点击事件才会调用。
 
 9. 假如点击了C，则必须在离开C后，C才会成为hitTestView
 
 */


#import "TestTen.h"

@implementation TesthitTestViewA

+(instancetype)getSelf{
    TesthitTestViewA *view = [[NSBundle mainBundle] loadNibNamed:@"TestTen" owner:nil options:nil].lastObject;
    view.bounds = CGRectMake(0, 0, 260, 371);
    view.center = kcenter;
    return view;
}

/** hit：撞击， 返回被撞击的view即包含用户所点击的点的view，第一个调用,若此view不是hitTestView则返回的UIview为nil */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"进入A_View---hitTest withEvent ---");
    UIView * view = [super hitTest:point withEvent:event];
    NSLog(@"离开A_View--- hitTest withEvent ---hitTestView:%@",view);
    return view;
}

/** 看在自己的响应区域里是否包含用户点击的点，会在hitTest方法调用后调用  第二个调用 */
- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event {
    NSLog(@"A_view--- pointInside withEvent ---");
    BOOL isInside = [super pointInside:point withEvent:event];
    NSLog(@"A_view--- pointInside withEvent --- isInside:%d",isInside);
    return isInside;
}

/**最后才会调用*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"A_touchesBegan");
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    NSLog(@"A_touchesMoved");
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    NSLog(@"A_touchesEnded");
}

@end

@implementation TesthitTestViewB

/** hit：撞击， 返回被撞击的view即包含用户所点击的点的view */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"进入B_View---hitTest withEvent ---");
    UIView * view = [super hitTest:point withEvent:event];
    NSLog(@"离开B_View--- hitTest withEvent ---hitTestView:%@",view);
    return view;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event {
    NSLog(@"B_view--- pointInside withEvent ---");
    BOOL isInside = [super pointInside:point withEvent:event];
    NSLog(@"B_view--- pointInside withEvent --- isInside:%d",isInside);
    return isInside;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"B_touchesBegan");
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    NSLog(@"B_touchesMoved");
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    NSLog(@"B_touchesEnded");
}

@end

@implementation TesthitTestViewC
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"进入C_View---hitTest withEvent ---");
    UIView * view = [super hitTest:point withEvent:event];
    NSLog(@"离开C_View--- hitTest withEvent ---hitTestView:%@",view);
    return view;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event {
    NSLog(@"C_view--- pointInside withEvent ---");
    BOOL isInside = [super pointInside:point withEvent:event];
    NSLog(@"C_view--- pointInside withEvent --- isInside:%d",isInside);
    return isInside;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"C_touchesBegan");
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    NSLog(@"C_touchesMoved");
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    NSLog(@"C_touchesEnded");
}

@end

@implementation TesthitTestViewD
// ------------   这是测试点击事件是如何一步步寻找到 （响应级别最高的view，最靠近用户手指或最靠近屏幕的view）。找到的那个view即为hitTestView，若   -------//
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"进入D_View---hitTest withEvent ---");
    UIView * view = [super hitTest:point withEvent:event];
    NSLog(@"离开D_View--- hitTest withEvent ---hitTestView:%@",view);
    return view;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event {
    NSLog(@"D_view--- pointInside withEvent ---");
    BOOL isInside = [super pointInside:point withEvent:event];
    NSLog(@"D_view--- pointInside withEvent --- isInside:%d",isInside);
    return isInside;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"D_touchesBegan");
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    NSLog(@"D_touchesMoved");
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    NSLog(@"D_touchesEnded");
}

@end


@implementation TesthitTestViewE

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"进入E_View---hitTest withEvent ---");
    UIView * view = [super hitTest:point withEvent:event];
    NSLog(@"离开E_View--- hitTest withEvent ---hitTestView:%@",view);
    return view;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event {
    NSLog(@"E_view--- pointInside withEvent ---");
    BOOL isInside = [super pointInside:point withEvent:event];
    NSLog(@"E_view--- pointInside withEvent --- isInside:%d",isInside);
    return isInside;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"E_touchesBegan");
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    NSLog(@"E_touchesMoved");
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    NSLog(@"E_touchesEnded");
}


@end
