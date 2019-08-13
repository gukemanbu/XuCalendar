//
//  XuCalendarView.m
//  XuCalendar
//
//  Created by xucg on 2019/7/22.
//  Copyright © 2019年 xucg. All rights reserved.
//
//  日历

#import "XuCalendarView.h"
#import "XuCalendarWeekBar.h"
#import "XuCollectionMonthView.h"
#import "XuCollectionViewLayout.h"
#import "UIView+XuFrame.h"
#import "XuCollectionWeekView.h"
#import <NSDate+DateTools.h>

@interface XuCalendarView ()

@property (nonatomic, strong) XuCalendarWeekBar *weekBar;
@property (nonatomic, assign) CGFloat weekBarHeight;

@property (nonatomic, strong) XuCollectionViewLayout *monthLayout;
@property (nonatomic, strong) XuCollectionMonthView *monthView;
@property (nonatomic, strong) XuCollectionViewLayout *weekLayout;
@property (nonatomic, strong) XuCollectionWeekView *weekView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, strong) NSDate *stayDate; // 要停留的日期
@property (nonatomic, assign) int stayRow;      // 要停留的行

@property (nonatomic, assign) CGFloat minHeight;
@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, assign) CGFloat originalHeight;
@property (nonatomic, assign) CGFloat originalTop;
@property (nonatomic, assign) BOOL isPanUp;

@end

@implementation XuCalendarView

- (instancetype)initWithFrame:(CGRect)frame weekBarHeight:(CGFloat)weekBarHeight {
    self = [super initWithFrame:frame];
    if (self) {
        self.weekBarHeight = weekBarHeight;
        self.weekBar.hidden = (weekBarHeight == 0);
        
        self.maxHeight = frame.size.height;
        self.minHeight = self.weekBar.xu_height + (frame.size.height - self.weekBar.xu_height) / 6;
        
        [self addSubview:self.weekBar];
        
        [self initMonthView];
        [self initWeekView];
        
        self.panGesture.enabled = YES;
        self.clipsToBounds = YES;
        
        [self bringSubviewToFront:self.weekBar];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame weekBarHeight:30];
}

- (void)initMonthView {
    CGFloat tmpWidth = self.xu_width / 7;
    CGFloat tmpHeight = (self.xu_height - self.weekBar.xu_height) / 6;
    self.monthLayout.itemSize = CGSizeMake(tmpWidth, tmpHeight);
    
    CGRect tmpFrame = self.bounds;
    tmpFrame.origin.y = self.weekBar.xu_height;
    tmpFrame.size.height -= self.weekBar.xu_height;
    self.monthView.frame = tmpFrame;
    [self addSubview:self.monthView];
}

- (void)initWeekView {
    CGFloat tmpWidth = self.xu_width / 7;
    CGFloat tmpHeight = (self.xu_height - self.weekBar.xu_height) / 6;
    self.weekLayout.itemSize = CGSizeMake(tmpWidth, tmpHeight);
    
    CGRect tmpFrame = self.bounds;
    tmpFrame.origin.y = self.weekBar.xu_height;
    tmpFrame.size.height -= self.weekBar.xu_height;
    self.weekView.frame = tmpFrame;
    [self addSubview:self.weekView];
    
    self.weekView.hidden = YES;
}

- (XuCalendarWeekBar*)weekBar {
    if (!_weekBar) {
        _weekBar = [[XuCalendarWeekBar alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.weekBarHeight)];
    }
    
    return _weekBar;
}

- (XuCollectionViewLayout*)monthLayout {
    if (!_monthLayout) {
        _monthLayout = [[XuCollectionViewLayout alloc] init];
        _monthLayout.row = 6;
        _monthLayout.column = 7;
        _monthLayout.sectionInset = UIEdgeInsetsZero;
        _monthLayout.minimumLineSpacing = 0;
        _monthLayout.minimumInteritemSpacing = 0;
        _monthLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    return _monthLayout;
}

- (XuCollectionMonthView*)monthView {
    if (!_monthView) {
        _monthView = [[XuCollectionMonthView alloc] initWithFrame:self.bounds collectionViewLayout:self.monthLayout];
        _monthView.pagingEnabled = YES;
        _monthView.contentInset = UIEdgeInsetsZero;
        _monthView.showsVerticalScrollIndicator = NO;
        _monthView.showsHorizontalScrollIndicator = NO;
        _monthView.dateCellPadding = 2;
        _monthView.dotMarginBottom = 4;
        
        __weak typeof(self) weakSelf = self;
        _monthView.monthDidChanged = ^(NSDate * _Nonnull date) {
            NSDate *firstDay = [date dateBySubtractingDays:date.day-1];
            NSDate *lastDay = [firstDay dateByAddingDays:[date daysInMonth]-1];
            
            // 如果此月中有选中的日期，则收起时，默认停在选中行
            if ([weakSelf.weekView.selectedDate isLaterThanOrEqualTo:firstDay] && [weakSelf.weekView.selectedDate isEarlierThanOrEqualTo:lastDay]) {
                weakSelf.stayDate = weakSelf.weekView.selectedDate;
            } else {
                weakSelf.stayDate = date;
            }
            
            [weakSelf.weekView scrollToWeek:weakSelf.stayDate];
            
            if (weakSelf.monthDidChanged) {
                weakSelf.monthDidChanged(date);
            }
        };
        
        _monthView.dateDidSelected = ^(NSDate * _Nonnull date) {
            weakSelf.stayDate = date;
            weakSelf.weekView.selectedDate = date;
        };
    }
    
    return _monthView;
}

- (XuCollectionViewLayout*)weekLayout {
    if (!_weekLayout) {
        _weekLayout = [[XuCollectionViewLayout alloc] init];
        _weekLayout.row = 1;
        _weekLayout.column = 7;
        _weekLayout.sectionInset = UIEdgeInsetsZero;
        _weekLayout.minimumLineSpacing = 0;
        _weekLayout.minimumInteritemSpacing = 0;
        _weekLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    return _weekLayout;
}

- (XuCollectionWeekView*)weekView {
    if (!_weekView) {
        _weekView = [[XuCollectionWeekView alloc] initWithFrame:self.bounds collectionViewLayout:self.weekLayout];
        _weekView.pagingEnabled = YES;
        _weekView.contentInset = UIEdgeInsetsZero;
        _weekView.showsVerticalScrollIndicator = NO;
        _weekView.showsHorizontalScrollIndicator = NO;
        _weekView.dateCellPadding = 2;
        _weekView.dotMarginBottom = 4;
        
        __weak typeof(self) weakSelf = self;
        _weekView.weekDidChanged = ^(NSDate * _Nonnull date) {
            weakSelf.stayDate = date;
            [weakSelf.monthView scrollToMonth:date];
            if (weakSelf.monthDidChanged) {
                weakSelf.monthDidChanged(date);
            }
        };
        
        _weekView.dateDidSelected = ^(NSDate * _Nonnull date) {
            weakSelf.stayDate = date;
            weakSelf.monthView.selectedDate = date;
        };
    }
    
    return _weekView;
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.originalHeight = self.xu_height;
        self.originalTop = self.monthView.xu_top;
        self.stayRow = [self.monthView rowOfDate:self.stayDate];
        if (self.monthView.hidden) {
            CGFloat tmpTop = self.weekBar.xu_height - self.monthLayout.itemSize.height*(self.stayRow-1);
            self.monthView.xu_top = tmpTop;
        }
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self];
        CGFloat absX = fabs(translation.x);
        CGFloat absY = fabs(translation.y);
        if (absY > absX) {
            self.monthView.hidden = NO;
            self.weekView.hidden = YES;
            
            CGPoint velocity = [gesture velocityInView:gesture.view];
            if (velocity.y != 0) {
                self.isPanUp = velocity.y < 0;
            }
            
            CGFloat tmpHeight = self.originalHeight + translation.y;
            if (tmpHeight < self.minHeight) {
                tmpHeight = self.minHeight;
            }
            
            if (tmpHeight > self.maxHeight) {
                tmpHeight = self.maxHeight;
            }

            self.xu_height = tmpHeight;
            
            CGFloat tmpTop = (self.monthLayout.itemSize.height*self.stayRow + self.weekBar.xu_height) - tmpHeight;
            if (tmpTop >= 0) {
                self.monthView.xu_top = -tmpTop + self.weekBar.xu_height;
            }
        }
    } else if (gesture.state == UIGestureRecognizerStateEnded ||
               gesture.state == UIGestureRecognizerStateCancelled ||
               gesture.state == UIGestureRecognizerStateFailed) {
        CGFloat tmpHeight = self.maxHeight;
        CGFloat tmpTop = self.weekBar.xu_height;
        if (self.isPanUp) {
            tmpHeight = self.minHeight;
            tmpTop = self.weekBar.xu_height - self.monthLayout.itemSize.height*(self.stayRow-1);
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            self.xu_height = tmpHeight;
            self.monthView.xu_top = tmpTop;
        } completion:^(BOOL finished) {
            self.monthView.hidden = self.isPanUp;
            self.weekView.hidden = !self.isPanUp;
        }];
    }
}

- (UIPanGestureRecognizer*)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        _panGesture.minimumNumberOfTouches = 1;
        _panGesture.maximumNumberOfTouches = 1;
        [self addGestureRecognizer:_panGesture];
    }
    
    return _panGesture;
}

- (void)setSelectedDate:(NSDate *)selectedDate {
    self.monthView.selectedDate = selectedDate;
    self.weekView.selectedDate = selectedDate;
}

- (void)setDelegate:(id<XuCalendarViewDelegate>)delegate {
    self.monthView.xu_delegate = delegate;
    self.weekView.xu_delegate = delegate;
}

- (void)setMode:(XuCalendarViewMode)mode {
    _mode = mode;
    
    CGFloat tmpHeight = 0;
    CGFloat tmpTop = 0;
    
    if (mode == XuCalendarViewModeMonth) {
        tmpHeight = self.maxHeight;
        tmpTop = self.weekBar.xu_height;
    } else {
        tmpHeight = self.minHeight;
        tmpTop = self.weekBar.xu_height - self.monthLayout.itemSize.height*(self.stayRow-1);
        
        self.monthView.hidden = YES;
        self.weekView.hidden = NO;
    }
    
    self.xu_height = tmpHeight;
    self.monthView.xu_top = tmpTop;
    
    self.monthView.hidden = mode != XuCalendarViewModeMonth;
    self.weekView.hidden = mode != XuCalendarViewModeWeek;
}

- (void)setDisableVerticalScroll:(BOOL)disableVerticalScroll {
    _disableVerticalScroll = disableVerticalScroll;
    self.panGesture.enabled = !disableVerticalScroll;
}

- (void)setDisableHorizontalScroll:(BOOL)disableHorizontalScroll {
    _disableHorizontalScroll = disableHorizontalScroll;
    self.weekView.scrollEnabled = !disableHorizontalScroll;
    self.monthView.scrollEnabled = !disableHorizontalScroll;
}

#pragma mark - ui相关属性

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    
    self.weekBar.backgroundColor = backgroundColor;
    self.monthView.backgroundColor = backgroundColor;
    self.weekView.backgroundColor = backgroundColor;
}

- (void)setWeekBarFont:(UIFont *)weekBarFont {
    self.weekBar.textFont = weekBarFont;
}

- (void)setWeekBarTextColor:(UIColor *)weekBarTextColor {
    self.weekBar.textColor = weekBarTextColor;
}

- (void)setDateFont:(UIFont *)dateFont {
    self.monthView.dateFont = dateFont;
    self.weekView.dateFont = dateFont;
}

- (void)setDateColor:(UIColor *)dateColor {
    self.monthView.dateColor = dateColor;
    self.weekView.dateColor = dateColor;
}

- (void)setPlaceholderDateColor:(UIColor *)placeholderDateColor {
    self.monthView.placeholderDateColor = placeholderDateColor;
}

- (void)setSelectedDateColor:(UIColor *)selectedDateColor {
    self.monthView.selectedDateColor = selectedDateColor;
    self.weekView.selectedDateColor = selectedDateColor;
}

- (void)setSelectedBgColor:(UIColor *)selectedBgColor {
    self.monthView.selectedBgColor = selectedBgColor;
    self.weekView.selectedBgColor = selectedBgColor;
}

- (void)setDotColor:(UIColor *)dotColor {
    self.monthView.dotColor = dotColor;
    self.weekView.dotColor = dotColor;
}

- (void)setSelectedDotColor:(UIColor *)selectedDotColor {
    self.monthView.selectedDotColor = selectedDotColor;
    self.weekView.selectedDotColor = selectedDotColor;
}

- (void)setDotMarginBottom:(CGFloat)dotMarginBottom {
    self.monthView.dotMarginBottom = dotMarginBottom;
    self.weekView.dotMarginBottom = dotMarginBottom;
}

- (void)setDateCellPadding:(CGFloat)dateCellPadding {
    self.monthView.dateCellPadding = dateCellPadding;
    self.weekView.dateCellPadding = dateCellPadding;
}

@end
