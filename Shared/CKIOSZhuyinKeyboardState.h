//
// CKIOSZhuyinKeyboardState.h
//
// UI-agnostic state model for an old-style dynamic Zhuyin keyboard shell.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CKIOSZhuyinKeyKind) {
  CKIOSZhuyinKeyKindInitial,
  CKIOSZhuyinKeyKindMedial,
  CKIOSZhuyinKeyKindFinal,
  CKIOSZhuyinKeyKindTone,
  CKIOSZhuyinKeyKindFirstTone,
};

@interface CKIOSZhuyinKey : NSObject

@property(nonatomic, copy, readonly) NSString *label;
@property(nonatomic, copy, readonly) NSString *input;
@property(nonatomic, assign, readonly) CKIOSZhuyinKeyKind kind;

+ (instancetype)keyWithLabel:(NSString *)label
                       input:(NSString *)input
                        kind:(CKIOSZhuyinKeyKind)kind;

- (instancetype)init NS_UNAVAILABLE;

@end

@interface CKIOSZhuyinKeyboardState : NSObject

@property(nonatomic, copy, readonly) NSString *composedReading;
@property(nonatomic, copy, readonly) NSArray<CKIOSZhuyinKey *> *availableKeys;
@property(nonatomic, assign, readonly) BOOL hasPendingReading;

+ (NSArray<CKIOSZhuyinKey *> *)allKeys;
+ (instancetype)state;

- (void)reset;
- (BOOL)applyKey:(CKIOSZhuyinKey *)key;
- (BOOL)applyInput:(NSString *)input;
- (BOOL)deleteLastPendingComponent;

@end

NS_ASSUME_NONNULL_END
