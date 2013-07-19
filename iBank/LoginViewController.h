//
//  LoginViewController.h
//  iBank
//
//  Created by Florjon Koci on 5/9/13.
//  Copyright (c) 2013 Florjon Koci. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *Login;

- (IBAction)Login:(id)sender;

@end
