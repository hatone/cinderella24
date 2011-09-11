//
//  AppDelegate_iPhone.h
//  Cinderella24v2
//
//  Created by 大島 孝子 on 11/09/06.
//  Copyright 2011 Future Univercity ,Hakodate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectionFirstViewController.h"
#import "MessageViewController.h"
#import "TitleViewController.h"

@interface AppDelegate_iPhone : NSObject <UIApplicationDelegate> {
    //UIWindow *window;
    //SelectionFirstViewController *viewController;
    //MessageViewController *viewController;
    TitleViewController* viewController;
 //   NSUserDefaults* defaults;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TitleViewController *viewController;
//@property (nonatomic, retain) NSUserDefaults* defaults;

@end

