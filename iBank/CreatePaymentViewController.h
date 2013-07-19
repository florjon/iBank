//
//  CreatePaymentViewController.h
//  iBank
//
//  Created by Florjon Koci on 5/3/13.
//  Copyright (c) 2013 Florjon Koci. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatePaymentViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *orderingAccountField;
@property (strong, nonatomic) IBOutlet UITextField *beneficiaryAccountField;
@property (strong, nonatomic) IBOutlet UITextField *amountField;
@property (strong, nonatomic) IBOutlet UITextField *currencyField;
@property (strong, nonatomic) IBOutlet UITextField *descriptionField;


- (IBAction)callService:(id)sender;

@end
