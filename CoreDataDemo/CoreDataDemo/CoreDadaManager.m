//
//  CoreDadaManager.m
//  CoreDataDemo
//
//  Created by liuzhibin on 2020/5/19.
//  Copyright © 2020 liuzhibin. All rights reserved.
//

//参考链接：https://juejin.im/post/5c088751e51d450d857fa826

#import <UIKit/UIKit.h>
#import "CoreDadaManager.h"
#import <CoreData/CoreData.h>


@interface CoreDadaManager ()

@property (nonatomic,strong) NSManagedObjectContext *context;///<操作数据库的上下文

@end
@implementation CoreDadaManager

+(instancetype)manager {
    static CoreDadaManager *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [CoreDadaManager new];
        [tools managerBaseConfig];
    });
    return tools;
}


#pragma mark - CoreData基础配置, 如果我们不使用CoreData的自动创建模型功能, 自己创建模型, 则模型需要继承自NSManagedObject, 并且我们就需要自行关联模型和数据库,
-(void)managerBaseConfig {
    
    /*
     NSManagedObjectContext 管理对象，上下文，持久性存储模型对象，处理数据与应用的交互
     NSManagedObjectModel 被管理的数据模型，数据结构
     NSPersistentStoreCoordinator 添加数据库，设置数据存储的名字，位置，存储方式
     NSManagedObject 被管理的数据记录
     NSFetchRequest 数据请求
     NSEntityDescription 表格实体结构
     
     系统创建模型文件时会自动生成关联数据库的代码，在iOS10以下和iOS10之后生成的不一样，出现了一个新类NSPersistentContainer, 如果你是创建项目时勾选 'Use CoreData'就能在 AppDelegate.m中看到, 它会自动帮我们关联CoreData文件与上下文
     */
    
    
    
    //1.获取模型路径 coredate文件路径url, 注意文件后缀是 momd
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"UserInfoModel" withExtension:@"momd"];
    
    //根据模型文件创建模型对象
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    
    //2.创建持久化存储助理：数据库
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    //数据库的名称和路径, CoreData要关联到那个数据库? 此数据库文件是自定义的
    NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"stu_info.sqlite"];
    NSLog(@"sqlitePath = %@",dbPath);
    NSURL *dbUrl = [NSURL fileURLWithPath:dbPath];
    
    NSError *err = nil;
    //设置数据库相关信息 添加一个持久化存储库并设置类型和路径，NSSQLiteStoreType：SQLite作为存储库, 并会自动生成SQL语句来做CRUD（增删改查）
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:dbUrl options:nil error:&err];
    
    if (err) {
        NSLog(@"添加数据库失败, error = %@",err);
        return;
    }
    
    //3.创建上下文 保存信息 对数据库进行操作, 所有的ManagedObject的CRUD都是在context上进行的。
    NSManagedObjectContext *content = [[NSManagedObjectContext alloc] initWithConcurrencyType:(NSMainQueueConcurrencyType)];
    
    //关联持久化助理, 建立persistStore和context的关联
    content.persistentStoreCoordinator = store;
    //长期持有context用于操作数据库
    _context = content;
}



     

#pragma mark - 增
-(void)insertData {
    
//1.根据Entity名称和NSManagedObjectContext获取一个新的继承于NSManagedObject的子类模型
//注意的是: Entity 右侧栏设置中, 你要name是设置Entity名称, Class是设置根据这个表创建那个类的模型, 并且模型类名不能与Entity名词一样!!!
//比如这里: Entity name 是 Student , class 是 StudentModel
    StudentModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:_context];
    
    //给模型赋值
    model.id = 100010;
    model.name = @"小花";
    model.age = arc4random()%20;
    model.height = arc4random()%180;
    model.gender = arc4random()%2;
    
    //3.保存插入的数据
    NSError *err = nil;
    if ([_context save:&err]) {//只有调用MOC的save方法后，才会真正对数据库进行操作，否则这个对象只是存在内存中，这样做避免了频繁的数据库访问。
        NSLog(@"插入数据成功");
    }else{
        NSLog(@"插入数据失败 -- Error = %@",err);
    }
    
}

#pragma mark - 删
-(void)deleteData {
    
    //创建删除请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    
    //删除条件, 有点类似FMDB, 同样的是语句+ 参数
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"age > %d",10];
    request.predicate = pre;
    
    //返回需要删除的对象的数组
    NSArray <StudentModel *>*deleteDatas = [_context executeFetchRequest:request error:nil];
    
    //从库中删除这些对象
    for (StudentModel *model in deleteDatas) {
        [_context deleteObject:model];
    }
    
    
    NSError *error = nil;
    //保存(确定)这个操作
    if ([_context save:&error]) {
        NSLog(@"删除数据成功");
    }else{
        NSLog(@"删除数据失败 error = %@",error);
    }
}

#pragma mark - 改
-(void)updateData {
    
    //创建请求
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    //请求的查询条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"gender = %d",1];
    req.predicate = pre;
    
    //执行请求得到一个结果集
    NSArray *updateDatas = [_context executeFetchRequest:req error:nil];
    
    
    for (StudentModel *model in updateDatas) {
        model.name = @"小红";
        NSLog(@"model = %@",model);
    }
    
    //保存(确认)此次操作
    NSError *err = nil;
    if ([_context save:&err]) {
        NSLog(@"更新成功");
    }else{
        NSLog(@"更新失败 error = %@",err);
    }
}


#pragma mark - 查
-(NSArray *)selectData {
    /*
     例：@"number >= 99"
     
     2.范围运算符：IN 、BETWEEN
     例：@"number BETWEEN {1,5}"
     @"address IN {'shanghai','nanjing'}"
     
     3.字符串本身:SELF
     例：@"SELF == 'APPLE'"
     
     4.字符串相关：BEGINSWITH、ENDSWITH、CONTAINS
     例：  @"name CONTAIN[cd] 'ang'"  //包含某个字符串
     @"name BEGINSWITH[c] 'sh'"    //以某个字符串开头
     @"name ENDSWITH[d] 'ang'"    //以某个字符串结束
     
     5.通配符：LIKE
     例：@"name LIKE[cd] '*er*'"   //'*'代表通配符,Like也接受[cd].
     @"name LIKE[cd] '???er*'"
     
     *注*: 星号 "*" : 代表0个或多个字符
     问号 "?" : 代表一个字符
     
     6.正则表达式：MATCHES
     例：NSString *regex = @"^A.+e$"; //以A开头，e结尾
     @"name MATCHES %@",regex
     
     注:[c]*不区分大小写 , [d]不区分发音符号即没有重音符号, [cd]既不区分大小写，也不区分发音符号。
     
     7. 合计操作
     ANY，SOME：指定下列表达式中的任意元素。比如，ANY children.age < 18。
     ALL：指定下列表达式中的所有元素。比如，ALL children.age < 18。
     NONE：指定下列表达式中没有的元素。比如，NONE children.age < 18。它在逻辑上等于NOT (ANY ...)。
     IN：等于SQL的IN操作，左边的表达必须出现在右边指定的集合中。比如，name IN { 'Ben', 'Melissa', 'Nick' }。
     
     提示:
     1. 谓词中的匹配指令关键字通常使用大写字母
     2. 谓词中可以使用格式字符串
     3. 如果通过对象的key
     path指定匹配条件，需要使用%K
     */
    
    //创建请求 fetch 英 [fetʃ] -- 拿去;请来;卖得(高价)
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    //请求的查询条件predicate 英 [ˈpredɪkət] -- 谓词
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"gender = %d",1];
    req.predicate = pre;

    
    //设置查询范围, 从第几页开始显示
    //通过这个属性实现分页
    //req.fetchOffset = 0;
    //每页显示多少条数据
    //req.fetchLimit = 6;
    
    NSError *err = nil;
    //发送请求, 得到一个结果集
    NSArray *arr = [_context executeFetchRequest:req error:nil];
    if (err) {
        NSLog(@"查询错误 err = %@",err);
    }
    
    
//    for (StudentModel *model in selectDatas) {
//        NSLog(@"查 %ld - %@ - %lf - %ld ",(long)model.id, model.name, model.age, (long)model.height);
//    }
    return arr;
}



#pragma mark - 排序
- (void)sort{
    //创建排序请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    //实例化排序对象
    NSSortDescriptor *ageSort = [NSSortDescriptor sortDescriptorWithKey:@"age"ascending:YES];
    NSSortDescriptor *numberSort = [NSSortDescriptor sortDescriptorWithKey:@"number"ascending:YES];
    request.sortDescriptors = @[ageSort,numberSort];
    //发送请求
    NSError *error = nil;
    NSArray *resArray = [_context executeFetchRequest:request error:&error];
    if (error == nil) {
        NSLog(@"resarr = %@",resArray);
        NSLog(@"按照age和number排序");
    }else{
        NSLog(@"排序失败, %@", error);
    }
}








        

@end
