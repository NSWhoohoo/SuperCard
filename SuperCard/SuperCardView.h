//
//  SuperCardView.h
//  SuperCard
//
//  Created by will hunting on 5/28/14.
//  Copyright (c) 2014 will hunting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuperCardView : UIView
@property (nonatomic)NSUInteger rank;
@property (nonatomic, copy)NSString* suit;
@property (nonatomic)BOOL faceUp;
@end
