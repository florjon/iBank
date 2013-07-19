//
//  ListCardsViewController.m
//  iBank
//
//  Created by Florjon Koci on 4/26/13.
//  Copyright (c) 2013 Florjon Koci. All rights reserved.
//

#import "ListCardsViewController.h"
#import "CardDetailsController.h"

@interface ListCardsViewController ()
{
    NSMutableArray *arrayOfCards;
    NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSString *finaldata;
	NSMutableString *nodeContent;
}
@end

@implementation ListCardsViewController

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
    
    arrayOfCards = [[NSMutableArray alloc]init];
    
    [[self cardsTableView]setDelegate:self];
    [[self cardsTableView]setDataSource:self];
    
    self.cardsTableView.backgroundColor = [UIColor clearColor];
    self.cardsTableView.opaque = NO;
    self.cardsTableView.backgroundView = nil;
    
    [arrayOfCards removeAllObjects];
    
    [self displayCards];
    
    [[self cardsTableView]reloadData];

    //self.cardsTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yellow2.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)displayCards {
    
    NSString *soapFormat = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                            "<soap:Body>\n"
                            "<GetCardList xmlns=\"http://tempuri.org/\">\n"
                            "<customerNumber>006104</customerNumber>\n"
                            "</GetCardList>\n"
                            "</soap:Body>\n"
                            "</soap:Envelope>"];
    
    
    NSURL *locationOfWebService = [NSURL URLWithString:@"http://192.168.18.97:800/macmobile/Cards.asmx"];
    
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc]initWithURL:locationOfWebService];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d",[soapFormat length]];
    
    [theRequest addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:@"http://tempuri.org/GetCardList" forHTTPHeaderField:@"SOAPAction"];
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
    return [arrayOfCards count];
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
    
    Card *aCard = [arrayOfCards objectAtIndex:indexPath.row];
    
    NSLog(@"Limit: %@", aCard.CardLimit);
    
    cell.textLabel.text = [NSString stringWithFormat:@"Card: %@", aCard.CardID];
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Limit: %@ %@", aCard.CardLimit, aCard.CardCcy];
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
    
    NSArray *arr=[theXML componentsSeparatedByString:@"<iosCardList>"];
    
    for(int i=1;i<[arr count];i++)
    {
        Card *object = [[Card alloc] init];
        NSString *str=[arr objectAtIndex:i];
        
        NSArray *arr=[str componentsSeparatedByString:@"<AccountCode>"];
        NSString *data=[arr objectAtIndex:1];
        NSRange ranfrom=[data rangeOfString:@"</AccountCode>"];
        object.AcountCode=[data substringToIndex:ranfrom.location];
        
        arr=[str componentsSeparatedByString:@"<Nrp>"];
        data=[arr objectAtIndex:1];
        ranfrom=[data rangeOfString:@"</Nrp>"];
        object.CustomerNumber=[data substringToIndex:ranfrom.location];
        
       
        
        arr=[str componentsSeparatedByString:@"<CardID>"];
        data=[arr objectAtIndex:1];
        ranfrom=[data rangeOfString:@"</CardID>"];
        object.CardID=[data substringToIndex:ranfrom.location];
        
        
        arr=[str componentsSeparatedByString:@"<CardLimit>"];
        data=[arr objectAtIndex:1];
        ranfrom=[data rangeOfString:@"</CardLimit>"];
        object.CardLimit=[data substringToIndex:ranfrom.location];
        
        arr=[str componentsSeparatedByString:@"<AccountCCY>"];
        data=[arr objectAtIndex:1];
        ranfrom=[data rangeOfString:@"</AccountCCY>"];
        object.CardCcy=[data substringToIndex:ranfrom.location];
        
        [arrayOfCards addObject:object];
    }
    
    stopActivityIndicator;
    
    [[self cardsTableView]reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowCardDetails"])
    {
        CardDetailsController *detailViewController = [segue destinationViewController];
        
        NSIndexPath *myIndexPath = [self.cardsTableView indexPathForSelectedRow];
        
        detailViewController.card = [arrayOfCards objectAtIndex:[myIndexPath row]];
    }
}

@end
