//
//  AutoCompleteTextField.m
//  AutoCompleteTextField
//
//  Created by Chandan on 5/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CAAutoFillTextField.h"
#import "CAAutoCompleteObject.h"

@interface CAAutoFillTextField () {
    CGFloat tableHeight;
}

@property(nonatomic, strong) UITableView *autoCompleteTableView;
@property(nonatomic, strong) NSMutableArray<CAAutoCompleteObject *> *autoCompleteArray;

@end

@implementation CAAutoFillTextField

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        CGRect frame = self.frame;
        tableHeight = 30.0;
        
        _txtField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        _txtField.borderStyle = 3; // rounded, recessed rectangle
        _txtField.autocorrectionType = UITextAutocorrectionTypeNo;
        _txtField.textAlignment = NSTextAlignmentLeft;
        _txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _txtField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _txtField.returnKeyType = UIReturnKeyDone;
        _txtField.font = [UIFont systemFontOfSize:17.0];
        _txtField.textColor = [UIColor blackColor];
        _txtField.clipsToBounds = NO;
        [_txtField setDelegate:self];
        [self addSubview:_txtField];
        
        // Autocomplete Table
        self.autoCompleteTableView =
        [[UITableView alloc] initWithFrame:CGRectMake(3, _txtField.frame.origin.y + _txtField.frame.size.height, frame.size.width - 5, tableHeight) style:UITableViewStylePlain];
        self.autoCompleteTableView.delegate = self;
        self.autoCompleteTableView.dataSource = self;
        self.autoCompleteTableView.scrollEnabled = YES;
        self.autoCompleteTableView.hidden = NO;
        self.autoCompleteTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.autoCompleteTableView.rowHeight = tableHeight;
        [self addSubview:self.autoCompleteTableView];
        
        _dataSourceArray = [[NSMutableArray alloc] init];
        _autoCompleteArray = [[NSMutableArray alloc] init];
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        tableHeight = 30.0;
        
        _txtField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        _txtField.borderStyle = 3; // rounded, recessed rectangle
        _txtField.autocorrectionType = UITextAutocorrectionTypeNo;
        _txtField.textAlignment = NSTextAlignmentLeft;
        _txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _txtField.returnKeyType = UIReturnKeyDone;
        _txtField.font = [UIFont systemFontOfSize:14.0];
        _txtField.textColor = [UIColor blackColor];
        _txtField.clipsToBounds = NO;
        _txtField.delegate = self;
        [self addSubview:_txtField];
        
        // Autocomplete Table
        self.autoCompleteTableView =
        [[UITableView alloc] initWithFrame:CGRectMake(3, _txtField.frame.origin.y + _txtField.frame.size.height, frame.size.width - 5, tableHeight) style:UITableViewStylePlain];
        self.autoCompleteTableView.delegate = self;
        self.autoCompleteTableView.dataSource = self;
        self.autoCompleteTableView.scrollEnabled = YES;
        self.autoCompleteTableView.hidden = NO;
        self.autoCompleteTableView.rowHeight = tableHeight;
        [self addSubview:self.autoCompleteTableView];
        
        _dataSourceArray = [[NSMutableArray alloc] init];
        _autoCompleteArray = [[NSMutableArray alloc] init];
    }
    return self;
}

// Take string from Search Textfield and compare it with autocomplete array
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    [_autoCompleteArray removeAllObjects];
    
    for (CAAutoCompleteObject *object in _dataSourceArray) {
        NSRange substringRangeLowerCase = [[object.objName lowercaseString] rangeOfString:[substring lowercaseString]];
        
        if (substringRangeLowerCase.length != 0) {
            [_autoCompleteArray addObject:object];
        }
    }
    self.autoCompleteTableView.hidden = NO;
    [self.autoCompleteTableView reloadData];
}

#pragma mark UITableViewDelegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Resize auto complete table based on how many elements will be displayed in the table
    
    CGRect tableRect;
    CGRect baseViewRect;
    NSInteger returnCount = 0;
    
    if (_autoCompleteArray.count >= 3) {
        tableRect = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableHeight * 3);
        baseViewRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, (tableHeight * 3) + 30);
        returnCount = _autoCompleteArray.count;
    }
    
    else if (_autoCompleteArray.count == 2 || _autoCompleteArray.count == 1) {
        tableRect = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableHeight * 2);
        baseViewRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, (tableHeight * 2) + 30);
        returnCount = _autoCompleteArray.count;
    }
    
    else {
        tableRect = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, 0.0);
        baseViewRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, tableHeight);
        returnCount = _autoCompleteArray.count;
    }
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.autoCompleteTableView.frame = tableRect;
                         self.frame = baseViewRect;
                     }
                     completion:^(BOOL finished){
                     }];
    
    self.autoCompleteTableView.hidden = NO;
    if (returnCount == 0) {
        self.autoCompleteTableView.hidden = YES;
    }
    return returnCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
        
        CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version > 6) {
            [cell setBackgroundColor:[UIColor clearColor]];
        }
    }
    CAAutoCompleteObject *object = [_autoCompleteArray objectAtIndex:indexPath.row];
    cell.textLabel.text = object.objName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CAAutoCompleteObject *object = [_autoCompleteArray objectAtIndex:indexPath.row];
    _txtField.text = object.objName;
    [self finishedSearching];
}

- (void)finishedSearching {
    [self resignFirstResponder];
    
    [_autoCompleteArray removeAllObjects];
    [self.autoCompleteTableView reloadData];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(CAAutoTextFillBeginEditing:)]) {
        [_delegate CAAutoTextFillBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(CAAutoTextFillEndEditing:)]) {
        [_delegate CAAutoTextFillEndEditing:self];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL didYES = NO;
    if ([_delegate respondsToSelector:@selector(CAAutoTextFillWantsToEdit:)]) {
        didYES = [_delegate CAAutoTextFillWantsToEdit:self];
    }
    
    return didYES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *substring = [NSString stringWithString:_txtField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    [self searchAutocompleteEntriesWithSubstring:substring];
    
    return YES;
}

- (void)dealloc {
    [_dataSourceArray removeAllObjects];
    [_autoCompleteArray removeAllObjects];
    
    [_autoCompleteTableView removeFromSuperview];
    
    [_txtField removeFromSuperview];
}

@end
