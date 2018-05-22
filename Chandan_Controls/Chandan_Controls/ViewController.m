//
//  ViewController.m
//  Chandan_Controls
//
//  Created by Singh, Chandan F. on 16/05/16.
//  Copyright © 2016 Chandan SIngh. All rights reserved.
//

#import "ViewController.h"
#import "CAAutoFillTextField.h"
#import "CAAutoCompleteObject.h"
@interface ViewController () <CAAutoFillDelegate>

@property(nonatomic, weak) IBOutlet CAAutoFillTextField *myTextField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = 0; i <= 10; i++) {
        CAAutoCompleteObject *object = [[CAAutoCompleteObject alloc] initWithObjectName:[NSString stringWithFormat:@"drop down %d", i] AndID:i];
        [tempArray addObject:object];
    }
    _myTextField.dataSourceArray = tempArray;
    _myTextField.delegate = self;
}

- (void)CAAutoTextFillBeginEditing:(CAAutoFillTextField *)textField {
}

- (void)CAAutoTextFillEndEditing:(CAAutoFillTextField *)textField {
}

- (BOOL)CAAutoTextFillWantsToEdit:(CAAutoFillTextField *)textField {
    return YES;
}

@end
