//
// CKIOSZhuyinKeyboardState.m
//

#import "CKIOSZhuyinKeyboardState.h"

@interface CKIOSZhuyinKey ()

@property(nonatomic, copy) NSString *label;
@property(nonatomic, copy) NSString *input;
@property(nonatomic, assign) CKIOSZhuyinKeyKind kind;

@end

@implementation CKIOSZhuyinKey

+ (instancetype)keyWithLabel:(NSString *)label
                       input:(NSString *)input
                        kind:(CKIOSZhuyinKeyKind)kind {
  CKIOSZhuyinKey *key = [[self alloc] initPrivate];
  key.label = label;
  key.input = input;
  key.kind = kind;
  return key;
}

- (instancetype)initPrivate {
  return [super init];
}

@end

@interface CKIOSZhuyinKeyboardState ()

@property(nonatomic, strong) CKIOSZhuyinKey *initialKey;
@property(nonatomic, strong) CKIOSZhuyinKey *medialKey;
@property(nonatomic, strong) CKIOSZhuyinKey *finalKey;

@end

@implementation CKIOSZhuyinKeyboardState

+ (instancetype)state {
  return [[self alloc] init];
}

+ (NSArray<CKIOSZhuyinKey *> *)initialKeys {
  return @[
    [CKIOSZhuyinKey keyWithLabel:@"ㄅ" input:@"1" kind:CKIOSZhuyinKeyKindInitial],
    [CKIOSZhuyinKey keyWithLabel:@"ㄆ" input:@"q" kind:CKIOSZhuyinKeyKindInitial],
    [CKIOSZhuyinKey keyWithLabel:@"ㄇ" input:@"a" kind:CKIOSZhuyinKeyKindInitial],
    [CKIOSZhuyinKey keyWithLabel:@"ㄈ" input:@"z" kind:CKIOSZhuyinKeyKindInitial],
    [CKIOSZhuyinKey keyWithLabel:@"ㄉ" input:@"2" kind:CKIOSZhuyinKeyKindInitial],
    [CKIOSZhuyinKey keyWithLabel:@"ㄊ" input:@"w" kind:CKIOSZhuyinKeyKindInitial],
    [CKIOSZhuyinKey keyWithLabel:@"ㄋ" input:@"s" kind:CKIOSZhuyinKeyKindInitial],
    [CKIOSZhuyinKey keyWithLabel:@"ㄌ" input:@"x" kind:CKIOSZhuyinKeyKindInitial],
    [CKIOSZhuyinKey keyWithLabel:@"ㄍ" input:@"e" kind:CKIOSZhuyinKeyKindInitial],
    [CKIOSZhuyinKey keyWithLabel:@"ㄎ" input:@"d" kind:CKIOSZhuyinKeyKindInitial],
    [CKIOSZhuyinKey keyWithLabel:@"ㄏ" input:@"c" kind:CKIOSZhuyinKeyKindInitial],
    [CKIOSZhuyinKey keyWithLabel:@"ㄐ" input:@"r" kind:CKIOSZhuyinKeyKindInitial],
    [CKIOSZhuyinKey keyWithLabel:@"ㄑ" input:@"f" kind:CKIOSZhuyinKeyKindInitial],
    [CKIOSZhuyinKey keyWithLabel:@"ㄒ" input:@"v" kind:CKIOSZhuyinKeyKindInitial],
    [CKIOSZhuyinKey keyWithLabel:@"ㄓ" input:@"5" kind:CKIOSZhuyinKeyKindInitial],
    [CKIOSZhuyinKey keyWithLabel:@"ㄔ" input:@"t" kind:CKIOSZhuyinKeyKindInitial],
    [CKIOSZhuyinKey keyWithLabel:@"ㄕ" input:@"g" kind:CKIOSZhuyinKeyKindInitial],
    [CKIOSZhuyinKey keyWithLabel:@"ㄖ" input:@"b" kind:CKIOSZhuyinKeyKindInitial],
    [CKIOSZhuyinKey keyWithLabel:@"ㄗ" input:@"y" kind:CKIOSZhuyinKeyKindInitial],
    [CKIOSZhuyinKey keyWithLabel:@"ㄘ" input:@"h" kind:CKIOSZhuyinKeyKindInitial],
    [CKIOSZhuyinKey keyWithLabel:@"ㄙ" input:@"n" kind:CKIOSZhuyinKeyKindInitial],
  ];
}

+ (NSArray<CKIOSZhuyinKey *> *)medialKeys {
  return @[
    [CKIOSZhuyinKey keyWithLabel:@"ㄧ" input:@"u" kind:CKIOSZhuyinKeyKindMedial],
    [CKIOSZhuyinKey keyWithLabel:@"ㄨ" input:@"j" kind:CKIOSZhuyinKeyKindMedial],
    [CKIOSZhuyinKey keyWithLabel:@"ㄩ" input:@"m" kind:CKIOSZhuyinKeyKindMedial],
  ];
}

+ (NSArray<CKIOSZhuyinKey *> *)finalKeys {
  return @[
    [CKIOSZhuyinKey keyWithLabel:@"ㄚ" input:@"8" kind:CKIOSZhuyinKeyKindFinal],
    [CKIOSZhuyinKey keyWithLabel:@"ㄛ" input:@"i" kind:CKIOSZhuyinKeyKindFinal],
    [CKIOSZhuyinKey keyWithLabel:@"ㄜ" input:@"k" kind:CKIOSZhuyinKeyKindFinal],
    [CKIOSZhuyinKey keyWithLabel:@"ㄝ" input:@"," kind:CKIOSZhuyinKeyKindFinal],
    [CKIOSZhuyinKey keyWithLabel:@"ㄞ" input:@"9" kind:CKIOSZhuyinKeyKindFinal],
    [CKIOSZhuyinKey keyWithLabel:@"ㄟ" input:@"o" kind:CKIOSZhuyinKeyKindFinal],
    [CKIOSZhuyinKey keyWithLabel:@"ㄠ" input:@"l" kind:CKIOSZhuyinKeyKindFinal],
    [CKIOSZhuyinKey keyWithLabel:@"ㄡ" input:@"." kind:CKIOSZhuyinKeyKindFinal],
    [CKIOSZhuyinKey keyWithLabel:@"ㄢ" input:@"0" kind:CKIOSZhuyinKeyKindFinal],
    [CKIOSZhuyinKey keyWithLabel:@"ㄣ" input:@"p" kind:CKIOSZhuyinKeyKindFinal],
    [CKIOSZhuyinKey keyWithLabel:@"ㄤ" input:@";" kind:CKIOSZhuyinKeyKindFinal],
    [CKIOSZhuyinKey keyWithLabel:@"ㄥ" input:@"/" kind:CKIOSZhuyinKeyKindFinal],
    [CKIOSZhuyinKey keyWithLabel:@"ㄦ" input:@"-" kind:CKIOSZhuyinKeyKindFinal],
  ];
}

+ (NSArray<CKIOSZhuyinKey *> *)toneKeys {
  return @[
    [CKIOSZhuyinKey keyWithLabel:@"ˉ" input:@" " kind:CKIOSZhuyinKeyKindFirstTone],
    [CKIOSZhuyinKey keyWithLabel:@"ˊ" input:@"6" kind:CKIOSZhuyinKeyKindTone],
    [CKIOSZhuyinKey keyWithLabel:@"ˇ" input:@"3" kind:CKIOSZhuyinKeyKindTone],
    [CKIOSZhuyinKey keyWithLabel:@"ˋ" input:@"4" kind:CKIOSZhuyinKeyKindTone],
    [CKIOSZhuyinKey keyWithLabel:@"˙" input:@"7" kind:CKIOSZhuyinKeyKindTone],
  ];
}

+ (NSArray<CKIOSZhuyinKey *> *)allKeys {
  NSMutableArray<CKIOSZhuyinKey *> *keys = [NSMutableArray array];
  [keys addObjectsFromArray:self.initialKeys];
  [keys addObjectsFromArray:self.medialKeys];
  [keys addObjectsFromArray:self.finalKeys];
  [keys addObjectsFromArray:self.toneKeys];
  return [keys copy];
}

- (NSString *)composedReading {
  NSMutableString *result = [NSMutableString string];
  if (self.initialKey) [result appendString:self.initialKey.label];
  if (self.medialKey) [result appendString:self.medialKey.label];
  if (self.finalKey) [result appendString:self.finalKey.label];
  return [result copy];
}

- (BOOL)hasPendingReading {
  return self.initialKey || self.medialKey || self.finalKey;
}

- (NSArray<CKIOSZhuyinKey *> *)availableKeys {
  NSMutableArray<CKIOSZhuyinKey *> *keys = [NSMutableArray array];

  if (!self.hasPendingReading) {
    [keys addObjectsFromArray:self.class.initialKeys];
    [keys addObjectsFromArray:self.class.medialKeys];
    [keys addObjectsFromArray:self.class.finalKeys];
    return [keys copy];
  }

  if (!self.medialKey && !self.finalKey) {
    [keys addObjectsFromArray:self.class.medialKeys];
  }

  if (!self.finalKey) {
    [keys addObjectsFromArray:self.class.finalKeys];
  }

  [keys addObjectsFromArray:self.class.toneKeys];
  return [keys copy];
}

- (void)reset {
  self.initialKey = nil;
  self.medialKey = nil;
  self.finalKey = nil;
}

- (BOOL)applyInput:(NSString *)input {
  for (CKIOSZhuyinKey *key in self.class.allKeys) {
    if ([key.input isEqualToString:input]) {
      return [self applyKey:key];
    }
  }
  return NO;
}

- (BOOL)applyKey:(CKIOSZhuyinKey *)key {
  switch (key.kind) {
    case CKIOSZhuyinKeyKindInitial:
      if (self.hasPendingReading) return NO;
      self.initialKey = key;
      return YES;

    case CKIOSZhuyinKeyKindMedial:
      if (self.medialKey || self.finalKey) return NO;
      self.medialKey = key;
      return YES;

    case CKIOSZhuyinKeyKindFinal:
      if (self.finalKey) return NO;
      self.finalKey = key;
      return YES;

    case CKIOSZhuyinKeyKindTone:
    case CKIOSZhuyinKeyKindFirstTone:
      if (!self.hasPendingReading) return NO;
      [self reset];
      return YES;
  }
}

- (BOOL)deleteLastPendingComponent {
  if (self.finalKey) {
    self.finalKey = nil;
    return YES;
  }
  if (self.medialKey) {
    self.medialKey = nil;
    return YES;
  }
  if (self.initialKey) {
    self.initialKey = nil;
    return YES;
  }
  return NO;
}

@end
