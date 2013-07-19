//
//  DetailDepositViewController.m
//  iBank
//
//  Created by Florjon Koci on 5/7/13.
//  Copyright (c) 2013 Florjon Koci. All rights reserved.
//

#import "DetailDepositViewController.h"

@interface DetailDepositViewController ()

@end

@implementation DetailDepositViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@synthesize deposit = _deposit;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.deposit = _deposit;
    
    self.dealno.text = self.deposit.MidasDealNumber;
       self.ProductName.text = self.deposit.ProductName;
       self.AccountDebitValue.text = self.deposit.AccountDebitValue;
       self.AccountCreditValue.text = self.deposit.AccountCreditValue;
       self.DepositAmount.text = self.deposit.DepositAmount;
       self.CurrencyCode.text = self.deposit.CurrencyCode;
       self.DepositStatus.text = self.deposit.DepositStatus;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
