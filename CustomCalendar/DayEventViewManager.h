//
//  DayEventViewManager.h
//  CustomCalendar
//
//  Created by Иван on 7/3/19.
//  Copyright © 2019 Иван. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DateEventsModel : NSObject
@property (strong, nonatomic) NSDate * _Nullable date;
@property (strong, nonatomic) NSMutableArray * _Nullable eventsArray;

@end

@interface DayEventViewManager : NSObject <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) DateEventsModel *model;
@end

NS_ASSUME_NONNULL_END
