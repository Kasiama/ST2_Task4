//
//  EventCollectionViewCell.m
//  CustomCalendar
//
//  Created by Иван on 7/3/19.
//  Copyright © 2019 Иван. All rights reserved.
//

#import "EventCollectionViewCell.h"

@implementation EventCollectionViewCell

static const CGFloat padding = 5.0;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        
        self.nameLabel = [UILabel new];
        self.nameLabel.numberOfLines = 0;
        [self.nameLabel sizeToFit];
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.nameLabel];
        
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.nameLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:padding],
                                                  [self.nameLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-padding],
                                                  [self.nameLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:padding],
                                                  [self.nameLabel.bottomAnchor constraintLessThanOrEqualToAnchor:self.contentView.bottomAnchor constant:-padding]
                                                  ]];
    }
    return self;
}
@end
