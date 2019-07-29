//
//  XuCollectionDateCell.m
//  XuCalendar
//
//  Created by xucg on 2019/7/22.
//  Copyright © 2019年 xucg. All rights reserved.
//

#import "XuCollectionDateCell.h"
#import <NSDate+DateTools.h>
#import "UIView+XuFrame.h"

@interface XuCollectionDateCell()

@property (nonatomic, strong) CAShapeLayer *bgLayer;
@property (nonatomic, strong) CAShapeLayer *dotLayer;
@property (nonatomic, strong) UILabel *dayLabel;

@end

@implementation XuCollectionDateCell

@synthesize dateFont;
@synthesize dateColor;
@synthesize selectedDateColor;
@synthesize selectedBgColor;
@synthesize dotColor;
@synthesize selectedDotColor;
@synthesize dotMarginBottom;
@synthesize dateCellPadding;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dayLabel.frame = self.bounds;
        [self.contentView addSubview:self.dayLabel];
        
        CGRect dotFrame = self.dotLayer.frame;
        dotFrame.origin.x = (frame.size.width - dotFrame.size.width) / 2;
        dotFrame.origin.y = frame.size.height - 10;
        self.dotLayer.frame = dotFrame;
        [self.contentView.layer addSublayer:self.dotLayer];
        
        self.bgLayer.fillColor = UIColor.greenColor.CGColor;
        [self.contentView.layer insertSublayer:self.bgLayer atIndex:0];
    }
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
     // 避免导航转换中断
    if (self.window) {
        // 避免bgLayer闪烁
        [CATransaction setDisableActions:YES];
    }
    self.isChecked = NO;
}

- (void)setDate:(NSDate *)date {
    _date = date;
    
    NSDate *today = [NSDate date];
    if ([date isSameDay:today]) {
        self.dayLabel.text = @"今";
    } else {
        self.dayLabel.text = [NSString stringWithFormat:@"%d", (int)date.day];
    }
}

- (void)setIsChecked:(BOOL)isChecked {
    _isChecked = isChecked;
    
    self.bgLayer.hidden = !isChecked;
    self.dayLabel.textColor = isChecked ? self.selectedDateColor : self.dateColor;
    self.dotLayer.fillColor = isChecked ? (self.selectedDotColor.CGColor ?: self.dotColor.CGColor) : self.dotColor.CGColor;
}

- (UILabel*)dayLabel {
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.textColor = UIColor.blackColor;
        _dayLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _dayLabel;
}

- (CAShapeLayer*)bgLayer {
    if (!_bgLayer) {
        _bgLayer = [CAShapeLayer layer];
        _bgLayer.hidden = YES;
    }
    
    return _bgLayer;
}

- (CAShapeLayer*)dotLayer {
    if (!_dotLayer) {
        CGRect tmpFrame = CGRectMake(0, 0, 4, 4);
        _dotLayer = [CAShapeLayer layer];
        _dotLayer.frame = tmpFrame;
        CGPathRef dotPath = [UIBezierPath bezierPathWithRoundedRect:tmpFrame cornerRadius:2].CGPath;
        _dotLayer.path = dotPath;
        _dotLayer.fillColor = UIColor.redColor.CGColor;
        _dotLayer.hidden = YES;
    }
    
    return _dotLayer;
}

- (void)setDateFont:(UIFont *)dateFont {
    self.dayLabel.font = dateFont;
}

- (void)setSelectedBgColor:(UIColor *)selectedBgColor {
    self.bgLayer.fillColor = selectedBgColor.CGColor;
}

- (void)setShowDot:(BOOL)showDot {
    self.dotLayer.hidden = !showDot;
}

- (void)setDotMarginBottom:(CGFloat)dotMarginBottom {
    CGRect tmpFrame = self.dotLayer.frame;
    tmpFrame.origin.y = self.xu_height - dotMarginBottom - 4;
    self.dotLayer.frame = tmpFrame;
}

- (void)setDateCellPadding:(CGFloat)dateCellPadding {
    CGFloat tmpWidth = MIN(self.xu_width, self.xu_height) - dateCellPadding*2;
    CGFloat tmpX = (self.xu_width - tmpWidth) / 2;
    CGFloat tmpY = (self.xu_height - tmpWidth) / 2;
    CGPathRef circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(tmpX, tmpY, tmpWidth, tmpWidth) cornerRadius:tmpWidth/2].CGPath;
    self.bgLayer.path = circlePath;
}

@end
