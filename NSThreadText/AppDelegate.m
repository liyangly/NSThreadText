//
//  AppDelegate.m
//  NSThreadText
//
//  Created by 李阳 on 16/4/21.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self threadText];
    return YES;
}

- (void)threadText {
    
    tickets = 10;
    count = 0;
    theLock = [[NSLock alloc] init];
    ticketCondition = [[NSCondition alloc] init];
    ticketThreadOne = [[NSThread alloc] initWithTarget:self
                                              selector:@selector(runThread:)
                                                object:nil];
    [ticketThreadOne setName:@"Thread-1"];
    [ticketThreadOne start];
    
    ticketThreadTwo = [[NSThread alloc] initWithTarget:self
                                              selector:@selector(runThread:)
                                                object:nil];
    [ticketThreadTwo setName:@"Thread-2"];
    [ticketThreadTwo start];
    
    NSThread *ticketThreadThree = [[NSThread alloc] initWithTarget:self
                                                          selector:@selector(runThread2)
                                                            object:nil];
    [ticketThreadThree setName:@"Thread-3"];
    [ticketThreadThree start];
}

- (void)runThread2 {
    
    while (true) {
        
        [ticketCondition lock];
        [NSThread sleepForTimeInterval:2];
        [ticketCondition signal];
        [ticketCondition unlock];
    }
}

- (void)runThread:(id)anObj {
    
    while (true) {
        
        [ticketCondition lock];
        [ticketCondition wait];//只有 NSCondition 有线程等待操作
        
        //线程已经被 ticketCondition 锁住，可以不用再开线程锁
        //1.
        @synchronized(anObj) {
            //使用指令 @synchronized 来简化 NSLock的使用，这样我们就不必显示编写创建NSLock,加锁并解锁相关代码。
            if (tickets >= 0) {
                
                [NSThread sleepForTimeInterval:0.09];
                count = 100 - tickets;
                NSLog(@"当前票数时:%d,售出:%d,线程名:%@",tickets,count,[[NSThread currentThread] name]);
                tickets--;
            }else {
                break;
            }
        }
        
//        2.
//        [theLock lock];
        
//        if (tickets >= 0) {
//            
//            [NSThread sleepForTimeInterval:0.09];
//            count = 100 - tickets;
//            NSLog(@"当前票数时:%d,售出:%d,线程名:%@",tickets,count,[[NSThread currentThread] name]);
//            tickets--;
//        }else {
//            break;
//        }
        
//        [theLock unlock];
        
        [ticketCondition unlock];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
