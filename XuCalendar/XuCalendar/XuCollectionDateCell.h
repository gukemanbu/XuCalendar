//
//  XuCollectionDateCell.h
//  XuCalendar
//
//  Created by xucg on 2019/7/22.
//  Copyright © 2019年 xucg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XuCalendarDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface XuCollectionDateCell : UICollectionViewCell <XuCalendarUIDelegate>

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, assign) BOOL isChecked;
@property (nonatomic, assign) BOOL showDot;

@end

NS_ASSUME_NONNULL_END
