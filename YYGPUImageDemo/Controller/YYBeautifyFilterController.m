//
//  YYBeautifyFilterController.m
//  YYGPUImageDemo
//
//  Created by Ryan on 2017/6/2.
//  Copyright © 2017年 Ryan. All rights reserved.
//

#import "YYBeautifyFilterController.h"
#import "GPUImageBeautifyFilter.h"
#import "GPUImage.h"

@interface YYBeautifyFilterController ()

/* <#description#> */
@property (nonatomic,strong) UISwitch *switchBtn;

/* <#description#> */
@property (nonatomic,strong) GPUImageVideoCamera *videoCamera;
/* <#description#> */
@property (nonatomic,strong) GPUImageView *videoPreview;
/* <#description#> */
@property (nonatomic,strong) UIButton *backBtn;
@end

@implementation YYBeautifyFilterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, 20, 50, 44); //必须设置尺寸大小
    [self.backBtn setImage:[UIImage imageNamed:@"main_black_back"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    self.switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenWidth-10-60, 64, 40, 40)];
    [self.switchBtn addTarget:self action:@selector(clickSwitchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.switchBtn];
    
    //创建视频源
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionFront];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    //创建预览图层
    self.videoPreview = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:self.videoPreview atIndex:0];
    
    //设置处理链
    [self.videoCamera addTarget:self.videoPreview];
    
    //开始采集视频
    [self.videoCamera startCameraCapture];
    
}


- (void)clickSwitchBtnAction:(UISwitch *)sender {
    
    if (sender.on) {
        //移除之前所有处理链
        [self.videoCamera removeAllTargets];
        
        GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
        
        // 设置GPUImage处理链，从数据源 => 滤镜 => 最终界面效果
        [self.videoCamera addTarget:beautifyFilter];
        
        [beautifyFilter addTarget:self.videoPreview];
        
    } else {
        // 移除之前所有处理链
        [self.videoCamera removeAllTargets];
        
        [self.videoCamera addTarget:self.videoPreview];
    }
}


- (void)back {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end





















































