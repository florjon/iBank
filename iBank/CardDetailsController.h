//
//  CardDetailsController.h
//  iBank
//
//  Created by Aida Ymeri on 5/6/13.
//  Copyright (c) 2013 Florjon Koci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface CardDetailsController :  UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Card  *card;

@property (strong, nonatomic) IBOutlet UILabel *CardLimit;//makeLabel
@property (strong, nonatomic) IBOutlet UILabel *CardType;//modelLabel
@property (strong, nonatomic) IBOutlet UILabel *AccountNumber;
@property (strong, nonatomic) IBOutlet UILabel *CustomerNumber;
@property (strong, nonatomic) IBOutlet UILabel *CardID;
@property (strong, nonatomic) IBOutlet UILabel *RetailAccountNumber;
@property (strong, nonatomic) IBOutlet UILabel *CardStatus;
@property (strong, nonatomic) IBOutlet UILabel *CardCcy;
@property (strong, nonatomic) IBOutlet UILabel *AcountCode;
@property (strong, nonatomic) IBOutlet UILabel *ExpireDate;
@property (strong, nonatomic) IBOutlet UILabel *CardHolderName;
@property (strong, nonatomic) IBOutlet UILabel *Nrp;

@end
