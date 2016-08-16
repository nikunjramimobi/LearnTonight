//
//  KeyUtils.m
//  BLE Scanner
//
//  Created by Ashok Domadiya on 17/02/16.
//  Copyright © 2016 Bluepixel Technologies LLP. All rights reserved.
//

#import "KeyUtils.h"


@implementation KeyUtils

@end


@implementation UITextField (SpaceTextField)

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 5, bounds.size.width - 20, bounds.size.height - 10);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 5, bounds.size.width - 20, bounds.size.height - 10);
}

@end

@implementation UIButton (ButtonRounded)

//-(void)layoutSubviews
//{
//    self.viewContainer.layer.borderColor = [UIColor colorWithRed:52.0f/255.0f green:152.0f/255.0f blue:219.0f/255.0f alpha:1.0f].CGColor;
//    self.layer.borderWidth = 1.5f;
//    self.layer.cornerRadius = 5.0f;
//}

@end













