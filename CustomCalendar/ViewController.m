//
//  ViewController.m
//  CustomCalendar
//
//  Created by Иван on 7/2/19.
//  Copyright © 2019 Иван. All rights reserved.
//
#import <EventKit/EventKit.h>
#import "ViewController.h"
#import "SelectDayCollectionViewCell.h"

@interface DateEventsModel : NSObject
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSMutableArray *eventsArray;

@end

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) EKEventStore *eventStore;

@property (strong, nonatomic) UICollectionView *weekCollectionView;
@property(strong,nonatomic) NSMutableArray *datesEvents;

@property (strong, nonatomic) UICollectionView *eventsCollectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:@"d MMMM yyyy"];
    
    
    
    self.title = [dateFormatter stringFromDate:[NSDate date]];
    NSDictionary *titleAtributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17 weight: UIFontWeightSemibold], NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil];
     self.navigationController.navigationBar.titleTextAttributes = titleAtributes;
   
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.012 green:0.459 blue:0.580 alpha:1];
    
    
    
    UICollectionViewFlowLayout *selectDayFlowlayout = [[UICollectionViewFlowLayout alloc] init];
    [selectDayFlowlayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.weekCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:selectDayFlowlayout];
    self.weekCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.weekCollectionView];
   
    
    self.weekCollectionView.collectionViewLayout = selectDayFlowlayout;
    self.weekCollectionView.backgroundColor = [UIColor colorWithRed:0.012 green:0.459 blue:0.580 alpha:1];
    [self.weekCollectionView setPagingEnabled:YES];
    self.weekCollectionView.delegate = self;
    self.weekCollectionView.dataSource = self;
    self.weekCollectionView.scrollEnabled = YES;
   
    
    
    [self.weekCollectionView registerClass:[SelectDayCollectionViewCell class] forCellWithReuseIdentifier:@"DayCollectionViewCell"];
    [NSLayoutConstraint activateConstraints:@[
                                              [self.weekCollectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                              [self.weekCollectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                                              [self.weekCollectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
                                              [self.weekCollectionView.heightAnchor constraintEqualToConstant:60]
                                              ]
     ];
}












- (void)startDate:(NSDate **)start andEndDate:(NSDate **)end ofWeekOn:(NSDate *)date{
    
    NSDate *startDate = nil;
    NSTimeInterval duration = 0;
    NSCalendar *calendar =  [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setLocale: [NSLocale localeWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
    BOOL b = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&startDate interval:&duration forDate:date];
    
    
    if(! b){
        *start = nil;
        *end = nil;
        return;
    }
    
    NSDate *endDate = [startDate dateByAddingTimeInterval:duration-1];
    *start = startDate;
    *end = endDate;
}
-(NSDate *)addingDay:(NSInteger)days toDate:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setFirstWeekday:2];
    NSDateComponents *components = [NSDateComponents new];
    components.day = days;
    return [calendar dateByAddingComponents: components toDate: date options: 0];
}

- (NSString *)stringWeekDayForWeek:(NSUInteger)week weekDay:(NSUInteger)weekDay {
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setFirstWeekday:2];
    [calendar setTimeZone:[NSTimeZone localTimeZone]];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitWeekOfYear|NSCalendarUnitWeekday fromDate:[NSDate date]];
   // weekDay = weekDay+1 == 7 ? 0 : weekDay +1;
    [components setYear:2019];
    [components setWeekOfYear:week];
    [components setWeekday:weekDay+1];
    NSDate *date = [calendar dateFromComponents:components];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"ru"];
    [formatter setLocale:locale];
    [formatter setDateFormat:@"EE"];
    return [formatter stringFromDate:date];;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"DayCollectionViewCell";
    SelectDayCollectionViewCell *cell = (SelectDayCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDate *date = [NSDate new];
    NSDate *this_start = nil, *this_end = nil;
    [self startDate:&this_start andEndDate:&this_end ofWeekOn:date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d"];
    date = [self addingDay: indexPath.row toDate: this_start];
    cell.wordLabel.text = [self stringWeekDayForWeek:indexPath.section weekDay:indexPath.row];
    cell.numberLabel.text = [[dateFormatter stringFromDate:date] uppercaseString];
    cell.date = date;
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (CGFloat)widthOfDayCell {
     return self.weekCollectionView.bounds.size.width / 7;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1000;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
         return CGSizeMake([self widthOfDayCell], 50);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
          static NSString *cellIdentifier = @"DayCollectionViewCell";
        NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.item inSection:0];
        SelectDayCollectionViewCell *cell = (SelectDayCollectionViewCell *)[self.weekCollectionView cellForItemAtIndexPath:path];
        
        NSDateFormatter *objTitleFormatter = [NSDateFormatter new];
        [objTitleFormatter setDateFormat:@"d MMMM yyyy"];
        [objTitleFormatter setLocale: [NSLocale localeWithLocaleIdentifier: @"ru_RU"]];
        self.title = [objTitleFormatter stringFromDate:cell.date];
        NSLog(@"%@", self.title);
        
    
    
}



@end
