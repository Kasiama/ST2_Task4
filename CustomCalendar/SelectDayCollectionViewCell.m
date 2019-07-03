//
//  selectDayCollectionViewCell.m
//  CustomCalendar
//
//  Created by Иван on 7/3/19.
//  Copyright © 2019 Иван. All rights reserved.
//

#import "SelectDayCollectionViewCell.h"

@interface SelectDayCollectionViewCell ()

@property (strong, nonatomic) UIView *selectionView;

@end


@implementation SelectDayCollectionViewCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _date = [NSDate date];
        self.contentView.backgroundColor = [UIColor colorWithRed:0.012 green:0.459 blue:0.580 alpha:1];;
        
        self.selectionView = [UIView new];
        self.selectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.selectionView];
        self.selectionView.backgroundColor = [UIColor redColor];
        self.selectionView.hidden = YES;
        
        const CGFloat selectionViewDiameter = 50.0;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.selectionView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
                                                  [self.selectionView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor constant:-5],
                                                  [self.selectionView.widthAnchor constraintEqualToConstant:selectionViewDiameter],
                                                  [self.selectionView.heightAnchor constraintEqualToConstant:selectionViewDiameter],
                                                  ]
         ];
        self.selectionView.layer.cornerRadius = selectionViewDiameter / 2;
        self.selectionView.layer.masksToBounds = YES;
        
        
        
        
        self.numberLabel = [UILabel new];
        self.numberLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.numberLabel.font = [UIFont systemFontOfSize:17 weight: UIFontWeightSemibold];
        self.numberLabel.textColor = [UIColor whiteColor];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.numberLabel];
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.numberLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
                                                  [self.numberLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
                                                  [self.numberLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
                                                  ]];
        self.wordLabel = [UILabel new];
        self.wordLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.wordLabel.font = [UIFont systemFontOfSize:12];
        self.wordLabel.textColor = [UIColor whiteColor];
        self.wordLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.wordLabel];
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.wordLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
                                                  [self.wordLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
                                                  [self.wordLabel.topAnchor constraintEqualToAnchor:self.numberLabel.bottomAnchor],
                                                  ]];
        const CGFloat dotViewDiameter = 5.0;
        self.dotView = [UIView new];
        self.dotView.translatesAutoresizingMaskIntoConstraints = NO;
        self.dotView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.dotView];
        
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.dotView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
                                                  [self.dotView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
                                                  [self.dotView.heightAnchor constraintEqualToConstant:dotViewDiameter],
                                                  [self.dotView.widthAnchor constraintEqualToConstant:dotViewDiameter]
                                                  ]];
    }
    return self;
}

- (void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.selectionView.hidden = NO;
    } else {
        self.selectionView.hidden = YES;
    }
    
}




@end
