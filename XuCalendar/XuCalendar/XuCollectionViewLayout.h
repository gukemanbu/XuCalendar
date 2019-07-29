//
//  XuCollectionViewLayout.h
//  XuCalendar
//
//  Created by xucg on 2019/7/22.
//  Copyright © 2019年 xucg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XuCollectionViewLayout : UICollectionViewFlowLayout
// 一页展示行数
@property (nonatomic, assign) NSInteger row;
// 一页展示列数
@property (nonatomic, assign) NSInteger column;
// 一页的宽度
@property (nonatomic, assign) CGFloat pageWidth;

@end

NS_ASSUME_NONNULL_END
