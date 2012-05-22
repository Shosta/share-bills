//
//  CustomImagePicker.m
//  CustomImagePicker
//
//  Created by Ray Wenderlich on 1/27/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "OLGridViewController.h"
#import "UIImageExtras.h"

@implementation OLGridViewController
@synthesize images = _images;
@synthesize thumbs = _thumbs;
@synthesize selectedImage = _selectedImage;

- (id) init {
	if ((self = [super init])) {
		_images =  [[NSMutableArray alloc] init];
		_thumbs =  [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)addImage:(UIImage *)image {
	[_images addObject:image];
	[_thumbs addObject:[image imageByScalingAndCroppingForSize:CGSizeMake(64, 64)]];
}

- (void)viewDidLoad {
	
	// Create view
	UIScrollView *view = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	int row = 0;
	int column = 0;
	for(int i = 0; i < _thumbs.count; ++i) {
		
		UIImage *thumb = [_thumbs objectAtIndex:i];
		UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(column*100+24, row*80+10, 64, 64);
		[button setImage:thumb forState:UIControlStateNormal];
		[button addTarget:self 
               action:@selector(buttonClicked:) 
		 forControlEvents:UIControlEventTouchUpInside];
		button.tag = i; 
		[view addSubview:button];
		
		if (column == 2) {
			column = 0;
			row++;
		} else {
			column++;
		}
		
	}
	
	[view setContentSize:CGSizeMake(320, (row+1) * 80 + 10)];
	
	self.view = view;
	[view release];
	
	// Create cancel button
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" 
                                                                   style:UIBarButtonItemStylePlain 
                                                                  target:self 
                                                                  action:@selector(cancel:)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
	
	[super viewDidLoad];
}

- (IBAction)buttonClicked:(id)sender {
	UIButton *button = (UIButton *)sender;
	self.selectedImage = [_images objectAtIndex:button.tag];
	RLLogDebug(@"Button clicked");
}

- (IBAction)cancel:(id)sender {
	self.selectedImage = nil;
	RLLogDebug(@"Selecting people canceled");
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}

- (void)dealloc {
	self.images = nil;
	self.thumbs = nil;
	self.selectedImage = nil;
	[super dealloc];
}

@end
