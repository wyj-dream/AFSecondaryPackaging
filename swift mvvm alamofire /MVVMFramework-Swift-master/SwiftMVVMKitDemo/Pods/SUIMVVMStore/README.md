# SUIMVVMStore
SUIMVVMKit -- SUIMVVMStore

====
##usage
```
pod 'SUIMVVMStore'
```
====

##introduction

```objc
@interface MVVMStore : NSObject

+ (instancetype)sharedStore;

/**
 *  根据dbName初始化数据库
 */
- (BOOL)db_initDBWithName:(NSString *)dbName;

/**
 *  根据dbPath初始化数据库
 */
- (BOOL)db_initDBWithPath:(NSString *)dbPath;

/**
 *  根据tableName创建数据表
 */
- (void)db_createTableWithName:(NSString *)tableName;

/**
 *  初始化dbName并根据tableName创建表
 */
- (void)db_initWithDBName:(NSString *)dbName tableName:(NSString *)tableName;

/**
 *  初始化dbPath并根据tableName创建表
 */
- (void)db_initWithDBPath:(NSString *)dbPath tableName:(NSString *)tableName;

/**
 *  清空数据表
 */
- (void)db_clearTable:(NSString *)tableName;

/**
 *  删除表
 */
- (BOOL)db_deleteTable:(NSString *)tableName;

/**
 *  删除数据库
 */
- (void)db_deleteDatabseWithDBName:(NSString *)DBName;

/**
 *  关闭数据库
 */
- (void)db_close;

/**
 *  获得数据库存储路径
 */
- (NSString *)db_getDBPath;

/**
 *  tableName是否存在
 */
- (BOOL)db_isExistTableWithName:(NSString *)tableName;

///************************ Put&Get methods *****************************************

- (void)db_putObject:(id)object withId:(NSString *)objectId intoTable:(NSString *)tableName;

- (id)db_getObjectById:(NSString *)objectId fromTable:(NSString *)tableName;

- (MVVMStoreItem *)db_getStoreItemById:(NSString *)objectId fromTable:(NSString *)tableName;

- (void)db_putString:(NSString *)string withId:(NSString *)stringId intoTable:(NSString *)tableName;

- (NSString *)db_getStringById:(NSString *)stringId fromTable:(NSString *)tableName;

- (void)db_putNumber:(NSNumber *)number withId:(NSString *)numberId intoTable:(NSString *)tableName;

- (NSNumber *)db_getNumberById:(NSString *)numberId fromTable:(NSString *)tableName;

- (NSArray *)db_getAllItemsFromTable:(NSString *)tableName;

- (NSArray *)db_getItemsFromTable:(NSString *)tableName withRange:(NSRange)range;

- (void)db_deleteObjectById:(NSString *)objectId fromTable:(NSString *)tableName;

- (void)db_deleteObjectsByIdArray:(NSArray *)objectIdArray fromTable:(NSString *)tableName;

- (void)db_deleteObjectsByIdPrefix:(NSString *)objectIdPrefix fromTable:(NSString *)tableName;

@end

```

