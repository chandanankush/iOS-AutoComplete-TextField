//
//  CATextFieldWithTableView.m
//  Created by Chandan on 4/29/14.
//


#import "CATextFieldWithTableView.h"
#import "CAAutoCompleteObject.h"

@interface CATextFieldWithTableView() {
    UITableView *autoCompleteTableView;
    CGFloat tableHeight;
    NSMutableArray *autoCompleteArray;
}

@end

@implementation CATextFieldWithTableView

- (id) initWithCoder:(NSCoder *)aDecoder {
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
        
        //Autocomplete Table
        autoCompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(3, _txtField.frame.origin.y+_txtField.frame.size.height, frame.size.width - 5, tableHeight) style:UITableViewStylePlain];
        autoCompleteTableView.delegate = self;
        autoCompleteTableView.dataSource = self;
        autoCompleteTableView.scrollEnabled = YES;
        autoCompleteTableView.hidden = NO;
        autoCompleteTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        autoCompleteTableView.rowHeight = tableHeight;
        [self addSubview:autoCompleteTableView];
        _elementArray = [[NSMutableArray alloc] init];
        autoCompleteArray = [[NSMutableArray alloc] init];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
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
        
        //Autocomplete Table
        autoCompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(3, _txtField.frame.origin.y+_txtField.frame.size.height, frame.size.width - 5, tableHeight) style:UITableViewStylePlain];
        autoCompleteTableView.delegate = self;
        autoCompleteTableView.dataSource = self;
        autoCompleteTableView.scrollEnabled = YES;
        autoCompleteTableView.hidden = NO;
        autoCompleteTableView.rowHeight = tableHeight;
        [self addSubview:autoCompleteTableView];
        
        _elementArray = [[NSMutableArray alloc] init];
        autoCompleteArray = [[NSMutableArray alloc] init];
    }
    return self;
}

// Take string from Search Textfield and compare it with autocomplete array
- (void)searchAutocompleteEntriesWithSubstring:(NSString *) filterText {
	
	[autoCompleteArray removeAllObjects];
	for(CAAutoCompleteObject *customObj in _elementArray) {
        NSString *curString = customObj.objName;
		NSRange substringRangeLowerCase = [[curString lowercaseString] rangeOfString:[_txtField.text lowercaseString]];
        if (substringRangeLowerCase.length != 0) {
			[autoCompleteArray addObject:customObj];
		}
	}
	autoCompleteTableView.hidden = NO;
	[autoCompleteTableView reloadData];
}

#pragma mark UITableViewDelegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    
	//Resize auto complete table based on how many elements will be displayed in the table
    
    CGRect tableRect;
    CGRect baseViewRect;
    NSInteger returnCount = 0;
    
    if (autoCompleteArray.count >= 3) {
        tableRect = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableHeight*3);
        baseViewRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, (tableHeight*3)+30);
		returnCount = autoCompleteArray.count;
	}
	
	else if (autoCompleteArray.count == 2 || autoCompleteArray.count == 1) {
		tableRect = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableHeight*2);
        baseViewRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, (tableHeight*2)+30);
		returnCount = autoCompleteArray.count;
	}
	
	else {
		tableRect = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, 0.0);
        baseViewRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, tableHeight);
		returnCount = autoCompleteArray.count;
	}
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^ {
        autoCompleteTableView.frame = tableRect;
        self.frame = baseViewRect;
    } completion:^(BOOL finished) { }];
    
    autoCompleteTableView.hidden = NO;
    if (returnCount == 0) {
        autoCompleteTableView.hidden = YES;
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
        
        CGFloat version = [[[ UIDevice currentDevice ] systemVersion ] floatValue];
        if( version > 6 ){
            [cell setBackgroundColor:[UIColor clearColor]];
        }
	}
    CAAutoCompleteObject *tmpObject = [autoCompleteArray objectAtIndex:indexPath.row];
	cell.textLabel.text = tmpObject.objName;
    cell.tag = tmpObject.objID;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
	_txtField.text = @"";
    if ([_delegate respondsToSelector:@selector(CATextFieldTableColunSelected:customAlertObject:)]) {
        [_delegate CATextFieldTableColunSelected:self customAlertObject:[autoCompleteArray objectAtIndex:indexPath.row]];
    }
	[self finishedSearching];
}

- (void) finishedSearching {
	[self resignFirstResponder];
    [autoCompleteArray removeAllObjects];
    [_elementArray removeAllObjects];
    _txtField.text = @"";
    [autoCompleteTableView reloadData];
}

- (void)dealloc {
	autoCompleteArray = nil;;
	_elementArray = nil;
    
    [autoCompleteTableView removeFromSuperview];
    autoCompleteTableView = nil;
    [_txtField removeFromSuperview];
    _txtField = nil;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(CATextFieldBeginEditing:)]) {
        [_delegate CATextFieldBeginEditing:self];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(CATextFieldEndEditing:)]) {
        [_delegate CATextFieldEndEditing:self];
    }
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL didYES = NO;
    if ([_delegate respondsToSelector:@selector(CATextFieldWantsToEdit:)]) {
        didYES =  [_delegate CATextFieldWantsToEdit:self];
    }
    
    return didYES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *substring = [NSString stringWithString:_txtField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    
    [self searchAutocompleteEntriesWithSubstring:substring];
	return YES;
}

@end

