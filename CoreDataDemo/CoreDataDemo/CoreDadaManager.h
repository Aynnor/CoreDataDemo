//
//  CoreDadaManager.h
//  CoreDataDemo
//
//  Created by liuzhibin on 2020/5/19.
//  Copyright © 2020 liuzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StudentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDadaManager : NSObject

///实例化manager
+(instancetype)manager;


///增加数据
-(void)insertData;

///删除数据
-(void)deleteData;

///更新数据
-(void)updateData;

///查询数据
-(NSArray *)selectData;


@end

NS_ASSUME_NONNULL_END
