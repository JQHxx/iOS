//
//  TestTVViewController.m
//  NDL_Category
//
//  Created by dzcx on 2019/5/14.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "TestTVViewController.h"
#import "XLogManager.h"
#import "DebugThread.h"

#import "TestMapViewController.h"

#import "GradientRingView.h"
#import "HighlightGradientProgressView.h"

#import "NSObject+KVO.h"
#import "Person.h"
#import "BaseNavigationController.h"

#import "ResidentThread.h"

#import <YYKit/YYKit.h>
#import "Person.h"

#import "CTMediator+ModuleA.h"
#import "TestButton.h"
#import "TestSubButton.h"
#import "UIControl+TouchLimitation.h"

static int count = 0;

void stackFrame (void) {
    /* Trigger a crash */
    ((char *)NULL)[1] = 0;
}

typedef struct TestStruct{
    int testInt;
    int nextInt;
}TS;

@interface TestTVViewController () <UITextViewDelegate>

@property (nonatomic, weak) UITextView *textView;

@property (nonatomic, strong) DebugThread *thread;

@property (nonatomic, strong) Person *person;

@property (nonatomic, copy) void(^testBB)(void);

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, weak) void(^weakBlock)(void);
@property (nonatomic, copy) void(^strongBlock)(void);


@end

@implementation TestTVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // 将结构体封装成NSValue对象
    TS testStruct = {100, 200};
    NSValue *structValue = [NSValue valueWithBytes:&testStruct objCType:@encode(TS)];
    TS temp = {0};
    [structValue getValue:&temp];
    NSLog(@"testInt = %d nextInt = %d", temp.testInt, temp.nextInt);
    
    [self test];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 120, self.view.width, 300)];
    textView.backgroundColor = [UIColor whiteColor];
    /*
     type: 键盘文字 点击作用
     default: return 换行
     UIReturnKeyDone: Done 换行
     */
    textView.returnKeyType = UIReturnKeyDone;
    if (@available(iOS 12.0, *)) {
        textView.textContentType = UITextContentTypeOneTimeCode;
    }
    textView.delegate = self;
//    [textView addObserver:self forKeyPath:@"markedTextRange" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:textView];
    self.textView = textView;
    
    // GradientRingView
    GradientRingView *gradientView = [[GradientRingView alloc] initWithFrame:CGRectMake(0, 420, 150, 150) ringWidth:20.0 ringColors:@[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor yellowColor].CGColor, (__bridge id)[UIColor greenColor].CGColor]];
    gradientView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:gradientView];
    
    // HighlightGradientProgressView
    HighlightGradientProgressView *progressView = [[HighlightGradientProgressView alloc] initWithFrame:CGRectMake(0, 580, 300, 20) gradientColors:@[(__bridge id)[UIColor cyanColor].CGColor, (__bridge id)[UIColor yellowColor].CGColor, (__bridge id)[UIColor cyanColor].CGColor, (__bridge id)[UIColor yellowColor].CGColor, (__bridge id)[UIColor cyanColor].CGColor]];
    [self.view addSubview:progressView];
    
    TestButton *button = [TestButton buttonWithType:UIButtonTypeCustom];
    button.testName = @"123";
    [button setTitle:@"我是按钮" forState:UIControlStateNormal];
    [button setTitle:@"-我是按钮-" forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(0, 620, self.view.width, 40);
    button.acceptEventInterval = 3.0;
    [self.view addSubview:button];
    NSLog(@"button.testName = %@", button.testName);
    
    // KVO-Block 
    self.person = [Person personWithName:@"ndl" age:20];
    [self.person ndl_addObserver:self forKeyPath:@"name" changedBlock:^(NSString * _Nonnull keyPath, NSObject * _Nonnull observedObject, id  _Nonnull oldValue, id  _Nonnull newValue) {
        // ##weakSelf##
        NSLog(@"self.person.name = %@", self.person.name);// yxx
        NSLog(@"===newValue = %@ oldValue = %@===", newValue, oldValue);// yxx ndl
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"change name###");
        self.person.name = @"yxx";
    });
    
    NSLog(@"anchorPoint = %@ position = %@", NSStringFromCGPoint(button.layer.anchorPoint), NSStringFromCGPoint(button.layer.position));
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.0 animations:^{
            button.transform = CGAffineTransformMakeScale(1.0, -1.0);// y轴翻转
//            button.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
    });
    
    // buttonDidTapped执行 buttonDidClicked不执行
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonDidTapped:)];
//    [button addGestureRecognizer:tap];
    
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(0, 600, self.view.width, 40)];
    testView.userInteractionEnabled = NO;// 在他下面的button(与testView同层级)就能响应事件了
    testView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.35];
    [self.view addSubview:testView];
    
//    DebugThread *thread = [[DebugThread alloc] initWithTarget:self selector:@selector(threadTask) object:nil];
//    [thread start];
//    self.thread = thread;// 不强引用 执行完就释放了dealloc,强引用 执行完状态为finish
    
    // test crash
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self testCrash];
//    });
    
    /*
     ##Block的存储域:##
     _NSConcreteStackBlock // 存储在栈上
     _NSConcreteGlobalBlock // 存储在数据段(text段),类似函数
     _NSConcreteMallocBlock // 存储在堆上
     
     全局静态 block，不会访问任何外部变量，执行完就销毁
     保存在栈中的 block，当函数返回时会被销毁，和第一种的区别就是调用了外部变量
     保存在堆中的 block，当引用计数为 0 时会被销毁
     
     使用了静态或者全局变量的时候，block实际上是存放在全局区的
     Block语法的表达式中不使用外部变量，block是存放在全局区的
     
     栈上的forwarding其实是去指向堆中的forwarding，而堆中的forwarding指向的还是自己。所以这样就能保证我们访问的就是同一个变量
     
     在ARC下，通常讲Block作为返回值的时候，编译器会自动加上copy，也就是自动生成复制到堆上的代码
     */
    // Block只捕获Block中会用到的变量。由于只捕获了自动变量(自动变量是以值传递方式传递到Block的构造函数里面)的值，并非内存地址，所以Block内部不能改变自动变量的值。Block捕获的外部变量可以改变值的是静态变量，静态全局变量，全局变量
    // __block原理:没有__block修饰，被block捕获，是值拷贝,__block修饰的变量被转化成了一个结构体，复制其引用地址,我们存放指针的方式就可以修改实际的值了
    // __block_impl  结构体中的 FuncPtr 函数指针，指向的就是我们的 Block 的具体实现。真正调用 Block 就是利用这个函数指针去调用的。
    // 为什么能访问外部变量，就是因为将外部变量复制到了结构体中（上面的 int i），即自动变量会作为成员变量追加到 Block 结构体中
    /*
     具有 __block 修饰的变量，会生成一个 Block_byref_a_0 结构体来表示外部变量，然后再追加到 Block 结构体中，这里生成 Block_byref_a_0 这个结构体大概有两个原因：一个是抽象出一个结构体，可以让多个 Block 同时引用这个外部变量；另外一个好管理，因为 Block_byref_a_0 中有个非常重要的成员变量 forwarding  指针，这个指针非常重要（这个指针指向 Block_byref_a_0 结构体），这里是保证当我们将 Block 从栈拷贝到堆中，修改的变量都是同一份
     
     Block 从栈复制到堆上，__block 修饰的变量也会从栈复制到堆上；为了结构体 __block 变量无论在栈上还是在堆上，都可以正确的访问变量，我们需要 forwarding 指针
     
     在 Block 从栈复制到堆上的时候，原本栈上结构体的 forwarding 指针，会改变指向，直接指向堆上的结构体。这样子就可以保证之后我们都是访问同一个结构体中的变量，这里就是为什么 __block 修饰的变量，在 Block 内部中可以修改的原因了
     */
    // 对于全局区的 Block，是不存在作用域的问题，但是栈区 Block 不同，在作用域结束后就会 pop 出栈
    /*
     1.Block 内部没有引用外部变量，Block 在全局区，属于 GlobalBlock
     2.Block 内部有外部变量：
     a.引用全局变量、全局静态变量、局部静态变量：Block 在全局区，属于 GlobalBlock
     b.引用普通外部变量，用 copy，strong 修饰的 Block 就存放在堆区，属于 MallocBlock；用 weak 修饰的Block 存放在栈区，属于 StackBlock
     */
    int val = 1;
    void (^blk)(void) = ^{
        printf("%d\n", val);// Block保存了val的瞬间值,值拷贝
    };
    val = 2;
    blk();// 1
    
    // block
    // 我们可以通过是否引用外部变量识别，未引用外部变量即为NSGlobalBlock，可以当做函数使用
    float (^sum)(float, float) = ^(float a, float b){
        return a + b;
    };
    NSLog(@"%@", sum);// block is <__NSGlobalBlock__>
    sum(4.f, 5.f);
    
    // block 使用 copy 是从 MRC遗留下来的“传统”,在 MRC 中,方法内部的 block 是在栈区的,使用 copy 可以把它放到堆区.在 ARC 中写不写都行：对于 block 使用 copy 还是 strong 效果是一样的,编译器自动对 block 进行了 copy 操作
    // MRC 环境下：访问外界变量的 Block 默认存储栈中
    // ARC 环境下：访问外界变量的 Block 默认存储在堆中（实际是放在栈区，然后ARC情况下自动又拷贝到堆区），自动释放
    // 如果是一个copy属性的block,它一定是NSMallocBlock.block堆内存的一个明显的特性就是:他会强引用block中的对象
    // 在处理对象时,block会malloc
    Person* model = [Person personWithName:@"ndl" age:21];
    float (^sum1)(float, float) = ^(float a, float b){
        model.age = 20;
        return a + b;
    };
    NSLog(@"%@ age = %ld", sum1, model.age);// block is <__NSMallocBlock__> age = 21
    
    //
    int multiplier = 7;
    int (^myBlock)(int) = ^(int num) {
        return num * multiplier;
    };
    NSLog(@"myBlock = %@", myBlock);// __NSMallocBlock__
    
    
    int (^staticBlock)(int) = ^(int num) {
        return num * count;
    };
    NSLog(@"staticBlock = %@", staticBlock);// __NSGlobalBlock__
    
    void (^nullBlock)() = ^ {
        
    };
    NSLog(@"nullBlock = %@", nullBlock);// __NSGlobalBlock__
    [self func:nullBlock];
    
    static int staticCount = 0;
    void (^staticInMethodBlock)() = ^ {
        staticCount = 1;
    };
    NSLog(@"staticInMethodBlock = %@", staticInMethodBlock);// __NSGlobalBlock__
    
    int weakInt = 0;
    self.weakBlock = ^{
        int value = weakInt + 1;
        NSLog(@"===self.weakBlock===");
    };
    NSLog(@"weakBlock = %@", self.weakBlock);// 不引用普通外部变量，__NSGlobalBlock__，引用普通外部变量 __NSStackBlock__
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.weakBlock();// __NSGlobalBlock__: 调用打印log，__NSStackBlock__: 调用崩溃，因为作用域结束被系统释放
    });
    
    // strong & copy 打印一致
    int strongInt = 0;
    self.strongBlock = ^{
//        int value = strongInt + 1;
    };
    NSLog(@"strongBlock = %@", self.strongBlock);// 不引用普通外部变量,__NSGlobalBlock__,引用普通外部变量 __NSMallocBlock__
    
    NSMutableArray *mutaArr = [NSMutableArray arrayWithObject:@"123"];
    void (^testBlock)(void) = ^{
        // test1
        [mutaArr addObject:@"234"];
    };
    testBlock();
    NSLog(@"mutaArr = %@", mutaArr);// test1: @"123", @"234"
    
    
    __weak void (^weakBlock)(void) = ^ {
        NSLog(@"123");
    };
    NSLog(@"匿名block = %@ weakBlock = %@", ^{NSLog(@"111");}, weakBlock);// 都是NSGlobalBlock
    
//    NSURLProtocol
    
//    NSURLConnection
//    NSURLConnectionDelegate
    
//    NSURLSession

    // =====perform selector=====
    /*
    SEL selector = NSSelectorFromString(@"aTestMethod");
    // 1
//    [self performSelector:@selector(aTestMethod)];
    
    // 2
//    ((void (*)(id, SEL))[self methodForSelector:selector])(self, selector);
    
    // 3
//    IMP imp = [self methodForSelector:selector];
//    void (*func)(id, SEL) = (void *)imp;
//    func(self, selector);
     */
    
    // 摇一摇
//    Application.applicationSupportsShakeToEdit = YES;
//    [self becomeFirstResponder];
    
    
    
    // 0,7,1,2,3,4,5,6 固定的
    dispatch_queue_t ndlQueue = dispatch_queue_create("ndl_queue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"===0===");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"===1===");
        dispatch_sync(ndlQueue, ^{
            NSLog(@"===2===");
        });
        
        NSLog(@"===3===");
        dispatch_sync(ndlQueue, ^{
            NSLog(@"===4===");
        });
        
        NSLog(@"===5===");
        dispatch_sync(ndlQueue, ^{
            NSLog(@"===6===");
        });
    });
    
    // 0,7,1,8,2,10,3,9,11,4,5,6 不固定的
    /*
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"===8===");
        dispatch_sync(ndlQueue, ^{
            NSLog(@"===9===");
        });
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"===10===");
        dispatch_sync(ndlQueue, ^{
            NSLog(@"===11===");
        });
    });
     */
    
    NSLog(@"===7===");
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        YYImage *image = [YYImage imageNamed:@"launch_2"];
//        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        imageView.frame = self.view.bounds;
//        [self.view addSubview:imageView];
//    });
    
    
    /*
     NSDate 或 CFAbsoluteTimeGetCurrent 返回的系统时钟时间
     从时钟偏移量的角度 mach_absolute_time() 和 CACurrentMediaTime 基于内建时钟.能够更精确的测试时间,并且不会根据外部的时间变化而变化.(例如,时区变化\夏时制),它和系统的upTime有关.系统重启后,CACurrentMediaTime 也会重新设置.
     */
    NSTimeInterval timeIntervalSinceReferenceDate = [[NSDate date] timeIntervalSinceReferenceDate];
    NSDate *date = [NSDate date];
    CFAbsoluteTime cfTime = CFAbsoluteTimeGetCurrent();
    CFTimeInterval caTime = CACurrentMediaTime();
    NSLog(@"timeIntervalSinceReferenceDate = %lf\ncfTime = %lf\ncaTime = %lf\ndate = %@", timeIntervalSinceReferenceDate, cfTime, caTime, date);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 延时函数，会在内部创建一个 NSTimer，然后添加到当前线程的RunLoop中。也就是如果当前线程没有开启RunLoop，该方法会失效
        [self performSelector:@selector(test1) withObject:nil afterDelay:2];
        // 如果RunLoop的mode中一个item都没有，RunLoop会退出。即在调用RunLoop的run方法后，由于其mode中没有添加任何item去维持RunLoop的事件循环，RunLoop随即还是会退出
        // 所以我们自己启动RunLoop，一定要在添加item后
        [[NSRunLoop currentRunLoop] run];// 这个不写上面的test1不执行
        NSLog(@"after test1");
        
    });
}

- (void)test1
{
    NSLog(@"===test===");
}

- (void)func:(void (^)())funcBlock
{
    NSLog(@"funcBlock = %@", funcBlock);// __NSGlobalBlock__
    
    void (^methodBlock)() = ^ {
        
    };
//    methodBlock();
    NSLog(@"methodBlock = %@", methodBlock);// __NSGlobalBlock__
}

//// 开始摇动
//- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//
//}
//// 取消摇动
//- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//
//}
//// 摇动结束
//- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//
//}

- (void)dealloc
{
    NSLog(@"===[TestTVViewController dealloc]===");
}

- (void)threadTask
{
    NSLog(@"log threadTask");
}

- (void)testCrash
{
    // xlog日志
//    for (NSInteger i = 0; i < 5; i++) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [XLogManager logWithLevel:XLogLevelDebug moduleName:@"TestTextView" fileName:NSStringFromClass([self class]) lineNumber:__LINE__ funcName:__FUNCTION__ format:@"count = %ld", i];
//
//            if (i == 4) {
//                [XLogManager flushLog:^{
//
//                }];
//            }
//        });
//    }
    
    
//    [self arrayIndexOutOfBoundsException];
//    [self unrecognizableSelectorException];
//    [self abortSignalException];
//    [self raiseException];
    
    /* Add another stack frame */
//    stackFrame();
}

// ==============================================
// 前两个方法属于系统奔溃，直接编译运行，即可监听到Crash异常信息
// 数组越界异常
- (void)arrayIndexOutOfBoundsException
{
    NSArray *array= @[@"sss", @"xxx", @"ooo"];
    [array objectAtIndex:5];
}

// 无法识别的方法异常
- (void)unrecognizableSelectorException
{
    [self performSelector:@selector(ndl) withObject:nil afterDelay:2.0];
}

// 终止信号异常
- (void)abortSignalException
{
    int list[2] = {1,2};
    int *p = list;
    // 导致SIGABRT的错误，因为内存中根本就没有这个空间，哪来的free，就在栈中的对象而已
    free(p);
    p[1] = 5;
}

- (void)raiseException
{
    [NSException raise:@"raiseException-name" format:@"raiseException-format"];
}
// ==============================================

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"self retainCount = %ld self = %@", CFGetRetainCount((__bridge CFTypeRef)(self)), self);// 11 0x7fa5d0408930
    __weak typeof(self) weakSelf = self;
    NSLog(@"self retainCount = %ld", CFGetRetainCount((__bridge CFTypeRef)(self)));// 11
    // self的引用计数+1，栈中的strongSelf_s作用域结束后被释放使得self的引用计数-1
//    __strong typeof(self) strongSelf_ = weakSelf;
    
//    self.testBB = ^{
//        // self
////        NSLog(@"self retainCount = %ld", CFGetRetainCount((__bridge CFTypeRef)(self)));// 13
////        self.tag = @"123";
////        NSLog(@"self retainCount = %ld", CFGetRetainCount((__bridge CFTypeRef)(self)));// 13
//
//        // weakSelf
//        NSLog(@"self retainCount = %ld weakSelf = %@", CFGetRetainCount((__bridge CFTypeRef)(weakSelf)), weakSelf);// 12 0x7fa5d0408930
//        weakSelf.tag = @"123";
//        NSLog(@"tag = %@", weakSelf.tag);// 123
//    };
//    self.testBB();
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"==========");
        NSLog(@"self retainCount = %ld self = %@", CFGetRetainCount((__bridge CFTypeRef)(self)), self);//weakSelf 7, self 8
    });
    NSLog(@"after dispatch_after");
    
    // textView retainCount
//    NSLog(@"textView retainCount = %ld", CFGetRetainCount((__bridge CFTypeRef)(self.textView)));// 3
//    UITextView *temp = self.textView;
//    NSLog(@"textView retainCount = %ld", CFGetRetainCount((__bridge CFTypeRef)(self.textView)));// 4
//    __strong UITextView *temp1 = self.textView;
//    NSLog(@"textView retainCount = %ld", CFGetRetainCount((__bridge CFTypeRef)(self.textView)));// 5
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"textView retainCount = %ld", CFGetRetainCount((__bridge CFTypeRef)(self.textView)));// 3
//    });
    
    
    // textView :{0, 120, 375, 300}
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"textContainer.size = %@", NSStringFromCGSize(self.textView.textContainer.size));
//    });
    
}



- (void)buttonDidClicked:(UIButton *)button
{
    NSLog(@"##buttonDidClicked##");
//    [self dismissViewControllerAnimated:YES completion:nil];

    // tes map
//    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:[TestMapViewController new]];
//    [self presentViewController:nav animated:YES completion:nil];
    
    
//    [self presentViewController:[[CTMediator sharedInstance] moduleA_TestViewController] animated:YES completion:nil];
}

- (void)buttonDidTapped:(UITapGestureRecognizer *)gesture
{
    NSLog(@"##buttonDidTapped##");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"markedTextRange"]) {
        UITextRange *markedTextRange = change[NSKeyValueChangeNewKey];
        NSLog(@"###observeValueForKeyPath markedTextRange = %@###", markedTextRange);
    }
}

- (void)test
{
    NSString *str = @"123";
    NSLog(@"subStr = %@", [str substringToIndex:1]);// @"1"
    
    // 13个字符
    
    // testStr.length: UTF-16 code units
    NSString *testStr = @"sdf🤨123j🤨7sdf";// 15(个码元) flag = 0 【末尾+我 16(个码元)】
    // 30, 19
//    NSLog(@"UTF16 = %ld UTF8 = %ld", [testStr lengthOfBytesUsingEncoding:NSUTF16StringEncoding], [testStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    
//    testStr = @"123sdfg你懂";// flag = 0
//    testStr = @"asd123";// flag = 1
//    testStr = @"sdf🤨123j🤨7sdf我";// 16 flag = 0
    BOOL flag = [testStr canBeConvertedToEncoding:NSASCIIStringEncoding];
    NSLog(@"length = %ld flag = %ld", testStr.length, [NSNumber numberWithBool:flag].integerValue);
    
    // @"sdf🤨123j🤨7sdf"
//    NSLog(@"UTF16-flag = %ld UTF8-flag = %ld", [testStr canBeConvertedToEncoding:NSUTF16StringEncoding], [testStr canBeConvertedToEncoding:NSUTF8StringEncoding]);// 1, 1
    
    // UTF16 空字符串是2字节
//    testStr = @"asd123";// UTF16, UTF8: 14, 6
//    testStr = @"123sdfg你懂";// 20, 13(UTF8 汉字3字节)
//    testStr = @"sdf🤨1你";// 16(UTF16 汉字2字节 🤨4字节) ,11(UTF8 🤨4字节)
//    NSData *testStrData = [testStr dataUsingEncoding:NSUTF16StringEncoding];
//    testStrData = [testStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"testStrData.length = %ld", testStrData.length);// 32, 19
    
//    Byte *bytes = (Byte *)testStrData.bytes;
    
    for (NSUInteger i = 0; i < testStr.length; i++) {
        NSRange range = [testStr rangeOfComposedCharacterSequenceAtIndex:i];
        NSLog(@"range = %@", NSStringFromRange(range));
        /*
         2019-05-15 16:09:26.791512+0800 NDL_Category[20738:158453] range = {0, 1}
         2019-05-15 16:09:26.791674+0800 NDL_Category[20738:158453] range = {1, 1}
         2019-05-15 16:09:26.791860+0800 NDL_Category[20738:158453] range = {2, 1}
         2019-05-15 16:09:26.792022+0800 NDL_Category[20738:158453] range = {3, 2}
         2019-05-15 16:09:26.792176+0800 NDL_Category[20738:158453] range = {3, 2}
         2019-05-15 16:09:26.792354+0800 NDL_Category[20738:158453] range = {5, 1}
         2019-05-15 16:09:26.792803+0800 NDL_Category[20738:158453] range = {6, 1}
         2019-05-15 16:09:26.793274+0800 NDL_Category[20738:158453] range = {7, 1}
         2019-05-15 16:09:26.793605+0800 NDL_Category[20738:158453] range = {8, 1}
         2019-05-15 16:09:26.793913+0800 NDL_Category[20738:158453] range = {9, 2}
         2019-05-15 16:09:26.794387+0800 NDL_Category[20738:158453] range = {9, 2}
         2019-05-15 16:09:26.794978+0800 NDL_Category[20738:158453] range = {11, 1}
         2019-05-15 16:09:26.795325+0800 NDL_Category[20738:158453] range = {12, 1}
         2019-05-15 16:09:26.809670+0800 NDL_Category[20738:158453] range = {13, 1}
         2019-05-15 16:09:26.809888+0800 NDL_Category[20738:158453] range = {14, 1}
         2019-05-15 16:09:26.810064+0800 NDL_Category[20738:158453] range = {15, 1}// 原有字符串末尾+我
         */
    }
    
    // 计数
    __block NSInteger count = 0;
    [testStr enumerateSubstringsInRange:NSMakeRange(0, testStr.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        count++;
        NSLog(@"count = %ld subString = %@ (substringRange = %@) [enclosingRange = %@]", count, substring, NSStringFromRange(substringRange), NSStringFromRange(enclosingRange));
    }];
    /*
     2019-05-15 16:09:26.810348+0800 NDL_Category[20738:158453] count = 1 subString = s (substringRange = {0, 1}) [enclosingRange = {0, 1}]
     2019-05-15 16:09:26.810666+0800 NDL_Category[20738:158453] count = 2 subString = d (substringRange = {1, 1}) [enclosingRange = {1, 1}]
     2019-05-15 16:09:26.811006+0800 NDL_Category[20738:158453] count = 3 subString = f (substringRange = {2, 1}) [enclosingRange = {2, 1}]
     2019-05-15 16:09:26.811198+0800 NDL_Category[20738:158453] count = 4 subString = 🤨 (substringRange = {3, 2}) [enclosingRange = {3, 2}]
     2019-05-15 16:09:26.811356+0800 NDL_Category[20738:158453] count = 5 subString = 1 (substringRange = {5, 1}) [enclosingRange = {5, 1}]
     2019-05-15 16:09:26.811527+0800 NDL_Category[20738:158453] count = 6 subString = 2 (substringRange = {6, 1}) [enclosingRange = {6, 1}]
     2019-05-15 16:09:26.811680+0800 NDL_Category[20738:158453] count = 7 subString = 3 (substringRange = {7, 1}) [enclosingRange = {7, 1}]
     2019-05-15 16:09:26.811865+0800 NDL_Category[20738:158453] count = 8 subString = j (substringRange = {8, 1}) [enclosingRange = {8, 1}]
     2019-05-15 16:09:26.812030+0800 NDL_Category[20738:158453] count = 9 subString = 🤨 (substringRange = {9, 2}) [enclosingRange = {9, 2}]
     2019-05-15 16:09:26.812473+0800 NDL_Category[20738:158453] count = 10 subString = 7 (substringRange = {11, 1}) [enclosingRange = {11, 1}]
     2019-05-15 16:09:26.812888+0800 NDL_Category[20738:158453] count = 11 subString = s (substringRange = {12, 1}) [enclosingRange = {12, 1}]
     2019-05-15 16:09:26.813258+0800 NDL_Category[20738:158453] count = 12 subString = d (substringRange = {13, 1}) [enclosingRange = {13, 1}]
     2019-05-15 16:09:26.813684+0800 NDL_Category[20738:158453] count = 13 subString = f (substringRange = {14, 1}) [enclosingRange = {14, 1}]
     2019-05-15 16:09:26.813941+0800 NDL_Category[20738:158453] count = 14 subString = 我 (substringRange = {15, 1}) [enclosingRange = {15, 1}]
     */
}

#pragma mark - UITextViewDelegate
// UITextViewTextDidChangeNotification

// 在keyboardWillShow前面执行// 键盘弹出前计算textView的bottomY
// 1-1
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSLog(@"textViewShouldBeginEditing length = %ld", textView.text.length);
    return YES;
}

// 3-1
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    NSLog(@"textViewShouldEndEditing");
    return YES;
}

// 在keyboardWillShow后面执行
// 1-2
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"textViewDidBeginEditing");
}

// 3-2
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"textViewDidEndEditing");
}

// ##没有text点击删除 第三方键盘和系统i键盘都走这个方法## shouldChangeTextInRange curText =  (range = {0, 0}) [replacementText = ]
// 一开始光标的位子:range(0,0)
// 2-1
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self logCommonWithTextView:textView tagStr:@"shouldChangeTextInRange"];
    // range:改变的范围
    NSLog(@"shouldChangeTextInRange curText = %@ (range = %@) [replacementText = %@]", textView.text, NSStringFromRange(range), text);
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    // range:表示应该改变text的范围
    NSUInteger curTotalTextLen = textView.text.length;
    // 光标位置（光标位置 || 范围开始位置）
    NSUInteger cursorIndex = range.location;
    NSUInteger cursorLen = range.length;// 光标选中的textLen
    // 光标前的textLen
    NSUInteger beforeCursorTextLen = cursorIndex;
    // 替换的textLen
    NSUInteger replaceTextLen = text.length;
    
    return YES;
}
// 2-3
- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"textViewDidChange");
    
    NSString *curText = textView.text;
    NSUInteger curTotalTextLen = curText.length;
    if (curTotalTextLen > kTextViewMaxTextLength) {
        // 最后个Character(码元)
        NSRange lastIndexRange = [curText rangeOfComposedCharacterSequenceAtIndex:kTextViewMaxTextLength - 1];
        NSUInteger lastIndex = lastIndexRange.location;
        NSUInteger lastIndexLen = lastIndexRange.length;
        NSInteger substringToIndex = 0;// 截取到的index，也表示现在的textLen
        
        // 组合字符序列 超过了kTextViewMaxTextLength
        if (lastIndex + lastIndexLen > kTextViewMaxTextLength) {
            substringToIndex = lastIndex;
        } else {
            substringToIndex = lastIndex + lastIndexLen;
        }
        
        NSString *resultStr = [curText substringToIndex:substringToIndex];
        [textView setText:resultStr];
    }
}

// 选中的改变（包括光标的改变）
// 2-2 ||
// (改变光标位置,范围选中)会掉
//- (void)textViewDidChangeSelection:(UITextView *)textView
//{
//    [self logCommonWithTextView:textView tagStr:@"textViewDidChangeSelection"];
//    NSLog(@"textViewDidChangeSelection");
//}

- (void)logCommonWithTextView:(UITextView *)textView tagStr:(NSString *)tagStr
{
    UITextRange *markedTextRange = [textView markedTextRange];
    UITextRange *selectedTextRange = [textView selectedTextRange];
    NSString *markedText = [textView textInRange:markedTextRange];
    
    // ###
    NSRange selectedRange = textView.selectedRange;// 选中的范围
    
    UITextPosition *beginPos = textView.beginningOfDocument;
    UITextPosition *endPos = textView.endOfDocument;
    
    NSLog(@"===%@:markedTextRange = %@ selectedTextRange = %@ markedText = %@ selectedRange = %@ beginPos = %@ endPos = %@===", tagStr, markedTextRange, selectedTextRange, markedText, NSStringFromRange(selectedRange), beginPos, endPos);
}

@end
