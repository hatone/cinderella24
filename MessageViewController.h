//
//  MessageViewController.h
//  Cinderella24v2
//
//  Created by 大島 孝子 on 11/09/06.
//  Copyright 2011 Future Univercity ,Hakodate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MessageViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate>
    // class method
    +(CGRect)labelRectFor:(int)gender;
    +(id)colorFor:(int)gender;
    +(id)labelMakeFor:(int)gender with:(NSString*)message offsetY:(int)offset;

    NSMutableArray* mArray;
    
    //インタフェース
    UITextField* _sendMessageField;
    UIButton* _sendMessageButton;
    UIScrollView* _showMessagScrollView; //UIスクロールビュー
    UIView* _messageStreamView;

    NSMutableData*           _data;//通信用のデータ
    NSTimer* timer;
    
    NSString* _apiSend;//apiの送信を叩く文字列    
    NSString* _apiReceive;//apiの受信を叩く文字列
    NSString* _apiSetroom;//apiの受信を叩く文字列


    int _textCount; //発言文字数、最初から最後までの個数。

    
    NSMutableArray* _sexMessage;//発言保存用　性別
    NSMutableArray* _textMessage;//発言保存用　発言内容

    int tempID;
    int maxID;//最大ID番号
    //Labelmakeは同じクラス内につくる！
    int column; //初期値-35

NSUserDefaults *ud; //ユーザデフォルト
NSDate *pastDate;

    //通信関連
@property (nonatomic, retain)NSMutableArray* mArray;
-(id)labelMake:(int)sexType setFrame:(CGRect)settingFrame;
@end
