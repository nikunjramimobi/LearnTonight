//
//  StudentDashboardViewController.m
//  LearnTonight
//
//  Created by Mag_Mini_1 on 08/08/16.
//  Copyright © 2016 Mag_Mini_1. All rights reserved.
//

#import "StudentDashboardViewController.h"
@interface StudentDashboardViewController ()

@end

@implementation StudentDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view.
    [self.btnMenu addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}
- (IBAction)actionMenu:(id)sender {
    
}
@end
