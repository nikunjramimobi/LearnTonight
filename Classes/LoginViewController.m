//
//  LoginViewController.m
//  LearnTonight
//
//  Created by Mag_Mini_1 on 27/07/16.
//  Copyright © 2016 Mag_Mini_1. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Google/SignIn.h>
#import <Twitter/Twitter.h>
#import <TwitterKit/TwitterKit.h>
#import <linkedin-sdk/LISDK.h>
#import "RegistrationViewController.h"

@interface LoginViewController ()<GIDSignInDelegate, GIDSignInUIDelegate>{
    ModelClass *mdlClass;
    NSString *Email;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mdlClass = [[ModelClass alloc] init];
    mdlClass.delegate = self;
    
    Email = nil;
    
    [self.viewEmail.layer setCornerRadius:(self.viewEmail.frame.size.height /2)];
    [self.viewPassword.layer setCornerRadius:(self.viewPassword.frame.size.height /2)];
    
    [self.viewEmail.layer setBorderWidth:2.0f];
    [self.viewEmail.layer setBorderColor:theamcolor.CGColor];
    [self.viewPassword.layer setBorderWidth:2.0f];
    [self.viewPassword.layer setBorderColor:theamcolor.CGColor];
    
    [self.txtEmail setValue:theamcolor forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtPassword setValue:theamcolor forKeyPath:@"_placeholderLabel.textColor"];
    //self.txtEmail.text =@"test.125@magnates.mobi";
    //self.txtPassword.text =@"nikunj";
    
    [self.btnLogin.layer setCornerRadius:(self.btnLogin.frame.size.height /2)];
    if (!IsStudent()) {
        [self.btnRegister setHidden:TRUE];
    }
    
    //**** Setup Google Login Instance
  /*  GIDSignIn.sharedInstance().signInSilently()
    GIDSignIn.sharedInstance().delegate = self
    GIDSignIn.sharedInstance().uiDelegate = self
    GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.login")
    GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me")
    */
   
    [[GIDSignIn sharedInstance] signInSilently];
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionLogin:(id)sender {
    
    if ([self validateLoginData]) {
        
        
        
        if ([self validateLoginData]) {
            
            [self callLoginWebService:self.txtEmail.text pass:self.txtPassword.text loginType:@"M" socialId:@"" firstname:@"" lastname:@"" andProfileImageUrl:@""];
            
        }
        
        
    }
}

- (IBAction)actionForgotPass:(id)sender {
    ForgotPassViewController *forgotPassViewController = [[ForgotPassViewController alloc] initWithNibName:@"ForgotPassword" bundle:nil];
    forgotPassViewController.delegate = self;
    [self presentPopupViewController:forgotPassViewController animationType:1];
}

- (IBAction)actionRegistration:(id)sender {
    
    RegistrationViewController *registerView = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 1.0;
    transition.type = @"pageCurl";
    transition.subtype = kCATransitionFromRight;
    //transition.timingFunction = UIViewAnimationCurveEaseInOut;
    transition.timingFunction = UIViewAnimationCurveEaseInOut;
    [self.navigationController.view.layer
     addAnimation:transition forKey:kCATransition];
    
    [self.navigationController
     pushViewController:registerView animated:NO];
}

- (IBAction)actionFbLogin:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile",@"email",@"user_friends"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             
             [self getFbUserData];
             
         }
     }];
}

- (IBAction)actionLinkedInLogin:(id)sender {
    NSArray *permissions = [NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION,LISDK_EMAILADDRESS_PERMISSION, nil];
    
    [LISDKSessionManager createSessionWithAuth:permissions state:nil showGoToAppStoreDialog:YES successBlock:^(NSString *returnState)
     {
         NSLog(@"%s","success called!");
         LISDKSession *session = [[LISDKSessionManager sharedInstance] session];
         NSLog(@"Session : %@", session.description);
         [self getLinkdInData];
     } errorBlock:^(NSError *error)
     {
         NSLog(@"%@ >>>",error.description);
     }];
}



- (IBAction)actionGmailLogin:(id)sender {
    
    [[GIDSignIn sharedInstance] signIn];
}
- (IBAction)actionTwitterLogin:(id)sender {
    
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
            [self getTwitterData];
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
    
}


#pragma mark - UITextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.txtEmail) {
        [self.txtPassword becomeFirstResponder];
        //[self.txtPassword canBecomeFirstResponder];
    }
    else {
        [self.txtPassword resignFirstResponder];
    }
    
    return YES;
    
    
}

#pragma mark - ForgotPassView


- (void)SendPressed{
    
    // Kid Popup View Controller Delegate -  Sohan Vanani 25-Feb-2016
    [self dismissPopupViewControllerWithanimationType:1];
    //[AppDelegate_ switchToMainScreen];
    
    
    
}
- (void)CanclePressed{
    
    // Kid Popup View Controller Delegate -  Sohan Vanani 25-Feb-2016
    [self dismissPopupViewControllerWithanimationType:1];
    //NSLog(@"cancel Pressed");
    
}


#pragma mark - Custom methods
-(BOOL)validateLoginData{
    if([[self.txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
        ShowAlert(@"", @"Please Enter Email Address.!");
        
        return FALSE;
    }
    if([[self.txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
        
    }
    
    if (![self NSStringIsValidEmail:self.txtEmail.text]) {
        ShowAlert(@"", @"Please Enter valide email address.!");
        
        return FALSE;
    }
    
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    return TRUE;
}



-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void)getLoginResponse:(NSDictionary *)result
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [AppDelegate_ RemoveProgressloader:self.view];
        if (result != nil) {
            DLog(@"result >>%@",result);
            
            if ([[result valueForKey:@"status"] integerValue] == 1 ) {
                
                
                NSDictionary *Dic = [result valueForKey:@"data"][0];
                DLog(@"Dic >>%@",Dic);
                StoreValue(@"UserInfo", Dic);
                StoreValue(kIsLogin, @"true");
                
                if (IsStudent()) {
                    if ([[Dic valueForKey:@"buyers_mode"] integerValue] == 0 ){
                        [self performSegueWithIdentifier:@"basicinfo" sender:self];
                    }
                    else {
                        DLog(@"Dis >>>%@",Dic);
                        [AppDelegate_ switchToMainScreen];
                    }
                }
                else {
                    if ([[Dic valueForKey:@"selling_mode"] integerValue] == 0 ){
                        [self performSegueWithIdentifier:@"basicinfoL" sender:self];
                    }
                    else {
                        DLog(@"Dis >>>%@",Dic);
                        [AppDelegate_ switchToMainScreen];
                    }
                }
                
                
                
                
            }
            else {
                
                NSString *msg = [result valueForKey:@"msg"];
                ShowAlert(@"", msg);
            }
            
        }
    });
    
    
}

-(void)getLinkdInData {
    
   [[LISDKAPIHelper sharedInstance] getRequest:@"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,email-address,picture-url,formatted-name,phonetic-last-name,location:(country:(code)),industry,distance,current-status,current-share,network,skills,phone-numbers,date-of-birth,main-address,positions:(title),educations:(school-name,field-of-study,start-date,end-date,degree,activities))"
                                        success:^(LISDKAPIResponse *response)
     {
         NSData* data = [response.data dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         
         NSLog(@"dictResponse >>%@",dictResponse);
         
         NSString *fName = [dictResponse valueForKey: @"firstName"];
         NSString *lName = [dictResponse valueForKey: @"lastName"];
         NSString *email = [dictResponse valueForKey: @"emailAddress"];
         NSString *SocialId = [dictResponse valueForKey: @"id"];
         NSString *pictureUrl = [dictResponse valueForKey: @"pictureUrl"];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [self callLoginWebService:email pass:@"" loginType:@"L" socialId:SocialId firstname:fName lastname:lName andProfileImageUrl:pictureUrl];
         });
         
         
        
     } error:^(LISDKAPIError *apiError)
     {
         NSLog(@"Error : %@", apiError);
     }];
    
}

-(void)getTwitterData {
    
    
    NSString *userID = [Twitter sharedInstance].sessionStore.session.userID;
    TWTRAPIClient *client = [[TWTRAPIClient alloc] initWithUserID:userID];
    NSURLRequest *request = [client URLRequestWithMethod:@"GET"
                                                     URL:@"https://api.twitter.com/1.1/account/verify_credentials.json"
                                              parameters:@{@"include_email": @"true", @"skip_status": @"true",@"media_ids": @"media_id_string"}
                                                   error:nil];
    
    [client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        
        
        if(data != nil){
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            
            
            NSLog(@"responseDict >>>%@",responseDict);
            
            NSString *socialId = [responseDict valueForKey:@"id_str"];
            NSString *name = [responseDict valueForKey:@"name"];
            NSString *profile_image_url = [responseDict valueForKey:@"profile_image_url"];
            
            
            if ([[[Twitter sharedInstance] sessionStore] session]) {
                
                TWTRShareEmailViewController *shareEmailViewController = [[TWTRShareEmailViewController alloc] initWithCompletion:^(NSString *email, NSError *error) {
                    Email = email;
                    DLog(@"Email >>>%@",Email);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{[self callLoginWebService:Email pass:@"" loginType:@"T" socialId:socialId firstname:name lastname:@"" andProfileImageUrl:profile_image_url];});
                    
                    NSLog(@"Email %@ | Error: %@", email, error);
                }];
                
                [self presentViewController:shareEmailViewController
                                   animated:YES
                                 completion:nil];
            } else {
                // Handle user not signed in (e.g. attempt to log in or show an alert)
            }
            
            
        }
        
        
    }];
    
    
    
}

-(void)getFbUserData {
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"picture.type(large), email,name,id,first_name,last_name"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
                 
                 NSString *fname = [result valueForKey: @"first_name"];
                 NSString *lname = [result valueForKey: @"last_name"];
                 NSString *email = [result valueForKey: @"email"];
                 NSString *SocialId = [result valueForKey: @"id"];
                 NSString *pictureUrl = [[[result valueForKey: @"picture"] valueForKey:@"data"] valueForKey:@"url"];
                 
                 NSLog(@"email >>%@",email);
                 NSLog(@"SocialId >>%@",SocialId);

                 NSLog(@"pictureUrl >>%@",pictureUrl);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self callLoginWebService:email pass:@"" loginType:@"F" socialId:SocialId firstname:fname lastname:lname andProfileImageUrl:pictureUrl];
                 });

             }
         }];
    }
}




//MARK: Google Delegates
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    
    if (user) {
        NSString *userId = user.userID;                  // For client-side use only!
        NSString *token = user.authentication.idToken;   // Safe to send to the server
        NSString *name = user.profile.name;
        NSString *email = user.profile.email;
        NSURL *imageURL;
        if ([GIDSignIn sharedInstance].currentUser.profile.hasImage)
        {
            NSUInteger dimension = round(200 * 200);
            imageURL = [user.profile imageURLWithDimension:dimension];
        }
        
        NSString *profileUrl = [NSString stringWithFormat:@"%@",imageURL];
        
        [self callLoginWebService:email pass:@"" loginType:@"G" socialId:userId firstname:name lastname:@"" andProfileImageUrl:profileUrl];
    }
}
-(void)callLoginWebService:(NSString *)email pass:(NSString *)pass loginType:(NSString *)login_type socialId:(NSString *)socialid firstname:(NSString *)firstname lastname:(NSString *)lastname andProfileImageUrl:(NSString *)profile_image{
    
   NSMutableDictionary *dicLogin = [@{kMethodType: kMethodTypePost, user_email:email, user_pass:pass,user_login_type:login_type,user_socialId:socialid,user_firstname:firstname,user_lastname:lastname,user_profile_image:profile_image} mutableCopy];
    [AppDelegate_ showProgressloader:self.view];
    SendRequestToWebService(WSLogin, dicLogin, ^(id response) {
        if(response){
            NSMutableDictionary *dic = [response mutableCopy];
            if (dic && [dic[@"status"] integerValue] == 1) {
                NSDictionary *Dic = [dic valueForKey:@"data"][0];
                DLog(@"Dic >>%@",Dic);
                StoreValue(@"UserInfo", Dic);
                StoreValue(kIsLogin, @"true");
                
                if (IsStudent()) {
                    if ([[Dic valueForKey:@"buyers_mode"] integerValue] == 0 ){
                        [self performSegueWithIdentifier:@"basicinfo" sender:self];
                    }
                    else {
                        DLog(@"Dis >>>%@",Dic);
                        [AppDelegate_ switchToMainScreen];
                    }
                }
                else {
                    if ([[Dic valueForKey:@"selling_mode"] integerValue] == 0 ){
                        [self performSegueWithIdentifier:@"basicinfoL" sender:self];
                    }
                    else {
                        DLog(@"Dis >>>%@",Dic);
                        [AppDelegate_ switchToMainScreen];
                    }
                }
            }else{
                ShowUIAlertWithOKButtonAndTapBlock(@"", dic[@"msg"], NO, ^{
                    [self.txtEmail becomeFirstResponder];
                });
            }
        }
    }, ^(NSString *error, NSInteger code) {
        ShowAlert(@"Error" , [NSString stringWithFormat:@"%@",[error description]]);
    }, ^{
        //[MBProgressHUD hideHUDForView:self.view animated:NO];
        [AppDelegate_ RemoveProgressloader:self.view];
    });
    
    /*[AppDelegate_ showProgressloader:self.view];
    
    mdlClass = [[ModelClass alloc] init];
    mdlClass.delegate = self;
    
    
    
    
    NSArray *arrKey = @[@"email",@"password",@"login_type",@"id",@"firstname"
                        ,@"lastname"
                        ,@"profile_image"];
    NSArray *arrValue = @[email,pass,login_type,socialid,firstname,lastname,profile_image];
    DLog(@"arrKey >>%@",arrKey);
    DLog(@"arrValue >>%@",arrValue);
    
    [mdlClass serviceCall:arrKey value:arrValue url:@"login.php" selector:@selector(getLoginResponse:)];*/
    
}

@end
