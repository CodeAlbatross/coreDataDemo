//
//  ViewController.h
//  coreDemo
//
//  Created by 刘知远 on 2021/1/4.
//

#import <UIKit/UIKit.h>
#import "Teacher+CoreDataProperties.h"

@interface ViewController : UIViewController
+ (BOOL)CheckInput:(NSString *)string;
@property(strong,nonatomic)NSManagedObjectContext *context;//所有的增删查改的基础
@property(strong,nonatomic)NSMutableArray *students;
@property(strong,nonatomic)Teacher *teacher;
@property(strong,nonatomic)NSIndexPath *indexPath;

@end

