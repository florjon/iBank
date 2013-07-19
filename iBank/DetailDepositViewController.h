//
//  DetailDepositViewController.h
//  iBank
//
//  Created by Florjon Koci on 5/7/13.
//  Copyright (c) 2013 Florjon Koci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deposit.h"

@interface DetailDepositViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Deposit *deposit;

@property (strong, nonatomic) IBOutlet UILabel *ProductName;
@property (strong, nonatomic) IBOutlet UILabel *dealno;
@property (strong, nonatomic) IBOutlet UILabel *AccountDebitValue;
@property (strong, nonatomic) IBOutlet UILabel *AccountCreditValue;
@property (strong, nonatomic) IBOutlet UILabel *DepositAmount;
@property (strong, nonatomic) IBOutlet UILabel *CurrencyCode;
@property (strong, nonatomic) IBOutlet UILabel *DepositStatus;
@end
