//
//  SelectionFirstViewController.m
//  Cinderella24v2
//
//  Created by 大島 孝子 on 11/09/06.
//  Copyright 2011 Future Univercity ,Hakodate. All rights reserved.
//

#import "SelectionFirstViewController.h"
#import "AppDelegate_iPhone.h"

@implementation SelectionFirstViewController

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

static NSString *str_notification = @"確認します", *str_ok = @"OK", *str_cancel = @"キャンセル";

static const int MAN = 1, LADY = 2;



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title-background111.png"]];
    messageVC = [[MessageViewController alloc] initWithNibName:nil bundle:nil];
    //[[[NSUserDefaults standardUserDefaults] integerForKey:@"firstUp"] retain];
    
    
    //ボタン2つ表示
    UIButton *manButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    manButton.frame = CGRectMake(15, 170, 140, 140);
    [manButton setTitle:@"man" forState:UIControlStateNormal];
    UIImage *imageMan =[UIImage imageNamed:@"manfinal111.png"];
    [manButton setImage:imageMan forState:UIControlStateNormal];
    [manButton addTarget:self action: @selector(manDidPushAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *ladyButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    ladyButton.frame = CGRectMake(165, 170, 140, 140);
    [ladyButton setTitle:@"lady" forState:UIControlStateNormal];
    UIImage *imageLady =[UIImage imageNamed:@"ladyfinal111.png"];
    [ladyButton setImage:imageLady forState:UIControlStateNormal];
    [ladyButton addTarget:self action:@selector(ladyDidPushAction) forControlEvents:UIControlEventTouchUpInside];
    
    //ラベル
    //ラベル例文
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 10, 100, 50);
    label.backgroundColor = [UIColor yellowColor];
    label.textColor = [UIColor blueColor];
    label.font = [UIFont fontWithName:@"AppleGothic" size:12];
    label.textAlignment = UITextAlignmentCenter;
    label.text = @"性別を選んでね";
    //[self.view addSubview:label];
    
    //ボタンを画面に追加
    [self.view addSubview:manButton];
    [self.view addSubview:ladyButton];
}
static NSString* str_confirm_gender[] = {nil, @"男性で登録してよろしいですか？", @"女性で登録してよろしいですか？"};

-(void) manDidPushAction {
    UIAlertView *alertMan = [[UIAlertView alloc]initWithTitle:str_notification message:str_confirm_gender[MAN] delegate:self cancelButtonTitle:str_cancel otherButtonTitles:str_ok,nil];
    alertMan.cancelButtonIndex = 0;
    [alertMan show];
    [alertMan release];
}

-(void) ladyDidPushAction{
    UIAlertView *alertLady = [[UIAlertView alloc]initWithTitle:str_notification message:str_confirm_gender[LADY] delegate:self cancelButtonTitle:str_cancel otherButtonTitles:str_ok,nil];
    alertLady.cancelButtonIndex = 0;
    [alertLady show];
    [alertLady release];
}

-(void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    for (int i=MAN; i<=LADY; i++) {
        if ([alertView.message isEqualToString:str_confirm_gender[i]]) {
            if(buttonIndex != alertView.cancelButtonIndex){
                [self personalSetting:i];
            }
        }
    }
}  


-(void) personalSetting:(int)gender {
    [[NSUserDefaults standardUserDefaults] setInteger:gender forKey:@"sex"];
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstUp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"firstUp %d saved ", [[NSUserDefaults standardUserDefaults] boolForKey:@"firstUp"]);
    
    [self.navigationController pushViewController:messageVC animated:YES];
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
