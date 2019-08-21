//
//  ViewController.m
//  CycleLabel
//
//  Created by ZZ on 2019/8/21.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "ViewController.h"
#import "CycleViewController.h"

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController pushViewController:[CycleViewController new] animated:YES];
}

- (IBAction)pushCycleVC:(UIButton *)sender {
    CycleViewController *vc = [CycleViewController new];
    vc.type = (sender.tag==11)?1:2;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
