//
//  CycleLabelView.h
//  CycleLabel
//
//  Created by ZZ on 2019/8/21.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CycleLabelViewDelegate <NSObject>

- (void)cycleLabelViewTapOnUILable:(NSInteger)index;
- (void)cycleLabelViewScrollCurrentIndex:(NSInteger)index;

@end

@interface CycleLabelView : UIView

- (void)cycleLabelViewTitles:(NSArray<NSString *> *)titles;

@property (nonatomic, weak) id <CycleLabelViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
