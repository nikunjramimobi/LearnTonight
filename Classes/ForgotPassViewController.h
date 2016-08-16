//
//  ForgotPassViewController.h
//  LearnTonight
//
//  Created by Mag_Mini_1 on 05/08/16.
//  Copyright © 2016 Mag_Mini_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ForgotPassDelegate <NSObject>
@optional
- (void)SendPressed;
- (void)CanclePressed;
// ... other methods here
@end

@interface ForgotPassViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, weak) id <ForgotPassDelegate> delegate;

@property (nonatomic,strong) NSString *email;
@property (nonatomic, weak) IBOutlet UIButton *btnSend;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (nonatomic, weak) IBOutlet UIButton *btnCancle;

- (IBAction)CancelBtnAction:(id)sender;
- (IBAction)SendBtnAction:(id)sender;

@end

