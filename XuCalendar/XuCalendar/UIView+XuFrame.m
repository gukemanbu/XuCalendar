//
//  UIView+BHFrame.m
//  BHKit
//
//  Created by xucg on 2019/2/23.
//

#import "UIView+XuFrame.h"

@implementation UIView (XuFrame)

- (CGFloat)xu_left {
    return self.frame.origin.x;
}

- (void)setXu_left:(CGFloat)xu_left {
    CGRect frame = self.frame;
    frame.origin.x = xu_left;
    self.frame = frame;
}

- (CGFloat)xu_top {
    return self.frame.origin.y;
}

- (void)setXu_top:(CGFloat)xu_top {
    CGRect frame = self.frame;
    frame.origin.y = xu_top;
    self.frame = frame;
}

- (CGFloat)xu_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setXu_right:(CGFloat)xu_right {
    CGRect frame = self.frame;
    frame.origin.x = xu_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)xu_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setXu_bottom:(CGFloat)xu_bottom {
    CGRect frame = self.frame;
    frame.origin.y = xu_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)xu_width {
    return self.frame.size.width;
}

- (void)setXu_width:(CGFloat)xu_width {
    CGRect frame = self.frame;
    frame.size.width = xu_width;
    self.frame = frame;
}

- (CGFloat)xu_height {
    return self.frame.size.height;
}

- (void)setXu_height:(CGFloat)xu_height {
    CGRect frame = self.frame;
    frame.size.height = xu_height;
    self.frame = frame;
}

- (CGFloat)xu_centerX {
    return self.center.x;
}

- (void)setXu_centerX:(CGFloat)xu_centerX {
    self.center = CGPointMake(xu_centerX, self.center.y);
}

- (CGFloat)xu_centerY {
    return self.center.y;
}

- (void)setXu_centerY:(CGFloat)xu_centerY {
    self.center = CGPointMake(self.center.x, xu_centerY);
}

- (CGPoint)xu_origin {
    return self.frame.origin;
}

- (void)setXu_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)xu_size {
    return self.frame.size;
}

- (void)setXu_size:(CGSize)xu_size {
    CGRect frame = self.frame;
    frame.size = xu_size;
    self.frame = frame;
}

- (CGPoint)xu_leftTop {
    return CGPointMake(self.xu_left, self.xu_top);
}

- (CGPoint)xu_leftBottom {
    return CGPointMake(self.xu_left, self.xu_top + self.xu_height);
}

- (CGPoint)xu_rightTop {
    return CGPointMake(self.xu_left + self.xu_width, self.xu_top);
}

- (CGPoint)xu_rightBottom {
    return CGPointMake(self.xu_left + self.xu_width, self.xu_top + self.xu_height);
}

@end
