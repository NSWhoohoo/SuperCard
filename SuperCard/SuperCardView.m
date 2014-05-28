//
//  SuperCardView.m
//  SuperCard
//
//  Created by will hunting on 5/28/14.
//  Copyright (c) 2014 will hunting. All rights reserved.
//

#import "SuperCardView.h"

@interface SuperCardView()
@property (nonatomic)CGFloat faceCardScaleFactor;
@end

@implementation SuperCardView
@synthesize faceCardScaleFactor = _faceCardScaleFactor;

#pragma mark - property

#define DEFAULT_FACE_SCALE_FACTOR

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor
{
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

- (CGFloat)faceCardScaleFactor
{
    if (!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_SCALE_FACTOR;
    return _faceCardScaleFactor;
}


#pragma mark - drawing

#define CONNER_RADIUS_STANDARD_HEIGHT 180.0
#define CONNER_RADIUS 12.0

- (CGFloat)connerScaleFactor { return self.bounds.size.height/CONNER_RADIUS_STANDARD_HEIGHT; }

- (CGFloat)connerRadius { return CONNER_RADIUS * [self connerScaleFactor]; }

- (CGFloat)connerOffset { return [self connerRadius] / 3; }

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath* roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self connerRadius]];
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    UIImage* faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", [self rankAsString], self.suit]];
    if (faceImage) {
        CGRect imageRect = CGRectInset(self.bounds, self.bounds.size.width * (1.0-self.faceCardScaleFactor), self.bounds.size.height * (1.0-self.faceCardScaleFactor));
        [faceImage drawInRect:imageRect];
    } else {
        
    }
    
    [self drawConners];
}

- (void)drawPips
{
    
}

- (NSString*)rankAsString
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"J", @"Q", @"K"][self.rank];
}

- (void)drawConners
{
    NSMutableParagraphStyle* paragraphstyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphstyle setAlignment:NSTextAlignmentCenter];
    
    UIFont* connerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    connerFont = [connerFont fontWithSize:connerFont.pointSize*[self connerScaleFactor]];
    
    NSAttributedString* connerText = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@", [self rankAsString], self.suit] attributes:@{NSFontAttributeName: connerFont, NSParagraphStyleAttributeName: paragraphstyle}];
    
    CGRect textBound;
    textBound.origin = CGPointMake([self connerOffset], [self connerOffset]);
    textBound.size = [connerText size];
    [connerText drawInRect:textBound];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
    [connerText drawInRect:textBound];
}

#pragma mark - initialization

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}



@end
