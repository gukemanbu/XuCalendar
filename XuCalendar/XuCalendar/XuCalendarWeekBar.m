//
//  XuCalendarWeekBar.m
//  XuCalendar
//
//  Created by xucg on 2019/7/23.
//  Copyright © 2019年 xucg. All rights reserved.
//
//  日历星期栏

#import "XuCalendarWeekBar.h"

@implementation XuCalendarWeekBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addWeekLabels];
    }
    
    return self;
}

- (void)addWeekLabels {
    NSArray *weekArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    CGFloat tmpWidth = self.bounds.size.width / 7;
    for (int i=0; i<7; i++) {
        CGRect tmpFrame = self.bounds;
        tmpFrame.origin.x = i * tmpWidth;
        tmpFrame.size.width = tmpWidth;
        UILabel *weekLabel = [[UILabel alloc] initWithFrame:tmpFrame];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        weekLabel.textColor = UIColor.blackColor;
        weekLabel.text = weekArray[i];
        [self addSubview:weekLabel];
    }
}

- (void)setTextFont:(UIFont *)textFont {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.font = textFont;
    }];
}

- (void)setTextColor:(UIColor *)textColor {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.textColor = textColor;
    }];
}

@end
