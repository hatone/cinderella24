//
//  TitleViewController.m
//  Cinderella24v2
//
//  Created by 大島 孝子 on 11/09/07.
//  Copyright 2011 Future Univercity ,Hakodate. All rights reserved.
//

#import "TitleViewController.h"


@implementation TitleViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"newtitle-didsizeedit.png"]];
    selectionFirstVC = [[SelectionFirstViewController  alloc] initWithNibName:nil bundle:nil];
    messageVC=[[MessageViewController alloc] initWithNibName:nil bundle:nil];
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.5) target:self selector:@selector(onTimer) userInfo:nil repeats:NO];
}

-(void)onTimer{
    //        [self.navigationController pushViewController:messageVC animated:YES];
    
    
    // if([[NSUserDefaults standardUserDefaults]  boolForKey:@"firstUp"]==YES){
    
    //            [self.navigationController pushViewController:selectionFirstVC animated:YES];
    //}
    //else{    
    //            [self.navigationController pushViewController:messageVC animated:YES];
    //}
    NSLog(@"firstuUp %d load", [[NSUserDefaults standardUserDefaults] boolForKey:@"firstUp"]);
    
    // CAUTION: this line is only for debug!! by kumagi    
    
    NSLog(@"asdf%@", [[NSUserDefaults standardUserDefaults] boolForKey:@"firstUp"] ? @"YES" : @"NO");
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstUp"]) {
        NSLog(@"firstu up %d", [[NSUserDefaults standardUserDefaults] boolForKey:@"firstUp"]);    
        [self.navigationController pushViewController:messageVC animated:YES];
    }
    else{
        NSLog(@"not first up %d", [[NSUserDefaults standardUserDefaults] boolForKey:@"firstUp"]);
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstUp"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController pushViewController:selectionFirstVC animated:YES];
    }   

    // [self.navigationController pushViewController:messageVC animated:YES];
    
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end