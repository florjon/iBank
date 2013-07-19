//
//  ListDepositsViewController.m
//  iBank
//
//  Created by Florjon Koci on 4/26/13.
//  Copyright (c) 2013 Florjon Koci. All rights reserved.
//

#import "ListDepositsViewController.h"
#import "DetailDepositViewController.h"

@interface ListDepositsViewController ()
{
    NSMutableArray *arrayOfDeposit;
    NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSString *finaldata;
	NSMutableString *nodeContent;
}
@end

@implementation ListDepositsViewController

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
    
    arrayOfDeposit = [[NSMutableArray alloc]init];
    
    [[self depositsTableView]setDelegate:self];
    [[self depositsTableView]setDataSource:self];
    
    self.depositsTableView.backgroundColor = [UIColor clearColor];
    self.depositsTableView.opaque = NO;
    self.depositsTableView.backgroundView = nil;
    
    [arrayOfDeposit removeAllObjects];
    
    [self displayDeposits];
    
    [[self depositsTableView]reloadData];
    
    //self.depositsTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yellow2.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)displayDeposits {
    
    NSString *soapFormat = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                            "<soap:Body>\n"
                            "<GetDepositList xmlns=\"http://tempuri.org/\">\n"
                            "<customerNumber>380072</customerNumber>\n"
                            "</GetDepositList>\n"
                            "</soap:Body>\n"
                            "</soap:Envelope>"];
    
    
    NSURL *locationOfWebService = [NSURL URLWithString:@"http://192.168.18.97:800/macmobile/Deposits.asmx"];
    
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc]initWithURL:locationOfWebService];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d",[soapFormat length]];
    
    [theRequest addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:@"http://tempuri.org/GetDepositList" forHTTPHeaderField:@"SOAPAction"];
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
    return [arrayOfDeposit count];
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
    
    Deposit *aDeposit = [arrayOfDeposit objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Deal: %@", aDeposit.MidasDealNumber];
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Balance: %@ %@", aDeposit.AccountCreditValue, aDeposit.CurrencyCode];
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
	NSLog(@"ERROR with theConnection");
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
	NSLog(@"DONE. Received Bytes: %d", [webData length]);
	NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    NSArray *arr=[theXML componentsSeparatedByString:@"<iosDeposit>"];
    
    for(int i=1;i<[arr count];i++)
    {
        Deposit *object = [[Deposit alloc] init];
        NSString *str=[arr objectAtIndex:i];
        
        NSArray *arr=[str componentsSeparatedByString:@"<ProductName>"];
        NSString *data=[arr objectAtIndex:1];
        NSRange ranfrom=[data rangeOfString:@"</ProductName>"];
        object.ProductName=[data substringToIndex:ranfrom.location];
        
        arr=[str componentsSeparatedByString:@"<MidasDealNumber>"];
        data=[arr objectAtIndex:1];
        ranfrom=[data rangeOfString:@"</MidasDealNumber>"];
        object.MidasDealNumber=[data substringToIndex:ranfrom.location];
        
        arr=[str componentsSeparatedByString:@"<AccountDebitValue>"];
        data=[arr objectAtIndex:1];
        ranfrom=[data rangeOfString:@"</AccountDebitValue>"];
        object.AccountDebitValue=[data substringToIndex:ranfrom.location];
        
        arr=[str componentsSeparatedByString:@"<AccountCreditValue>"];
        data=[arr objectAtIndex:1];
        ranfrom=[data rangeOfString:@"</AccountCreditValue>"];
        object.AccountCreditValue=[data substringToIndex:ranfrom.location];
        
        arr=[str componentsSeparatedByString:@"<DepositAmount>"];
        data=[arr objectAtIndex:1];
        ranfrom=[data rangeOfString:@"</DepositAmount>"];
        object.DepositAmount=[data substringToIndex:ranfrom.location];
        
        arr=[str componentsSeparatedByString:@"<CurrencyCode>"];
        data=[arr objectAtIndex:1];
        ranfrom=[data rangeOfString:@"</CurrencyCode>"];
        object.CurrencyCode=[data substringToIndex:ranfrom.location];
        
        arr=[str componentsSeparatedByString:@"<DepositStatus>"];
        data=[arr objectAtIndex:1];
        ranfrom=[data rangeOfString:@"</DepositStatus>"];
        object.DepositStatus=[data substringToIndex:ranfrom.location];
        
        [arrayOfDeposit addObject:object];
    }
    
    stopActivityIndicator;
    
    [[self depositsTableView]reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowDepositDetails"])
    {
        DetailDepositViewController *detailViewController = [segue destinationViewController];
        
        NSIndexPath *myIndexPath = [self.depositsTableView indexPathForSelectedRow];
        
        detailViewController.deposit = [arrayOfDeposit objectAtIndex:[myIndexPath row]];
    }
}


@end
