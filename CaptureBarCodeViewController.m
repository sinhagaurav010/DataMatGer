//
//  CaptureBarCodeViewController.m
//  DataMatrixBarCode
//
//  Created by saurav sinha on 25/02/12.
//  Copyright (c) 2012 sauravsinha007@gmail.com. All rights reserved.
//

#import "CaptureBarCodeViewController.h"
#import "SHDataMatrixReader.h"
#import "MBProgressHUD.h"
#import "ShowDataViewController.h"
@implementation CaptureBarCodeViewController
@synthesize stillImageOutput,captureManager,scanningLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    [self setCaptureManager:[[[CaptureSessionManager alloc] init] autorelease]];
    
	[[self captureManager] addVideoInput];
    
    [[self captureManager] addStillImageOutput];
    
	[[self captureManager] addVideoPreviewLayer];
	CGRect layerRect = [[[self view] layer] bounds];
	[[[self captureManager] previewLayer] setBounds:layerRect];
	[[[self captureManager] previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                                                  CGRectGetMidY(layerRect))];
	[[[self view] layer] addSublayer:[[self captureManager] previewLayer]];
    
    UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlaygraphic.png"]];
    [overlayImageView setFrame:CGRectMake(10, 20, 300, 300)];
    [[self view] addSubview:overlayImageView];
    [overlayImageView release];
    
    UIButton *overlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [overlayButton setImage:[UIImage imageNamed:@"scanbutton.png"] forState:UIControlStateNormal];
    [overlayButton setFrame:CGRectMake(130, 350, 60, 30)];
    [overlayButton addTarget:self action:@selector(scanButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:overlayButton];
    
    /* UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 120, 30)];
     [self setScanningLabel:tempLabel];
     [tempLabel release];
     [scanningLabel setBackgroundColor:[UIColor clearColor]];
     [scanningLabel setFont:[UIFont fontWithName:@"Courier" size: 18.0]];
     [scanningLabel setTextColor:[UIColor redColor]]; 
     [scanningLabel setText:@"Saving..."];
     [scanningLabel setHidden:YES];
     [[self view] addSubview:scanningLabel];	*/
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveImageToPhotoAlbum) name:kImageCapturedSuccessfully object:nil];
    
	[[captureManager captureSession] startRunning];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
   
}
- (void)scanButtonPressed {
    [NSThread detachNewThreadSelector:@selector(startTheBackgroundJob) toTarget:self withObject:nil];
     timer=[NSTimer scheduledTimerWithTimeInterval:(1.0/2.0) target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [[self captureManager] captureStillImage];
    [[captureManager captureSession] stopRunning];
}
-(void)startTheBackgroundJob
{
    
    activitity=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(150, 200, 30, 30)];
    [activitity hidesWhenStopped];
    [activitity setBackgroundColor:[UIColor blackColor]];
    activitity.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    [activitity startAnimating];
    [self.view addSubview:activitity];
    [NSThread exit];
    
}
-(void)tick
{
    [activitity stopAnimating];
}
- (void)saveImageToPhotoAlbum 
{
    // UIImageWriteToSavedPhotosAlbum([[self captureManager] stillImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    SHDataMatrixReader * reader = [SHDataMatrixReader sharedDataMatrixReader];
    NSString * decodedMessage = [reader decodeBarcodeFromImage:[[self captureManager] stillImage]];      
    NSLog(@"Decoded : %@", decodedMessage);  
    [activitity stopAnimating];
    if([decodedMessage length]>0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Scan Result" message:decodedMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
      /*  ShowDataViewController *sdvc=[[ShowDataViewController alloc]init];
        [sdvc setStrData:decodedMessage];
        [self.navigationController pushViewController:sdvc animated:YES];*/
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[captureManager captureSession] startRunning]; 
}
@end
