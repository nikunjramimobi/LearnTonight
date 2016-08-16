//
//  LoginViewController.h
//  LearnTonight
//
//  Created by Mag_Mini_1 on 27/07/16.
//  Copyright © 2016 Mag_Mini_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForgotPassViewController.h"
#import "UIViewController+MJPopupViewController.h"
@interface LoginViewController : UIViewController<UITextFieldDelegate,ForgotPassDelegate>


@property (weak, nonatomic) IBOutlet UIView *viewEmail;
@property (weak, nonatomic) IBOutlet UIView *viewPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;

- (IBAction)actionLogin:(id)sender;
- (IBAction)actionForgotPass:(id)sender;
- (IBAction)actionRegistration:(id)sender;
- (IBAction)actionFbLogin:(id)sender;
- (IBAction)actionLinkedInLogin:(id)sender;
- (IBAction)actionGmailLogin:(id)sender;
- (IBAction)actionTwitterLogin:(id)sender;
@end
