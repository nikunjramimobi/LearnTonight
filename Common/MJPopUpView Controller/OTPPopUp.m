//
//  kidAdultPopUp.m
//  BNW-Customer
//
//  Created by Raviraj Jadeja on 25/02/16.
//  Copyright © 2016 Magnates. All rights reserved.
//

#import "OTPPopUp.h"

@interface OTPPopUp ()
@end

@implementation OTPPopUp
@synthesize delegate;
@synthesize btnCancle,btnVerify,mobile,isUpdateProfile,tempDic;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.view.layer.borderWidth = 2.0f;
    self.view.layer.borderColor = txtColor.CGColor;
    self.view.layer.cornerRadius = 10.0f;
    
    
    UIImageView *imgView = (UIImageView *)[self.view viewWithTag:11];
    imgView.layer.borderWidth = 2.0f;
    imgView.layer.cornerRadius = 10.0f;
    
    self.btnVerify.layer.borderWidth = 1.0f;
    self.btnVerify.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnVerify.layer.cornerRadius = 5.0f;
    
    self.btnCancle.layer.borderWidth = 1.0f;
    self.btnCancle.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnCancle.layer.cornerRadius = 5.0f;
    
    
    UIView *spacerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.txtOTP setLeftViewMode:UITextFieldViewModeAlways];
    [self.txtOTP setLeftView:spacerView1];
    [self.txtOTP setValue:txtColor forKeyPath:@"_placeholderLabel.textColor"];
    
    [self toolBar];
}

-(void)pickerNext
{
    [self.view endEditing:TRUE];
    if ([self.txtOTP isFirstResponder])
    {
        [self.txtOTP resignFirstResponder];
        
    }
    
}
-(void)toolBar{
    UIToolbar*  mypickerToolbar1 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 56)];
    mypickerToolbar1.barStyle = UIBarStyleBlackOpaque;
    [mypickerToolbar1 sizeToFit];
    NSMutableArray *barItems1 = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *tnext1 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerNext)];
    [barItems1 addObject:flexSpace1];
    [barItems1 addObject:tnext1];
    [mypickerToolbar1 setItems:barItems1 animated:YES];
    
    
    self.txtOTP.inputAccessoryView = mypickerToolbar1;
}


- (IBAction)VerifyBtnAction:(id)sender
{
    [self.txtOTP resignFirstResponder];
    if (isUpdateProfile == TRUE) {
        [self UpdateProfileInfo];
    }
    else{
         [self CheckForOTP:@""];
    }
   
    
    
}
- (IBAction)CancelBtnAction:(id)sender
{
    if(delegate != nil)
    {
        [delegate CanclePressed];
    }
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)CheckForOTP:(NSString *)otp{
    
    
    mdlClass = [[ModelClass alloc] init];
    mdlClass.delegate = self;
    
    
    //NSLog(@"Mobile>>>%@",mobile);
    
    NSArray *arrKey = @[@"mobile",@"otp"];
    
    NSArray *arrValue = @[mobile,self.txtOTP.text];
    
    showHud;
    [mdlClass serviceCall:arrKey value:arrValue url:@"set_otp" selector:@selector(GetResponseOfCheckOTP:)];
    
    
    
}

-(void)GetResponseOfCheckOTP:(NSMutableArray *)result
{
    NSLog(@"result >>>%@",result);
    hideHud;
    
    if (result != nil) {
        NSMutableDictionary *dic = [[result objectAtIndex:0] mutableCopy];
        
        NSArray *arr = dic.allKeys;
        for (int i = 0; i < arr.count; i++) {
            NSString *str = [arr objectAtIndex:i];
            
            if ([str containsString:@"OTP"]) {
                
                NSString *value = [dic valueForKey:str];
                
                if (value == nil || value == (id)[NSNull null]) {
                    [dic setValue:@"" forKey:str];
                    // nil branch
                }
                
                
            }
            if ([str containsString:@"HTTP_Respons"]) {
                NSString *value = [dic valueForKey:str];
                
                if (value == nil || value == (id)[NSNull null]) {
                    [dic setValue:@"" forKey:str];
                    // nil branch
                }
            }
            
            if ([str containsString:@"TermCondition"]) {
                NSString *value = [dic valueForKey:str];
                
                if (value == nil || value == (id)[NSNull null]) {
                    [dic setValue:@"" forKey:str];
                    // nil branch
                }
            }
        }
        //[dic removeObjectForKey:@"TermCondition"];
        
        arr = dic.allKeys;
        
        
        NSMutableDictionary *UserDic = [[NSMutableDictionary alloc]init];
        
        for (int i = 0; i < arr.count; i++) {
            NSString *str = [arr objectAtIndex:i];
            NSString *value = (NSString *)[dic.allValues objectAtIndex:i];
            
            
            [UserDic setObject:value forKey:str];
            
        }
        
        if ([[dic valueForKey:@"Status"] integerValue] == 1 ) {
            
            //NSLog(@"result success >>>");
            
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *dicUser = [[NSMutableDictionary alloc ] init];
            
            StoreValue(isLogin, @"true");
            StoreValue(@"dicuser", UserDic);
            dicUser =UserDic;
            [userdefault removeObjectForKey:@"dictempuser"];
            [userdefault synchronize];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ProfileUpdated" object:self];
            if(delegate != nil)
            {
                [delegate VerifyPressed];
            }
            
        }
        else {
            NSString *str = [dic valueForKey:@"Message"];
            [AppDelegate_ showAlert:@"" withMessage:str andViewController:self];
        }
        
    }
    
    /*if (result != nil) {
        NSMutableDictionary *dic = [[result objectAtIndex:0] mutableCopy];
        
        if ([[dic valueForKey:@"Status"] integerValue] == 1 ) {
            
            if(delegate != nil)
            {
                [delegate VerifyPressed];
            }
            
            
            
        }
        else {
            NSString *str = [dic valueForKey:@"Message"];
            [AppDelegate_ showAlert:@"" withMessage:str andViewController:self];
        }
        
    }*/
}

-(void)UpdateProfileInfo{
    
    
    mdlClass = [[ModelClass alloc] init];
    mdlClass.delegate = self;
    NSArray *arrKey = [tempDic allKeys];
    
    NSArray *arrValue =[tempDic allValues];
    
    NSLog(@"arrKey >>>>%@",arrKey);
    
    NSLog(@"arrValue >>>>%@",arrValue);
    
     showHud;
    [mdlClass serviceCall:arrKey value:arrValue url:@"update_user_profile" selector:@selector(GetResponseOfUpdateProfile:)];
    
    
    
}

-(void)GetResponseOfUpdateProfile:(NSMutableArray *)result
{
    //NSLog(@"result >>>%@",result);
    hideHud;
    if (result != nil) {
        NSMutableDictionary *dic = [[result objectAtIndex:0] mutableCopy];
        
        NSArray *arr = dic.allKeys;
        for (int i = 0; i < arr.count; i++) {
            NSString *str = [arr objectAtIndex:i];
            
            if ([str containsString:@"OTP"]) {
                
                NSString *value = [dic valueForKey:str];
                
                if (value == nil || value == (id)[NSNull null]) {
                    [dic setValue:@"" forKey:str];
                    // nil branch
                }
                
                
            }
            if ([str containsString:@"HTTP_Respons"]) {
                NSString *value = [dic valueForKey:str];
                
                if (value == nil || value == (id)[NSNull null]) {
                    [dic setValue:@"" forKey:str];
                    // nil branch
                }
            }
            
            if ([str containsString:@"TermCondition"]) {
                NSString *value = [dic valueForKey:str];
                
                if (value == nil || value == (id)[NSNull null]) {
                    [dic setValue:@"" forKey:str];
                    // nil branch
                }
            }
        }
        //[dic removeObjectForKey:@"TermCondition"];
        [dic setValue:@"" forKey:@"OTP"];
        
        arr = dic.allKeys;
        
        
        NSMutableDictionary *UserDic = [[NSMutableDictionary alloc]init];
        
        for (int i = 0; i < arr.count; i++) {
            NSString *str = [arr objectAtIndex:i];
            NSString *value = (NSString *)[dic.allValues objectAtIndex:i];
            
            
            [UserDic setObject:value forKey:str];
            
        }
        
        if ([[dic valueForKey:@"Status"] integerValue] == 1 ) {
            
            //NSLog(@"result success >>>");
            
            //StoreValue(isLogin, @"true");
            StoreValue(@"dicuser", UserDic);
            UserDic =UserDic;
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ProfileUpdated" object:self];
            if(delegate != nil)
            {
                [delegate VerifyPressed];
            }
            NSString *str = [dic valueForKey:@"Message"];
            [self.view makeToast:str];
            
            
            
        }
        else {
            NSString *str = [dic valueForKey:@"Message"];
            [AppDelegate_ showAlert:@"" withMessage:str andViewController:self];
        }
        
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
