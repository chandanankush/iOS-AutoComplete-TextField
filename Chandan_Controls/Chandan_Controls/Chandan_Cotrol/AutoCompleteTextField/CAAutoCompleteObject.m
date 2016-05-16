//
//  CAAutoCompleteObject.m
//  Chandan_Controls
//
//  Created by Singh, Chandan F. on 16/05/16.
//  Copyright © 2016 Chandan SIngh. All rights reserved.
//

#import "CAAutoCompleteObject.h"

@implementation CAAutoCompleteObject

- (id) initWithObjectName:(NSString *) objName AndID:(NSInteger ) obID {
    if (self = [super init]) {
        self.objName = objName;
        self.objID = obID;
        self.isSelectable = YES;
        self.isDefaultSelected = NO;
    }
    return self;
}

- (void) dealloc {
    self.objName = nil;
}

@end
