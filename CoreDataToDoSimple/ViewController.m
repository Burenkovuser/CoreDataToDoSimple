//
//  ViewController.m
//  CoreDataToDoSimple
//
//  Created by Vasilii on 18.07.17.
//  Copyright © 2017 Vasilii Burenkov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

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

@end
