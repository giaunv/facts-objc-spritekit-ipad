//
//  factObject.h
//  facts
//
//  Created by lavalamp on 3/21/15.
//  Copyright (c) 2015 366. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface factObject : NSObject
@property (nonatomic, readwrite) int factID;
@property (nonatomic, readwrite, retain) NSString* statement;
@property (nonatomic, readwrite) NSInteger isCorrect;
@property (nonatomic, readwrite, retain) NSString* additionalInfo;
@end
