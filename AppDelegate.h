//
//  AppDelegate.h
//  LearnTonight
//
//  Created by Mag_Mini_1 on 27/07/16.
//  Copyright © 2016 Mag_Mini_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceActor.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) WebServiceActor *webServiceActor;

- (void)switchToMainScreen;
- (void)switchToLoginScreen;
-(void)showProgressloader:(UIView *)view;
-(void)RemoveProgressloader:(UIView *)view;

@end

