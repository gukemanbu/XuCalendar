//
//  UIView+BHFrame.h
//  BHKit
//
//  Created by xucg on 2019/2/23.
//

#import <UIKit/UIKit.h>

@interface UIView (XuFrame)

@property (assign, nonatomic) CGFloat xu_left;
@property (assign, nonatomic) CGFloat xu_top;
@property (assign, nonatomic) CGFloat xu_right;
@property (assign, nonatomic) CGFloat xu_bottom;
@property (assign, nonatomic) CGFloat xu_width;
@property (assign, nonatomic) CGFloat xu_height;
@property (assign, nonatomic) CGFloat xu_centerX;
@property (assign, nonatomic) CGFloat xu_centerY;
@property (assign, nonatomic) CGPoint xu_origin;
@property (assign, nonatomic) CGSize xu_size;

@property (assign, nonatomic, readonly) CGPoint xu_leftTop;
@property (assign, nonatomic, readonly) CGPoint xu_leftBottom;
@property (assign, nonatomic, readonly) CGPoint xu_rightTop;
@property (assign, nonatomic, readonly) CGPoint xu_rightBottom;

@end
