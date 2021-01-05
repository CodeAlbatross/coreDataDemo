//
//  Student+CoreDataProperties.h
//  coreDemo
//
//  Created by 刘知远 on 2021/1/5.
//
//

#import "Student+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest;

@property (nonatomic) int16_t age;
@property (nullable, nonatomic, copy) NSString *memo;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *number;
@property (nonatomic) float score;
@property (nullable, nonatomic, retain) Teacher *whoTeach;

@end

NS_ASSUME_NONNULL_END
