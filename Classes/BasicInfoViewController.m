//
//  BasicInfoViewController.m
//  LearnTonight
//
//  Created by Mag_Mini_1 on 04/08/16.
//  Copyright © 2016 Mag_Mini_1. All rights reserved.
//

#import "BasicInfoViewController.h"
#import "CountryListDataSource.h"
#import "NSTimeZone+CountryCode.h"
@interface BasicInfoViewController (){
    
    NSDictionary *userInfo;
    
    UIView *viewSelected;
    NSString *requestURLString;
    NSString *strCountryCode;
    
    NSMutableArray *arrSpeakLanguage;
    NSMutableArray *arrInterestedCategoies;
    NSMutableArray *arrCountry;
    NSMutableArray *arrTimeZone;
    NSMutableArray *arrSelectData;
    NSString *type;
    NSString *countryName;
    NSString *countryTimeZone;
    UIImage *PicProfile;
    
     ModelClass *mdlClass;
    NSDictionary *dicUser;
    
    NSInteger defualtHieghtOfCenterView;
    NSInteger defualtHieghtOfCategoreisView;
    NSInteger currentHieghtOfCategoreisView;
    
}

@end

@implementation BasicInfoViewController
@synthesize popoverController,ctr;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    userInfo = ReadValue(@"UserInfo");
    
    mdlClass = [[ModelClass alloc] init];
    mdlClass.delegate = self;
    dicUser = ReadValue(@"UserInfo");
   
    // Do any additional setup after loading the view.
    
    arrSpeakLanguage = [[NSMutableArray alloc] init];
    arrInterestedCategoies= [[NSMutableArray alloc] init];
    arrCountry= [[NSMutableArray alloc] init];
    arrTimeZone= [[NSMutableArray alloc] init];
    arrSelectData= [[NSMutableArray alloc] init];
    
    defualtHieghtOfCenterView =self.viewCenter.frame.size.height;
    defualtHieghtOfCategoreisView = 40;
    
    [self setUp];
    [self setCountry];
    [self setTimeZone];
    
    [self fillInfo];
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    
    
    
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

#pragma mark - custom methods
-(void)setUp{
    
    
    [self.txtFName.layer setCornerRadius:(self.txtLName.frame.size.height /2)];
    [self.txtFName.layer setBorderWidth:2.0f];
    [self.txtFName.layer setBorderColor:theamcolor.CGColor];
    [self.txtFName setValue:theamcolor forKeyPath:@"_placeholderLabel.textColor"];
    
    
    [self.txtLName.layer setCornerRadius:(self.txtLName.frame.size.height /2)];
    [self.txtLName.layer setBorderWidth:2.0f];
    [self.txtLName.layer setBorderColor:theamcolor.CGColor];
    [self.txtLName setValue:theamcolor forKeyPath:@"_placeholderLabel.textColor"];

    
    [self.viewLanguage.layer setCornerRadius:(self.viewLanguage.frame.size.height /2)];
    [self.viewLanguage.layer setBorderWidth:2.0f];
    [self.viewLanguage.layer setBorderColor:theamcolor.CGColor];
    [self.txtLanguage setValue:theamcolor forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.viewSubject.layer setCornerRadius:(self.viewSubject.frame.size.height /2)];
    [self.viewSubject.layer setBorderWidth:2.0f];
    [self.viewSubject.layer setBorderColor:theamcolor.CGColor];
    [self.txtSubject setValue:theamcolor forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.viewCountry.layer setCornerRadius:(self.viewCountry.frame.size.height /2)];
    [self.viewCountry.layer setBorderWidth:2.0f];
    [self.viewCountry.layer setBorderColor:theamcolor.CGColor];
    [self.txtCountry setValue:theamcolor forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.viewTimeZone.layer setCornerRadius:(self.viewTimeZone.frame.size.height /2)];
    [self.viewTimeZone.layer setBorderWidth:2.0f];
    [self.viewTimeZone.layer setBorderColor:theamcolor.CGColor];
    [self.txtTimeZone setValue:theamcolor forKeyPath:@"_placeholderLabel.textColor"];

    
    [self.viewMobile.layer setCornerRadius:(self.viewMobile.frame.size.height /2)];
    [self.viewMobile.layer setBorderWidth:2.0f];
    [self.viewMobile.layer setBorderColor:theamcolor.CGColor];
    [self.txtMobile setValue:theamcolor forKeyPath:@"_placeholderLabel.textColor"];
    
    if (IsStudent()) {
        [self.txtLanguage setPlaceholder:@"Select learning language"];
        [self.txtSubject setPlaceholder:@"Subject you want to learn"];
        
    }
    else {
        [self.txtLanguage setPlaceholder:@"Select teaching language"];
        [self.txtSubject setPlaceholder:@"Subject you want to teach"];
    }
    
    [self.btnNext.layer setCornerRadius:(self.btnNext.frame.size.height /2)];
    [self.btnNext.layer setBorderWidth:2.0f];
    [self.btnNext.layer setBorderColor:theamcolor.CGColor];
    
    
    UITapGestureRecognizer *tapLanguage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OpentSelectionList:)];
        tapLanguage.numberOfTapsRequired = 1;
    [self.viewLanguage addGestureRecognizer:tapLanguage];
    
    UITapGestureRecognizer *tapSubject = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OpentSelectionList:)];
    tapSubject.numberOfTapsRequired = 1;
    [self.viewSubject addGestureRecognizer:tapSubject];
    
    UITapGestureRecognizer *tapCountry = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OpentSelectionList:)];
    tapCountry.numberOfTapsRequired = 1;
    //[self.viewCountry addGestureRecognizer:tapCountry];
    
    UITapGestureRecognizer *tapTimeZone = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OpentSelectionList:)];
    tapTimeZone.numberOfTapsRequired = 1;
    //[self.viewTimeZone addGestureRecognizer:tapTimeZone];
    
    
    UITapGestureRecognizer *tapProfilePic = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SelectProfilePic:)];
    tapProfilePic.numberOfTapsRequired = 1;
    [self.imgProfile addGestureRecognizer:tapProfilePic];
    
    
    
    UIView *spacerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.txtFName setLeftViewMode:UITextFieldViewModeAlways];
    [self.txtFName setLeftView:spacerView1];
    
    UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.txtLName setLeftViewMode:UITextFieldViewModeAlways];
    [self.txtLName setLeftView:spacerView2];
    
    //UIView *spacerView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    //[self.txtMobile setLeftViewMode:UITextFieldViewModeAlways];
    //[self.txtMobile setLeftView:spacerView3];
    
    [self setUpConstringAsPerTarget];
}

-(void)fillInfo{
    
    
    if (dicUser != nil) {
        
        NSString *url = [dicUser valueForKey:@"profile_image"];
        
        if (url  && [url length] > 0) {
            
            UIImage *img = [UIImage imageNamed:@"profil_icon"];
            [self.btnImgProfile.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:img completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                PicProfile = image;
                [self.btnImgProfile setImage:PicProfile forState:UIControlStateNormal];
                self.btnImgProfile.layer.cornerRadius = self.btnImgProfile.frame.size.width / 2;;
                self.btnImgProfile.clipsToBounds = YES;
                self.btnImgProfile.layer.borderColor = [UIColor redColor].CGColor;
                self.btnImgProfile.layer.borderWidth = 1.0f;
                
            }];
            
        }
        
        self.txtFName.text = [dicUser valueForKey:@"firstname"];
        self.txtLName.text = [dicUser valueForKey:@"lastname"];
    }
}

-(void)setCountry{
    
   // NSString *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
   
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSString *country = [usLocale displayNameForKey: NSLocaleCountryCode value: countryCode];
    
    countryName = country;
    
    CountryListDataSource *dataSource = [[CountryListDataSource alloc] init];
    NSArray *arrCategories = [dataSource countries];
    
    for (int i = 0; i<arrCategories.count; i++)
    {
        NSMutableDictionary *dictionary = [arrCategories objectAtIndex:i];
        
        
        if ([[dictionary valueForKey:@"name"] caseInsensitiveCompare:countryName] == NSOrderedSame) {
            strCountryCode = [dictionary valueForKey:@"dial_code"];
            break;
        }
    }

    self.lblCountryCode.text = strCountryCode;
    self.lblCountryCode.backgroundColor = [UIColor grayColor];
    self.lblCountryCode.layer.masksToBounds = YES;
    self.lblCountryCode.textAlignment = NSTextAlignmentCenter;
    self.lblCountryCode.layer.cornerRadius = self.lblCountryCode.frame.size.height/2;
    
    DLog(@"country >>>%@",country);
    
     [arrCountry removeAllObjects];
     [arrCountry addObject:country];
     arrSelectData = arrCountry;
     viewSelected = self.viewCountry;
     [self setUpIntestedCategories];
}

-(void)setTimeZone{
    
    [arrTimeZone removeAllObjects];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSLog(@" - current  local timezone  is  %@",[timeZone abbreviation]);
    NSString *tzName = [timeZone name];
    countryTimeZone = [NSString stringWithFormat:@"%@ %@",[timeZone abbreviation],tzName];
    [arrTimeZone addObject:countryTimeZone];
    arrSelectData = arrTimeZone;
    viewSelected = self.viewTimeZone;
    [self setUpIntestedCategories];
    
    
}

-(void)setUpConstringAsPerTarget{
    if (IsStudent()) {
        NSLayoutConstraint *heightConstraintLastBoarder;
        for (NSLayoutConstraint *constraint in self.lastBorder.constraints) {
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                heightConstraintLastBoarder = constraint;
                break;
            }
        }
        
        
        heightConstraintLastBoarder.constant = 0;
        
        NSLayoutConstraint *heightConstraintMobile;
        for (NSLayoutConstraint *constraint in self.viewMobile.constraints) {
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                heightConstraintMobile = constraint;
                break;
            }
        }
        
        heightConstraintMobile.constant = 0;
        [self.viewMobile setHidden:TRUE];
        
        heightConstraintLastBoarder.constant = 0;
        
        NSLayoutConstraint *heightConstraintBtnTerms;
        for (NSLayoutConstraint *constraint in self.btnTerms.constraints) {
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                heightConstraintBtnTerms = constraint;
                break;
            }
        }
        
        heightConstraintBtnTerms.constant = 0;
        [self.btnTerms setHidden:TRUE];
    }
    else {
        if ([[dicUser valueForKey:@"buyers_mode"] integerValue] == 1 ) {
            NSLayoutConstraint *heightConstraintviewLanguage;
            for (NSLayoutConstraint *constraint in self.viewLanguage.constraints) {
                if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                    heightConstraintviewLanguage = constraint;
                    break;
                }
            }
            
            
            heightConstraintviewLanguage.constant = 0;
            [self.viewLanguage setHidden:true];
            
            NSLayoutConstraint *heightConstraintViewCountry;
            for (NSLayoutConstraint *constraint in self.viewCountry.constraints) {
                if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                    heightConstraintViewCountry = constraint;
                    break;
                }
            }
            
            heightConstraintViewCountry.constant = 0;
            
            
            NSLayoutConstraint *heightConstraintViewTimeZone;
            for (NSLayoutConstraint *constraint in self.viewTimeZone.constraints) {
                if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                    heightConstraintViewTimeZone = constraint;
                    break;
                }
            }
            
            heightConstraintViewTimeZone.constant = 0;
        }
    }
}

-(void)setUpIntestedCategories{
    
    
    if (viewSelected != self.viewCountry && viewSelected != self.viewTimeZone) {
        if (arrSelectData.count > 0) {
            
            UITextField *txt = (UITextField *)[viewSelected viewWithTag:2];
            [txt setHidden:TRUE];
            
            UIImageView *img = (UIImageView *)[viewSelected viewWithTag:1];
            [img setHidden:TRUE];
        }
        else{
            UITextField *txt = (UITextField *)[viewSelected viewWithTag:2];
            [txt setHidden:FALSE];
            
            UIImageView *img = (UIImageView *)[viewSelected viewWithTag:1];
            [img setHidden:FALSE];
        }
        
        for (UIView *subView in viewSelected.subviews) {
            if ([subView isKindOfClass:[UILabel class]]) {
                [subView removeFromSuperview];
            }
        }
    }
    
    
    NSInteger height = 25;
    NSInteger indexX = 10;
    NSInteger indexY = (40 - 25)/2;
    
    NSInteger herizontalSpace = 5;
    NSInteger verticalSpace = 3;
    
    UILabel *lastLabel;
    
    for (NSInteger i = 0; i < arrSelectData.count; i++) {
        NSString *categoryName = [arrSelectData objectAtIndex:i];
        CGFloat width = [self widthOfString:categoryName withFont:self.txtLanguage.font];
        
        if ((indexX + width + herizontalSpace) > viewSelected.frame.size.width) {
            indexX = 10;
            indexY = indexY + height +verticalSpace;
        }
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(indexX, indexY, width, height)];
        lbl.text = categoryName;
        lbl.font = self.txtLanguage.font;
        lbl.textColor = [UIColor whiteColor];
        lbl.backgroundColor = [UIColor grayColor];
        lbl.layer.masksToBounds = YES;
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.layer.cornerRadius = height/2;
        [viewSelected addSubview:lbl];
        
        indexX = indexX + width +herizontalSpace;
        
        lastLabel = lbl;
    }
    
    NSLayoutConstraint *heightConstraint;
    for (NSLayoutConstraint *constraint in viewSelected.constraints) {
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

-(NSString *)jsonFormArray:(NSMutableArray *)arr{
    
    NSError *error;
    
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    
    DLog(@"jsonString >>>%@",jsonString);
    return jsonString;
}

-(void)changeScrollviewFram{
    
    /*if(viewSelected.subviews.count > 0){
        
        if (currentHieghtOfCategoreisView > defualtHieghtOfCategoreisView) {
            [self.scollview setScrollEnabled:YES];
        }
        else {
            [self.scollview setScrollEnabled:NO];
        }
        
    }
    else {
        [self.scollview setScrollEnabled:NO];
    }*/
    
}
- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width + 10;
}

- (void)OpentSelectionList:(UITapGestureRecognizer *)gesture {
    
    viewSelected = nil;
    if (gesture.view.tag == 11) {
        
        viewSelected = self.viewLanguage;
         type = @"Language";
        [arrSelectData removeAllObjects];
        arrSelectData = arrSpeakLanguage;
    }
    else if(gesture.view.tag == 12){
        viewSelected = self.viewSubject;
        type = @"subject";
        [arrSelectData removeAllObjects];
        arrSelectData = arrInterestedCategoies;
    }
    else if(gesture.view.tag == 13){
        viewSelected = self.viewCountry;
        type = @"Country";
        [arrSelectData removeAllObjects];
        arrSelectData = arrCountry;
    }
    else if(gesture.view.tag == 14) {
        viewSelected = self.viewTimeZone;
        type = @"TimeZone";
        [arrSelectData removeAllObjects];
        arrSelectData = arrTimeZone;
    }
    else {
        
    }

    InterestedCategoriesViewController *intrestCategories = [self.storyboard instantiateViewControllerWithIdentifier:@"intrestedcategories"];
    
    
    intrestCategories.arrSelectedCategories = arrSelectData;
    intrestCategories.selectionType = type;
    intrestCategories.delegate = self;
    [self presentViewController:intrestCategories animated:YES completion:nil];
}

- (void)SelectProfilePic:(UITapGestureRecognizer *)gesture{
    
}


-(void)enableBuyerMode:(NSString *)unique_id{
    
    [AppDelegate_ showProgressloader:self.view];
    NSArray *arrKey = @[@"unique_id",@"firstname",@"lastname",@"speak_language",@"learn_category",@"teach_category",@"country",@"timezone",@"mobile_code",@"mobile_number",@"selling_mode",@"buyers_mode",@"profile_image"];
    
    
    NSArray *arrValue;
    if (IsStudent()) {
        
        if (PicProfile == nil) {
            arrValue = @[unique_id,self.txtFName.text,self.txtLName.text,[self jsonFormArray:arrSpeakLanguage],[self jsonFormArray:arrInterestedCategoies],@"",countryName,countryTimeZone,self.lblCountryCode.text,self.txtMobile.text,@"",@"1",@""];
        }
        else {
           NSData *data = UIImageJPEGRepresentation(PicProfile, 0.0005);
            arrValue = @[unique_id,self.txtFName.text,self.txtLName.text,[self jsonFormArray:arrSpeakLanguage],[self jsonFormArray:arrInterestedCategoies],@"",countryName,countryTimeZone,self.lblCountryCode.text,self.txtMobile.text,@"",@"1",data];
            
        }
    }
    else {
        
        
        if (PicProfile == nil) {
            arrValue = @[unique_id,[self jsonFormArray:arrSpeakLanguage],[self jsonFormArray:arrInterestedCategoies],@"",countryName,countryTimeZone,self.lblCountryCode.text,self.txtMobile.text,@"1",@"",@""];
        }
        else {
            NSData *data = UIImageJPEGRepresentation(PicProfile, 0.0005);
            arrValue = @[unique_id,[self jsonFormArray:arrSpeakLanguage],[self jsonFormArray:arrInterestedCategoies],@"",countryName,countryTimeZone,self.lblCountryCode.text,self.txtMobile.text,@"1",@"",data];
            
        }
        
    }
   
    DLog(@"arrKey >>>%@",arrKey);
    DLog(@"arrValue >>>%@",arrValue);
    
    [mdlClass serviceCallForMultipart:arrKey value:arrValue url:@"dashboard.php" selector:@selector(getDashboardStudenResponse:)];
}

-(void)tempServiceCall{
    /*NSMutableDictionary *dicDashboard;
    
    
    if (IsStudent()) {
        
        if (PicProfile == nil) {
            
            dicDashboard = [@{kMethodType: kMethodTypePost, user_unique_id:unique_id,
                              user_firstname:self.txtFName.text,
                              user_lastname:self.txtLName.text,
                              user_speak_language:[self jsonFormArray:arrSpeakLanguage],
                              user_learn_category:[self jsonFormArray:arrInterestedCategoies],
                              user_teach_category:@"",
                              user_country:countryName,
                              user_timezone:countryTimeZone,
                              user_mobile_code:self.lblCountryCode.text,
                              user_mobile_number:self.txtMobile.text,
                              user_selling_mode:@"",
                              user_buyers_mode:@"1",
                              user_profile_image:@""} mutableCopy];
            
            
            
        }
        else {
            NSData *data = UIImageJPEGRepresentation(PicProfile, 0.0005);
            dicDashboard = [@{kMethodType: kMethodTypePost, user_unique_id:unique_id,
                              user_firstname:self.txtFName.text,
                              user_lastname:self.txtLName.text,
                              user_speak_language:[self jsonFormArray:arrSpeakLanguage],
                              user_learn_category:[self jsonFormArray:arrInterestedCategoies],
                              user_teach_category:@"",
                              user_country:countryName,
                              user_timezone:countryTimeZone,
                              user_mobile_code:self.lblCountryCode.text,
                              user_mobile_number:self.txtMobile.text,
                              user_selling_mode:@"",
                              user_buyers_mode:@"1",
                              user_profile_image:data} mutableCopy];
            
        }
    }
    else {
        
        
        if (PicProfile == nil) {
            dicDashboard = [@{kMethodType: kMethodTypePost, user_unique_id:unique_id,
                              user_firstname:self.txtFName.text,
                              user_lastname:self.txtLName.text,
                              user_speak_language:[self jsonFormArray:arrSpeakLanguage],
                              user_learn_category:@"",
                              user_teach_category:[self jsonFormArray:arrInterestedCategoies],
                              user_country:countryName,
                              user_timezone:countryTimeZone,
                              user_mobile_code:self.lblCountryCode.text,
                              user_mobile_number:self.txtMobile.text,
                              user_selling_mode:@"1",
                              user_buyers_mode:@"",
                              user_profile_image:@""} mutableCopy];
        }
        else {
            NSData *data = UIImageJPEGRepresentation(PicProfile, 0.0005);
            dicDashboard = [@{kMethodType: kMethodTypePost, user_unique_id:unique_id,
                              user_firstname:self.txtFName.text,
                              user_lastname:self.txtLName.text,
                              user_speak_language:[self jsonFormArray:arrSpeakLanguage],
                              user_learn_category:@"",
                              user_teach_category:[self jsonFormArray:arrInterestedCategoies],
                              user_country:countryName,
                              user_timezone:countryTimeZone,
                              user_mobile_code:self.lblCountryCode.text,
                              user_mobile_number:self.txtMobile.text,
                              user_selling_mode:@"1",
                              user_buyers_mode:@"",
                              user_profile_image:data} mutableCopy];
            
        }
        
    }
    
    
    
    [AppDelegate_ showProgressloader:self.view];
    SendRequestToWebService(WSDashboard, dicDashboard, ^(id response) {
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
                [AppDelegate_ switchToMainScreen];
                
                
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
    });*/
}

-(void)getDashboardStudenResponse:(NSDictionary *)result
{
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
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults synchronize];
        }
        
    }
}

#pragma mark - UIButton Action
- (IBAction)actionNext:(id)sender{
    
    if ([self validateBasicInfo]) {
        
        NSDictionary *dic = ReadValue(@"UserInfo");
        DLog(@"Dis >>>%@",[dic objectForKey:@"uniqueid"]);
        [self enableBuyerMode:[dic objectForKey:@"uniqueid"]];
    }
    
}
- (IBAction)actionBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)actionSelectProfilePic:(id)sender {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Profile picture from" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [self dismissViewControllerAnimated:NO completion:nil];
        // Gallery button tappped.
        
        
        ctr = [[UIImagePickerController alloc] init];
        ctr.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ctr.delegate = self;
        ctr.allowsEditing = YES;
        [self presentViewController:ctr animated:YES completion:nil];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        // Camera button tapped.
        [self dismissViewControllerAnimated:NO completion:nil];
        
        ctr = [[UIImagePickerController alloc] init];
        ctr.sourceType = UIImagePickerControllerSourceTypeCamera;
        ctr.delegate = self;
        ctr.allowsEditing = YES;
        //self.ctr.videoMaximumDuration = 60.f;
        [self presentViewController:ctr animated:YES completion:nil];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            popoverController = [[UIPopoverController alloc] initWithContentViewController:ctr];
            [popoverController presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        } else {
            
        }

    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    PicProfile = image;
    
    [self.btnImgProfile setImage:image forState:UIControlStateNormal];
    self.btnImgProfile.layer.cornerRadius = self.btnImgProfile.frame.size.width / 2;;
    self.btnImgProfile.clipsToBounds = YES;
    self.btnImgProfile.layer.borderColor = [UIColor redColor].CGColor;
    self.btnImgProfile.layer.borderWidth = 1.0f;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (IBAction)actionAcceptTermsConditions:(id)sender{
    if (self.btnTerms.selected == TRUE) {
        [self.btnTerms setSelected:FALSE];
    }
    else {
        [self.btnTerms setSelected:TRUE];
    }
}
-(void)selectedCategories:(NSMutableArray *)arrCategories{
    
    NSMutableArray *arrTemp = [[NSMutableArray alloc] initWithArray:arrCategories];
    [arrSelectData removeAllObjects];
    arrSelectData = arrTemp;

    
    if (arrSelectData.count > 0) {
        
        if ([type isEqualToString:@"Language"]) {
            [arrSpeakLanguage removeAllObjects];
            arrSpeakLanguage = [arrSelectData mutableCopy];
        }
        else if([type isEqualToString:@"subject"]){
            [arrInterestedCategoies removeAllObjects];
            arrInterestedCategoies = [arrSelectData mutableCopy];
        }
        else if([type isEqualToString:@"Country"]){
            [arrCountry removeAllObjects];
            arrCountry = [arrSelectData mutableCopy];
        }
        else if([type isEqualToString:@"TimeZone"]) {
            [arrTimeZone removeAllObjects];
            arrTimeZone = [arrSelectData mutableCopy];
        }
        else {
            
        }
    }
    
    BOOL flag = TRUE;
    if (viewSelected.subviews.count > 0) {
        if (arrSelectData.count == 0) {
            flag = FALSE;
        }
    }
    if (flag == TRUE) {
        
        if (arrSelectData > 0) {
            [self setUpIntestedCategories];
        }
        
    }
    
    
    DLog(@"arrInterestedCategoies >>>%@",arrInterestedCategoies);
}

-(BOOL)validateBasicInfo{
    
    if([[self.txtFName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
        ShowAlert(@"", @"Please Enter Fisrt Name.!");
        
        return FALSE;
    }
    
    if([[self.txtLName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
        ShowAlert(@"", @"Please Enter Last Name.!");
        
        return FALSE;
    }
    
    if (arrSpeakLanguage.count == 0) {
        
        if (IsStudent()) {
            ShowAlert(@"", @"Please Select learning language.!");
             return FALSE;
        }
        else{
            if ([[dicUser valueForKey:@"buyers_mode"] integerValue] == 0 ){
                ShowAlert(@"", @"Please Select teaching language.!");
                return FALSE;
            }
            
            
        }
        
        
       
    }
    
    if (arrInterestedCategoies.count == 0) {
        
        if (IsStudent()) {
            ShowAlert(@"", @"Please Select subject you want to learn.!");
        }
        else{
            ShowAlert(@"", @"Please Select subject you want to teach.!");
        }
        
        return FALSE;
    }
    
    
    /*if(arrCountry.count == 0){
        ShowAlert(@"", @"Please select country.!");
        
        return FALSE;
    }
    
    if(arrTimeZone.count == 0){
        ShowAlert(@"", @"Please select timezone of country.!");
        
        return FALSE;
    }*/

    
    if (!IsStudent()) {
        
        /*if(arrSpeakLanguage.count == 0){
            ShowAlert(@"", @"Please Select Speck language.!");
            
            return FALSE;
        }*/

        
        if([[self.txtMobile.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
            ShowAlert(@"", @"Please Enter Mobile no..!");
            
            return FALSE;
        }
        
        if(self.btnTerms.isSelected == FALSE){
            ShowAlert(@"", @"Please Accept terms & condition!");
            
            return FALSE;
        }
    }
    
    
    [self.txtMobile resignFirstResponder];
    
    return TRUE;
}

#pragma mark - UITextField Delegate Mathod.

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(self.txtFName == textField){
        [self.txtLName becomeFirstResponder];
    }
    else if(self.txtLName == textField){
        [self.txtLName resignFirstResponder];
    }
    
    if(self.txtMobile == textField){
        [self.txtMobile resignFirstResponder];
    }
    
    
    return YES;
    
    
}

@end
