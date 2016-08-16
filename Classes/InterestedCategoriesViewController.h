//
//  InterestedCategoriesViewController.h
//  LearnTonight
//
//  Created by Mag_Mini_1 on 01/08/16.
//  Copyright © 2016 Mag_Mini_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InterestedCategoriesDelegate <NSObject>
-(void) selectedCategories:(NSMutableArray *)arrCategories;
@end


@interface categoriesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblCategory;
@property (weak, nonatomic) IBOutlet UIButton *btnCategory;


@end


@interface InterestedCategoriesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtCategories;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSString *selectionType;
@property (strong, nonatomic) NSMutableArray *arrSelectedCategories;
@property (nonatomic, assign) id<InterestedCategoriesDelegate>delegate;

- (IBAction)actionBack:(id)sender;
- (IBAction)actionDone:(id)sender;


@end
