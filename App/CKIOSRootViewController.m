//
// CKIOSRootViewController.m
//

#import "CKIOSRootViewController.h"

@implementation CKIOSRootViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = UIColor.systemBackgroundColor;

  UIStackView *stack = [[UIStackView alloc] init];
  stack.axis = UILayoutConstraintAxisVertical;
  stack.alignment = UIStackViewAlignmentCenter;
  stack.spacing = 12.0;
  stack.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:stack];

  UILabel *titleLabel = [[UILabel alloc] init];
  titleLabel.text = @"ChiaKey";
  titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
  titleLabel.textAlignment = NSTextAlignmentCenter;
  [stack addArrangedSubview:titleLabel];

  UILabel *bodyLabel = [[UILabel alloc] init];
  bodyLabel.text =
      @"Enable the ChiaKey keyboard in Settings to try the experimental iOS host.";
  bodyLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  bodyLabel.textAlignment = NSTextAlignmentCenter;
  bodyLabel.numberOfLines = 0;
  [stack addArrangedSubview:bodyLabel];

  [NSLayoutConstraint activateConstraints:@[
    [stack.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor
                                                     constant:24.0],
    [stack.trailingAnchor constraintLessThanOrEqualToAnchor:self.view.trailingAnchor
                                                   constant:-24.0],
    [stack.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
    [stack.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
  ]];
}

@end
