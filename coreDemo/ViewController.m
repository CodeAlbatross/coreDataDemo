//
//  ViewController.m
//  coreDemo
//
//  Created by 刘知远 on 2021/1/4.
//

#import "ViewController.h"
#import "Student+CoreDataProperties.h"
#import "TableViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *TxtName;
@property (weak, nonatomic) IBOutlet UITextField *TxtNumber;
@property (weak, nonatomic) IBOutlet UITextField *TxtAge;
@property (weak, nonatomic) IBOutlet UITextField *TxtScore;
@property (weak, nonatomic) IBOutlet UITextView *TxtMemo;
@property (weak, nonatomic) IBOutlet UITextField *TxtTeacher;
@end

@implementation ViewController

+ (BOOL)CheckInput:(NSString *)string {
    if (string == nil || string.length == 0) {
        return NO;
    }

   NSCharacterSet *cs;

    cs = [[NSCharacterSet characterSetWithCharactersInString:@"123456789."] invertedSet];

    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];

    BOOL basicTest = [string isEqualToString:filtered];

    return basicTest;

}

- (IBAction)DataSave:(UIButton *)sender {
    
    Student *student;
    
    
    if (self.indexPath == nil) {
        student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.context];
        [self.students addObject:student];
    }else{
        student = self.students[self.indexPath.row];
    }
    
    student.name = self.TxtName.text;
    student.age = [self.TxtAge.text floatValue];
    student.number = self.TxtNumber.text;
    student.score = [self.TxtScore.text floatValue];
    student.memo = self.TxtMemo.text;
    student.whoTeach = self.teacher;
   
    if (![ViewController CheckInput:self.TxtScore.text] || ![ViewController CheckInput:self.TxtAge.text]) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入不合法" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVc animated:NO completion:nil];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        }]];
        [self.context deleteObject:student];
        [self.students removeLastObject];
    }
    NSError *err;
    if (![self.context save:&err]) {
        NSLog(@"保存时出错：%@",err);
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)DataClear:(UIButton *)sender {
    self.TxtMemo.text = nil;
    self.TxtAge.text = nil;
    self.TxtName.text =nil;
    self.TxtNumber.text = nil;
    self.TxtScore.text = nil;
    self.TxtTeacher.text = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    if (self.indexPath != nil) {
        Student *student = self.students[self.indexPath.row];
        self.TxtName.text = student.name;
        self.TxtNumber.text = student.number;
        self.TxtAge.text = [NSString stringWithFormat:@"%ld",(long)student.age];
        self.TxtScore.text = [NSString stringWithFormat:@"%f",student.score];
        self.TxtMemo.text = student.memo;
        self.TxtTeacher.text = student.whoTeach.name;
    }
}

/**
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890n"]invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    BOOL canChange = [string isEqualToString:filtered];
    return canChange;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



@end
