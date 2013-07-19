//
//  LoginViewController.m
//  iBank
//
//  Created by Florjon Koci on 5/9/13.
//  Copyright (c) 2013 Florjon Koci. All rights reserved.
//

#import "LoginViewController.h"
#import "Customer.h"

@interface LoginViewController (){
    NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSString *finaldata;
	NSMutableString *nodeContent;
}

@end

@implementation LoginViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Login:(id)sender {
    if ([self.username.text length]==0 || [self.password.text length]==0 ) {
		
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Credential" message:@"Supply Data in text field" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok",nil];
		[alert show];
	}
	else {
		
		[self.username resignFirstResponder];
        [self.password resignFirstResponder];
        
        NSString *soapFormat = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                "<soap:Body>\n"
                                "<GetCustomerDetails xmlns=\"http://tempuri.org/\">\n"
                                "<username>%@</username>\n"
                                "<password>%@</password>\n"
                                "</GetCustomerDetails>\n"
                                "</soap:Body>\n"
                                "</soap:Envelope>", self.username.text, self.password.text];
		
		
		NSLog(@"The request format is %@",soapFormat);
		
		NSURL *locationOfWebService = [NSURL URLWithString:@"http://192.168.18.97:800/macmobile/customers.asmx"];
		
		NSLog(@"web url = %@",locationOfWebService);
		
		NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc]initWithURL:locationOfWebService];
        
		NSString *msgLength = [NSString stringWithFormat:@"%d",[soapFormat length]];
		
		[theRequest addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
		[theRequest addValue:@"http://tempuri.org/GetCustomerDetails" forHTTPHeaderField:@"SOAPAction"];
		[theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
		[theRequest setHTTPMethod:@"POST"];
		//the below encoding is used to send data over the net
		[theRequest setHTTPBody:[soapFormat dataUsingEncoding:NSUTF8StringEncoding]];
		
		
		NSURLConnection *connect = [[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
		
		if (connect) {
			webData = [[NSMutableData alloc]init];
            startActivityIndicator;
            [self performSegueWithIdentifier:@"ShowMain" sender:sender];
		}
		else {
			NSLog(@"No Connection established");
		}
		
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
        Customer *object = [[Customer alloc] init];
        NSString *str=[arr objectAtIndex:i];
        
        NSArray *arr=[str componentsSeparatedByString:@"<CustomerID>"];
        NSString *data=[arr objectAtIndex:1];
        NSRange ranfrom=[data rangeOfString:@"</CustomerID>"];
        object.CustomerID = [data substringToIndex:ranfrom.location];
        
        //[arrayOfPayment addObject:object];
        break;
    }
    
    stopActivityIndicator;
    
    //[[self paymentsTableView]reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowMain"])
    {
        //DetailPaymentViewController *detailViewController = [segue destinationViewController];
        
        //NSIndexPath *myIndexPath = [self.paymentsTableView indexPathForSelectedRow];
        
        //detailViewController.payment = [arrayOfPayment objectAtIndex:[myIndexPath row]];
        
        // Get destination view
        //ViewController *vc = [segue destinationViewController];
        
        // Get button tag number (or do whatever you need to do here, based on your object
        //NSInteger tagIndex = [(UIButton *)sender tag];
        
        // Pass the information to your destination view
        //[vc setSelectedButton:tagIndex];
    }
}
@end
