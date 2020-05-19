//
//  StudentModel.h
//  CoreDataDemo
//
//  Created by liuzhibin on 2020/5/19.
//  Copyright © 2020 liuzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface StudentModel : NSManagedObject

//+ (NSFetchRequest<StudentModel *> *)fetchRequest;


@property (nonatomic,assign) int64_t id;///<id
@property (nullable,nonatomic,copy) NSString *name;///<name
@property (nonatomic,assign) float age;///<age
@property (nonatomic,assign) int64_t height;///<height cm
@property (nonatomic,assign) BOOL gender;///<gender



@end

NS_ASSUME_NONNULL_END
