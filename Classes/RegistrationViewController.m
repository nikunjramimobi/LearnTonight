//
//  RegistrationViewController.m
//  LearnTonight
//
//  Created by Mag_Mini_1 on 30/07/16.
//  Copyright © 2016 Mag_Mini_1. All rights reserved.
//

#import "RegistrationViewController.h"
#import "LoginViewController.h"
@interface RegistrationViewController (){
    NSString *requestURLString;
    NSMutableArray *arrInterestedCategoies;
    NSInteger defualtHieghtOfCenterView;
    NSInteger defualtHieghtOfCategoreisView;
    NSInteger currentHieghtOfCategoreisView;
    
    ModelClass *mdlClass;
}

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrInterestedCategoies = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    defualtHieghtOfCenterView =self.viewCenter.frame.size.height;
    defualtHieghtOfCategoreisView = self.viewIntrestedCategories.frame.size.height;
    
    mdlClass = [[ModelClass alloc] init];
    mdlClass.delegate = self;
    
    [self setUp];
}
-(void)viewWillAppear:(BOOL)animated{
    [self setUpIntestedCategories];
}


-(void)viewWillDisappear:(BOOL)animated{
    NSLayoutConstraint *heightConstraint1;
    for (NSLayoutConstraint *constraint in self.viewCenter.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            heightConstraint1 = constraint;
            break;
        }
    }
    
    heightConstraint1.constant = defualtHieghtOfCenterView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - custom methods
-(void)setUp{
    [self.viewEmail.layer setCornerRadius:(self.viewEmail.frame.size.height /2)];
    [self.viewPassword.layer setCornerRadius:(self.viewPassword.frame.size.height /2)];
    [self.viewIntrestedCategories.layer setCornerRadius:(self.viewPassword.frame.size.height /2)];
    
    [self.viewEmail.layer setBorderWidth:2.0f];
    [self.viewEmail.layer setBorderColor:theamcolor.CGColor];
    [self.viewPassword.layer setBorderWidth:2.0f];
    [self.viewPassword.layer setBorderColor:theamcolor.CGColor];
    
    [self.viewIntrestedCategories.layer setBorderWidth:2.0f];
    [self.viewIntrestedCategories.layer setBorderColor:theamcolor.CGColor];
    
    [self.txtEmail setValue:theamcolor forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtPassword setValue:theamcolor forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtCategoryPlaceHolder setValue:theamcolor forKeyPath:@"_placeholderLabel.textColor"];
    
    
    
    [self.btnRegistration.layer setCornerRadius:(self.btnRegistration.frame.size.height /2)];
    
    //self.txtEmail.text =@"test.125@magnates.mobi";
    //self.txtPassword.text =@"nikunj";
    //self.txtConfirmPassword.text =@"nikunj";
    
    /*if (IsStudent()) {
        //[self.viewIntrestedCategories setValue:txtPlaceholdercolor forKeyPath:@"_placeholderLabel.textColor"];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openIntrestedCategories)];
        tapGesture.numberOfTapsRequired = 1;
        [self.viewIntrestedCategories addGestureRecognizer:tapGesture];
     }*/

    
    
    requestURLString = @"https://restcountries.eu/rest/v1/all";
}

-(void)setUpIntestedCategories{
    
    if (arrInterestedCategoies.count > 0) {
        [self.txtCategoryPlaceHolder setHidden:TRUE];
        [self.imgCategoryIcon setHidden:TRUE];
    }
    else{
        [self.txtCategoryPlaceHolder setHidden:FALSE];
        [self.imgCategoryIcon setHidden:FALSE];
    }
    
    for (UIView *subView in self.viewIntrestedCategories.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        }
    }
    
    NSInteger height = 25;
    NSInteger indexX = 10;
    NSInteger indexY = 5;
    
    NSInteger herizontalSpace = 5;
    NSInteger verticalSpace = 3;
    
    UILabel *lastLabel;
    
    for (NSInteger i = 0; i < arrInterestedCategoies.count; i++) {
        NSString *categoryName = [arrInterestedCategoies objectAtIndex:i];
        CGFloat width = [self widthOfString:categoryName withFont:self.txtEmail.font];
        
        if ((indexX + width + herizontalSpace) > self.viewIntrestedCategories.frame.size.width) {
            indexX = 10;
            indexY = indexY + height +verticalSpace;
        }
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(indexX, indexY, width, height)];
        lbl.text = categoryName;
        lbl.font = self.txtEmail.font;
        lbl.textColor = [UIColor whiteColor];
        lbl.backgroundColor = [UIColor grayColor];
        lbl.layer.masksToBounds = YES;
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.layer.cornerRadius = height/2;
        [self.viewIntrestedCategories addSubview:lbl];
        
        indexX = indexX + width +herizontalSpace;
        
        lastLabel = lbl;
    }
    
    NSLayoutConstraint *heightConstraint;
    for (NSLayoutConstraint *constraint in self.viewIntrestedCategories.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            heightConstraint = constraint;
            break;
        }
    }
    
    NSInteger heightOfView = defualtHieghtOfCategoreisView;
    
    if ((indexY + height + verticalSpace) > heightOfView) {
        heightOfView =indexY + height + 10;
    }
    
    currentHieghtOfCategoreisView = heightOfView;
    heightConstraint.constant = heightOfView;
    
    
    
    NSLayoutConstraint *heightConstraint1;
    for (NSLayoutConstraint *constraint in self.viewCenter.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            heightConstraint1 = constraint;
            break;
        }
    }
    
    NSInteger heightOfView1 = self.viewCenter.frame.size.height + (heightOfView - defualtHieghtOfCategoreisView);
    heightConstraint1.constant = heightOfView1;
    [self changeScrollviewFram];
    

}

-(void)changeScrollviewFram{
    
    if(self.viewIntrestedCategories.subviews.count > 0){
        
        if (currentHieghtOfCategoreisView > defualtHieghtOfCategoreisView) {
            [self.scollview setScrollEnabled:YES];
        }
        else {
            [self.scollview setScrollEnabled:NO];
        }
        
    }
    else {
        [self.scollview setScrollEnabled:NO];
    }
    
}
- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width + 10;
}

-(void)openIntrestedCategories{
    
    InterestedCategoriesViewController *intrestCategories = [self.storyboard instantiateViewControllerWithIdentifier:@"intrestedcategories"];
    
    intrestCategories.arrSelectedCategories = arrInterestedCategoies;
    intrestCategories.delegate = self;
    [self presentViewController:intrestCategories animated:YES completion:nil];
}


#pragma mark - UIButton Action
- (IBAction)actionLogin:(id)sender{
    //[self.navigationController popViewControllerAnimated:YES];
    //LoginViewController login = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    CATransition* transition = [CATransition animation];
    transition.duration = 1.0;
    transition.type = @"pageUnCurl";
    transition.subtype = kCATransitionFromRight;
    transition.timingFunction = UIViewAnimationCurveEaseInOut;
    [self.navigationController.view.layer
     addAnimation:transition forKey:kCATransition];
    
    [self.navigationController popViewControllerAnimated:NO];
    //[self.navigationController
     //pushViewController:registerView animated:NO];

}
- (IBAction)actionRegistration:(id)sender{
    
    if ([self validateLoginData]) {
        
        
        if (IsStudent()) {
           /* NSMutableDictionary *dicLogin = [@{kMethodType: kMethodTypePost, user_email : self.txtEmail.text, user_pass : self.txtPassword.text} mutableCopy];
            [AppDelegate_ showProgressloader:self.view];
            NSArray *arrKey = @[@"email",@"password",@"login_type",@"id",@"firstname",@"lastname",@"profile_image"];
            
            NSArray *arrValue = @[self.txtEmail.text,self.txtPassword.text,@"M",@"",@"",@"",@""];
            DLog(@"self.txtEmail.text >>%@",self.txtEmail.text);
            DLog(@"arrKey >>%@",arrKey);
            DLog(@"arrValue >>%@",arrValue);
            
            
            [mdlClass serviceCall:arrKey value:arrValue url:@"registration.php" selector:@selector(getRegisterForStudenResponse:)];*/
            
            
            NSMutableDictionary *dicLogin = [@{kMethodType: kMethodTypePost, user_email:self.txtEmail.text, user_pass:self.txtPassword.text,user_login_type:@"M",user_socialId:@"",user_firstname:@"",user_lastname:@"",user_profile_image:@""} mutableCopy];
            [AppDelegate_ showProgressloader:self.view];
            SendRequestToWebService(WSRegistration, dicLogin, ^(id response) {
                if(response){
                    DLog(@"response >>>%@",response);
                    NSMutableDictionary *dic = [response mutableCopy];
                    if (dic && [dic[@"status"] integerValue] == 1) {
                        StoreValue(WSRegistration, dic);
                        NSDictionary *Dic = [dic valueForKey:@"data"][0];
                        DLog(@"Dis >>>%@",Dic);
                        
                        DLog(@"Dis >>>%@",[Dic objectForKey:@"uniqueid"]);
                        
                        StoreValue(@"UserInfo", Dic);
                        StoreValue(kIsLogin, @"true");
                        [AppDelegate_ RemoveProgressloader:self.view];
                        
                        if ([[Dic valueForKey:@"buyers_mode"] integerValue] == 0) {
                            [self performSegueWithIdentifier:@"basicinfo" sender:self];
                        }
                    }else{
                        ShowUIAlertWithOKButtonAndTapBlock(@"", dic[@"msg"], NO, ^{
                            //[self.txtEmail becomeFirstResponder];
                        });
                    }
                }
            }, ^(NSString *error, NSInteger code) {
                ShowAlert(@"Error" , [NSString stringWithFormat:@"%@",[error description]]);
            }, ^{
                //[MBProgressHUD hideHUDForView:self.view animated:NO];
                [AppDelegate_ RemoveProgressloader:self.view];
            });

        }
        else {
            [self performSegueWithIdentifier:@"basicinfo" sender:self];
        }
        
        
         
        
    }
    
}

-(void)selectedCategories:(NSMutableArray *)arrCategories{
    
    NSMutableArray *arrTemp = [[NSMutableArray alloc] initWithArray:arrCategories];
    
    [arrInterestedCategoies removeAllObjects];
    arrInterestedCategoies = arrTemp;
    DLog(@"arrInterestedCategoies >>>%@",arrInterestedCategoies);
}

#pragma mark - UITextField Delegate Mathod.

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(self.txtEmail == textField){
        [self.txtPassword becomeFirstResponder];
    }
    else if(self.txtPassword == textField){
        [self.txtConfirmPassword becomeFirstResponder];
    }
    else {
        [self.txtConfirmPassword resignFirstResponder];
    }
    
    
    return YES;
    
    
}

#pragma mark - Custom methods

-(void)enableBuyerMode:(NSString *)unique_id{
    
    DLog(@"unique_id >>>%@",unique_id);
    
    //unique_id = [unique_id stringByReplacingOccurrencesOfString:@"(" withString:@""];
    //unique_id = [unique_id stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    NSArray *arrKey = @[@"unique_id",@"speak_language",@"teach_category",@"country",@"timezone",@"mobile_code",@"mobile_number",@"selling_mode",@"buyers_mode",@"profile_image"];
    
    NSArray *arrValue = @[unique_id,@"",@"",@"",@"",@"",@"",@"0",@"1",@""];
    
    
    [mdlClass serviceCall:arrKey value:arrValue url:@"dashboard.php" selector:@selector(getDashboardStudenResponse:)];
    
}
-(BOOL)validateLoginData{
    if([[self.txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
        ShowAlert(@"", @"Please Enter Email Address.!");
        
        return FALSE;
    }
    if (![self NSStringIsValidEmail:self.txtEmail.text]) {
        ShowAlert(@"", @"Please Enter valide email address.!");
        
        return FALSE;
    }

    if([[self.txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
        ShowAlert(@"", @"Please Enter Password.!");
        
        return FALSE;
    }
    
    if (!IsStudent()) {
        if([[self.txtConfirmPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
            ShowAlert(@"", @"Please ReEnter Password.!");
            
            return FALSE;
        }
        
        if(![self.txtPassword.text isEqualToString:self.txtConfirmPassword.text]){
            ShowAlert(@"", @"Password not match.!");
            
            return FALSE;
        }
    }
    
    
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self.txtConfirmPassword resignFirstResponder];
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

-(void)getRegisterForStudenResponse:(NSDictionary *)result
{
    
    
    [AppDelegate_ RemoveProgressloader:self.view];
    if (result != nil) {
        
        if ([[result valueForKey:@"status"] integerValue] == 1 ) {
            
            NSDictionary *Dic = [result valueForKey:@"data"][0];
            DLog(@"Dis >>>%@",Dic);
            
            DLog(@"Dis >>>%@",[Dic objectForKey:@"uniqueid"]);
            //[self enableBuyerMode:[Dic objectForKey:@"uniqueid"]];
            
            StoreValue(@"UserInfo", Dic);
            StoreValue(kIsLogin, @"true");
            [AppDelegate_ RemoveProgressloader:self.view];
            
            if ([[Dic valueForKey:@"buyers_mode"] integerValue] == 0) {
                [self performSegueWithIdentifier:@"basicinfo" sender:self];
            }
        }
        else {
            NSString *msg = [result valueForKey:@"msg"];
            ShowAlert(@"", msg);
        }
        
    }
}

-(void)getDashboardStudenResponse:(NSDictionary *)result
{
    
    [AppDelegate_ showProgressloader:self.view];
    if (result != nil) {
        
        if ([[result valueForKey:@"status"] integerValue] == 1 ) {
            
            NSDictionary *Dic = [result valueForKey:@"data"];
            DLog(@"Dis >>>%@",Dic);
            StoreValue(@"UserInfo", Dic);
            StoreValue(kIsLogin, @"true");
            [AppDelegate_ RemoveProgressloader:self.view];
            [AppDelegate_ switchToMainScreen];
            
        }
        else {
            NSString *msg = [result valueForKey:@"msg"];
            ShowAlert(@"", msg);
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
