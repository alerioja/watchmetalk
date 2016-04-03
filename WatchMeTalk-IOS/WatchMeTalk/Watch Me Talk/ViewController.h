//
//  ViewController.h
//  Watch Me Talk
//
//  Created by Ritvik Upadhyaya on 24/05/14.
//  Copyright (c) 2014 Ritvik Upadhyaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
- (IBAction)login:(UIButton *)sender;

@end
