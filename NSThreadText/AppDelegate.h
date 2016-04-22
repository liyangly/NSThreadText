//
//  AppDelegate.h
//  NSThreadText
//
//  Created by 李阳 on 16/4/21.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
    int tickets;
    int count;
    NSThread *ticketThreadOne;
    NSThread *ticketThreadTwo;
    NSCondition *ticketCondition;
    NSLock *theLock;
}

@property (strong, nonatomic) UIWindow *window;


@end

