//
//  RepoResultsViewController.m
//  GithubDemo
//
//  Created by Nicholas Aiwazian on 9/15/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "RepoResultsViewController.h"
#import "MBProgressHUD.h"
#import "GithubRepo.h"
#import "GithubRepoSearchSettings.h"
#import "RepoTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface RepoResultsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *repoTableView;
@property (nonatomic, strong) GithubRepoSearchSettings *searchSettings;
@property (strong, nonatomic) NSArray *repos;
@end

@implementation RepoResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchSettings = [[GithubRepoSearchSettings alloc] init];
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];
    self.navigationItem.titleView = self.searchBar;
    [self setUpTableView];
    [self doSearch];
}

- (void)setUpTableView {
    self.repoTableView.rowHeight = UITableViewAutomaticDimension;
    self.repoTableView.estimatedRowHeight = 100;
    [self.repoTableView registerNib:[UINib nibWithNibName:@"RepoTableViewCell" bundle:nil] forCellReuseIdentifier:@"repoTableViewCell"];
    self.repoTableView.delegate = self;
    self.repoTableView.dataSource = self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RepoTableViewCell *cell = [self.repoTableView dequeueReusableCellWithIdentifier:@"repoTableViewCell"];
    GithubRepo *repo = self.repos[indexPath.row];
    cell.nameLabel.text = repo.name;
    cell.ownerLabel.text = repo.ownerHandle;
    cell.starsLabel.text = [NSString stringWithFormat:@"%ld", (long)repo.stars];
    cell.forksLabel.text = [NSString stringWithFormat:@"%ld", (long)repo.forks];
    cell.descriptionLabel.text = repo.repoDescription;
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:repo.ownerAvatarURL]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.repos.count;
}

- (void)doSearch {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [GithubRepo fetchRepos:self.searchSettings successCallback:^(NSArray *repos) {
        self.repos = repos;
        for (GithubRepo *repo in repos) {
            NSLog(@"%@", repo);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.repoTableView reloadData];
    }];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.searchSettings.searchString = searchBar.text;
    [searchBar resignFirstResponder];
    [self doSearch];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
