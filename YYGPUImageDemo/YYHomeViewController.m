//
//  ViewController.m
//  YYGPUImageDemo
//
//  Created by Ryan on 2017/6/2.
//  Copyright © 2017年 Ryan. All rights reserved.
//

#import "YYHomeViewController.h"
#import "YYBeautifyFilterController.h"
#import "YYGPUImageFilterController.h"

@interface YYHomeViewController () <UITableViewDelegate,UITableViewDataSource>

/* <#description#> */
@property (nonatomic,strong) UITableView *tableView;
/* <#description#> */
@property (nonatomic,strong) NSArray *titleArr;

@end

@implementation YYHomeViewController


- (NSArray *)titleArr {
    if (_titleArr == nil) {
        _titleArr = [[NSArray alloc] initWithObjects:@"GPUImage原生美颜",@"美颜滤镜美颜", nil];
    }
    return _titleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect aRect = CGRectMake(0, 64, ScreenWidth, ScreenHeight);
    self.tableView = [[UITableView alloc] initWithFrame:aRect style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
}

//MARK:- TableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *mainCellIndentifier = @"mainCellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainCellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mainCellIndentifier];
    }
    
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, ScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:lineView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    switch (indexPath.row) {
        case 0: {
            YYGPUImageFilterController *gpuCtrl = [[YYGPUImageFilterController alloc] init];
            [self presentViewController:gpuCtrl animated:true completion:nil];
        }
            break;
        case 1: {
            YYBeautifyFilterController *beautyCtrl = [[YYBeautifyFilterController alloc] init];
            [self presentViewController:beautyCtrl animated:true completion:nil];
        }
            break;
        default:
            break;
    }
}


@end
