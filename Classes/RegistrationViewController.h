//
//  RegistrationViewController.h
//  LearnTonight
//
//  Created by Mag_Mini_1 on 30/07/16.
//  Copyright © 2016 Mag_Mini_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController<InterestedCategoriesDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scollview;
@property (weak, nonatomic) IBOutlet UIView *viewCenter;
@property (weak, nonatomic) IBOutlet UIView *viewEmail;
@property (weak, nonatomic) IBOutlet UIView *viewPassword;
@property (weak, nonatomic) IBOutlet UIView *viewIntrestedCategories;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword
;
@property (weak, nonatomic) IBOutlet UIButton *btnRegistration;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIImageView *imgBorader;
@property (weak, nonatomic) IBOutlet UILabel *lblHaveAccount;

@property (weak, nonatomic) IBOutlet UIImageView *imgCategoryIcon;
@property (weak, nonatomic) IBOutlet UITextField *txtCategoryPlaceHolder;

- (IBAction)actionLogin:(id)sender;
- (IBAction)actionRegistration:(id)sender;

@end
