//
// CKIOSChiaKeyEngineBridge.h
//
// Foundation-friendly wrapper around ChiaKeyCore's C ABI for Swift hosts.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CKIOSKeyModifiers : NSObject

@property(nonatomic, assign) BOOL alt;
@property(nonatomic, assign) BOOL opt;
@property(nonatomic, assign) BOOL ctrl;
@property(nonatomic, assign) BOOL shift;
@property(nonatomic, assign) BOOL command;
@property(nonatomic, assign) BOOL capsLock;
@property(nonatomic, assign) BOOL numLock;
@property(nonatomic, assign) BOOL directText;

+ (instancetype)none;

@end

@interface CKIOSEnginePaths : NSObject

@property(nonatomic, copy) NSString *loadedPath;
@property(nonatomic, copy) NSString *resourcePath;
@property(nonatomic, copy) NSString *writablePath;
@property(nonatomic, copy) NSString *lexiconDatabasePath;

@end

@interface CKIOSEngineConfig : NSObject

@property(nonatomic, copy) NSString *locale;
@property(nonatomic, copy) NSString *keyboardLayout;
@property(nonatomic, copy) NSString *candidateSelectionKeys;
@property(nonatomic, assign) BOOL candidateCursorAtEndOfTargetBlock;
@property(nonatomic, assign) BOOL showCandidateListWithSpace;
@property(nonatomic, assign) BOOL clearComposingTextWithEsc;
@property(nonatomic, assign) BOOL shiftKeyAlwaysCommitUppercaseCharacters;
@property(nonatomic, assign) NSUInteger composingTextBufferSize;

+ (instancetype)defaultConfig;

@end

@interface CKIOSCandidateState : NSObject

@property(nonatomic, assign, getter=isVisible) BOOL visible;
@property(nonatomic, copy) NSArray<NSString *> *candidates;
@property(nonatomic, assign) NSUInteger currentPage;
@property(nonatomic, assign) NSUInteger pageCount;
@property(nonatomic, assign) NSUInteger candidatesPerPage;
@property(nonatomic, assign) NSUInteger highlightedIndex;
@property(nonatomic, assign) NSUInteger highlightedCandidateIndex;

@end

@interface CKIOSEngineSnapshot : NSObject

@property(nonatomic, copy) NSString *readingText;
@property(nonatomic, copy) NSString *composingText;
@property(nonatomic, copy) NSString *committedText;
@property(nonatomic, copy) NSArray<NSString *> *committedTextSegments;
@property(nonatomic, assign) NSUInteger cursorPosition;
@property(nonatomic, assign) NSRange highlight;
@property(nonatomic, copy) NSArray<NSValue *> *wordSegments;
@property(nonatomic, copy) NSString *tooltip;
@property(nonatomic, strong) CKIOSCandidateState *candidateState;
@property(nonatomic, assign) BOOL beeped;
@property(nonatomic, copy) NSArray<NSString *> *notifications;

@end

@interface CKIOSChiaKeyEngineBridge : NSObject

- (nullable instancetype)initWithPaths:(CKIOSEnginePaths *)paths
                                config:(CKIOSEngineConfig *)config
                                 error:(NSError **)error NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (BOOL)handleAsciiKey:(unichar)key modifiers:(CKIOSKeyModifiers *)modifiers;
- (BOOL)handleKeyCode:(NSInteger)keyCode
       receivedString:(nullable NSString *)receivedString
            modifiers:(CKIOSKeyModifiers *)modifiers;
- (BOOL)selectCandidateAtIndex:(NSUInteger)candidateIndex;
- (void)reset;
- (CKIOSEngineSnapshot *)snapshot;
- (void)acknowledgeCommit;

@end

FOUNDATION_EXPORT NSErrorDomain const CKIOSChiaKeyEngineBridgeErrorDomain;

NS_ASSUME_NONNULL_END
