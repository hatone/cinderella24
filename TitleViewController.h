//
//  TitleViewController.h
//  Cinderella24v2
//
//  Created by 大島 孝子 on 11/09/07.
//  Copyright 2011 Future Univercity ,Hakodate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectionFirstViewController.h"
#import "MessageViewController.h"

@interface TitleViewController : UIViewController {
    SelectionFirstViewController* selectionFirstVC;
    MessageViewController* messageVC;
    NSTimer* timer;
}

@end
