//
//  CardDetailsController.m
//  iBank
//
//  Created by Aida Ymeri on 5/6/13.
//  Copyright (c) 2013 Florjon Koci. All rights reserved.
//

#import "CardDetailsController.h"

@implementation CardDetailsController
@synthesize CardLimit = _CardLimit;
@synthesize CardType = _CardType;
@synthesize AccountNumber=_AccountNumber;
@synthesize CustomerNumber=_CustomerNumber;
@synthesize CardID=_CardID;
@synthesize RetailAccountNumber =_RetailAccountNumber;
@synthesize CardStatus =_CardStatus;
@synthesize CardCcy =_CardCcy;
@synthesize AcountCode= _AcountCode;
@synthesize ExpireDate =_ExpireDate;
@synthesize CardHolderName = _CardHolderName;

@synthesize card = _card;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.card = _card;
    
    self.CardLimit.text = self.card.CardLimit;
    self.CardType.text = self.card.CardType;
    self.AccountNumber.text= self.card.AccountNumber;
    self.CustomerNumber.text = self.card.CustomerNumber;
    self.CardID.text= self.card.CardID;
    self.RetailAccountNumber.text= self.card.RetailAccountNumber;
    self.CardStatus.text = self.card.CardStatus;
    self.CardCcy.text = self.card.CardCcy;
    self.AcountCode.text = self.card.AcountCode;
    self.ExpireDate.text = self.card.ExpireDate;
    self.CardHolderName.text = self.card.CardHolderName;
}
@end