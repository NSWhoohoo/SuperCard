//
//  ViewController.m
//  SuperCard
//
//  Created by will hunting on 5/28/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "SuperCardView.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet SuperCardView *card;
@property (nonatomic, strong)Deck* deck;
@end

@implementation ViewController

- (Deck *)deck
{
    if (!_deck) _deck = [[PlayingCardDeck alloc] init];
    return _deck;
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    self.card.faceUp = !self.card.faceUp;
    if (self.card.faceUp) [self drawRandomCard];
}

- (void)drawRandomCard {
    Card *card = [self.deck drawRandomCard];
    if ([card isKindOfClass:[PlayingCard class]]) {
        PlayingCard *playingCard = (PlayingCard *)card;
        self.card.rank = playingCard.rank;
        self.card.suit = playingCard.suit;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

@end
