//
//  XuCalendarDelegate.h
//  XucgCalendar
//
//  Created by xucg on 2019/7/25.
//  Copyright © 2019年 xucg. All rights reserved.
//

#import <UIKit/UIkit.h>

@protocol XuCalendarUIDelegate <NSObject>

@optional
@property (nonatomic, strong) UIFont *dateFont;
@property (nonatomic, strong) UIColor *dateColor;
@property (nonatomic, strong) UIColor *placeholderDateColor;
@property (nonatomic, strong) UIColor *selectedDateColor;
@property (nonatomic, strong) UIColor *selectedBgColor;
@property (nonatomic, strong) UIColor *dotColor;
@property (nonatomic, strong) UIColor *selectedDotColor;
@property (nonatomic, assign) CGFloat dotMarginBottom;
@property (nonatomic, assign) CGFloat dateCellPadding;

@end


@protocol XuCalendarViewDelegate <NSObject>

@optional
- (int)xu_numberOfDotForDate:(NSDate*)date;
- (UIColor*)xu_colorOfDotForDate:(NSDate*)date;

@end
