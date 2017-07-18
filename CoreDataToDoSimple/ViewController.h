//
//  ViewController.h
//  CoreDataToDoSimple
//
//  Created by Vasilii on 18.07.17.
//  Copyright © 2017 Vasilii Burenkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lbl_nodata;
@property (weak, nonatomic) IBOutlet UITableView *table_View;
@property (weak, nonatomic) IBOutlet UIView *view_EditAdd;
@property (weak, nonatomic) IBOutlet UITextField *txtfld_Title;
@property (weak, nonatomic) IBOutlet UITextField *textfld_Desc;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segctrl_completed;
@property (weak, nonatomic) IBOutlet UIButton *btn_AddUpdate;

- (IBAction)AddNew_Todo:(id)sender;
- (IBAction)save_AddEditView:(id)sender;
- (IBAction)close_AddEditView:(id)sender;



@end

