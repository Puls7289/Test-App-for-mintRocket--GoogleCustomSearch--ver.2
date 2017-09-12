//
//  TableViewController.m
//  TestApps
//
//  Created by я on 08.09.17.
//  Copyright © 2017 VolkovIS. All rights reserved.
//

#import "VITableViewController.h"
#import "VITableViewCellIn.h"
#import "VITableDataDelegate.h"
#import "VISeeViewController.h"

@interface VITableViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation VITableViewController
{
    NSMutableArray* tableData;
    NSMutableArray* descriptionData;
    NSMutableArray* imageData;
    NSInteger* currentIndexRow;
    BOOL clickOrNo;
}

- (void)initializeFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Items"];
    
    NSSortDescriptor *lastNameSort = [NSSortDescriptor sortDescriptorWithKey:@"itemName" ascending:YES];
    
    [request setSortDescriptors:@[lastNameSort]];
    
    VITableDataDelegate *tdd = [[VITableDataDelegate alloc] init];

    NSManagedObjectContext *moc =tdd.persistentContainer.viewContext;
    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil]];
    [[self fetchedResultsController] setDelegate:self];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initializeFetchedResultsController];
    
    clickOrNo = false;
    VITableDataDelegate* tbDelegate = [[VITableDataDelegate alloc] init];
    
    NSMutableArray* totalItemNames = [[NSMutableArray alloc] initWithArray:[tbDelegate getItemElementsArray:@"itemName"]];
    NSMutableArray* totalItemDescriptions = [[NSMutableArray alloc] initWithArray:[tbDelegate getItemElementsArray:@"itemDescription"]];
    NSMutableArray* totalItemImages = [[NSMutableArray alloc] initWithArray:[tbDelegate getItemElementsArray:@"itemImage"]];
    
    tableData = [[NSMutableArray alloc] init];
    descriptionData = [[NSMutableArray alloc] init];
    imageData = [[NSMutableArray alloc] init];
    
    for (NSString* str in totalItemNames) {
        [tableData addObject:str];
    }
    
    for (NSString* str in totalItemDescriptions) {
        [descriptionData addObject:str];
    }
    
    for (UIImage* image in totalItemImages) {
        [imageData addObject:image];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
            break;
    }
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [[self tableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView] beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView] endUpdates];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return 1;
    return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [tableData count];
    id< NSFetchedResultsSectionInfo> sectionInfo = [[self fetchedResultsController] sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"tableItem";

    VITableViewCellIn* cell = (VITableViewCellIn*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[VITableViewCellIn alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.itemImage.image = [imageData objectAtIndex:indexPath.row];
    cell.itemName.text = [tableData objectAtIndex:indexPath.row];
    cell.itemDescription.text = [descriptionData objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"SegueDetail"])
    {
        VISeeViewController *destViewController = segue.destinationViewController;
        destViewController.itemName = [tableData objectAtIndex:(long)currentIndexRow];
        destViewController.itemDescription = [descriptionData objectAtIndex:(long)currentIndexRow];
        destViewController.title = [tableData objectAtIndex:(long)currentIndexRow];
        destViewController.itemImage = [imageData objectAtIndex:(long)currentIndexRow];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    currentIndexRow = (NSInteger*)indexPath.row;
    [self performSegueWithIdentifier:@"SegueDetail" sender:self];
}

#pragma mark - Table view Editing

- (IBAction)didTapeEditButtonAction:(id)sender {
    if (clickOrNo == false)
    {
        [self.tableView setEditing:YES animated:YES];
        clickOrNo = true;
    } else {
        [self.tableView setEditing:NO animated:YES];
        clickOrNo = false;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
     if (editingStyle == UITableViewCellEditingStyleDelete)
     {
         //deleting from core data
         NSManagedObject* item = [self.fetchedResultsController objectAtIndexPath:indexPath];

         [self.fetchedResultsController.managedObjectContext deleteObject:item];
         [self.fetchedResultsController.managedObjectContext save:nil];
         
         NSError *error = nil;
         if (![self.fetchedResultsController.managedObjectContext save:&error])
         {
             NSLog(@"%@", [error localizedDescription]);
         }
     }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
