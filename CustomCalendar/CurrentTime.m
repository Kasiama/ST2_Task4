//
//  CurrentTime.m
//  CustomCalendar
//
//  Created by Иван on 7/3/19.
//  Copyright © 2019 Иван. All rights reserved.
//

#import "CurrentTime.h"

@implementation CurrentTime
- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.currentTimeLabel = [UILabel new];
        self.currentTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.currentTimeLabel];
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.currentTimeLabel.leadingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.leadingAnchor constant:10],
                                                  [self.currentTimeLabel.widthAnchor constraintEqualToConstant:50],
                                                  [self.currentTimeLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
                                                  [self.currentTimeLabel.heightAnchor constraintEqualToAnchor:self.heightAnchor]
                                                  ]];
        
        self.currentTimeLine = [UIView new];
        self.currentTimeLine.backgroundColor = [UIColor redColor];
        self.currentTimeLine.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.currentTimeLine];
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.currentTimeLine.leadingAnchor constraintEqualToAnchor:self.currentTimeLabel.trailingAnchor],
                                                  [self.currentTimeLine.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor],
                                                  [self.currentTimeLine.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
                                                  [self.currentTimeLine.heightAnchor constraintEqualToConstant:2]
                                                  ]];
    }
    return self;
}
@end
