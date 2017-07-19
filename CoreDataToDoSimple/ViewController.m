//
//  ViewController.m
//  CoreDataToDoSimple
//
//  Created by Vasilii on 18.07.17.
//  Copyright © 2017 Vasilii Burenkov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong) NSManagedObject *selected_Todo;
@property (strong) NSMutableArray *todolist;

@end

@implementation ViewController

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Managed Object Context

-(NSManagedObjectContext *) managedObjectContext {
    NSManagedObjectContext *context = nil;
    id deligate = [[UIApplication sharedApplication] delegate];
    if ([deligate performSelector:@selector(managedObjectContext)]) {
        context = [deligate managedObjectContext];
    }
    return context;
}

#pragma mark - Load Core data values

- (void) load_CoreData {
    //извлечение данных
    NSManagedObjectContext *managmedObjectContex = [self managedObjectContext];
    NSFetchRequest *fetcRequest = [[NSFetchRequest alloc] initWithEntityName:@"Todolist"];//извлекаем данные из созданной сущности
    self.todolist = [[managmedObjectContex executeRequest:fetcRequest error:nil] mutableCopy]; //выполняем запрос на извлечение в изменяемый архив todolist
    _lbl_nodata.alpha = 0.0;
    if (self.todolist.count == 0) {
        _lbl_nodata.alpha = 1.0;
    }
    [_table_View reloadData];
}
/*
#pragma mark - Add Dummy Values for Testing
-(void)addtodolist
{
    for (int i = 1 ; i < 6; i++)
    {
        NSString *str_Title = [NSString stringWithFormat:@"TEST DATA-%d", i];
        NSString *str_Desc = [NSString stringWithFormat:@"TEST DESCRIPTION-%d", i];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        NSString *str_Date = [dateFormatter stringFromDate:[NSDate date]];
        
      // [self addCoreDateValues:YES Title:str_Title Desc:str_Desc Date:str_Date completed:@"N" stats:@"Y"];
    }
}
*/

#pragma mark - Add or Update Core data values
// все атрибуты сущности из модели
- (void) addCoreDataValues: (BOOL) newValue Title:(NSString*)str_Title Desc:(NSString*)str_Desc Date:(NSString *)str_Date completed:(NSString *)str_Completed stats:(NSString *)str_Status
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (newValue == YES) {
        //создаем новый объект по сущности
        NSManagedObject *new_todo_object = [NSEntityDescription insertNewObjectForEntityForName:@"Todolist" inManagedObjectContext:context];
        [new_todo_object setValue:str_Title forKey:@"title"];//значение из метода, ключ из сущности
        [new_todo_object setValue:str_Desc forKey:@"desc"];
        [new_todo_object setValue:str_Date forKey:@"date"];
        [new_todo_object setValue:str_Completed forKey:@"complited"];
        [new_todo_object setValue:str_Status forKey:@"status"];
        
    } else { //иначе выбираем
        [self.selected_Todo setValue:str_Title forKey:@"title"];
        [self.selected_Todo setValue:str_Desc forKey:@"desc"];
        [self.selected_Todo setValue:str_Date forKey:@"date"];
        [self.selected_Todo setValue:str_Completed forKey:@"comploted"];
        [self.selected_Todo setValue:str_Status forKey:@"status"];
    }
    NSError *error = nil;
    //сохраняем объект в хранилище
    if (![context save:&error]) {//если нет ошибки
         NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // количество секциий
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // количество строк в секции
    return self.todolist.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    //настройка данный в ячейке
        NSManagedObject *todo_object = [self.todolist objectAtIndex:indexPath.row];
        NSString *str_Title_Txt = [[NSString stringWithFormat:@"%@", [todo_object valueForKey:@"title"]]uppercaseString];
        [cell.textLabel setText:str_Title_Txt];
        
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"Created Date: %@", [todo_object valueForKey:@"datetime"]]];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"Times New Roman" size:10.0]];
        if ([[todo_object valueForKey:@"complited"] isEqualToString:@"Y"]) {
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        } else {
            cell.textLabel.textColor = [UIColor greenColor];
            cell.textLabel.textColor = [UIColor greenColor];
        }
    }
    return cell;
}
//возможность редактирования
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
//удаление из базы и из таблицы
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObjectContext *context =[self managedObjectContext];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //удаление из базы
        [context deleteObject:[self.todolist objectAtIndex:indexPath.row]];
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
            //удаление из таблицы
            [self.todolist removeObjectAtIndex:indexPath.row];
            [_table_View deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            _lbl_nodata.alpha = 0.0;
            if (self.todolist.count == 0)
            {
                _lbl_nodata.alpha = 1.0;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selected_Todo = nil;
    NSManagedObject *selectedTodo = [self.todolist objectAtIndex:indexPath.row]; //[[table_View indexPathForSelectedRow] row]
    self.selected_Todo = selectedTodo;
    [self open_AddEditView:NO];
}

#pragma mark - Show and Hide the AddEditView
-(void)open_AddEditView:(BOOL)AddNew
{
    _view_EditAdd.alpha = 1.0;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [animation setFromValue:[NSNumber numberWithFloat:0.0f]];
    [animation setToValue:[NSNumber numberWithFloat:1.0f]];
    [animation setDuration:0.2];
    [animation setBeginTime:CACurrentMediaTime()];
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    [[_view_EditAdd layer] addAnimation:animation forKey:@"scale"];
    
    [_btn_AddUpdate setTag:100];
    [_btn_AddUpdate setTitle:@"ADD" forState:UIControlStateNormal];
    [_txtfld_Title setText:@""];
    [_textfld_Desc setText:@""];
    _segctrl_completed.selectedSegmentIndex = 0;
    
    if (AddNew == NO)
    {
        [_btn_AddUpdate setTag:200];
        [_btn_AddUpdate setTitle:@"UPDATE" forState:UIControlStateNormal];
        
        [_txtfld_Title setText:[self.selected_Todo valueForKey:@"title"]];
        [_textfld_Desc setText:[self.selected_Todo valueForKey:@"desc"]];
        NSString *str_txt_segment = [[self.selected_Todo valueForKey:@"completed"] uppercaseString];
        if ([str_txt_segment isEqualToString:@"Y"])
        {
            _segctrl_completed.selectedSegmentIndex = 1;
        }
        else
        {
            _segctrl_completed.selectedSegmentIndex = 0;
        }
    }
}

-(void)hide_AddEditView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [animation setFromValue:[NSNumber numberWithFloat:1.0f]];
    [animation setToValue:[NSNumber numberWithFloat:0.0f]];
    [animation setDuration:0.2];
    [animation setBeginTime:CACurrentMediaTime()];
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    [[_view_EditAdd layer] addAnimation:animation forKey:@"scale"];
    
    [self performSelector:@selector(hide_ViewEditAdd) withObject:nil afterDelay:0.2];
}

-(void)hide_ViewEditAdd
{
    _view_EditAdd.alpha = 0.0;
}



- (IBAction)AddNew_Todo:(id)sender {
    [self open_AddEditView:YES];
}

- (IBAction)save_AddEditView:(id)sender {
    
    {
        [_txtfld_Title resignFirstResponder];
        [_textfld_Desc resignFirstResponder];
        
        UIButton *btn = (UIButton *)sender;
        int btn_tag = (int)btn.tag;
        
        NSString *str_Title = [NSString stringWithFormat:@"%@", _txtfld_Title.text];
        NSString *str_Desc = [NSString stringWithFormat:@"%@", _textfld_Desc.text];
        
        if (str_Title.length > 0 && str_Desc.length > 0)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterLongStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
            NSString *str_Date = [dateFormatter stringFromDate:[NSDate date]];
            
            NSString *str_Completed = [NSString stringWithFormat:@"N"];
            if (_segctrl_completed.selectedSegmentIndex == 1)
            {
                str_Completed = [NSString stringWithFormat:@"Y"];
            }
            if (btn_tag == 200)
            {
                [self addCoreDataValues:NO Title:str_Title Desc:str_Desc Date:str_Date completed:str_Completed stats:@"Y"];
            }
            else
            {
                [self addCoreDataValues:NO Title:str_Title Desc:str_Desc Date:str_Date completed:str_Completed stats:@"Y"];
            }
            [self hide_AddEditView];
            [self load_CoreData];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Fill the details" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
}

- (IBAction)close_AddEditView:(id)sender {
    [self hide_AddEditView];
}

#pragma mark - Text Field Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


    @end


