//
//  CATextFieldWithTableView.h
//
//  Created by Chandan on 4/29/14.


#import <UIKit/UIKit.h>

@class CAAutoCompleteObject;

@protocol CATextFieldWithTableViewDelegate;

@interface CATextFieldWithTableView : UIView<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
 
}

@property (nonatomic, strong) NSMutableArray *elementArray;
@property (nonatomic, strong) UITextField * txtField;
@property (nonatomic, assign) id<CATextFieldWithTableViewDelegate>delegate;
@property BOOL isICDNineCodeCall;
@property BOOL isModifiersCodeCall;
@end

@protocol CATextFieldWithTableViewDelegate <NSObject>
@optional
- (void) CATextFieldBeginEditing:(CATextFieldWithTableView *) textField;
- (void) CATextFieldEndEditing:(CATextFieldWithTableView *) textField;
- (void) CATextFieldTableColunSelected:(CATextFieldWithTableView *) textField customAlertObject:(CAAutoCompleteObject *)selectedObject;
- (BOOL) CATextFieldWantsToEdit:(CATextFieldWithTableView *) textField;
@end