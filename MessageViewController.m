//
//  MessageViewController.m
//  Cinderella24v2
//
//  Created by 大島 孝子 on 11/09/06.
//  Copyright 2011 Future Univercity ,Hakodate. All rights reserved.
//

#import "MessageViewController.h"
#import "SelectionFirstViewController.h"
#import "SBJson.h"

@implementation MessageViewController

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


//-------------------------------------------------------通信処理部分------------------------------------------------------------
//データ→文字列
- (NSString*)data2str:(NSData*)data {
    return [[[NSString alloc] initWithData:data 
                                  encoding:NSUTF8StringEncoding] autorelease];
}

//GETによるHTTP通信(1)
- (void)http2data:(NSString*)url delegate:(id)delegate {
    NSURLRequest* request=[NSURLRequest 
                           requestWithURL:[NSURL URLWithString:url]
                           cachePolicy:NSURLRequestUseProtocolCachePolicy 
                           timeoutInterval:30.0];        
    [NSURLConnection connectionWithRequest:request 
                                  delegate:delegate];
}

//データ受信開始時に呼ばれる(2)
- (void)connection:(NSURLConnection*)connection
didReceiveResponse:(NSURLResponse*)response {
    if (_data!=nil) [_data release];
    _data=[[NSMutableData data] retain];//(3)
}

//データ受信時に呼ばれる(2)
- (void)connection:(NSURLConnection*)connection
    didReceiveData:(NSData*)data {
    [_data appendData:data];//(3)
}

//データ受信完了時に呼ばれる(2)
- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
    NSRange s = [[self data2str:_data] rangeOfString:@"send"];//send
    NSRange r = [[self data2str:_data] rangeOfString:@"rsv"];//receive
    NSRange g = [[self data2str:_data] rangeOfString:@"room"];//room
    
    if(s.length){
        NSLog(@"sendに入ってる");
        _sendMessageField.text=nil;
    }
    else if(r.length){
        NSLog(@"rsvに入ってる");
        
        //NSString *jsonString  = [[[self data2str:_data]substringToIndex:4] JSONValue];
        
        NSMutableString *tstr = [NSMutableString stringWithString:[self data2str:_data]];
        
        [tstr replaceOccurrencesOfString: @"rsv\n" withString: @"" options:0 range:NSMakeRange(0 , [tstr length] )];
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSArray *object = [parser objectWithString:tstr error:nil];
        for(NSDictionary* obj in object){
            
            //    NSLog(@"%d",[[obj objectForKey:@"id"] intValue]);
            //    NSLog(@"%d",[[obj objectForKey:@"sex"] intValue]);
            //    NSLog(@"%@",[obj objectForKey:@"text"]);
            if(maxID<=[[obj objectForKey:@"id"] intValue])
            {
                //[_showMessagScrollView setContentOffset:CGPointMake(0,column) animated:YES];
                [_showMessagScrollView  addSubview:[MessageViewController labelMakeFor:[[obj objectForKey:@"sex"]intValue] with:[obj objectForKey:@"text"] offsetY:0] ];
            }
            //   [appDelegate.defaults insertObject:[obj objectForKey:@"text"] atIndex:0];
            //[appDelegate.array addObject:[obj objectForKey:@"text"]];
            tempID=[[obj objectForKey:@"id"] intValue];
            
        }
    }
    else if(g.length){
        NSMutableString *tstr = [NSMutableString stringWithString:[self data2str:_data]];
        [tstr replaceOccurrencesOfString: @"room\n" withString: @"" options:0 range:NSMakeRange(0 , [tstr length] )];
        int roomID= [tstr intValue];
        NSLog(@"roomID: %d",roomID);
        //[ud setInteger:roomID forKey:@"channelID"];  
        //[ud synchronize];
    }
    
    maxID=tempID;
    //変数の解放
    [_data release];
    _data=nil;
    
    
}

//データ受信失敗時に呼ばれる(2)
- (void)connection:(NSURLConnection*)connection 
  didFailWithError:(NSError*)error {
    NSLog(@"エラーでござる");
}

//-------------------定数----------------
static const int MAN = 1, LADY = 2;
//----------------------------------------------------初期設定------------------------------------------------------
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chat-background111.png"]];
         
    //初期化
    column=-35;
    maxID = 1;
    
    //apiの文字列の設定
    //   _apiSend= @"http://localhost/api/message/send.php?";
    //   _apireceive=@"http://localhost/api/message/receive.php?";
    
    ud = [NSUserDefaults standardUserDefaults];  
    
    //ボタンの設定
    _sendMessageButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    _sendMessageButton.frame = CGRectMake(260, 5, 60, 30);
    [_sendMessageButton setTitle:@"send" forState:UIControlStateNormal];
    [_sendMessageButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //テキストフィールドの設定
    _sendMessageField= [[UITextField alloc] initWithFrame:CGRectMake(5, 5, 250, 30)];
    _sendMessageField.borderStyle=UITextBorderStyleRoundedRect;
    _sendMessageField.delegate =self;
    
    //ラベル例文 
    UILabel* _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(10, 10, 100, 50);
    _label.backgroundColor = [UIColor yellowColor];
    _label.textColor = [UIColor blueColor];
    _label.font = [UIFont fontWithName:@"AppleGothic" size:12];
    _label.textAlignment = UITextAlignmentCenter;
    _label.text = @"MessageView";
    
    //スクロールビュー
    _showMessagScrollView = [[UIScrollView alloc] init];
    _showMessagScrollView.frame = CGRectMake(0, 40, 320, 450);
    _showMessagScrollView.contentSize = CGSizeMake(320, 10000);
    
    //メッセージビュー
    _messageStreamView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320, 10000)];
    [_showMessagScrollView addSubview:_messageStreamView];
    _showMessagScrollView.contentSize = _messageStreamView.bounds.size;
    
    //表示
    [self.view addSubview:_sendMessageButton];
    //   [self.view addSubview:_label];
    [self.view addSubview:_sendMessageField];
    [self.view addSubview:_showMessagScrollView ];
    
    
    //SelectionFirstViewController *appDelegate =(SelectionFirstViewController*)[[UIApplication sharedApplication] delegate];
    //  SelectionFirstViewController* appDelegate = (SelectionFirstViewController*) [[UIApplication sharedApplication] delegate];
    
    //    int posY=0; 
    //    for(int i=0;i<100;i++){
    //        int t = random()%2 + 1;
    //        CGRect labelRect = (t==MAN)? CGRectMake(10, offsetY, 250, 30) : CGRectMake(50, offsetY, 250, 30);
    
    //[_showMessagScrollView addSubview:[self labelMake:t setFrame:labelRect]];
    //        [_messageStreamView addSubview:[MessageViewController labelMakeFor:t with:@"がんばれー" offsetY:posY]];
    //        posY += 35.0;
    //    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.5) target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
    //部屋の取得
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	
	NSString *nowDateStr = [dateFormatter stringFromDate:[NSDate date]];
	NSDate* curentDate = [dateFormatter dateFromString:nowDateStr];

    pastDate = [ud objectForKey:@"date"];
   BOOL dateBool= [curentDate isEqualToDate:pastDate];
    NSLog(@"curentDate %@",curentDate);
    NSLog(@"pastDate %@",pastDate);
    if(dateBool==NO)
        {
            NSLog(@"日付が変わりました");
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            
            NSString *nowDateStr = [dateFormatter stringFromDate:[NSDate date]];
            pastDate = [dateFormatter dateFromString:nowDateStr];
            [ud setObject:pastDate forKey:@"date"];
            [ud synchronize];
            
            //maxID=tempID;
            _apiSetroom = [NSString stringWithFormat:@"http://localhost/api/channel/set.php?sex=%d",[ud integerForKey:@"sex"]];
            _apiSetroom= [_apiSetroom stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSLog(@"_apiRsv %@", _apiReceive);
            
            [self http2data:_apiSetroom delegate:self];
        }
    

    //[ud setObject:curentDate forKey:@"date"];
    //[ud synchronize];

}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//--------------------------------------------タイマー処理----------------------------------------------
-(void)onTimer{
    //        [self.navigationController pushViewController:messageVC animated:YES];
    //[self.navigationController pushViewController:selectionFirstVC animated:YES];
    
    //NSLog(@"sex: %@",1);
    
    //maxID=tempID;
    _apiReceive = [NSString stringWithFormat:@"http://localhost/api/message/receive.php?channelID=%d&id=%d",[ud integerForKey:@"channelID"],maxID];
    _apiReceive=[_apiReceive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"_apiRsv %@", _apiReceive);
    
    [self http2data:_apiReceive delegate:self];
    
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

//-------------------------------------------ボタン処理-----------------------------------------------------
- (void)sendButtonAction:(UIButton*)sender{
    //デモ用
     [ud setInteger:777 forKey:@"channelID"];
    if (_sendMessageField.text.length == 0) {
        return;
    }
    NSLog(@"length was %d ", _sendMessageField.text.length);

    NSString* message = _sendMessageField.text;
    
    //http://localhost/api/message/send.php?sex= %d &id =%d , sex,id
    //NSString *str = [NSString stringWithFormat:@"http:localhost/api/message/send.php?sex=%d&id=%d",sex,id];
    //NSURL *url = [NSURL URLWithString:str];
    
    //http://localhost/api/message/send.php?channelID=33&sex=2&text=%E3%81%8A%E3%81%AA%E3%81%8B%E3%81%8C%E3%81%99%E3%81%84%E3%81%9F%E3%83%BC
    _apiSend = [NSString stringWithFormat:@"http://localhost/api/message/send.php?channelID=%d&sex=%d&text=%@",[ud integerForKey:@"channelID"],[ud integerForKey:@"sex"],message];
    // _apiSend = @"http://localhost/api/message/send.php?channelID=33&sex=2&text=くまぎ";
    
    _apiSend=[_apiSend stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"くまぎありがとう %d メッセージ:%@", [ud integerForKey:@"sex"], _apiSend);
    
    // オフセットをずらすことで会話できてるように見えるがココの数字を延々と増やして行く事で対処することになってしまって良くない。
    // 長い会話は破綻しそうだけど、デモをするところまでならここの-35って数字をガシガシ動かしていく事で会話っぽくみせることは可能そう。でも美しくない回避策。
    // ん、addSubviewにNSWindowAboveというオプション発見。と思ったら上ってz軸方向に上に足す（重ねる)のね…使えない
    
    // [_showMessagScrollView setContentOffset:CGPointMake(0,0) animated:YES];
    //[_showMessagScrollView  addSubview:[MessageViewController labelMakeFor:[ud integerForKey:@"sex"] with:message offsetY:0] ];
    
    
    [self http2data:_apiSend delegate:self];
    // メッセージボックスを空に
    _sendMessageField.text = @"";
}

//-------------------------------------------ラベル処理-----------------------------------------------------

/* // 使いにくそうなのでdeprecated
 -(id)labelMake:(int)sexType setFrame:(CGRect)settingFrame{
 NSString* mess=@"てすとです";
 //男の発言
 if(sexType==1){
 _textLabel=[[UILabel alloc]initWithFrame:settingFrame];
 _textLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.8 blue:1.0 alpha:0.8]; //青色
 [_textLabel setLineBreakMode:UILineBreakModeWordWrap];
 [_textLabel setNumberOfLines:0];
 _textLabel.adjustsFontSizeToFitWidth=YES;
 [_textLabel setText:mess];
 [_textLabel sizeToFit];
 
 _textLabel.layer.cornerRadius = 10.0f;
 _textLabel.clipsToBounds =YES;
 }
 //女の発言
 else if(sexType==2){
 _textLabel=[[UILabel alloc]initWithFrame:settingFrame];
 _textLabel.backgroundColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.9 alpha:0.8];
 
 [_textLabel setLineBreakMode:UILineBreakModeWordWrap]; //単語毎に改行
 [_textLabel setNumberOfLines:0];//0だとフレキシブル。それ以外だと、任意。
 _textLabel.adjustsFontSizeToFitWidth=YES;//なんか、いい感じに。
 [_textLabel setText:mess];
 [_textLabel sizeToFit];//これやらなきゃラベルの大きさが変わらない（らしい）
 
 _textLabel.layer.cornerRadius =10.0f;
 _textLabel.clipsToBounds=YES;
 
 }
 return _textLabel;
 }
 // 代わりにlabelMakeForをば。 */ 

int offY=0;

+(CGRect)labelRectFor:(int)gender offsetY:(int)offset{
    return (gender == MAN) ? CGRectMake(10, offset, 250, 30) : CGRectMake(50, offset, 250, 30);
}
+(id)colorFor:(int)gender{
    return (gender == MAN) ? [UIColor colorWithRed:0.0 green:0.8 blue:1.0 alpha:0.8]
    : [UIColor colorWithRed:1.0 green:0.3 blue:0.9 alpha:0.8];      
}
+(id)labelMakeFor:(int)gender with:(NSString*)message offsetY:(int)offset {
    UILabel* new_label = [[UILabel alloc] initWithFrame:[MessageViewController labelRectFor:gender offsetY:offset]];
    new_label.backgroundColor = [MessageViewController colorFor:gender];
    [new_label setLineBreakMode:UILineBreakModeWordWrap];
    [new_label setNumberOfLines:0];
    new_label.adjustsFontSizeToFitWidth=YES;
    [new_label setText:message];
    [new_label sizeToFit];
    new_label.layer.cornerRadius = 10.0f;
    
    
    //---ラベルの横幅変更しない---
    CGRect nowFrame = new_label.frame;
    new_label.frame = CGRectMake(nowFrame.origin.x, nowFrame.origin.y, 250, CGRectGetHeight(nowFrame)+10);    
    new_label.clipsToBounds = YES;
    
  //  _messageStreamView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320, offY)];
//    [_showMessagScrollView addSubview:_messageStreamView];
//    _showMessagScrollView.contentSize = _messageStreamView.bounds.size;
//    offY+=CGRectGetHeight(nowFrame);
//    if(CGRectGetHeight(nowFrame)<22){
//        offY+=13;
//    }else if((CGRectGetHeight(nowFrame)>21)&&(CGRectGetHeight(nowFrame)<43)){
//        offY+=18;
//    }else if((CGRectGetHeight(nowFrame)>43)&&(CGRectGetHeight(nowFrame)<65)){
//        offY+=23;
//    }else {
//        offY+=35;
//    }

    
    //----------------------------
    for(UIView *onView in _showMessagScrollView.subviews){
        if ([onView isKindOfClass:[UILabel class]]) {
            CGRect aRect =onView.frame;
            onView.frame = CGRectMake(aRect.origin.x, aRect.origin.y+new_label.frame.size.height+20, aRect.size.width, aRect.size.height);
        }
    }
    
    return new_label;
}




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
    
    [mArray dealloc];
    [super dealloc];   
}


@end
