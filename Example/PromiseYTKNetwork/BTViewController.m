//
//  BTViewController.m
//  PromiseYTKNetwork
//
//  Created by onexf on 07/19/2020.
//  Copyright (c) 2020 onexf. All rights reserved.
//

#import "BTViewController.h"
#import "BTPromiseRequest.h"


@interface BTViewController ()

@end

@implementation BTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    BTPromiseRequest *request = [[BTPromiseRequest alloc] init];
    
    [request launch].then(^(NSDictionary *response) {
        NSLog(@"🚩🚩🚩🚩🚩🚩🚩🚩🚩🚩%@", response);
        
        return [request launch];
    }).then(^(NSDictionary *dict) {
        NSLog(@"🚩🚩🚩🚩%@", dict[@"code"]);
    }).catch(^(NSError *error){
        NSLog(@"🚩🚩🚩🚩🚩🚩🚩🚩🚩🚩%@", error);
    }).ensure(^{ // 隐藏HUD
        NSLog(@"无论成功还是失败，都结束了");
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
