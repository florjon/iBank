//
//  CreatePaymentViewController.m
//  iBank
//
//  Created by Florjon Koci on 5/3/13.
//  Copyright (c) 2013 Florjon Koci. All rights reserved.
//

#import "CreatePaymentViewController.h"

@interface CreatePaymentViewController ()
{
    NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSString *finaldata;
	NSMutableString *nodeContent;
    
    NSString *responseStatus;
    NSString *midasReference;
    NSString *midasMessage;
    NSString *paymentOrderId;
    NSString *senderId;
}

@end

@implementation CreatePaymentViewController

#define startActivityIndicator  [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES]
#define stopActivityIndicator  [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		nodeContent = [[NSMutableString alloc]init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)EmptyFields
{
    self.orderingAccountField.text = @"";
    self.beneficiaryAccountField.text = @"";
    self.amountField.text = @"";
    self.currencyField.text = @"";
    self.descriptionField.text = @"";
}


- (IBAction)callService:(id)sender {
    
    if ([self.descriptionField.text length]==0) {
		
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"WebService" message:@"Supply Data in text field" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok",nil];
		[alert show];
	}
	else {
		
		[self.descriptionField resignFirstResponder];
        
        NSString *soapFormat = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                 "<soap:Body>\n"
                                 "<InsertPayment xmlns=\"http://tempuri.org/\">\n"
                                 "<paymentCategory>EB1</paymentCategory>\n"
                                 "<amount>%@</amount>\n"
                                 "<currencyCode>%@</currencyCode>\n"
                                 "<ibanOrder>%@</ibanOrder>\n"
                                 "<ibanBeneficiary>%@</ibanBeneficiary>\n"
                                 "<description>%@</description>\n"
                                 "</InsertPayment>\n"
                                 "</soap:Body>\n"
                                 "</soap:Envelope>", self.amountField.text, self.currencyField.text, self.orderingAccountField.text, self.beneficiaryAccountField.text, self.descriptionField.text];
		
		
		NSLog(@"The request format is %@",soapFormat);
		
		NSURL *locationOfWebService = [NSURL URLWithString:@"http://192.168.18.97:800/macmobile/Payments.asmx"];
		
		NSLog(@"web url = %@",locationOfWebService);
		
		NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc]initWithURL:locationOfWebService];
        
		NSString *msgLength = [NSString stringWithFormat:@"%d",[soapFormat length]];
		
		[theRequest addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
		[theRequest addValue:@"http://tempuri.org/InsertPayment" forHTTPHeaderField:@"SOAPAction"];
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
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Payment *p = [arrayOfPayment objectAtIndex:indexPath.row];
        //[self deleteData:[NSString stringWithFormat:@"Delete from payments where name is '%s'", [p.name UTF8String]]];
        //[arrayOfPerson removeObjectAtIndex:indexPath.row];
        
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [[self orderingAccountField]resignFirstResponder];
    [[self beneficiaryAccountField]resignFirstResponder];
    [[self amountField]resignFirstResponder];
    [[self currencyField]resignFirstResponder];
    [[self descriptionField]resignFirstResponder];
}




-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[webData setLength: 0];
    //NSLog(@"didReceiveResponse: %@",webData);
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[webData appendData:data];
    //NSLog(@"didReceiveData: %@",webData);
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	//NSLog(@"ERROR with theConenction");
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//NSLog(@"DONE. Received Bytes: %d", [webData length]);
	//NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	//NSLog(@"%@",theXML);
	
	xmlParser = [[NSXMLParser alloc]initWithData:webData];
	[xmlParser setDelegate: self];
	[xmlParser parse];
    
    stopActivityIndicator;
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Payment was processed succesfully!" message:midasReference delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
    [alert show];
}

//xml delegates

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    nodeContent = [[NSMutableString alloc]init];
	[nodeContent appendString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    NSLog(@"node content: %@", nodeContent);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"ResponseStatus"]) {
		
		finaldata = nodeContent;
		responseStatus = finaldata;
	}
    
    if ([elementName isEqualToString:@"MidasReference"]) {
		
		finaldata = nodeContent;
		midasReference = finaldata;
	}
    
    if ([elementName isEqualToString:@"Message"]) {
		
		finaldata = nodeContent;
		midasMessage = finaldata;
	}
    
    if ([elementName isEqualToString:@"PaymentOrderId"]) {
		
		finaldata = nodeContent;
		paymentOrderId = finaldata;
	}
    
    if ([elementName isEqualToString:@"SenderId"]) {
		
		finaldata = nodeContent;
		senderId = finaldata;
	}
    
    if ([elementName isEqualToString:@"GetPaymentsListResult"]) {
		
		finaldata = nodeContent;
		senderId = finaldata;
	}    
}


@end

