//
//  Eventlayout.m
//  CustomCalendar
//
//  Created by Иван on 7/3/19.
//  Copyright © 2019 Иван. All rights reserved.
//

#import "DayEventViewManager.h"
#import "Eventlayout.h"
#import "GridLine.h"
#import "TimeLabel.h"
#import "CurrentTime.h"
#import <EventKit/EventKit.h>

static const CGFloat gridLine15minsSpacing = 30;
static const CGFloat gridLine15minsHeight = 0.5;
static const int gridLinesNumber = 60 / 15 * 24;
static const int timeLabelsNumber = gridLinesNumber;
static const CGFloat timeLabelWidth = 60;
static const CGFloat cellSpacing = 6;

@interface Eventlayout ()

@property (strong, nonatomic) NSMutableArray <UICollectionViewLayoutAttributes *> *gridLines;
@property (strong, nonatomic) NSMutableArray <UICollectionViewLayoutAttributes *> *timeLabels;
@property (strong, nonatomic) UICollectionViewLayoutAttributes *currentTime;
@property (strong, nonatomic) NSMutableArray <UICollectionViewLayoutAttributes *> *eventItems;
@property (strong, nonatomic) NSMutableArray <UICollectionViewLayoutAttributes *> *allAttributes;

@end

@implementation Eventlayout

- (CGSize) collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width, gridLinesNumber * gridLine15minsSpacing);
}

- (void)prepareLayout {
    self.allAttributes = [NSMutableArray new];
    
    [self.allAttributes addObject:[self prepareCurrentTime]];
    [self.allAttributes addObjectsFromArray:[self prepareGridLines]];
    [self.allAttributes addObjectsFromArray:[self prepareTimeLabels]];
    [self.allAttributes addObjectsFromArray:[self prepareEventItem]];
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self.allAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
        UICollectionViewLayoutAttributes * attr = (UICollectionViewLayoutAttributes *)object;
        return CGRectIntersectsRect(rect, attr.frame);
    }]];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.eventItems[indexPath.item];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:NSStringFromClass(GridLine.class)]) {
        return self.gridLines[indexPath.item];
    }
    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:NSStringFromClass(TimeLabel.class)]) {
        return self.timeLabels[indexPath.item];
    } else if ([elementKind isEqualToString:NSStringFromClass(CurrentTime.class)]) {
        return self.currentTime;
    }
    return nil;
}

- (NSMutableArray *)prepareGridLines {
    self.gridLines = [NSMutableArray new];
    for (int i = 0; i < gridLinesNumber; ++i) {
        UICollectionViewLayoutAttributes * attr = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:NSStringFromClass(GridLine.class) withIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        attr.frame = CGRectMake(0, i * gridLine15minsSpacing, self.collectionView.bounds.size.width, gridLine15minsHeight);
        [self.gridLines addObject:attr];
    }
    return self.gridLines;
}

- (NSMutableArray *)prepareTimeLabels {
    self.timeLabels = [NSMutableArray new];
    for (int i = 0; i < timeLabelsNumber; ++i) {
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:NSStringFromClass(TimeLabel.class) withIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        attr.frame = CGRectMake(0, i * gridLine15minsSpacing, timeLabelWidth, gridLine15minsSpacing);
        if (CGRectIntersectsRect(self.currentTime.frame, attr.frame)) {
            attr.hidden = YES;
        } else {
            attr.hidden = NO;
        }
        [self.timeLabels addObject:attr];
    }
    return self.timeLabels;
}

- (UICollectionViewLayoutAttributes *)prepareCurrentTime {
    NSDate *currentTime = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:currentTime];
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:NSStringFromClass(CurrentTime.class) withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    attr.frame = CGRectMake(0, gridLine15minsSpacing * components.hour * 4 + gridLine15minsSpacing * (components.minute / 15.0) - gridLine15minsSpacing / 2, self.collectionView.bounds.size.width, gridLine15minsSpacing);
    [self.timeLabels addObject:attr];
    self.currentTime = attr;
    return self.currentTime;
}

- (NSMutableArray *)prepareEventItem {
    CGFloat startX = timeLabelWidth;
    CGFloat containerWidth = self.collectionView.bounds.size.width - timeLabelWidth - 5;
    
    self.eventItems = [NSMutableArray new];
    
    //  Step 1: Make all adjusted by Y, width = containerWidth
    
    DayEventViewManager *dataSource = (DayEventViewManager *)self.collectionView.dataSource;
    for (int i = 0; i < dataSource.model.eventsArray.count; ++i) {
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        EKEvent *event = dataSource.model.eventsArray[i];
        NSDateComponents *componentsStartEvent = [[NSCalendar currentCalendar] components: NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:event.startDate];
        NSDateComponents *componentsEndEvent = [[NSCalendar currentCalendar] components: NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:event.endDate];
        CGFloat eventStartY = gridLine15minsSpacing * componentsStartEvent.hour * 4 + gridLine15minsSpacing * (componentsStartEvent.minute / 15.0);
        CGFloat eventEndY = gridLine15minsSpacing * componentsEndEvent.hour * 4 + gridLine15minsSpacing * (componentsEndEvent.minute / 15.0);
        attr.frame = CGRectMake(startX, eventStartY, containerWidth, eventEndY - eventStartY - cellSpacing / 2);
        [self.eventItems addObject:attr];
    }
    
    //  Step 2: Make all of minimum fitting width, left-aligned
    
    for (UICollectionViewLayoutAttributes *attribute in self.eventItems) {
        //  Find objects that overlap current object, excluding itself
        NSArray *overlappingItems = [self.eventItems filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
            UICollectionViewLayoutAttributes * maybeOverlappingAttribute = (UICollectionViewLayoutAttributes *)object;
            return CGRectIntersectsRect(maybeOverlappingAttribute.frame, attribute.frame);
        }]];
        
        //  If no object overlap, no need to change frames
        if (overlappingItems.count > 1) {
            //  Determine number of mutual exclusive frames (to calculate width)
            NSMutableArray * startY = [NSMutableArray new];
            NSMutableArray * endY = [NSMutableArray new];
            for (UICollectionViewLayoutAttributes *attribute in overlappingItems) {
                [startY addObject:@(CGRectGetMinY(attribute.frame))];
                [endY addObject:@(CGRectGetMaxY(attribute.frame))];
            }
            int divisor = [self numberOfExclusiveOverlapsInInterval:startY endY:endY];
            //  After we found divisor, we can determine minimal width of each element. Don't set it if it was previsouly set to lower value!
            for (UICollectionViewLayoutAttributes *attribute in overlappingItems) {
                CGRect frame = attribute.frame;
                CGFloat newWidth = containerWidth / divisor;
                if (newWidth < frame.size.width) {
                    frame.size.width = newWidth;
                }
                attribute.frame = frame;
            }
        }
    }
    
    //  Step 3: Align leading properly
    
    if (self.eventItems.count > 1) {
        for (UICollectionViewLayoutAttributes *attribute in self.eventItems) {
            NSArray * prevElements = [self.eventItems subarrayWithRange:NSMakeRange(0, [self.eventItems indexOfObject:attribute])];
            UICollectionViewLayoutAttributes * overlappingAttribute = [self layoutAttribute:attribute intersectsWithAttributes:prevElements];
            while (overlappingAttribute != nil) {
                CGRect frame = attribute.frame;
                frame.origin.x = CGRectGetMaxX(overlappingAttribute.frame);
                attribute.frame = frame;
                overlappingAttribute = [self layoutAttribute:attribute intersectsWithAttributes:prevElements];
            }
        }
    }
    
    //  Step 4: Apply spacings
    
    for (UICollectionViewLayoutAttributes *attribute in self.eventItems) {
        CGRect frame = attribute.frame;
        frame.origin.x += cellSpacing / 2;
        frame.size.width -= cellSpacing;
        attribute.frame = frame;
    }
    
    return self.eventItems;
}

//  returns attribute of first intersection from array
- (UICollectionViewLayoutAttributes *) layoutAttribute:(UICollectionViewLayoutAttributes *)attribute intersectsWithAttributes:(NSArray  <UICollectionViewLayoutAttributes *> *) attributes {
    for (UICollectionViewLayoutAttributes * attributeToCheck in attributes) {
        if (CGRectIntersectsRect(attributeToCheck.frame, attribute.frame)) {
            return attributeToCheck;
        }
    }
    return nil;
}

//  returns number of mutual exclusive intervals, found on internet and ported to objective-c
- (int) numberOfExclusiveOverlapsInInterval:(NSArray *)startY endY:(NSArray *)endY {
    int maxOverlap = 0;
    int currentOverlap = 0;
    NSArray * sortedStartY = [startY sortedArrayUsingSelector: @selector(compare:)];
    NSArray * sortedEndY = [endY sortedArrayUsingSelector: @selector(compare:)];
    
    int i = 0, j = 0;
    while (i < sortedStartY.count && j < sortedEndY.count) {
        if ([sortedStartY[i] floatValue] < [sortedEndY[j] floatValue]) {
            currentOverlap += 1;
            maxOverlap = MAX(maxOverlap, currentOverlap);
            i += 1;
        } else {
            currentOverlap -= 1;
            j += 1;
        }
    }
    return maxOverlap;
}

@end
