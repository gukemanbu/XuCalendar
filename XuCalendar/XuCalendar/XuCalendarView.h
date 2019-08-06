//
//  XuCalendarView.h
//  XuCalendar
//
//  Created by xucg on 2019/7/22.
//  Copyright © 2019年 xucg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XuCalendarDelegate.h"

typedef NS_ENUM(NSUInteger, XuCalendarViewMode) {
    XuCalendarViewModeMonth,
    XuCalendarViewModeWeek
};

@interface XuCalendarView : UIView <XuCalendarUIDelegate>

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) UIFont *weekBarFont;
@property (nonatomic, strong) UIColor *weekBarTextColor;
@property (nonatomic, assign) XuCalendarViewMode mode;

@property (nonatomic, weak) id<XuCalendarViewDelegate> delegate;
@property (nonatomic, copy) void (^monthDidChanged)(NSDate*);

- (instancetype)initWithFrame:(CGRect)frame weekBarHeight:(CGFloat)weekBarHeight;

@end
