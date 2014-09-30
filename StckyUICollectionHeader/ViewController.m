
#import "ViewController.h"
#import "CollectionViewCell.h"
#import "StickyCollectionReusableView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    StickCollectionView.delegate=self;
    StickCollectionView.dataSource=self;
    
    
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:170/255.0 green:10/255.0 blue:0/255.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    //    Adding header for Collection View
    
    [StickCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([StickyCollectionReusableView class]) bundle:nil]
         forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                withReuseIdentifier:NSStringFromClass([StickyCollectionReusableView class])];

    
//Adding navigation bar as translucent
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                                  forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;

    
    
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView1 viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * view = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        
        StickyCollectionReusableView *headerView = [StickCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"StickyheaderView" forIndexPath:indexPath];
        
        UILabel *labelhead=[[UILabel alloc]initWithFrame:CGRectMake(60, 10, 400, 200)];
        labelhead.text=@"STICKY HEADER";
        labelhead.textColor=[UIColor whiteColor];
        labelhead.font=[UIFont fontWithName:@"Arial Rounded MT Bold" size:30];

        [headerView addSubview:labelhead];
        
        view = headerView;
    }
    else
    {
        
        StickyCollectionReusableView *headerView = [StickCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"StickyheaderView" forIndexPath:indexPath];
        view = headerView;
        
        return view;
    }
    
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    // only the height component is used
    return CGSizeMake(50, 200);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    // only the height component is used
    return CGSizeMake(50, 0);
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 14;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView1 cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CollectionCell";
    
    /* Do UI work here */
    CollectionViewCell *cell = [StickCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(StickCollectionView.frame.size.width/2-7.5, 180);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
