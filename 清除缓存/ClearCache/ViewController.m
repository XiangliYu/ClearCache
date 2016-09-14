//
//  ViewController.m
//  ClearCache
//
//  Created by Mac on 16/9/13.
//  Copyright © 2016年 LoveSpending. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *cacheBt = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 100, 30))];
    cacheBt.center = CGPointMake(self.view.frame.size.width/2, 200);
    [cacheBt setTitle:@"清除缓存" forState:UIControlStateNormal];
    [cacheBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cacheBt addTarget:self action:@selector(cacheAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cacheBt];
}

- (void)cacheAction:(UIButton *)sender{

    //清除缓存
    NSString *cacheStr = [self getCacheSize];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"缓存大小%@，确认清除？",cacheStr] message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self clearMemory];
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [alertController addAction:noAction];
    [self presentViewController:alertController animated:YES completion:nil];
    


}

// 获取缓存大小
- (NSString *)getCacheSize{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        // 拿到有文件的数组
        NSArray *childerFile = [fileManager subpathsAtPath:path];
        // 拿到每个文件名字，不想清除就在这里判断
        for (NSString *fileName in childerFile) {
            // 拼在一起
            NSString *fullPath = [path stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizePath:fullPath];
        }
    }
    return [self exchangeString:folderSize];
}

// 计算大小
- (float)fileSizePath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}

// 换算
- (NSString *)exchangeString:(float)floatNum{
    if ((floatNum / 1024) < 1) {
        return @"0KB";
    } else if ((floatNum / pow(1024, 2)) < 1){
        return [[NSString stringWithFormat:@"%.2f",floatNum / 1024] stringByAppendingString:@" KB"];
    } else if ((floatNum / pow(1024, 3)) < 1){
        return [[NSString stringWithFormat:@"%.2f",floatNum / pow(1024, 2)] stringByAppendingString:@" MB"];
    } else if ((floatNum / pow(1024, 4)) < 1){
        return [[NSString stringWithFormat:@"%.2f",floatNum / pow(1024, 3)] stringByAppendingString:@" GB"];
    }
    return @"缓存过大，请及时清理";
}

//清除缓存
- (void)clearMemory{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
