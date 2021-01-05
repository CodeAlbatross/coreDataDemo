//
//  Student+CoreDataProperties.m
//  coreDemo
//
//  Created by 刘知远 on 2021/1/5.
//
//

#import "Student+CoreDataProperties.h"

@implementation Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Student"];
}

@dynamic age;
@dynamic memo;
@dynamic name;
@dynamic number;
@dynamic score;
@dynamic whoTeach;

@end
