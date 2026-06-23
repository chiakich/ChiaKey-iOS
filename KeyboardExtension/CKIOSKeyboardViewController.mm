//
// CKIOSKeyboardViewController.mm
//

#import "CKIOSKeyboardViewController.h"

#import "CKIOSChiaKeyEngineBridge.h"
#import "CKIOSChiaKeyPaths.h"
#import "CKIOSZhuyinKeyboardState.h"

@interface CKIOSKeyboardViewController ()

@property(nonatomic, strong) CKIOSChiaKeyEngineBridge *engineBridge;
@property(nonatomic, strong) CKIOSZhuyinKeyboardState *keyboardState;
@property(nonatomic, strong) UILabel *compositionLabel;
@property(nonatomic, strong) UIStackView *candidateStack;
@property(nonatomic, strong) UIStackView *keyGrid;

@end

@implementation CKIOSKeyboardViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.keyboardState = [CKIOSZhuyinKeyboardState state];
  self.engineBridge = [self makeEngineBridge];
  [self buildKeyboardView];
  [self reloadKeyboardKeys];
  [self applySnapshot:[self.engineBridge snapshot]];
}

- (CKIOSChiaKeyEngineBridge *)makeEngineBridge {
  NSError *pathError = nil;
  CKIOSEnginePaths *paths =
      [CKIOSChiaKeyPaths enginePathsForBundle:NSBundle.mainBundle
                           appGroupIdentifier:nil
                                        error:&pathError];
  if (!paths) {
    NSLog(@"ChiaKey iOS paths unavailable: %@", pathError.localizedDescription);
    return nil;
  }

  NSError *error = nil;
  CKIOSChiaKeyEngineBridge *bridge =
      [[CKIOSChiaKeyEngineBridge alloc]
          initWithPaths:paths
                config:[CKIOSEngineConfig defaultConfig]
                 error:&error];
  if (!bridge) {
    NSLog(@"ChiaKey iOS engine unavailable: %@", error.localizedDescription);
  }
  return bridge;
}

- (void)buildKeyboardView {
  self.view.backgroundColor = UIColor.systemBackgroundColor;

  UIStackView *root = [[UIStackView alloc] init];
  root.axis = UILayoutConstraintAxisVertical;
  root.spacing = 6.0;
  root.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:root];

  self.compositionLabel = [[UILabel alloc] init];
  self.compositionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  self.compositionLabel.textAlignment = NSTextAlignmentCenter;
  self.compositionLabel.numberOfLines = 1;
  [root addArrangedSubview:self.compositionLabel];

  self.candidateStack = [[UIStackView alloc] init];
  self.candidateStack.axis = UILayoutConstraintAxisHorizontal;
  self.candidateStack.spacing = 4.0;
  self.candidateStack.distribution = UIStackViewDistributionFillEqually;
  [root addArrangedSubview:self.candidateStack];

  self.keyGrid = [[UIStackView alloc] init];
  self.keyGrid.axis = UILayoutConstraintAxisVertical;
  self.keyGrid.spacing = 4.0;
  [root addArrangedSubview:self.keyGrid];

  UIButton *nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [nextKeyboardButton setTitle:@"Next" forState:UIControlStateNormal];
  [nextKeyboardButton addTarget:self
                         action:@selector(handleNextKeyboard:)
               forControlEvents:UIControlEventTouchUpInside];
  [root addArrangedSubview:nextKeyboardButton];

  [NSLayoutConstraint activateConstraints:@[
    [root.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor
                                       constant:8.0],
    [root.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor
                                        constant:-8.0],
    [root.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:8.0],
    [root.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor
                                      constant:-8.0],
  ]];
}

- (void)reloadKeyboardKeys {
  for (UIView *row in self.keyGrid.arrangedSubviews.copy) {
    [self.keyGrid removeArrangedSubview:row];
    [row removeFromSuperview];
  }

  NSArray<CKIOSZhuyinKey *> *keys = self.keyboardState.availableKeys;
  const NSUInteger columns = 7;

  for (NSUInteger offset = 0; offset < keys.count; offset += columns) {
    UIStackView *row = [[UIStackView alloc] init];
    row.axis = UILayoutConstraintAxisHorizontal;
    row.spacing = 4.0;
    row.distribution = UIStackViewDistributionFillEqually;
    [self.keyGrid addArrangedSubview:row];

    NSRange range = NSMakeRange(offset, MIN(columns, keys.count - offset));
    NSArray<CKIOSZhuyinKey *> *rowKeys =
        [keys subarrayWithRange:range];
    for (CKIOSZhuyinKey *key in rowKeys) {
      UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
      [button setTitle:key.label forState:UIControlStateNormal];
      button.accessibilityIdentifier = key.input;
      [button addTarget:self
                 action:@selector(handleZhuyinKey:)
       forControlEvents:UIControlEventTouchUpInside];
      [row addArrangedSubview:button];
    }
  }
}

- (void)reloadCandidates:(CKIOSCandidateState *)candidateState {
  for (UIView *view in self.candidateStack.arrangedSubviews.copy) {
    [self.candidateStack removeArrangedSubview:view];
    [view removeFromSuperview];
  }

  if (!candidateState.visible || !candidateState.candidates.count) return;

  NSUInteger start = candidateState.currentPage *
                     MAX(candidateState.candidatesPerPage, 1);
  NSUInteger end =
      MIN(candidateState.candidates.count,
          start + MAX(candidateState.candidatesPerPage, 1));

  for (NSUInteger index = start; index < end; ++index) {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:candidateState.candidates[index]
            forState:UIControlStateNormal];
    button.tag = static_cast<NSInteger>(index);
    [button addTarget:self
               action:@selector(handleCandidate:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.candidateStack addArrangedSubview:button];
  }
}

- (void)handleZhuyinKey:(UIButton *)sender {
  NSString *input = sender.accessibilityIdentifier;
  if (!input.length) return;

  [self.keyboardState applyInput:input];
  if (self.engineBridge && input.length == 1) {
    [self.engineBridge handleAsciiKey:[input characterAtIndex:0]
                            modifiers:[CKIOSKeyModifiers none]];
  }

  [self reloadKeyboardKeys];
  [self applySnapshot:[self.engineBridge snapshot]];
}

- (void)handleCandidate:(UIButton *)sender {
  if (!self.engineBridge) return;
  [self.engineBridge selectCandidateAtIndex:static_cast<NSUInteger>(sender.tag)];
  [self applySnapshot:[self.engineBridge snapshot]];
}

- (void)handleNextKeyboard:(id)sender {
  [self advanceToNextInputMode];
}

- (void)applySnapshot:(CKIOSEngineSnapshot *)snapshot {
  NSMutableString *displayText = [NSMutableString string];
  if (snapshot.composingText.length) {
    [displayText appendString:snapshot.composingText];
  }
  if (snapshot.readingText.length) {
    [displayText appendFormat:@" %@", snapshot.readingText];
  }
  if (!displayText.length) {
    [displayText appendString:self.keyboardState.composedReading];
  }
  self.compositionLabel.text = displayText;

  [self reloadCandidates:snapshot.candidateState];

  for (NSString *segment in snapshot.committedTextSegments) {
    [self.textDocumentProxy insertText:segment];
  }
  if (snapshot.committedTextSegments.count) {
    [self.engineBridge acknowledgeCommit];
  }
}

@end
