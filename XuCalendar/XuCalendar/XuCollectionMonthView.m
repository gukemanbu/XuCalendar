//
//  XuCollectionMonthView.m
//  XuCalendar
//
//  Created by xucg on 2019/7/22.
//  Copyright © 2019年 xucg. All rights reserved.
//
//  日历

#import "XuCollectionMonthView.h"
#import "XuCollectionDateCell.h"
#import <NSDate+DateTools.h>
#import "UIView+XuFrame.h"

// 每页的天数 6行7列
#define kDaysOfPage (6*7)

@interface XuCollectionMonthView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSMutableArray<NSDate*> *dateArray;

@end

@implementation XuCollectionMonthView

@synthesize dateFont;
@synthesize dateColor;
@synthesize selectedDateColor;
@synthesize selectedBgColor;
@synthesize dotColor;
@synthesize selectedDotColor;
@synthesize placeholderDateColor;
@synthesize dotMarginBottom;
@synthesize dateCellPadding;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        if (@available(iOS 10.0, *)) {
            self.prefetchingEnabled = NO;
        }
        self.scrollsToTop = NO;
        
        NSDate *today = [NSDate date];
        NSDate *preMonth = [today dateBySubtractingMonths:1];
        NSDate *nextMonth = [today dateByAddingMonths:1];
        [self.dateArray addObjectsFromArray:[self monthArrayFor:preMonth]];
        [self.dateArray addObjectsFromArray:[self monthArrayFor:today]];
        [self.dateArray addObjectsFromArray:[self monthArrayFor:nextMonth]];
        
        [self registerClass:XuCollectionDateCell.class forCellWithReuseIdentifier:@"XuCollectionDateCell"];
        self.dataSource = self;
        self.delegate = self;
    }
    
    return self;
}

- (NSArray*)monthArrayFor:(NSDate*)month {
    NSDate *firstDay = [month dateBySubtractingDays:month.day-1];
    
    // weekday是从1开始的，所以要减1
    NSInteger offsetDay = (int)firstDay.weekday - 1;
    if (offsetDay == 0) {
        offsetDay = 7;
    }
    
    NSDate *startDay = [firstDay dateBySubtractingDays:offsetDay];
    
    // 每个月都要展示6行7列
    NSMutableArray<NSDate*> *monthArray = [NSMutableArray arrayWithCapacity:kDaysOfPage];
    for (int i=0; i<kDaysOfPage; i++) {
        NSDate *tmpDate = [startDay dateByAddingDays:i];
        [monthArray addObject:tmpDate];
    }
    
    return monthArray.copy;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dateArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XuCollectionDateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XuCollectionDateCell" forIndexPath:indexPath];
    NSDate *curDate = self.dateArray[indexPath.row];
    cell.dateCellPadding = self.dateCellPadding;
    
    NSDate *tmpMonth = nil;
    if (indexPath.row < kDaysOfPage) {
        tmpMonth = self.dateArray[15];
    } else if (indexPath.row < kDaysOfPage*2) {
        tmpMonth = self.dateArray[kDaysOfPage+15];
    } else {
        tmpMonth = self.dateArray[kDaysOfPage*2+15];
    }
    
    BOOL isSameMonth = [self isInSameMonth:curDate month:tmpMonth];
    
    cell.date = curDate;
    cell.dateFont = self.dateFont;
    cell.dateColor = isSameMonth ? self.dateColor : self.placeholderDateColor;
    cell.selectedDateColor = self.selectedDateColor;
    cell.selectedBgColor = self.selectedBgColor;
    cell.selectedDotColor = self.selectedDotColor;
    cell.dotMarginBottom = self.dotMarginBottom;
    
    BOOL showDot = NO;
    if ([self.xu_delegate respondsToSelector:@selector(xu_numberOfDotForDate:)]) {
        int i = [self.xu_delegate xu_numberOfDotForDate:curDate];
        showDot = i;
    }
    cell.showDot = showDot;
    if (showDot) {
        if ([self.xu_delegate respondsToSelector:@selector(xu_colorOfDotForDate:)]) {
            cell.dotColor = [self.xu_delegate xu_colorOfDotForDate:curDate];
        } else {
            cell.dotColor = self.dotColor;
        }
    }
    
    cell.isChecked = [self.selectedDate isSameDay:curDate];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectedDate = self.dateArray[indexPath.row];
    [self reloadData];
    
    if (self.dateDidSelected) {
        self.dateDidSelected(self.selectedDate);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int pageIdx = scrollView.contentOffset.x / scrollView.frame.size.width;
    NSDate *someday = self.dateArray[pageIdx * kDaysOfPage + 15];
    
    // 翻到前一个月时
    if (pageIdx == 0) {
        [self addPreMonthBy:someday];
        
        // 使collection永远处于中间的月
        self.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
        [self reloadData];
    }
    // 翻到下一个月
    else if (pageIdx == 2) {
        [self addNextMonthBy:someday];
        
        // 使collection永远处于中间的月
        self.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
        [self reloadData];
    }
    
    if (self.monthDidChanged) {
        NSDate *firstDay = [someday dateBySubtractingDays:someday.day-1];
        self.monthDidChanged(firstDay);
    }
}

- (void)addPreMonthBy:(NSDate*)someday {
    NSDate *preMonth = [someday dateBySubtractingMonths:1];
    NSMutableArray<NSDate*> *tmpArray = [NSMutableArray arrayWithCapacity:kDaysOfPage*3];
    [tmpArray addObjectsFromArray:[self monthArrayFor:preMonth]];
    
    // 从dateArray里去掉最后一个月
    for (int i=0; i<kDaysOfPage; i++) {
        [self.dateArray removeLastObject];
    }
    
    // 在前面补一个月
    [tmpArray addObjectsFromArray:self.dateArray];
    [self.dateArray removeAllObjects];
    [self.dateArray addObjectsFromArray:tmpArray];
}

- (void)addNextMonthBy:(NSDate*)someday {
    NSDate *nextMonth = [someday dateByAddingMonths:1];
    NSMutableArray<NSDate*> *tmpArray = [NSMutableArray arrayWithCapacity:kDaysOfPage*3];
    [tmpArray addObjectsFromArray:[self monthArrayFor:nextMonth]];
    // 从dateArray里去掉第一个月
    for (int i=0; i<kDaysOfPage; i++) {
        [self.dateArray removeObjectAtIndex:0];
    }
    // 在后面补一个月
    [self.dateArray addObjectsFromArray:tmpArray];
}

- (NSMutableArray*)dateArray {
    if (!_dateArray) {
        // 缓存3页数据
        _dateArray = [NSMutableArray arrayWithCapacity:kDaysOfPage*3];
    }
    
    return _dateArray;
}

- (BOOL)isInSameMonth:(NSDate*)month1 month:(NSDate*)month2 {
    NSDate *firstDay = [month1 dateBySubtractingDays:month1.day-1];
    NSDate *lastDay = [firstDay dateByAddingDays:firstDay.daysInMonth-1];
    
    BOOL isExist = NO;
    if ([month2 isLaterThanOrEqualTo:firstDay] && [month2 isEarlierThanOrEqualTo:lastDay]) {
        isExist = YES;
    }
    
    return isExist;
}

- (void)setSelectedDate:(NSDate *)selectedDate {
    _selectedDate = selectedDate;

    if (selectedDate == nil) {
        return;
    }
    
    [self scrollToMonth:selectedDate];
    
    if (!self.isHidden && self.monthDidChanged) {
        self.monthDidChanged(selectedDate);
    }
}

- (void)scrollToMonth:(NSDate*)month {
    // 是否在当前月
    NSDate *curMonth = self.dateArray[kDaysOfPage + 15];
    if ([self isInSameMonth:month month:curMonth]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.contentOffset = CGPointMake(self.xu_width, 0);
            [self reloadData];
        });
        return;
    }
    
    // 是否在前一个月
    NSDate *preMonth = self.dateArray[15];
    BOOL isExist0 = [self isInSameMonth:month month:preMonth];
    
    // 是否在下一个月
    NSDate *nextMonth = self.dateArray[kDaysOfPage*2 + 15];
    BOOL isExist1 = [self isInSameMonth:month month:nextMonth];
    
    if (isExist0 || isExist1) {
        int pageIdx = isExist0 ? 0 : 2;
        // 先动画跳转
        CGFloat offsetX = self.xu_width * pageIdx;
        [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        
        if (pageIdx == 0) {
            [self addPreMonthBy:month];
        } else if (pageIdx == 2) {
            [self addNextMonthBy:month];
        }
        
        // 再刷新数据，永远显示中间页
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.contentOffset = CGPointMake(self.xu_width, 0);
            [self reloadData];
        });
    } else {
        // 如果选中的日期较早，则向左滑动，否则向右滑动
        if ([month isEarlierThan:self.dateArray[0]]) {
            [self setContentOffset:CGPointMake(0, 0) animated:YES];
        } else {
            [self setContentOffset:CGPointMake(self.xu_width*2, 0) animated:YES];
        }
        
        // 接着调整数据，保留3页
        [self.dateArray removeAllObjects];
        
        NSDate *preMonth = [month dateBySubtractingMonths:1];
        NSDate *nextMonth = [month dateByAddingMonths:1];
        [self.dateArray addObjectsFromArray:[self monthArrayFor:preMonth]];
        [self.dateArray addObjectsFromArray:[self monthArrayFor:month]];
        [self.dateArray addObjectsFromArray:[self monthArrayFor:nextMonth]];
        
        // 默认停在中间
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.contentOffset = CGPointMake(self.xu_width, 0);
            [self reloadData];
        });
    }
}

- (int)rowOfDate:(NSDate*)date {
    int idx = 0;
    // 从当前页找
    for (int i=kDaysOfPage; i<kDaysOfPage+kDaysOfPage; i++) {
        NSDate *tmpDate = self.dateArray[i];
        if ([tmpDate isSameDay:date]) {
            idx = i - kDaysOfPage;
            break;
        }
    }
    
    int row = idx / 7 + 1;
    return row;
}

@end
