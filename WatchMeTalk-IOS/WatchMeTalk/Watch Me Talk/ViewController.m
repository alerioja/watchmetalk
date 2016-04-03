//
//  ViewController.m
//  Watch Me Talk
//
//  Created by Ritvik Upadhyaya on 24/05/14.
//  Copyright (c) 2014 Ritvik Upadhyaya. All rights reserved.
//

#import "ViewController.h"
#import <Firebase/Firebase.h>
#import "MyViewController.h"


@interface ViewController ()

@end

@implementation ViewController
@synthesize password;
@synthesize username;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_label1 setHidden:true];
    [_label2 setHidden:true];
    username.delegate =self;
    password.delegate =self;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -120.0f;  //set the -35.0f to your required value
        self.view.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == username) {
        [password becomeFirstResponder];
        [textField resignFirstResponder];
        
    }
    else if (textField == password) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (IBAction)login:(UIButton *)sender {
    
        NSString *user = [username text];
        NSString *pass = [password text];
        Firebase* myRootRef = [[Firebase alloc] initWithUrl:@"https://wmtlogin.firebaseio.com/"];
        Firebase* userRef = [myRootRef childByAppendingPath:user];
        [userRef  observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
           if(snapshot.value == [NSNull null]) {
               [_label2 setHidden:false];
               [self shakeAnimation:_label2];
               NSLog(@"User doesn't exist please try again");
               [username setText:@""];
               [password setText:@""];
           } else {
               NSLog(@"%@", snapshot.value);
               if([snapshot.valueInExportFormat isEqualToString:pass]){
                   NSLog(@"%@", snapshot.value);
                   [self performSegueWithIdentifier:@"login" sender:sender];
               }
               else
               {
                   [_label1 setHidden:false];
                   [password setText:@""];
                   NSLog(@"Password entered is incorrect %@", snapshot.value);
                   [self shakeAnimation:_label1];
               }
           }
       }];
    
}
- (void)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [_label1 setHidden:true];
    [_label2 setHidden:true];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
}
-(void)shakeAnimation:(UILabel*) label {
    const int reset = 5;
    const int maxShakes = 6;
    
    //pass these as variables instead of statics or class variables if shaking two controls simultaneously
    static int shakes = 0;
    static int translate = reset;
    
    [UIView animateWithDuration:0.09-(shakes*.01) // reduce duration every shake from .09 to .04
                          delay:0.01f//edge wait delay
                        options:(enum UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                     animations:^{label.transform = CGAffineTransformMakeTranslation(translate, 0);}
                     completion:^(BOOL finished){
                         if(shakes < maxShakes){
                             shakes++;
                             
                             //throttle down movement
                             if (translate>0)
                                 translate--;
                             
                             //change direction
                             translate*=-1;
                             [self shakeAnimation:label];
                         } else {
                             label.transform = CGAffineTransformIdentity;
                             shakes = 0;//ready for next time
                             translate = reset;//ready for next time
                             return;
                         }
                     }];
}

@end
