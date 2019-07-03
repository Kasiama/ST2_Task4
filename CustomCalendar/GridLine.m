//
//  GridLine.m
//  CustomCalendar
//
//  Created by Иван on 7/3/19.
//  Copyright © 2019 Иван. All rights reserved.
//

#import "GridLine.h"

@implementation GridLine
- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CAShapeLayer *dashLine = [CAShapeLayer layer];
        dashLine.strokeColor = [UIColor grayColor].CGColor;
        dashLine.fillColor = nil;
        dashLine.lineDashPattern = @[@2, @5];
        dashLine.frame = self.bounds;
        dashLine.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        [self.layer addSublayer:dashLine];
    }
    return self;
}
@end
