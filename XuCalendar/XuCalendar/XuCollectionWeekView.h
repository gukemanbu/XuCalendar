//
//  XuCollectionWeekView.h
//  XucgCalendar
//
//  Created by xucg on 2019/7/23.
//  Copyright © 2019年 xucg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XuCalendarDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface XuCollectionWeekView : UICollectionView <XuCalendarUIDelegate>

// 选中日期
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, copy) void (^weekDidChanged)(NSDate*);
@property (nonatomic, copy) void (^dateDidSelected)(NSDate*);
@property (nonatomic, weak) id<XuCalendarViewDelegate> xu_delegate;

// 跳转到某周
- (void)scrollToWeek:(NSDate*)week;

@end

NS_ASSUME_NONNULL_END
