//
//  StudentDashboardViewController.h
//  LearnTonight
//
//  Created by Mag_Mini_1 on 08/08/16.
//  Copyright © 2016 Mag_Mini_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentDashboardViewController : UIViewController<SlideNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
- (IBAction)actionMenu:(id)sender;


@end
