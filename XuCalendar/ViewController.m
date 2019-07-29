//
//  ViewController.m
//  XuCalendar
//
//  Created by xucg on 2019/7/29.
//  Copyright © 2019年 xucg. All rights reserved.
//

#import "ViewController.h"
#import "XuCalendarView.h"
#import <NSDate+DateTools.h>

@interface ViewController () <XuCalendarViewDelegate>

@property (nonatomic, strong) XuCalendarView *calendarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.title = @"Xucg Calendar";
    [self.view addSubview:self.calendarView];
    self.calendarView.selectedDate = [NSDate date];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)xu_numberOfDotForDate:(NSDate*)date {
    if ([date isEarlierThanOrEqualTo:[NSDate date]]) {
        return 1;
    }
    return 0;
}

- (XuCalendarView*)calendarView {
    if (!_calendarView) {
        _calendarView = [[XuCalendarView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 250)];
        _calendarView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
        _calendarView.weekBarFont = [UIFont systemFontOfSize:11];
        _calendarView.weekBarTextColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1];
        _calendarView.dateFont = [UIFont systemFontOfSize:16];
        _calendarView.dateColor = [UIColor colorWithRed:15/255.0 green:15/255.0 blue:15/255.0 alpha:1];
        _calendarView.placeholderDateColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1];
        _calendarView.selectedDateColor = UIColor.whiteColor;
        _calendarView.selectedBgColor = UIColor.redColor;
        _calendarView.dotColor = [UIColor colorWithRed:67/255.0 green:188/255.0 blue:194/255.0 alpha:1];
        _calendarView.selectedDotColor = [UIColor colorWithRed:67/255.0 green:188/255.0 blue:194/255.0 alpha:1];
        _calendarView.delegate = self;
        
        __weak typeof(self) weakSelf = self;
        _calendarView.monthDidChanged = ^(NSDate * _Nonnull date) {
            weakSelf.title = [date formattedDateWithFormat:@"yyyy-MM-dd"];
        };
    }
    
    return _calendarView;
}

@end
