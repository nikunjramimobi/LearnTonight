//
//  InterestedCategoriesViewController.m
//  LearnTonight
//
//  Created by Mag_Mini_1 on 01/08/16.
//  Copyright © 2016 Mag_Mini_1. All rights reserved.
//

#import "InterestedCategoriesViewController.h"
#import "CountryListDataSource.h"
#import "NSTimeZone+CountryCode.h"
@implementation categoriesCell

- (void)awakeFromNib {
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end


@interface InterestedCategoriesViewController (){
    NSArray *arrCategories;
    NSMutableArray *arrSortedcategories;
    NSIndexPath *selectedIndexPath;
    ModelClass *mdlClass;
    
}

@end

@implementation InterestedCategoriesViewController
@synthesize arrSelectedCategories,selectionType;;
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mdlClass = [[ModelClass alloc] init];
    mdlClass.delegate = self;
    [self getData];
    
}

-(void)getData{
    
    
    if ([selectionType isEqualToString:@"Language"]) {
        //arrCategories = [NSArray arrayWithObjects:@"Chinese",@"Spanish",@"English",@"Arabic",@"Hindi",@"Bengali",@"Portuguese",@"Russian",@"Japanese",@"German", nil];
        
        LanguageListDataSource *dataSource = [[LanguageListDataSource alloc] init];
        arrCategories = [dataSource languages];
        arrSortedcategories = [arrCategories  mutableCopy];
        
        self.lblTitle.text = @"Select Language";
    }
    else if([selectionType isEqualToString:@"subject"]){
        self.lblTitle.text = @"Select Subject";
        [self getcategories];
        /*arrCategories = [NSArray arrayWithObjects:@"Chinese",@"Spanish",@"English",@"Arabic",@"Hindi",@"Bengali",@"Portuguese",@"Russian",@"Japanese",@"German", nil];
        arrSortedcategories = [arrCategories  mutableCopy];*/
    }
    else if([selectionType isEqualToString:@"Country"]){
        self.lblTitle.text = @"Select Country";
        CountryListDataSource *dataSource = [[CountryListDataSource alloc] init];
        arrCategories = [dataSource countries];
        
        DLog(@"arrCategories >>>%@",arrCategories);
        arrSortedcategories = [arrCategories  mutableCopy];
    }
    else if([selectionType isEqualToString:@"TimeZone"]) {
        self.lblTitle.text = @"Select TimeZone";
       // NSTimeZone *time = ;
        DLog(@"arrCategories >>>%@",[NSTimeZone countryCodeFromLocalizedName]);

        
        arrCategories = [NSArray arrayWithObjects:@"Chinese",@"Spanish",@"English",@"Arabic",@"Hindi",@"Bengali",@"Portuguese",@"Russian",@"Japanese",@"German", nil];
        arrSortedcategories = [arrCategories  mutableCopy];
    }
    else {
        
    }
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods
-(void)setUp{
    
    [self.txtCategories.layer setBorderWidth:2.0f];
    [self.txtCategories.layer setBorderColor:theamcolor.CGColor];

}

#pragma mark - UIButton Action
- (IBAction)actionBack:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)actionDone:(id)sender{
    
    if([self.delegate respondsToSelector:@selector(selectedCategories:)])
    {
        DLog(@"arrSelectedCategories >>>%@",arrSelectedCategories);
        [self.delegate selectedCategories:arrSelectedCategories];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)getcategories{
    [AppDelegate_ showProgressloader:self.view];
    
    mdlClass = [[ModelClass alloc] init];
    mdlClass.delegate = self;
    
   // http://206.72.192.56/LearnTonight/category.php
    
   // NSArray *arrKey = @[@"email",@"password",@"login_type",@"id"];
   // NSArray *arrValue = @[email,pass,login_type,socialid];
    
    
    [mdlClass serviceCall:nil value:nil url:@"category.php" selector:@selector(getcategoriesResponse:)];
}
-(void)getcategoriesResponse:(NSDictionary *)result
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [AppDelegate_ RemoveProgressloader:self.view];
        if (result != nil) {
            DLog(@"result >>%@",result);
            
            if ([[result valueForKey:@"status"] integerValue] == 1 ) {
                
                
                NSMutableArray *Dic = [[result valueForKey:@"data"] mutableCopy];
                DLog(@"Dic >>%@",Dic);
                
                NSMutableArray *Categories = [[NSMutableArray alloc]init];
                for (NSInteger i = 0; i < Dic.count; i++) {
                    NSDictionary *dicCat = [Dic objectAtIndex:i];
                    
                    DLog(@"dicCat >>%@",dicCat);
                    
                    [Categories addObject:[dicCat valueForKey:@"category_name"]];
                }
                [arrSortedcategories removeAllObjects];
                               
                arrSortedcategories = [Categories mutableCopy];
                DLog(@"arrSortedcategories >>%@",arrSortedcategories);
                [self.tableview reloadData];
                
            }
            else {
                
                NSString *msg = [result valueForKey:@"msg"];
                ShowAlert(@"", msg);
            }
            
        }
    });
    
    
}

#pragma mark - Tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"count ==>%ld",(long)arrSortedcategories.count);
    return arrSortedcategories.count;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    
    
    categoriesCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    NSString *name = [arrSortedcategories objectAtIndex:indexPath.row];
    if ([selectionType isEqualToString:@"Country"] || [selectionType isEqualToString:@"Language"]) {
        NSDictionary *dic = [arrSortedcategories objectAtIndex:indexPath.row];
        
        name = [dic valueForKey:kName];
        
        if(indexPath == selectedIndexPath)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
     }
    
    
    cell.lblCategory.text = name;
    
    if ([arrSelectedCategories containsObject:cell.lblCategory.text]) {
        [cell.btnCategory setSelected:TRUE];
    }
    else {
        [cell.btnCategory setSelected:FALSE];
    }
        
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    categoriesCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *category;
    
    if ([selectionType isEqualToString:@"Country"] || [selectionType isEqualToString:@"Language"]) {
        NSDictionary *dic = [arrSortedcategories objectAtIndex:indexPath.row];
        
        category = [dic valueForKey:kName];
    }
    else {
        category = [arrSortedcategories objectAtIndex:indexPath.row];
    }
    
    
    
    if ([selectionType isEqualToString:@"Country"]) {
        
        [arrSelectedCategories removeAllObjects];
        [arrSelectedCategories addObject:category];
        
        DLog(@"arrSelectedCategories select >>>%@",arrSelectedCategories);
        [tableView reloadData];
    }
    else {
        if (![arrSelectedCategories containsObject:category]) {
            [arrSelectedCategories addObject:category];
            [cell.btnCategory setSelected:TRUE];
        }
        else {
            
            if (arrSelectedCategories.count >1) {
                [cell.btnCategory setSelected:false];
                [arrSelectedCategories removeObject:category];
            }
            
            
        }
        DLog(@"arrSelectedCategories select >>>%@",arrSelectedCategories);
    }
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *searchString;
    if (string.length > 0) {
        searchString = [NSString stringWithFormat:@"%@%@",textField.text, string];
    } else {
        searchString = [textField.text substringToIndex:[textField.text length] - 1];
    }
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", searchString];
    
    [arrSortedcategories removeAllObjects];
    arrSortedcategories = [[arrCategories filteredArrayUsingPredicate:filter] mutableCopy];
    
    if (!searchString || searchString.length == 0) {
        
        arrSortedcategories = [arrCategories mutableCopy];
    } else {
        if (arrSortedcategories.count == 0) {
            DLog(@"No data From Search");
        }
    }    
    [self.tableview reloadData];
    return YES;
}

-(void)updateTextLabelsWithText:(NSString *)string
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",self.txtCategories.text];
    
    [arrSortedcategories  removeAllObjects];
    arrSortedcategories = [[arrCategories filteredArrayUsingPredicate:predicate] mutableCopy];
    [self.tableview reloadData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
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
