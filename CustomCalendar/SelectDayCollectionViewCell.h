//
//  selectDayCollectionViewCell.h
//  CustomCalendar
//
//  Created by Иван on 7/3/19.
//  Copyright © 2019 Иван. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectDayCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *numberLabel;
@property (strong, nonatomic) UILabel *wordLabel;
@property (strong, nonatomic) UIView *dotView;

@property (strong, nonatomic) NSDate *date;

@end

NS_ASSUME_NONNULL_END
