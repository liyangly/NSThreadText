//
//  ViewController.m
//  NSThreadText
//
//  Created by 李阳 on 16/4/21.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "ViewController.h"

#define kURL @"http://avatar.csdn.net/2/C/D/1_totogo2010.jpg"

@interface ViewController ()

@end

@implementation ViewController

- (void)downloadImage:(NSString *)url {
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [[UIImage alloc] initWithData:data];
    NSAssert(image, @"图片为空");
    [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:YES];
}

- (void)updateUI:(id)image {
    
    self.imggeView.image = image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSThread *thread = [[NSThread alloc] initWithTarget:self
                                               selector:@selector(downloadImage:)
                                                 object:kURL];
    [thread start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
