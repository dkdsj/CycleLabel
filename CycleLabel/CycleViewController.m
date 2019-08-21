//
//  CycleViewController.m
//  CycleLabel
//
//  Created by ZZ on 2019/8/21.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "CycleViewController.h"
#import "CycleLabelView.h"

@interface CycleViewController () <CycleLabelViewDelegate>
@property (nonatomic, strong) CycleLabelView *vCycleLabel;

@property (nonatomic, strong) NSArray<NSString *>* titles;
@end

@implementation CycleViewController


- (void)dealloc
{
    NSLog(@"CycleViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initView];
}

- (void)initView {
    _vCycleLabel = [[CycleLabelView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 100) direction:_type==1?CycleLabelDirectionUp:CycleLabelDirectionDown];
    _vCycleLabel.delegate = self;
    [self.view addSubview:_vCycleLabel];
    
    _titles = @[
                @"1五部门打击校闹",
                @"2阿里推迟香港IPO",
                @"3数字人民币初露真容",
                @"4逼迫9名学生交往",
                @"5三星Note10"
                ];
    [_vCycleLabel cycleLabelViewTitles:_titles];
}

- (void)cycleLabelViewScrollCurrentIndex:(NSInteger)index {
    NSLog(@"%zd - %@", index+1, _titles[index]);
}

- (void)cycleLabelViewTapOnUILable:(NSInteger)index {
    NSLog(@"tap on label index:%zd", index);
}

@end
