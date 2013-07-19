//
//  ListAccountsViewController.m
//  iBank
//
//  Created by Florjon Koci on 4/26/13.
//  Copyright (c) 2013 Florjon Koci. All rights reserved.
//

#import "ListAccountsViewController.h"
#import "DetailAccountViewController.h"

@interface ListAccountsViewController ()
{
    NSMutableArray *arrayOfAccount;
    NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSString *finaldata;
	NSMutableString *nodeContent;
}
@end

@implementation ListAccountsViewController

#define startActivityIndicator  [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES]
#define stopActivityIndicator  [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrayOfAccount = [[NSMutableArray alloc]init];
    
    [[self accountsTableView]setDelegate:self];
    [[self accountsTableView]setDataSource:self];
    
    self.accountsTableView.backgroundColor = [UIColor clearColor];
    self.accountsTableView.opaque = NO;
    self.accountsTableView.backgroundView = nil;
    
    [arrayOfAccount removeAllObjects];
    
    [self displayAccounts];
    
    [[self accountsTableView]reloadData];
    
    //self.accountsTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yellow2.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)displayAccounts {
    
    NSString *soapFormat = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                            "<soap:Body>\n"
                            "<ViewAccountList xmlns=\"http://tempuri.org/\">\n"
                            "<customerNumber>380072</customerNumber>\n"
                            "</ViewAccountList>\n"
                            "</soap:Body>\n"
                            "</soap:Envelope>"];
    
    
    NSURL *locationOfWebService = [NSURL URLWithString:@"http://192.168.18.97:800/macmobile/Accounts.asmx"];
    
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc]initWithURL:locationOfWebService];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d",[soapFormat length]];
    
    [theRequest addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:@"http://tempuri.org/ViewAccountList" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    //the below encoding is used to send data over the net
    [theRequest setHTTPBody:[soapFormat dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLConnection *connect = [[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
    
    if (connect) {
        webData = [[NSMutableData alloc]init];
        startActivityIndicator;
    }
    else {
        NSLog(@"No Connection established");
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayOfAccount count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Account *aAccount = [arrayOfAccount objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Account: %@", aAccount.retailAccountNumber];
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Balance: %@ %@", aAccount.balance, aAccount.currency];
    cell.imageView.image = [UIImage imageNamed:@"confirm.png"];//44px = non retina, 88px = retina (retina = rename @2x)
    cell.textLabel.font = [UIFont systemFontOfSize: 14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize: 12];
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[webData setLength: 0];
    NSLog(@"didReceiveResponse: %@",webData);
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[webData appendData:data];
    NSLog(@"didReceiveData: %@",webData);
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"ERROR with theConenction");
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
	NSLog(@"DONE. Received Bytes: %d", [webData length]);
	NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	    
    NSArray *arr=[theXML componentsSeparatedByString:@"<iosAccounts>"];
    
    for(int i=1;i<[arr count];i++)
    {
        Account *object = [[Account alloc] init];
        NSString *str=[arr objectAtIndex:i];
        
        NSArray *arr=[str componentsSeparatedByString:@"<retailAccountNumber>"];
        NSString *data=[arr objectAtIndex:1];
        NSRange ranfrom=[data rangeOfString:@"</retailAccountNumber>"];
        object.retailAccountNumber=[data substringToIndex:ranfrom.location];
        
        arr=[str componentsSeparatedByString:@"<accountCurrency>"];
        data=[arr objectAtIndex:1];
        ranfrom=[data rangeOfString:@"</accountCurrency>"];
        object.currency=[data substringToIndex:ranfrom.location];
        
        arr=[str componentsSeparatedByString:@"<accountSequence>"];
        data=[arr objectAtIndex:1];
        ranfrom=[data rangeOfString:@"</accountSequence>"];
        object.frequency=[data substringToIndex:ranfrom.location];
        
        arr=[str componentsSeparatedByString:@"<accountBranchCode>"];
        data=[arr objectAtIndex:1];
        ranfrom=[data rangeOfString:@"</accountBranchCode>"];
        object.branchCode=[data substringToIndex:ranfrom.location];
        
        arr=[str componentsSeparatedByString:@"<accountCode>"];
        data=[arr objectAtIndex:1];
        ranfrom=[data rangeOfString:@"</accountCode>"];
        object.accountCode=[data substringToIndex:ranfrom.location];
        
        arr=[str componentsSeparatedByString:@"<customerNumber>"];
        data=[arr objectAtIndex:1];
        ranfrom=[data rangeOfString:@"</customerNumber>"];
        object.customerNumber=[data substringToIndex:ranfrom.location];
        
        arr=[str componentsSeparatedByString:@"<balance>"];
        data=[arr objectAtIndex:1];
        ranfrom=[data rangeOfString:@"</balance>"];
        object.balance=[data substringToIndex:ranfrom.location];
        
        [arrayOfAccount addObject:object];
    }
    
    stopActivityIndicator;
    
    [[self accountsTableView]reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowAccountDetails"])
    {
        DetailAccountViewController *detailViewController = [segue destinationViewController];
        
        NSIndexPath *myIndexPath = [self.accountsTableView indexPathForSelectedRow];
        
        detailViewController.account = [arrayOfAccount objectAtIndex:[myIndexPath row]];
    }
}

@end
