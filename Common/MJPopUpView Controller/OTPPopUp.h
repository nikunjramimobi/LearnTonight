//
//  OTPPopUp.h
//
//  Created by Nikunj Rami on 31/03/16.
//

#import <UIKit/UIKit.h>

@protocol OTPPopUpDelegate <NSObject>
@optional
- (void)VerifyPressed;
- (void)CanclePressed;
// ... other methods here
@end

@interface OTPPopUp : UIViewController{
    ModelClass *mdlClass;
}
@property (nonatomic) BOOL isUpdateProfile;
@property (nonatomic,strong) NSMutableDictionary *tempDic;
@property (nonatomic, weak) id <OTPPopUpDelegate> delegate;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic, weak) IBOutlet UIButton *btnVerify;
@property (strong, nonatomic) IBOutlet UITextField *txtOTP;
@property (nonatomic, weak) IBOutlet UIButton *btnCancle;
- (IBAction)CancelBtnAction:(id)sender;
- (IBAction)VerifyBtnAction:(id)sender;

@end
