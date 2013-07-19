//
//  DetailAccountViewController.m
//  iBank
//
//  Created by Florjon Koci on 5/7/13.
//  Copyright (c) 2013 Florjon Koci. All rights reserved.
//

#import "DetailAccountViewController.h"

@interface DetailAccountViewController ()

@end

@implementation DetailAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@synthesize account = _account;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.account = _account;
    self.accountNumber.text = self.account.accountNumber;
    self.retail.text = self.account.retailAccountNumber;
    self.iban.text= self.account.iban;
    self.accountProduct.text=self.account.accountProduct;
    self.currency.text=self.account.currency;
    self.frequency.text=self.account.frequency;
    self.accountCode.text=self.account.accountCode;
    self.branchCode.text=self.account.branchCode;
    self.customerNumber.text= self.account.branchCode;
    self.balance.text=self.account.balance;
    self.status.text=self.account.status;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
