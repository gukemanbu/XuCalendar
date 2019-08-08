//
//  XuCollectionWeekView.m
//  XucgCalendar
//
//  Created by xucg on 2019/7/23.
//  Copyright © 2019年 xucg. All rights reserved.
//
//  日历周视图

#import "XuCollectionWeekView.h"
#import "XuCollectionDateCell.h"
#import <NSDate+DateTools.h>
#import "UIView+XuFrame.h"

// 每页的天数
#define kDaysOfPage 7

@interface XuCollectionWeekView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSMutableArray<NSDate*> *dateArray;

@end

@implementation XuCollectionWeekView

@synthesize dateFont;
@synthesize dateColor;
@synthesize selectedDateColor;
@synthesize selectedBgColor;
@synthesize dotColor;
@synthesize selectedDotColor;
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
        NSDate *preWeek = [today dateBySubtractingWeeks:1];
        NSDate *nextWeek = [today dateByAddingWeeks:1];
        [self.dateArray addObjectsFromArray:[self weekArrayFor:preWeek]];
        [self.dateArray addObjectsFromArray:[self weekArrayFor:today]];
        [self.dateArray addObjectsFromArray:[self weekArrayFor:nextWeek]];
        
        [self registerClass:XuCollectionDateCell.class forCellWithReuseIdentifier:@"XuCollectionDateCell"];
        self.dataSource = self;
        self.delegate = self;
    }
    
    return self;
}

- (NSArray*)weekArrayFor:(NSDate*)someday {
    NSDate *sunday = [someday dateBySubtractingDays:someday.weekday-1];

    NSMutableArray<NSDate*> *weekArray = [NSMutableArray arrayWithCapacity:kDaysOfPage];
    for (int i=0; i<kDaysOfPage; i++) {
        NSDate *tmpDate = [sunday dateByAddingDays:i];
        [weekArray addObject:tmpDate];
    }
    
    return weekArray.copy;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dateArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XuCollectionDateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XuCollectionDateCell" forIndexPath:indexPath];
    cell.dateCellPadding = self.dateCellPadding;
    
    NSDate *curDate = self.dateArray[indexPath.row];
    cell.date = curDate;
    cell.dateFont = self.dateFont;
    cell.dateColor = self.dateColor;
    cell.selectedDateColor = self.selectedDateColor;
    cell.selectedBgColor = self.selectedBgColor;
    cell.dotColor = self.dotColor;
    cell.selectedDotColor = self.selectedDotColor;
    cell.dotMarginBottom = self.dotMarginBottom;
    
    BOOL showDot = NO;
    if ([self.xu_delegate respondsToSelector:@selector(xu_numberOfDotForDate:)]) {
        showDot = [self.xu_delegate xu_numberOfDotForDate:curDate];
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
    self.selectedDate = self.dateArray[indexPath.row];
    
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
    int pageIdx = scrollView.contentOffset.x / scrollView.xu_width;
    NSDate *someday = self.dateArray[pageIdx * kDaysOfPage + 3];
    
    // 翻到前一周
    if (pageIdx == 0) {
        if (self.weekDidChanged) {
            self.weekDidChanged(self.dateArray.firstObject);
        }
        
        [self addPreWeekBy:someday];
        
        // 使collection永远处于中间的周
        self.contentOffset = CGPointMake(scrollView.xu_width, 0);
        [self reloadData];
    }
    // 翻到下一周
    else if (pageIdx == 2) {
        if (self.weekDidChanged) {
            self.weekDidChanged(self.dateArray.lastObject);
        }
        
        [self addNextWeekBy:someday];
        
        // 使collection永远处于中间的周
        self.contentOffset = CGPointMake(scrollView.xu_width, 0);
        [self reloadData];
    }
}

- (void)addPreWeekBy:(NSDate*)someday {
    NSDate *preWeek = [someday dateBySubtractingWeeks:1];
    NSMutableArray<NSDate*> *tmpArray = [NSMutableArray arrayWithCapacity:kDaysOfPage];
    [tmpArray addObjectsFromArray:[self weekArrayFor:preWeek]];
    
    // 从dateArray里去掉最后一个周
    for (int i=0; i<kDaysOfPage; i++) {
        [self.dateArray removeLastObject];
    }
    
    // 在前面补一个周
    [tmpArray addObjectsFromArray:self.dateArray];
    [self.dateArray removeAllObjects];
    [self.dateArray addObjectsFromArray:tmpArray];
}

- (void)addNextWeekBy:(NSDate*)someday {
    NSDate *nextWeek = [someday dateByAddingWeeks:1];
    NSMutableArray<NSDate*> *tmpArray = [NSMutableArray arrayWithCapacity:kDaysOfPage];
    [tmpArray addObjectsFromArray:[self weekArrayFor:nextWeek]];
    // 从dateArray里去掉第一个周
    for (int i=0; i<kDaysOfPage; i++) {
        [self.dateArray removeObjectAtIndex:0];
    }
    // 在后面补一个周
    [self.dateArray addObjectsFromArray:tmpArray];
}

- (NSMutableArray*)dateArray {
    if (!_dateArray) {
        // 缓存3页数据
        _dateArray = [NSMutableArray arrayWithCapacity:kDaysOfPage*3];
    }
    
    return _dateArray;
}

- (void)setSelectedDate:(NSDate *)selectedDate {
    _selectedDate = selectedDate;
    
    if (selectedDate == nil) {
        return;
    }

    [self scrollToWeek:selectedDate];
    
    if (!self.isHidden && self.weekDidChanged) {
        self.weekDidChanged(selectedDate);
    }
}

- (void)scrollToWeek:(NSDate*)week {
    __block BOOL isExist = NO;
    __block NSUInteger pageIdx = self.contentOffset.x / self.xu_width;
    
    [self.dateArray enumerateObjectsUsingBlock:^(NSDate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isSameDay:week]) {
            pageIdx = idx / kDaysOfPage;
            isExist = YES;
            *stop = YES;
        }
    }];
    
    if (isExist) {
        if (pageIdx == 0) {
            [self addPreWeekBy:week];
        } else if (pageIdx == 2) {
            [self addNextWeekBy:week];
        }
        
        self.contentOffset = CGPointMake(self.xu_width, 0);
        [self reloadData];
    } else {
        // 如果选中的日期较早，则向左滑动，否则向右滑动
        if ([week isEarlierThan:self.dateArray[0]]) {
            [self setContentOffset:CGPointMake(0, 0) animated:YES];
        } else {
            [self setContentOffset:CGPointMake(self.xu_width*2, 0) animated:YES];
        }
        
        // 接着调整数据，保留3页
        [self.dateArray removeAllObjects];
        
        NSDate *preWeek = [week dateBySubtractingWeeks:1];
        NSDate *nextWeek = [week dateByAddingWeeks:1];
        [self.dateArray addObjectsFromArray:[self weekArrayFor:preWeek]];
        [self.dateArray addObjectsFromArray:[self weekArrayFor:week]];
        [self.dateArray addObjectsFromArray:[self weekArrayFor:nextWeek]];
        
        // 默认停在中间
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.contentOffset = CGPointMake(self.xu_width, 0);
            [self reloadData];
        });
    }
}

@end
