//
//  StudentModel+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by liuzhibin on 2020/5/19.
//  Copyright © 2020 liuzhibin. All rights reserved.
//

#import "StudentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StudentModel (CoreDataProperties)

@property (nonatomic,assign) float age;///<age
@property (nonatomic,assign) BOOL gender;///<gender
@property (nonatomic,assign) int64_t height;///<height
@property (nonatomic,assign) int64_t id;///<id
@property (nonatomic,assign) NSString *name;///<name


@end

NS_ASSUME_NONNULL_END
