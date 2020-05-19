//
//  ViewController.m
//  CoreDataDemo
//
//  Created by liuzhibin on 2020/5/19.
//  Copyright © 2020 liuzhibin. All rights reserved.
//

#import "ViewController.h"
#import "CoreDadaManager.h"

@interface ViewController ()

@property (nonatomic,weak) UILabel *label;///<lab

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //实例化manager
    [CoreDadaManager manager];
    [self setupUI];
}

-(void)setupUI {
    
    UILabel *label = [UILabel new];
    label.textColor = UIColor.redColor;
    label.text = @"什么?";
    [self.view addSubview:label];
    label.frame = CGRectMake(20, 100, self.view.bounds.size.width-40, 44);
    _label = label;
    
    CGFloat bgViewWidth = self.view.bounds.size.width - 88;
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = UIColor.yellowColor;
    bgView.frame = CGRectMake(0, 0, bgViewWidth, bgViewWidth);
    bgView.center = self.view.center;
    [self.view addSubview:bgView];
    
    
    NSInteger columnCount = 2;
    CGFloat margin = 5;
    CGFloat itemWidth = (bgViewWidth - margin)/columnCount;
    
    NSArray *items = @[@"增",@"删",@"改",@"查"];
    
    for (NSInteger i = 0; i<items.count; i++){
        
        NSInteger rowNum = i/columnCount;
        NSInteger columnNum = i % columnCount;
        
        CGFloat x = (itemWidth + margin) * columnNum;
        CGFloat y = (itemWidth + margin) * rowNum;
        
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        btn.backgroundColor = UIColor.grayColor;
        [btn setTitleColor:UIColor.redColor forState:(UIControlStateNormal)];
        [btn setTitle:items[i] forState:(UIControlStateNormal)];
        [bgView addSubview:btn];
        btn.tag = i+1;
        btn.frame = CGRectMake(x, y, itemWidth, itemWidth);
        [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    }
}

-(void)didClickBtn:(UIButton *)btn {
    switch (btn.tag) {
        case 1:
            [[CoreDadaManager manager] insertData];
            break;
        case 2:
            [[CoreDadaManager manager] deleteData];
            break;
        case 3:
            [[CoreDadaManager manager] updateData];
            break;
        case 4:{
            NSArray *datas = [[CoreDadaManager manager] selectData];
            StudentModel *model = datas.firstObject;
            
            self.label.text = model.name;
        }
            break;
        default:
            break;
    }
}

@end
