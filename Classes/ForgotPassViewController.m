//
//  ForgotPassViewController.m
//  LearnTonight
//
//  Created by Mag_Mini_1 on 05/08/16.
//  Copyright © 2016 Mag_Mini_1. All rights reserved.
//



#import "ForgotPassViewController.h"

@interface ForgotPassViewController (){
     ModelClass *mdlClass;
}
@end

@implementation ForgotPassViewController
@synthesize delegate;
@synthesize btnCancle,btnSend;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.layer.borderWidth = 2.0f;
    self.view.layer.borderColor = theamcolor_green.CGColor;
    self.view.layer.cornerRadius = 10.0f;
    
    [self.txtEmail.layer setCornerRadius:(self.txtEmail.frame.size.height /2)];
    [self.txtEmail.layer setBorderWidth:2.0f];
    [self.txtEmail.layer setBorderColor:theamcolor.CGColor];
    
    UIView *spacerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.txtEmail setLeftViewMode:UITextFieldViewModeAlways];
    [self.txtEmail setLeftView:spacerView1];
    [self.txtEmail setValue:theamcolor forKeyPath:@"_placeholderLabel.textColor"];

    
    self.btnSend.layer.borderWidth = 1.0f;
    self.btnSend.layer.borderColor = theamcolor.CGColor;
    self.btnSend.layer.cornerRadius = 5.0f;
    
    self.btnCancle.layer.borderWidth = 1.0f;
    self.btnCancle.layer.borderColor = theamcolor.CGColor;
    self.btnCancle.layer.cornerRadius = 5.0f;
}



- (IBAction)SendBtnAction:(id)sender
{
    [self.txtEmail resignFirstResponder];
    if(delegate != nil)
    {
        [delegate CanclePressed];
    }

    
//    if ([self validateData]) {
//        //[self SendMail:self.txtEmail.text];
//    }
    
    
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

-(BOOL)validateData{
    if([[self.txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
        ShowAlert(@"", @"Please Enter Email Address.!");
        
        return FALSE;
    }
        
    if (![self NSStringIsValidEmail:self.txtEmail.text]) {
        ShowAlert(@"", @"Please Enter valide email address.!");
        
        return FALSE;
    }
    
    [self.txtEmail resignFirstResponder];
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

-(void)SendMail:(NSString *)email{
    
    
    mdlClass = [[ModelClass alloc] init];
    mdlClass.delegate = self;
    
    
    //NSLog(@"Mobile>>>%@",mobile);
    
    NSArray *arrKey = @[@"email"];
    
    NSArray *arrValue = @[self.txtEmail.text];
    
    [AppDelegate_ showProgressloader:self.view];
    
    [mdlClass serviceCall:arrKey value:arrValue url:@"set_otp" selector:@selector(GetResponseOfSendMail:)];
    
    
    
}

-(void)GetResponseOfSendMail:(NSMutableArray *)result
{
    NSLog(@"result >>>%@",result);
    [AppDelegate_ RemoveProgressloader:self.view];;
    
    if (result != nil) {
        NSMutableDictionary *dic = [[result objectAtIndex:0] mutableCopy];
        
       
        
        if ([[dic valueForKey:@"Status"] integerValue] == 1 ) {
            
            //NSLog(@"result success >>>");
            
            
            //StoreValue(isLogin, @"true");
            //StoreValue(@"dicuser", UserDic);
            
            if(delegate != nil)
            {
                [delegate SendPressed];
            }
            
        }
        else {
            //NSString *str = [dic valueForKey:@"Message"];
            //[AppDelegate_ showAlert:@"" withMessage:str andViewController:self];
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

#pragma mark - UITextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.txtEmail resignFirstResponder];
    return YES;
    
    
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

