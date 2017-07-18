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

- (IBAction)AddNew_Todo:(id)sender {
}

- (IBAction)save_AddEditView:(id)sender {
}

- (IBAction)close_AddEditView:(id)sender {
}
@end
