//
//  DetailPaymentViewController.m
//  iBank
//
//  Created by Florjon Koci on 4/29/13.
//  Copyright (c) 2013 Florjon Koci. All rights reserved.
//

#import "DetailPaymentViewController.h"

@interface DetailPaymentViewController ()

@end

@implementation DetailPaymentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@synthesize payment = _payment;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.payment = _payment;
    
    self.MidasPaymentReference.text = self.payment.MidasPaymentReference;
        self.PaymentSegment.text = self.payment.PaymentSegment;
        self.CustomerNumber.text = self.payment.CustomerNumber;
        self.DebitAccount.text = self.payment.DebitAccount;
        self.DebitAmount.text = self.payment.DebitAmount;
        self.DebitCCY.text = self.payment.DebitCCY;
        self.CreditAccount.text = self.payment.CreditAccount;
        self.CreditAmount.text = self.payment.CreditAmount;
        self.CreditCCY.text = self.payment.CreditCCY;
        self.PaymentDate.text = self.payment.PaymentDate;
        self.PaymentStatus.text = self.payment.PaymentStatus;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
