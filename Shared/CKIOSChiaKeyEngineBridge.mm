//
// CKIOSChiaKeyEngineBridge.mm
//

#import "CKIOSChiaKeyEngineBridge.h"

#include <ChiaKeyCore/ChiaKeyCoreC.h>

NSErrorDomain const CKIOSChiaKeyEngineBridgeErrorDomain =
    @"CKIOSChiaKeyEngineBridgeErrorDomain";

namespace {

NSString *CKIOSStringFromCString(const char *string) {
  if (!string) return @"";
  return [NSString stringWithUTF8String:string] ?: @"";
}

NSArray<NSString *> *CKIOSArrayFromCStringVector(char **strings,
                                                 size_t count) {
  NSMutableArray<NSString *> *result =
      [NSMutableArray arrayWithCapacity:count];
  for (size_t index = 0; index < count; ++index) {
    [result addObject:CKIOSStringFromCString(strings[index])];
  }
  return [result copy];
}

NSArray<NSValue *> *CKIOSRangesFromCKCRanges(CKC_TextRange *ranges,
                                             size_t count) {
  NSMutableArray<NSValue *> *result = [NSMutableArray arrayWithCapacity:count];
  for (size_t index = 0; index < count; ++index) {
    NSRange range =
        NSMakeRange(static_cast<NSUInteger>(ranges[index].location),
                    static_cast<NSUInteger>(ranges[index].length));
    [result addObject:[NSValue valueWithRange:range]];
  }
  return [result copy];
}

CKC_KeyModifiers CKIOSCopyModifiers(CKIOSKeyModifiers *modifiers) {
  CKC_KeyModifiers result = CKC_KeyModifiersNone();
  if (!modifiers) return result;

  result.alt = modifiers.alt ? 1 : 0;
  result.opt = modifiers.opt ? 1 : 0;
  result.ctrl = modifiers.ctrl ? 1 : 0;
  result.shift = modifiers.shift ? 1 : 0;
  result.command = modifiers.command ? 1 : 0;
  result.caps_lock = modifiers.capsLock ? 1 : 0;
  result.num_lock = modifiers.numLock ? 1 : 0;
  result.direct_text = modifiers.directText ? 1 : 0;
  return result;
}

CKIOSCandidateState *CKIOSCandidateStateFromCKC(
    const CKC_CandidateState &state) {
  CKIOSCandidateState *result = [[CKIOSCandidateState alloc] init];
  result.visible = state.visible != 0;
  result.candidates =
      CKIOSArrayFromCStringVector(state.candidates, state.candidate_count);
  result.currentPage = static_cast<NSUInteger>(state.current_page);
  result.pageCount = static_cast<NSUInteger>(state.page_count);
  result.candidatesPerPage = static_cast<NSUInteger>(state.candidates_per_page);
  result.highlightedIndex = static_cast<NSUInteger>(state.highlighted_index);
  result.highlightedCandidateIndex =
      static_cast<NSUInteger>(state.highlighted_candidate_index);
  return result;
}

CKIOSEngineSnapshot *CKIOSEngineSnapshotFromCKC(CKC_EngineSnapshot *snapshot) {
  CKIOSEngineSnapshot *result = [[CKIOSEngineSnapshot alloc] init];
  result.readingText = CKIOSStringFromCString(snapshot->reading_text);
  result.composingText = CKIOSStringFromCString(snapshot->composing_text);
  result.committedText = CKIOSStringFromCString(snapshot->committed_text);
  result.committedTextSegments = CKIOSArrayFromCStringVector(
      snapshot->committed_text_segments,
      snapshot->committed_text_segment_count);
  result.cursorPosition = static_cast<NSUInteger>(snapshot->cursor_position);
  result.highlight =
      NSMakeRange(static_cast<NSUInteger>(snapshot->highlight.location),
                  static_cast<NSUInteger>(snapshot->highlight.length));
  result.wordSegments = CKIOSRangesFromCKCRanges(snapshot->word_segments,
                                                 snapshot->word_segment_count);
  result.tooltip = CKIOSStringFromCString(snapshot->tooltip);
  result.candidateState =
      CKIOSCandidateStateFromCKC(snapshot->candidate_state);
  result.beeped = snapshot->beeped != 0;
  result.notifications =
      CKIOSArrayFromCStringVector(snapshot->notifications,
                                  snapshot->notification_count);
  return result;
}

}  // namespace

@implementation CKIOSKeyModifiers

+ (instancetype)none {
  return [[self alloc] init];
}

@end

@implementation CKIOSEnginePaths
@end

@implementation CKIOSEngineConfig

+ (instancetype)defaultConfig {
  CKC_EngineConfig cConfig = CKC_EngineConfigDefault();

  CKIOSEngineConfig *config = [[self alloc] init];
  config.locale = CKIOSStringFromCString(cConfig.locale);
  config.keyboardLayout = CKIOSStringFromCString(cConfig.keyboard_layout);
  config.candidateSelectionKeys =
      CKIOSStringFromCString(cConfig.candidate_selection_keys);
  config.candidateCursorAtEndOfTargetBlock =
      cConfig.candidate_cursor_at_end_of_target_block != 0;
  config.showCandidateListWithSpace =
      cConfig.show_candidate_list_with_space != 0;
  config.clearComposingTextWithEsc =
      cConfig.clear_composing_text_with_esc != 0;
  config.shiftKeyAlwaysCommitUppercaseCharacters =
      cConfig.shift_key_always_commit_uppercase_characters != 0;
  config.composingTextBufferSize =
      static_cast<NSUInteger>(cConfig.composing_text_buffer_size);
  return config;
}

@end

@implementation CKIOSCandidateState

- (instancetype)init {
  self = [super init];
  if (self) {
    _candidates = @[];
  }
  return self;
}

@end

@implementation CKIOSEngineSnapshot

- (instancetype)init {
  self = [super init];
  if (self) {
    _readingText = @"";
    _composingText = @"";
    _committedText = @"";
    _committedTextSegments = @[];
    _tooltip = @"";
    _wordSegments = @[];
    _candidateState = [[CKIOSCandidateState alloc] init];
    _notifications = @[];
  }
  return self;
}

@end

@implementation CKIOSChiaKeyEngineBridge {
  CKC_Engine *_engine;
}

- (instancetype)initWithPaths:(CKIOSEnginePaths *)paths
                       config:(CKIOSEngineConfig *)config
                        error:(NSError **)error {
  self = [super init];
  if (!self) return nil;

  CKC_EnginePaths cPaths = {};
  cPaths.loaded_path = paths.loadedPath.UTF8String;
  cPaths.resource_path = paths.resourcePath.UTF8String;
  cPaths.writable_path = paths.writablePath.UTF8String;
  cPaths.lexicon_database_path = paths.lexiconDatabasePath.UTF8String;

  CKC_EngineConfig cConfig = CKC_EngineConfigDefault();
  cConfig.locale = config.locale.UTF8String;
  cConfig.keyboard_layout = config.keyboardLayout.UTF8String;
  cConfig.candidate_selection_keys = config.candidateSelectionKeys.UTF8String;
  cConfig.candidate_cursor_at_end_of_target_block =
      config.candidateCursorAtEndOfTargetBlock ? 1 : 0;
  cConfig.show_candidate_list_with_space =
      config.showCandidateListWithSpace ? 1 : 0;
  cConfig.clear_composing_text_with_esc =
      config.clearComposingTextWithEsc ? 1 : 0;
  cConfig.shift_key_always_commit_uppercase_characters =
      config.shiftKeyAlwaysCommitUppercaseCharacters ? 1 : 0;
  cConfig.composing_text_buffer_size = config.composingTextBufferSize;

  char *errorMessage = nullptr;
  _engine = CKC_EngineCreate(&cPaths, &cConfig, &errorMessage);
  if (!_engine) {
    NSString *message = CKIOSStringFromCString(errorMessage);
    CKC_StringDestroy(errorMessage);
    if (error) {
      *error = [NSError errorWithDomain:CKIOSChiaKeyEngineBridgeErrorDomain
                                   code:1
                               userInfo:@{
                                 NSLocalizedDescriptionKey : message
                               }];
    }
    return nil;
  }

  return self;
}

- (void)dealloc {
  CKC_EngineDestroy(_engine);
}

- (BOOL)handleAsciiKey:(unichar)key modifiers:(CKIOSKeyModifiers *)modifiers {
  if (!_engine || key > 0x7f) return NO;
  return CKC_EngineHandleAsciiKey(_engine, static_cast<char>(key),
                                  CKIOSCopyModifiers(modifiers)) != 0;
}

- (BOOL)handleKeyCode:(NSInteger)keyCode
       receivedString:(NSString *)receivedString
            modifiers:(CKIOSKeyModifiers *)modifiers {
  if (!_engine) return NO;

  CKC_KeyEvent event = {};
  event.key_code = static_cast<int>(keyCode);
  event.received_string = receivedString.UTF8String;
  event.modifiers = CKIOSCopyModifiers(modifiers);
  return CKC_EngineHandleKey(_engine, &event) != 0;
}

- (BOOL)selectCandidateAtIndex:(NSUInteger)candidateIndex {
  if (!_engine) return NO;
  return CKC_EngineSelectCandidate(_engine, candidateIndex) != 0;
}

- (void)reset {
  if (!_engine) return;
  CKC_EngineReset(_engine);
}

- (CKIOSEngineSnapshot *)snapshot {
  if (!_engine) return [[CKIOSEngineSnapshot alloc] init];

  CKC_EngineSnapshot cSnapshot = CKC_EngineCopySnapshot(_engine);
  CKIOSEngineSnapshot *snapshot = CKIOSEngineSnapshotFromCKC(&cSnapshot);
  CKC_EngineSnapshotDestroy(&cSnapshot);
  return snapshot;
}

- (void)acknowledgeCommit {
  if (!_engine) return;
  CKC_EngineAcknowledgeCommit(_engine);
}

@end
