//
//  ViewController.m
//  CustomCalendar
//
//  Created by Иван on 7/2/19.
//  Copyright © 2019 Иван. All rights reserved.
//

#import "ViewController.h"
#import "SelectDayCollectionViewCell.h"
@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *weekCollectionView;
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
    self.weekCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:selectDayFlowlayout];
    self.weekCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.weekCollectionView];
   
    
    self.weekCollectionView.collectionViewLayout = selectDayFlowlayout;
    self.weekCollectionView.backgroundColor = [UIColor colorWithRed:0.012 green:0.459 blue:0.580 alpha:1];
    [self.weekCollectionView setPagingEnabled:YES];
    self.weekCollectionView.delegate = self;
    self.weekCollectionView.dataSource = self;
    
    
    [self.weekCollectionView registerClass:[SelectDayCollectionViewCell class] forCellWithReuseIdentifier:@"DayCollectionViewCell"];
    [NSLayoutConstraint activateConstraints:@[
                                              [self.weekCollectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                              [self.weekCollectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                                              [self.weekCollectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
                                              [self.weekCollectionView.heightAnchor constraintEqualToConstant:100]
                                              ]
     ];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"DayCollectionViewCell";
    SelectDayCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.numberLabel.text = @"2";
    cell.wordLabel.text = @"1";
    cell.selected = YES;
    return cell;
}

- (CGFloat)widthOfDayCell {
     return self.weekCollectionView.bounds.size.width / 7;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (NSUInteger)maximumNumberOfColumnsForCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout {
    return 7;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([self widthOfDayCell], 100);
}



@end
