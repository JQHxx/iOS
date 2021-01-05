//
//  AV1ViewController.h
//  NDL_Category
//
//  Created by youdone-ndl on 2020/12/14.
//  Copyright © 2020 ndl. All rights reserved.
//

// MARK: AV概念
/**
 Core Audio:
 MIDI(Musical Instrument Digital Interface)乐器数字接口
 为音频和MIDI内容的录制、播放和处理提供相应接口
 
 Core Video:
 
 Core Media:
 
 音频播放和记录:
 播放音频文件可以使用AVAudioPlayer，
 录制音频文件可以使用AVAudioRecorder。
 还可以使用AVAudioSession来配置应用程序的音频行为。
 
 媒体文件检查:
 AVMetadataItem类提供功能强大的元数据支持。允许开发者读取关于媒体资源的描述信息。
 
 视频播放:
 AVPlayer和AVPlayerItem
 
 媒体捕捉:
 AVCaptureSession
 
 媒体编辑:
 
 媒体处理:
 AVAssetReader和AVAssetWriter
 
 了解信号的数字化过程:
 视频文件一秒内所能展现的帧数成为视频的帧率，用FPS作为单位进行测量。常见的帧率是24FPS、25FPS、30FPS。
 目前视频最流行的宽高比是16:9，意思是没16个水平像素对应9个垂直像素。常见视频尺寸为1280*720，1920*1080。
 如果每个像素点使用8位RGB色彩空间，这意味着红色8位，绿色8位，蓝色8位。
 一个帧率为30FPS，分辨率是1920*1080的视频存储需求就是：1920*1080 * 30 * 24 (b/s)
 
 数字媒体压缩:
 为缩小数字媒体文件大小，需要对齐使用压缩技术。
 1.色彩二次抽样
 视频数据是使用YCbCr颜色模式的典型案例，也常称为YUV。
 对RGB模式来说，每个像素是由红、绿、蓝三种颜色组合而成，而YUV使用的是色彩通道UV(颜色)替换了像素的亮度通道Y(亮度)。眼睛对于亮度的敏感度要高于颜色，所以可以大幅度减少存储在每个像素中的颜色信息，不至于是图片质量严重受损，减少颜色数据的过程就成为色彩二次抽样。
 2、编解码器压缩
 大部分音频和视频都是使用编解码器(codec)来压缩的，即编码器和解码器(encoder/decoder)。编解码器使用高级压缩算法对需要保存或发送的音频或视频数据进行压缩和编码，同时还可以将压缩文件解码成为适合播放和编辑的媒体资源。编解码器可以进行无损压缩也可以机型有损压缩。
 3、视频编解码器。
 对于视频编辑码而言，AV提供有限的编解码器集合，只提供苹果公司认定的最主流的几种媒体类型的支持。对视频文件主要可以归结为H.264和Apple ProRes。
 (1)H.264
 H.264规范是Motion Picture Experts Group(MPEG)所定义的MPEG-4的一部分，H.264遵循早期的MPEG-1和MPEG-2标准，但在以更低比特率得到更高图片质量方面有了长足进步，使其更好地使用与流媒体文件和移动设备及视频摄像头。
 H.264与其他形式的MPEG压缩一样，通过以下两个纬度缩小了视频文件的大小：
 1、空间：压缩独立视频帧，称为帧内压缩
 2、时间：通过以组为单位的视频帧压缩冗余数据，称为帧间压缩
 帧内压缩，通过消除包含在每个独立视频帧内的色彩及结构中的冗余信息来进行压缩，因此可在不降低图片质量的情况小尽可能缩小尺寸。这类压缩类似JEPG压缩，帧内压缩可以作为有损压缩算法，通常用于对原始图片的一部分进行处理以生成极高质量的照片，通过这一过程创建的帧成为I-frames。
 帧间压缩，很多帧被组合在一起成为一组图片(简称GOP)，对于GOP所存在的时间维度的冗余可以被消除。在一个时间维度上的冗余，如视频的固定背景环境，就可以通过压缩的方式进行消除。
 GOP中三种不同的帧：
 1、I-frames：关键帧，或者单独的帧，包含创建完整图片所需要的所有数据，每个GOP都正好有一个I-Frames。由于它是一个独立帧，其尺寸是最大的，但也是压缩最快的。
 2、P-frames：预测帧，是从基于最近I-frames或P-frames的可预测的图片进行编码得到的。P-frames可以引用最近的预测帧P-frames或一组I-frames。你将会经常看到被称为“Reference frames”的帧，临近的P-frames和B-Frames都可以对其进行引用。
 3、B-frames：双向帧，基于使用之前和之后的帧信息进行编码后得到的帧。几乎不需要存储空间，但其解码过程会耗费很长时间，因为它依赖于周围其他的帧。

 H.264还支持编码视图，用于确定在整个编码过程中所使用的算法定义三个高级标准：
 1、 Baseline：通常用于对移动设备的媒体内容进行处理，提供最低效的压缩，因此经过这个标准压缩后的文件仍较大，但同时这种方法也是最少计算强度的方法，因为它不支持B-frames。如果编译目标是比较久远的iOS设备，可能需要用到Baseline标准。
 2、Main：这个标准的计算强度比Baseline的高，使用的算法更多，但可以达到较高的压缩率
 3、High：高标准的方法会得到最高质量的压缩效果，但它也是三总方法中计算复杂度最高的，因为所有能用到的编码技术和算法几乎都用到了。
 
 (2)Apple ProRes
 ProRes编解码器只在OSX上使用，针对iOS进行开发，只能使用H.264。
 
 对H.264和Apple ProRes来说，AV还支持很多摄像头设备的编解码器，如MPEG-1、MPEG-2、MPEG-4、H.263和DV，允许用户以多种不同的视频捕捉设备导入内容资源。
 
 音频编解码器:
 只要是Core Audio框架支持的音频编解码，AV都可以支持。意味着AV可以支持大量不同格式的资源，然而在不适用线性PCM音频的情况下，更多的只能使用AAC。
 AAC，高级音频编码是H.264标准相应的音频处理方式，目前已成为音频流和下载的音频资源中最主流的编码方式。这种格式比MP3格式有显著的提升，可以在低比特率的前提下提供更高质量的音频，在web上发布和传播的音频格式中最为理想的。AAC没有来自证书和许可方面的限制。

 AV 和 Core Audio提供对MP3数据解码的支持，但不支持对齐进行编码。
 
 容器格式:
 
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AV1ViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

