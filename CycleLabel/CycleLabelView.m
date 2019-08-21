//
//  CycleLabelView.m
//  CycleLabel
//
//  Created by ZZ on 2019/8/21.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "CycleLabelView.h"
#import "ProxyWeak.h"
#import "NSTimer+UnretainCycle.h"

@interface CycleLabelView()

@property (nonatomic, strong) UILabel *lbUp;
@property (nonatomic, strong) UILabel *lbDown;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL firstUp;//YES lbUp在上面 NO lbDown在上面
@property (nonatomic, assign) CycleLabelDirection direction;

@property (nonatomic, strong) NSArray<NSString *> *titles;

@end

@implementation CycleLabelView

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
    NSLog(@"cycle label view dealloc!");
}

- (instancetype)initWithFrame:(CGRect)frame direction:(CycleLabelDirection)direction {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViewWithDirection:direction];
        
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)initViewWithDirection:(CycleLabelDirection)direction  {
    _lbUp = [UILabel new];
    [self addSubview:_lbUp];
    
    _lbDown = [UILabel new];
    [self addSubview:_lbDown];
    
    _lbUp.textAlignment = 1;
    _lbDown.textAlignment = 1;
    
    _lbUp.userInteractionEnabled = YES;
    _lbDown.userInteractionEnabled = YES;
    
    _lbUp.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:.3];
    _lbDown.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:.3];
    
    __weak __typeof(self)weakSelf = self;
    _timer = [NSTimer ucSchedulTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf showMsg];
    }];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    _index = 1;
    _firstUp = YES;
    _direction = direction;
    
    [_lbUp addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnLabelGes:)]];
    [_lbDown addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnLabelGes:)]];
    
    
    _lbUp.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGFloat downY = (_direction==CycleLabelDirectionUp)?CGRectGetMaxY(_lbUp.frame):-self.frame.size.height;
    _lbDown.frame = CGRectMake(0, downY, self.frame.size.width, self.frame.size.height);
    
}
- (void)initView1 {
    _lbUp = [UILabel new];
    [self addSubview:_lbUp];
    
    _lbDown = [UILabel new];
    [self addSubview:_lbDown];
    
    _lbUp.textAlignment = 1;
    _lbDown.textAlignment = 1;
    
    _lbUp.userInteractionEnabled = YES;
    _lbDown.userInteractionEnabled = YES;
    
    _lbUp.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:.3];
    _lbDown.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:.3];
    
    _timer = [NSTimer timerWithTimeInterval:2 target:[ProxyWeak proxyWithTarget:self] selector:@selector(showMsg) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    _index = 1;
    _firstUp = YES;
    
    [_lbUp addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnLabelGes:)]];
    [_lbDown addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnLabelGes:)]];
    
}

- (void)cycleLabelViewTitles:(NSArray<NSString *> *)titles {
    if (titles.count==0) {
        [_timer invalidate];
        _timer = nil;
        return;
    }
    
    self.lbUp.text = titles.firstObject;
    
    if (titles.count>2) {
        self.lbDown.text = titles[1];
    } else {
        self.lbDown.text = titles.firstObject;
    }
    
    _titles = titles;
}

- (void)showMsg {

    NSString *title = _titles[_index++];
    NSLog(@"title:%@ index:%zd", title, _index);
    
    if (_index==_titles.count) {
        _index = 0;
    }
    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(cycleLabelViewScrollCurrentIndex:)]) {
//        [self.delegate cycleLabelViewScrollCurrentIndex:_index==0?0:_index-1];
//    }
    
    
    if (_direction==CycleLabelDirectionUp) {
        [self labelMoveDirectionUp:title];
    } else {
        [self labelMoveDirectionDown:title];
    }
    
    _firstUp = !_firstUp;
}

- (void)labelMoveDirectionUp:(NSString *)title {
    if (_firstUp) {
        [UIView animateWithDuration:.5 animations:^{
            CGRect frameDown = self.lbDown.frame;
            frameDown.origin.y = 0;
            self.lbDown.frame = frameDown;
            
            CGRect frameUp = self.lbUp.frame;
            frameUp.origin.y = -frameUp.size.height;
            self.lbUp.frame = frameUp;
        } completion:^(BOOL finished) {
            CGRect frame = self.lbUp.frame;
            frame.origin.y = frame.size.height;
            self.lbUp.frame = frame;
        }];
        
        self.lbDown.text = title;
    } else {
        [UIView animateWithDuration:.5 animations:^{
            CGRect frameUp = self.lbUp.frame;
            frameUp.origin.y = 0;
            self.lbUp.frame = frameUp;
            
            CGRect frameDown = self.lbDown.frame;
            frameDown.origin.y = -frameDown.size.height;
            self.lbDown.frame = frameDown;
        } completion:^(BOOL finished) {
            CGRect frame = self.lbUp.frame;
            frame.origin.y = frame.size.height;
            self.lbDown.frame = frame;
        }];
        
        self.lbUp.text = title;
    }
}

- (void)labelMoveDirectionDown:(NSString *)title {
    if (_firstUp) {
        [UIView animateWithDuration:.5 animations:^{
            CGRect frameDown = self.lbDown.frame;
            frameDown.origin.y = 0;
            self.lbDown.frame = frameDown;
            
            CGRect frameUp = self.lbUp.frame;
            frameUp.origin.y = frameUp.size.height;
            self.lbUp.frame = frameUp;
        } completion:^(BOOL finished) {
            CGRect frame = self.lbUp.frame;
            frame.origin.y = -frame.size.height;
            self.lbUp.frame = frame;
        }];
        
        self.lbDown.text = title;
    }  else {
        [UIView animateWithDuration:.5 animations:^{
            CGRect frameUp = self.lbUp.frame;
            frameUp.origin.y = 0;
            self.lbUp.frame = frameUp;
            
            CGRect frameDown = self.lbDown.frame;
            frameDown.origin.y = frameDown.size.height;
            self.lbDown.frame = frameDown;
        } completion:^(BOOL finished) {
            CGRect frame = self.lbDown.frame;
            frame.origin.y = -frame.size.height;
            self.lbDown.frame = frame;
        }];
        
        self.lbUp.text = title;
    }
}
     

- (void)tapOnLabelGes:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cycleLabelViewTapOnUILable:)]) {
        [self.delegate cycleLabelViewTapOnUILable:_index];
    }
}
     

@end
