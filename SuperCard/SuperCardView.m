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

#define DEFAULT_FACE_SCALE_FACTOR 0.9

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor
{
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

- (CGFloat)faceCardScaleFactor
{
    if (!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_SCALE_FACTOR ;
    return _faceCardScaleFactor;
}


- (NSString*)rankAsString
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"][self.rank];
}

#pragma mark - gestrue handling
- (void)pinch:(UIPinchGestureRecognizer* )gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        self.faceCardScaleFactor = self.faceCardScaleFactor*gesture.scale;
        gesture.scale = 1.0;
    }
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
    
    if (self.faceUp) {
        UIImage* faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", [self rankAsString], self.suit]];
        if (faceImage) {
            CGRect imageRect = CGRectInset(self.bounds, self.bounds.size.width * (1.0-self.faceCardScaleFactor), self.bounds.size.height * (1.0-self.faceCardScaleFactor));
            [faceImage drawInRect:imageRect];
        } else {
            [self drawPips];
        }
        
        [self drawConners];
    } else {
        UIImage* cardback = [UIImage imageNamed:@"cardback"];
        [cardback drawInRect:self.bounds];
    }
}

- (void)pushContextRotationUpsideDown
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

- (void)popContext
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextRestoreGState(context);
}

#pragma mark - conners

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
    
    [self pushContextRotationUpsideDown];
    [connerText drawInRect:textBound];
    [self popContext];
}


#pragma mark - pips
- (void)drawPips
{
    
}

#pragma mark - initialization

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    [self addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)]];
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
