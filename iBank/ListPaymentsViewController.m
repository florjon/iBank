//
//  ListPaymentsViewController.m
//  sqliteTutorial
//
//  Created by Florjon Koci on 3/4/13.
//  Copyright (c) 2013 iffytheperfect. All rights reserved.
//

#import "ListPaymentsViewController.h"
#import "DetailPaymentViewController.h"
#import <UIKit/UIKit.h>

@interface ListPaymentsViewController ()
{
    NSMutableArray *arrayOfPayment;    
    NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSString *finaldata;
	NSMutableString *nodeContent;
}
@end

@implementation ListPaymentsViewController

#define startActivityIndicator  [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES]
#define stopActivityIndicator  [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.paymentsTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    
    arrayOfPayment = [[NSMutableArray alloc]init];
    
    [[self paymentsTableView]setDelegate:self];
    [[self paymentsTableView]setDataSource:self];
    
    self.paymentsTableView.backgroundColor = [UIColor clearColor];
    self.paymentsTableView.opaque = NO;
    self.paymentsTableView.backgroundView = nil;
    
    [arrayOfPayment removeAllObjects];
    
    [self displayPayments];
    
    [[self paymentsTableView]reloadData];
    
    //self.paymentsTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yellow2.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)displayPayments {
    
    NSString *soapFormat = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                            "<soap:Body>\n"
                            "<GetPaymentsList xmlns=\"http://tempuri.org/\">\n"
                            "<retailAccountNumber>8000380072</retailAccountNumber>\n"
                            "<firstDate>2013-01-01</firstDate>\n"
                            "<endDate>2013-05-05</endDate>\n"
                            "</GetPaymentsList>\n"
                            "</soap:Body>\n"
                            "</soap:Envelope>"];
    
    
    NSURL *locationOfWebService = [NSURL URLWithString:@"http://192.168.18.97:800/macmobile/Payments.asmx"];
    
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc]initWithURL:locationOfWebService];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d",[soapFormat length]];
    
    [theRequest addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:@"http://tempuri.org/GetPaymentsList" forHTTPHeaderField:@"SOAPAction"];
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
    return [arrayOfPayment count];
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
    
    Payment *aPayment = [arrayOfPayment objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Ordering: %@\nBeneficiary: %@", aPayment.DebitAccount, aPayment.CreditAccount];
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Amount: %@ (%@)", aPayment.DebitAmount, aPayment.DebitCCY];
    cell.textLabel.font = [UIFont systemFontOfSize: 13];
    cell.detailTextLabel.font = [UIFont systemFontOfSize: 12];
    cell.imageView.image = [UIImage imageNamed:@"confirm.png"];//44px = non retina, 88px = retina (retina = rename @2x)
    
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
	//NSLog(@"%@",theXML);
    
    
    NSArray *arr=[theXML componentsSeparatedByString:@"<iosPayment>"];
    
    
    for(int i=1;i<[arr count];i++)
    {
        Payment *object = [[Payment alloc] init];
        NSString *str=[arr objectAtIndex:i];
        
        NSArray *arr=[str componentsSeparatedByString:@"<DebitAccount>"];
        NSString *data=[arr objectAtIndex:1];
        NSRange ranfrom=[data rangeOfString:@"</DebitAccount>"];
        object.DebitAccount = [data substringToIndex:ranfrom.location];
        
        arr=[str componentsSeparatedByString:@"<DebitAmount>"];
        data=[arr objectAtIndex:1];
        ranfrom=[data rangeOfString:@"</DebitAmount>"];
        object.DebitAmount=[data substringToIndex:ranfrom.location];
        
        arr=[str componentsSeparatedByString:@"<DebitCCY>"];
        data=[arr objectAtIndex:1];
        ranfrom=[data rangeOfString:@"</DebitCCY>"];
        object.DebitCCY=[data substringToIndex:ranfrom.location];
        
        arr=[str componentsSeparatedByString:@"<CreditAccount>"];
        data=[arr objectAtIndex:1];
        ranfrom=[data rangeOfString:@"</CreditAccount>"];
        object.CreditAccount=[data substringToIndex:ranfrom.location];
        
        arr=[str componentsSeparatedByString:@"<CreditAmount>"];
        data=[arr objectAtIndex:1];
        ranfrom=[data rangeOfString:@"</CreditAmount>"];
        object.CreditAmount=[data substringToIndex:ranfrom.location];
        
        arr=[str componentsSeparatedByString:@"<CreditCCY>"];
        data=[arr objectAtIndex:1];
        ranfrom=[data rangeOfString:@"</CreditCCY>"];
        object.CreditCCY=[data substringToIndex:ranfrom.location];
        
        arr=[str componentsSeparatedByString:@"<PaymentDate>"];
        data=[arr objectAtIndex:1];
        ranfrom=[data rangeOfString:@"</PaymentDate>"];
        object.PaymentDate=[data substringToIndex:ranfrom.location];
        
        arr=[str componentsSeparatedByString:@"<PaymentStatus>"];
        data=[arr objectAtIndex:1];
        ranfrom=[data rangeOfString:@"</PaymentStatus>"];
        object.PaymentStatus=[data substringToIndex:ranfrom.location];
        
        arr=[str componentsSeparatedByString:@"<PaymentSegment>"];
        data=[arr objectAtIndex:1];
        ranfrom=[data rangeOfString:@"</PaymentSegment>"];
        object.PaymentSegment=[data substringToIndex:ranfrom.location];
        
        //arr=[str componentsSeparatedByString:@"<MidasPaymentReference>"];
        //data=[arr objectAtIndex:1];
        //ranfrom=[data rangeOfString:@"</MidasPaymentReference>"];
        //object.MidasPaymentReference=[data substringToIndex:ranfrom.location];
        
        [arrayOfPayment addObject:object];
    }
    
    stopActivityIndicator;
    
    [[self paymentsTableView]reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowPaymentDetails"])
    {
        DetailPaymentViewController *detailViewController = [segue destinationViewController];
        
        NSIndexPath *myIndexPath = [self.paymentsTableView indexPathForSelectedRow];
        
        detailViewController.payment = [arrayOfPayment objectAtIndex:[myIndexPath row]];
    }
}

@end
