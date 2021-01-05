//
//  TableViewController.m
//  coreDemo
//
//  Created by 刘知远 on 2021/1/5.
//

#import "TableViewController.h"
#import "Student+CoreDataProperties.h"
#import "AppDelegate.h"
#import "Teacher+CoreDataProperties.h"
#import "ViewController.h"

@interface TableViewController ()
@property(strong,nonatomic)NSManagedObjectContext *context;//所有的增删查改的基础
@property(strong,nonatomic)NSMutableArray *students;
@property(strong,nonatomic)Teacher *teacher;
@property(strong,nonatomic)Student *student;

@end

@implementation TableViewController

//重写get方法
-(NSManagedObjectContext *)context{
    if (!_context) {
        AppDelegate *coreDataManager = [[AppDelegate alloc] init];
        _context = [coreDataManager managedObjectContext];
    }
    return _context;
}

//取出持久层数据
-(NSArray *)queryData:(NSString *) entityname sortWith: (NSString *) sortDesc ascending:(BOOL) asc predicatString:(NSString *)ps{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];//向持久层发出请求
    request.fetchLimit = 100;//取出数据限制
    request.fetchBatchSize = 20;//缓存大小
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:sortDesc ascending:asc]];//排序规则
    //过滤条件ps
    if (ps)
        request.predicate = [NSPredicate predicateWithFormat:@"name contains %@",ps];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityname inManagedObjectContext:self.context];//获得一个实体
    request.entity = entity;//请求对象实体绑定
    NSError *error;
    NSArray *arrs = [self.context executeFetchRequest:request error:&error];//取出符合条件的对象
    if (error) {
        NSLog(@"can not get data, %@",error);
    }
    return arrs;
}

-(void)loadData{
    NSArray *arrstudents = [self queryData:@"Student" sortWith:@"number" ascending:YES predicatString:nil];
    _students = [NSMutableArray array];
    for (Student *stu in arrstudents) {
        [_students addObject:stu];
    }
}

-(NSMutableArray *)students{
    if (!_students) {
        [self loadData];
    }
    return _students;
}

-(Teacher *)teacher{
    if (!_teacher) {
        NSArray *arrteacher = [self queryData:@"Teacher" sortWith:@"name" ascending:YES predicatString:@"Bai Tian"];
        if (arrteacher.count > 0) {
            _teacher = arrteacher[0];
        }else{
            NSError *error;
            Teacher *th = [NSEntityDescription insertNewObjectForEntityForName:@"Teacher" inManagedObjectContext:self.context];
            th.name = @"Bai Tian";
            th.age = [NSNumber numberWithInt:99];
            th.number = @"ST00002";
            [self.context save:&error];
            _teacher = th;
            
        }
    }
    return _teacher;
}

//解决添加了信息后tableview无法刷新的问题
//这个函数会调用cellForRowAtIndexPath这个方法，从而重新加载了UITableViewCell的数据。
-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"addinfo"]) {
        if ([segue.destinationViewController isKindOfClass:[ViewController class]]) {
            ViewController *vc = (ViewController *)segue.destinationViewController;
            vc.students = self.students;
            vc.teacher = self.teacher;
            vc.indexPath = nil;
            vc.context = self.context;
        }
    }
    if ([segue.identifier isEqualToString:@"showdetail"]) {
        if ([segue.destinationViewController isKindOfClass:[ViewController class]]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            ViewController *vc = (ViewController *)segue.destinationViewController;
            vc.students = self.students;
            vc.indexPath = indexPath;
            vc.teacher = self.teacher;
            vc.context = self.context;
        }
    }
    
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
-(IBAction)refreshData:(UIRefreshControl *)sender{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self.students removeAllObjects];
        [self loadData];
        dispatch_async(dispatch_get_main_queue(), ^{[self.tableView reloadData];});
    });
    [self.refreshControl endRefreshing];
}


// 告诉我们有多少个表单元，小结

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.students count];
}

//把表单元显示出来
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"studentCell" forIndexPath:indexPath];
    self.student = self.students[indexPath.row];
    cell.textLabel.text = self.student.name;
    cell.detailTextLabel.text = self.student.number;
    return cell;
}

//滑动删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //如果处于删除状态，则删除表单以及数据库的内容
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.context deleteObject:self.students[indexPath.row]];
        [self.students removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSError *error;
        [self.context save:&error];
    }
}

//修改
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"modifyview"];
    vc.students = self.students;
    vc.indexPath = indexPath;
    vc.context = self.context;
    vc.teacher = self.teacher;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - searchBar coding
-(void)searchInName:(NSString *)searchString{
    [self.students removeAllObjects];
    NSArray *arraystudents = [self queryData:@"Student" sortWith:@"number" ascending:YES predicatString:searchString];
    for (Student *stu in arraystudents) {
        [self.students addObject:stu];
    }
    [self.tableView reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        return;
    }
    [self searchInName:searchText];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchInName:searchBar.text];
    [searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self searchInName:nil];
    [searchBar resignFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}


@end
