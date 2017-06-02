//
//  YYGPUImageFilterController.m
//  YYGPUImageDemo
//
//  Created by Ryan on 2017/6/2.
//  Copyright © 2017年 Ryan. All rights reserved.
//

#import "YYGPUImageFilterController.h"
#import "GPUImage.h"

@interface YYGPUImageFilterController ()

/* <#description#> */
@property (nonatomic,strong) GPUImageBilateralFilter *bilateralFilter;
/* <#description#> */
@property (nonatomic,strong) GPUImageBrightnessFilter *brightnessFilter;
/* <#description#> */
@property (nonatomic,strong) GPUImageVideoCamera *videoCamera;

/* <#description#> */
@property (nonatomic,strong) UIButton *backBtn;

@end

@implementation YYGPUImageFilterController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self configBottomView];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, 20, 50, 44); //必须设置尺寸大小
    [self.backBtn setImage:[UIImage imageNamed:@"main_black_back"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    //创建视频源
    // SessionPreset:屏幕分辨率，AVCaptureSessionPresetHigh会自适应高分辨率
    // cameraPosition:摄像头方向
    // 最好使用AVCaptureSessionPresetHigh，会自动识别，如果用太高分辨率，当前设备不支持会直接报错
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionFront];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    //创建预览图层
    GPUImageView *previewLayer = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:previewLayer atIndex:0];
    
    //创建滤镜组合
    GPUImageFilterGroup *filterGroup = [[GPUImageFilterGroup alloc] init];
    
    //磨皮滤镜
    self.bilateralFilter = [[GPUImageBilateralFilter alloc] init];
    [filterGroup addFilter:self.bilateralFilter];
    
    //美白滤镜
    self.brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    [filterGroup addFilter:self.brightnessFilter];
    
    //设置滤镜组链
    [self.bilateralFilter addTarget:self.brightnessFilter];
    [filterGroup setInitialFilters:@[self.bilateralFilter]];
    filterGroup.terminalFilter = self.brightnessFilter;
    
    //设置GPUImage处理链，从数据源 => 滤镜 => 最终界面效果
    [self.videoCamera addTarget:filterGroup];
    [filterGroup addTarget:previewLayer]; //注意别添加错误了
    
    //采集视频
    [self.videoCamera startCameraCapture];
    
    
}

- (void)configBottomView {
    
    UILabel *mopiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight-100, ScreenWidth, 16)];
    mopiLabel.text = @"磨皮";
    mopiLabel.textAlignment = NSTextAlignmentCenter;
    mopiLabel.textColor = [UIColor blackColor];
    mopiLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:mopiLabel];
    
    
    UISlider *moSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mopiLabel.frame)+2, ScreenWidth, 20)];
    moSlider.value = 5;
    moSlider.minimumValue = 5;
    moSlider.maximumValue = 10;
    moSlider.minimumTrackTintColor = [UIColor redColor];
    moSlider.maximumTrackTintColor = [UIColor whiteColor];
    moSlider.thumbTintColor = [UIColor blueColor];
    [moSlider addTarget:self action:@selector(clickMoSliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:moSlider];
    
    UILabel *whiteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(moSlider.frame)+10, ScreenWidth, 16)];
    whiteLabel.text = @"美白";
    whiteLabel.textAlignment = NSTextAlignmentCenter;
    whiteLabel.textColor = [UIColor blackColor];
    whiteLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:whiteLabel];
    
    
    UISlider *whiteSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(whiteLabel.frame)+2, ScreenWidth, 20)];
    whiteSlider.value = 0;
    whiteSlider.minimumValue = -1.0;
    whiteSlider.maximumValue = 1.0;
    whiteSlider.minimumTrackTintColor = [UIColor redColor];
    whiteSlider.maximumTrackTintColor = [UIColor whiteColor];
    whiteSlider.thumbTintColor = [UIColor blueColor];
    [whiteSlider addTarget:self action:@selector(clickWhiteSliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:whiteSlider];
}

- (void)clickMoSliderAction:(UISlider *)sender {
    CGFloat maxValue = 10.0;
    [self.bilateralFilter setDistanceNormalizationFactor:(maxValue - sender.value)];
    
}

- (void)clickWhiteSliderAction:(UISlider *)sender {
    
    self.brightnessFilter.brightness = sender.value;
}


- (void)back {
    [self dismissViewControllerAnimated:true completion:nil];
}


@end


















































































