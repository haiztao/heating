//
//  SqliteManager.m
//  heating
//
//  Created by haitao on 2017/3/22.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "SqliteManager.h"
#import <FMDB.h>

static FMDatabaseQueue *fmdbQueue = nil;

@interface SqliteManager ()

@property (copy,nonatomic)NSString *dbFilePath;
/** FMDatabase *DB*/
@property (nonatomic , strong) FMDatabase *dataBase;

@end

@implementation SqliteManager


static SqliteManager *sqliteManager = nil;
+(instancetype)shareSqliteManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sqliteManager = [[SqliteManager alloc] init];
    });
    return sqliteManager;
}

-(id)init{
    
    self = [super init];
    //在document路径下创建数据库路径//通过搜素方式找到沙盒下 Document文件夹路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    //创建数据库对象
    NSString *SQLPath = [docPath stringByAppendingPathComponent:@"FMDB.sqlite"];
    NSLog(@"SQLPath = %@",SQLPath);
    
    _dataBase =[FMDatabase databaseWithPath:SQLPath];
    
    self.dbFilePath = SQLPath;
    if ([_dataBase open]) {
        
        [self createSqliteTable];
        
        fmdbQueue = [[FMDatabaseQueue alloc]initWithPath:_dbFilePath];
    }
    
    return self;
}

#pragma mark - 创建表格
-(void)createSqliteTable {
    [self.dataBase open];

    [self.dataBase executeUpdate:@"CREATE TABLE IF  NOT EXISTS WIFI_Device_Table (rowid INTEGER PRIMARY KEY AUTOINCREMENT, msg text, time text, index text, value text)"];
    [self.dataBase close];
}


@end
