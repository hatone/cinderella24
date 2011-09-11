//
//  SelectionFirstViewController.h
//  Cinderella24v2
//
//  Created by 大島 孝子 on 11/09/06.
//  Copyright 2011 Future Univercity ,Hakodate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageViewController.h"

@interface SelectionFirstViewController : UIViewController {
    MessageViewController* messageVC;

    NSNumber* sex;
}

-(void) manSetting;
-(void) ladySetting;
-(void) personalSetting:(int)gender;


@end
    