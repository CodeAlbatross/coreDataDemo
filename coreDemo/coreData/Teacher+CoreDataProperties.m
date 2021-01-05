//
//  Teacher+CoreDataProperties.m
//  coreDemo
//
//  Created by 刘知远 on 2021/1/5.
//
//

#import "Teacher+CoreDataProperties.h"

@implementation Teacher (CoreDataProperties)

+ (NSFetchRequest<Teacher *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
}

@dynamic age;
@dynamic name;
@dynamic number;
@dynamic students;

@end
