//
//  BasicInfoViewController.h
//  LearnTonight
//
//  Created by Mag_Mini_1 on 04/08/16.
//  Copyright © 2016 Mag_Mini_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicInfoViewController : UIViewController<InterestedCategoriesDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scollview;
@property (weak, nonatomic) IBOutlet UIView *viewCenter;
@property (weak, nonatomic) IBOutlet UIView *viewLanguage;
@property (weak, nonatomic) IBOutlet UIView *viewSubject;
@property (weak, nonatomic) IBOutlet UIView *viewCountry;
@property (weak, nonatomic) IBOutlet UIView *viewTimeZone;
@property (weak, nonatomic) IBOutlet UIView *viewMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtLanguage;
@property (weak, nonatomic) IBOutlet UITextField *txtSubject;
@property (weak, nonatomic) IBOutlet UITextField *txtCountry;
@property (weak, nonatomic) IBOutlet UITextField *txtTimeZone;
@property (weak, nonatomic) IBOutlet UITextField *txtMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtFName;
@property (weak, nonatomic) IBOutlet UITextField *txtLName;

@property (weak, nonatomic) IBOutlet UILabel *lblCountryCode;

@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
;
@property (weak, nonatomic) IBOutlet UIImageView *secondBorder;
@property (weak, nonatomic) IBOutlet UIImageView *lastBorder;
@property (weak, nonatomic) IBOutlet UIButton *btnImgProfile;
@property (weak, nonatomic) IBOutlet UIButton *btnTerms;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) UIImagePickerController *ctr;




- (IBAction)actionNext:(id)sender;
- (IBAction)actionBack:(id)sender;
- (IBAction)actionOpenCamera:(id)sender;
- (IBAction)actionOpenGalary:(id)sender;
- (IBAction)actionAcceptTermsConditions:(id)sender;
- (IBAction)actionSelectProfilePic:(id)sender;



@end
