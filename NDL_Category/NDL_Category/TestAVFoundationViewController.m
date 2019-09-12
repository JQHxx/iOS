//
//  TestAVFoundationViewController.m
//  NDL_Category
//
//  Created by dzcx on 2019/9/4.
//  Copyright © 2019 ndl. All rights reserved.
//

/*
 CoreAudio:
 MIDI:电脑可以将来源于键盘乐器的声音信息转化为数字信息存入电脑
 声音是波,靠物体的振动产生
 声波的三要素,是频率,振幅,波形.频率代表音阶的高低,振幅代表响度,波形则代表音色.
 用分贝描述声音的响度
 分贝(decibel),是度量声音的强度单位,常用dB表示
 
 将模拟信号转换为数字信号的过程,分别是采样(sampling),量化和编码
 量化格式(sampleFormat)
 采样率(sampleRate)
 声道数(channel)
 
 以CD音质为例,量化格式为16bite,采样率为44100,声道数为2.这些信息描述CD音质.那么可以CD音质数据,比特率是:
 44100 * 16 * 2 = 1378.125kbps
 那么一分钟的,这类CD音质数据需要占用多少存储空间:
 1378.125 * 60 /8/1024 = 10.09MB
 如果sampleFormat更加精确或者sampleRate更加密集,那么所占的存储空间就会越大,同时能够描述的声音细节就会更加精确
 
 压缩编码的原理实际上就是压缩冗余的信号.冗余信号就是指不能被人耳感知的信号.包括人耳听觉范围之外的音频信号以及被掩盖掉的音频信号
 常用压缩编码格式:
 WAV编码
 MP3编码
 AAC编码
 Ogg编码
 
 CoreVideo:
 CoreMedia:
 
 
 音频数字化的过程包含一个编码: 线性脉冲编码调制,LPCM
 
 YUV
 */

/*
 MARK:视频捕捉
 1.捕捉会话
 核心类是AVCaptureSession
 2.捕捉设备
 AVCaptureDevice为摄像头、麦克风等物理设备提供接口
 AVCaptureDevice 针对物理设备提供了大量的控制方法。比如控制摄像头聚焦、曝光、白平衡、闪光灯等
 3.捕捉设备的输入
 为捕捉设备添加输入，不能添加到AVCaptureSession 中，必须通过将它封装到一个AVCaptureDeviceInputs实例中
 4.捕捉的输出
 AVCaptureOutput 是一个抽象类。用于为捕捉会话得到的数据寻找输出的目的地。框架定义了一些抽象类的高级扩展类。例如 AVCaptureStillImageOutput 和 AVCaptureMovieFileOutput类。使用它们来捕捉静态照片、视频。例如 AVCaptureAudioDataOutput 和 AVCaptureVideoDataOutput ,使用它们来直接访问硬件捕捉到的数字样本
 5.捕捉连接
 AVCaptureConnection类
 6.捕捉预览
 AVCaptureVideoPreviewLayer 类来满足该需求。这样就可以对捕捉的数据进行实时预览
 */

/*
 MARK:AVCaptureVideoPreviewLayer
 定义了2个方法用于坐标系间进行转换
 captureDevicePointOfInterestForPoint:获取屏幕坐标系的CGPoint 数据，返回转换得到的设备坐标系CGPoint数据
 pointForCaptureDevicePointOfInterest:获取摄像头坐标系的CGPoint数据，返回转换得到的屏幕坐标系CGPoint 数据
 */

#import "TestAVFoundationViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface TestAVFoundationViewController ()

@end

@implementation TestAVFoundationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
//    [self testGCD];
//    [self testGCD1];
//    [self testBarrier];
//    [self testBlockWait];
//    [self testBlockNotify];
//    [self testBlockCancel];
    
    // 750 X 1334
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"testImage" ofType:@"jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imagePath]];
    imageView.size = CGSizeMake(750 / 4.0, 1334 / 4.0);
    imageView.center = CGPointMake(self.view.width / 2.0, self.view.height / 2.0);
    [self.view addSubview:imageView];
    
    // MARK:test CGAffineTransform
    /*
     CGAffineTransform:
     [ a b c d tx ty ]
     
     a  b  0
     c  d  0
     tx ty 1
     
                a  b  0
     [x,y,1] *  c  d  0  = [x',y',1]
                tx ty 1
     
     eg:
     CGAffineTransformMake(0.2, 0, 0, 1, 0, 0);
     View的frame原来的{{100，100}，{100，100}}变成了{{140，100}，{20，100}}
     根据变换的transform我们知道 a = 0.2 , b = 0 , c = 0 , d = 1 , t.x = 0 , t.y = 0
     x = 100 ,  y = 100
     x` = ax + cy + tx = 0.2 * 100 + 0 * 100 + 0 = 20
     y` = bx + dy + ty = 0 * 100 + 1 * 100 + 0 = 100
     
     x按照a值进行了比例缩放，y按照d的值进行比列缩放，最重要的是缩放的过程中View的point（中心点）是不会改变的
     x会跟着tx进行x做表平移，y会跟着ty进行平移。这里的point（center）是跟着变换的
     
     a表示x水平方向的缩放，tx表示x水平方向的偏移
     d表示y垂直方向的缩放，ty表示y垂直方向的偏移
     如果b和c不为零的话，那么视图肯定发生了旋转
     
其中tx用来控制在x轴方向上的平移,ty用来控制在y轴方向上的平移;a用来控制在x轴方向上的缩放,d用来控制在y轴方向上的缩放;abcd共同控制旋转
     
     平移CGAffineTransformMakeTranslation原理
     self.demoImageView.transform = CGAffineTransformMakeTranslation(100, 100);
     self.demoImageView.transform = CGAffineTransformMake(1, 0, 0, 1, 100, 100);
     缩放CGAffineTransformMakeScale原理
     self.demoImageView.transform = CGAffineTransformMakeScale(2, 0.5);
     self.demoImageView.transform = CGAffineTransformMake(2, 0, 0, 0.5, 0, 0);
     旋转CGAffineTransformMakeRotation原理
     self.demoImageView.transform = CGAffineTransformMakeRotation(M_PI*0.5);
     self.demoImageView.transform = CGAffineTransformMake(cos(M_PI * 0.5), sin(M_PI * 0.5), -sin(M_PI * 0.5), cos(M_PI * 0.5), 0, 0);
     初始状态CGAffineTransformIdentity原理
     self.demoImageView.transform = CGAffineTransformIdentity;
     self.demoImageView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
     */
    
    // 按x轴做翻转
//    imageView.transform = CGAffineTransformMake(1.0, 0, 0, -1.0, 0, 0);
    // 按x轴做翻转+缩放
//    imageView.transform = CGAffineTransformMake(1.0, 0, 0, -1.2, 0, 0);
    
    // 旋转
    // 顺时针旋转90度
//    imageView.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
    
    // 顺时针旋转90度 right
//    imageView.transform = CGAffineTransformMake(0, 1.0, -1.0, 0, 0, 0);
    
    // 逆时针旋转90度 left
//    imageView.transform = CGAffineTransformMake(0, -1.0, 1.0, 0, 0, 0);
    
    // up 没有变化
//    imageView.transform = CGAffineTransformMake(1.0, 0.0, 0.0, 1.0, 0, 0);
    
    // xy翻转相当于 旋转180度 down
    imageView.transform = CGAffineTransformMake(-1.0, 0.0, 0.0, -1.0, 0, 0);
}

- (void)testBlockCancel
{
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    dispatch_block_t block1 = dispatch_block_create(0, ^{
        NSLog(@"block1 begin");
        [NSThread sleepForTimeInterval:1];
        NSLog(@"block1 done");
    });
    dispatch_block_t block2 = dispatch_block_create(0, ^{
        NSLog(@"block2 ");
    });
    dispatch_async(queue, block1);
    dispatch_async(queue, block2);
    dispatch_block_cancel(block2);
}

- (void)testBlockNotify
{
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    dispatch_block_t previousBlock = dispatch_block_create(0, ^{
        NSLog(@"previousBlock begin");
        [NSThread sleepForTimeInterval:1];
        NSLog(@"previousBlock done");
    });
    dispatch_async(queue, previousBlock);
    dispatch_block_t notifyBlock = dispatch_block_create(0, ^{
        NSLog(@"notifyBlock thread = %@", [NSThread currentThread]);
    });
    //当previousBlock执行完毕后，提交notifyBlock到global queue中执行
    dispatch_block_notify(previousBlock, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), notifyBlock);
}

- (void)testBlockWait
{
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    dispatch_block_t block = dispatch_block_create(0, ^{
        NSLog(@"before sleep");
        [NSThread sleepForTimeInterval:1];
        NSLog(@"after sleep");
    });
    dispatch_async(queue, block);
    NSLog(@"main run task");
    //等待前面的任务执行完毕
    dispatch_block_wait(block, DISPATCH_TIME_FOREVER);
//    dispatch_sync(queue, ^{
//        NSLog(@"sync task: thread = %@", [NSThread currentThread]);// main
//    });
    NSLog(@"coutinue");
}

- (void)testBarrier
{
    dispatch_queue_t queue = dispatch_queue_create("Database_Queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"reading data1");
    });
    dispatch_async(queue, ^{
        NSLog(@"reading data2");
    });
    // dispatch_barrier_sync
    dispatch_barrier_async(queue, ^{
        NSLog(@"writing data1");
    });
    NSLog(@"===after barrier===");
    dispatch_async(queue, ^{
        NSLog(@"reading data3");
    });
}

- (void)testQos
{
    
}

- (void)testGCD
{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    //1.用户登录
    dispatch_sync(concurrentQueue,^{
        NSLog(@"用户登录 %@",[NSThread currentThread]);// main
    });
    // 同步任务 没有执行完毕，后面的所有任务都不会去执行。所以它相当于一个🔐的功能
    
    //2.支付
    dispatch_async(concurrentQueue,^{
        NSLog(@"支付 %@",[NSThread currentThread]);
    });
    dispatch_async(concurrentQueue,^{
        NSLog(@"支付1 %@",[NSThread currentThread]);
    });
    dispatch_async(concurrentQueue,^{
        NSLog(@"支付2 %@",[NSThread currentThread]);
    });
    dispatch_sync(concurrentQueue,^{
        NSLog(@"test %@",[NSThread currentThread]);
    });
    //3.下载
    dispatch_async(concurrentQueue,^{
        NSLog(@"下载  %@",[NSThread currentThread]);
    });
}

- (void)testGCD1
{
    //队列
    dispatch_queue_t q = dispatch_queue_create("cc_queue",DISPATCH_QUEUE_CONCURRENT);
    
    //任务，在这个任务中添加了3个任务
    void (^task)() = ^{
        
        //1.用户登录
        dispatch_sync(q,^{
            NSLog(@"用户登录 %@",[NSThread currentThread]);
        });
        
        //2.支付
        dispatch_async(q,^{
            NSLog(@"支付 %@",[NSThread currentThread]);
        });
        
        //3.下载
        dispatch_async(q,^{
            NSLog(@"下载  %@",[NSThread currentThread]);
        });
    };
    
    for(int i = 0; i < 10; i++)
    {
        NSLog(@"%d %@",i,[NSThread currentThread]);
    }
    
    //将task丢到异步执行中去
    dispatch_async(q,task);
    NSLog(@"come here");
}


@end
