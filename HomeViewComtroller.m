//
//  HomeViewComtroller.m
//  DataMatrixBarCode
//
//  Created by saurav sinha on 25/02/12.
//  Copyright (c) 2012 sauravsinha007@gmail.com. All rights reserved.
//

#import "HomeViewComtroller.h"
#import "SHDataMatrixReader.h"
#import "ShowDataViewController.h"
#import "MBProgressHUD.h"
@implementation HomeViewComtroller

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
    // Do any additional setup after loading the view from its nib.
    
}
- (void)viewWillAppear:(BOOL)animated
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	[picker setDelegate:self];
	//picker.allowsEditing = NO;
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
		[picker setSourceType:UIImagePickerControllerSourceTypeCamera];
	}else{
		[picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
	}
    [self presentModalViewController:picker animated:YES];  
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

#pragma mark -  UIImagePickerController Delegates
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"----------------");
	//NSLog(@"%@", [info valueForKey:@"UIImagePickerControllerOriginalImage"]);
    //[image release];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setLabelText:@"Decoding..."];
    [self performSelector:@selector(DecodeBarCodeWithInfo:) withObject:info afterDelay:0];
    //[self DecodeBarCodeWithInfo:info];
	[picker dismissModalViewControllerAnimated:NO]; 
        
}

-(void)DecodeBarCodeWithInfo:(NSDictionary *)Info
{
    SHDataMatrixReader * reader = [SHDataMatrixReader sharedDataMatrixReader];
	
    NSString * decodedMessage = [reader decodeBarcodeFromImage:[Info valueForKey:@"UIImagePickerControllerOriginalImage"]];      
    NSLog(@"Decoded : %@", decodedMessage);
    ShowDataViewController *sdvc=[[ShowDataViewController alloc]init];
    [sdvc setStrData:decodedMessage];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    [self.navigationController pushViewController:sdvc animated:YES];

}
@end
