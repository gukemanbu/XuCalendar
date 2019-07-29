//
//  XuCollectionMonthView.h
//  XuCalendar
//
//  Created by xucg on 2019/7/22.
//  Copyright © 2019年 xucg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XuCalendarDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface XuCollectionMonthView : UICollectionView <XuCalendarUIDelegate>

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, copy) void (^monthDidChanged)(NSDate*);
@property (nonatomic, copy) void (^dateDidSelected)(NSDate*);
@property (nonatomic, weak) id<XuCalendarViewDelegate> xu_delegate;

// 跳转到某月
- (void)scrollToMonth:(NSDate*)month;
- (int)rowOfDate:(NSDate*)date;

@end

NS_ASSUME_NONNULL_END
