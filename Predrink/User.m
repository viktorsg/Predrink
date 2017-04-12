//
//  User.m
//  Predrink
//
//  Created by Viktor Georgiev on 4/1/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "User.h"

#import <FirebaseDatabase/FirebaseDatabase.h>

@implementation User

static User * currentUser;

- (instancetype)initWithSnapshot:(FIRDataSnapshot *)snapshot {
    if (self = [super init]) {
        self.uid = (NSString *)[snapshot childSnapshotForPath:@"uid"].value;
        self.fid = (NSString *)[snapshot childSnapshotForPath:@"fid"].value;
        self.firstName = (NSString *)[snapshot childSnapshotForPath:@"firstName"].value;
        self.lastName = (NSString *)[snapshot childSnapshotForPath:@"lastName"].value;
        self.birthday = (NSString *)[snapshot childSnapshotForPath:@"birthday"].value;
        self.profilePictureUri = (NSString *)[snapshot childSnapshotForPath:@"profilePictureUri"].value;
        self.phoneNumber = (NSString *)[snapshot childSnapshotForPath:@"phoneNumber"].value;
        self.bio = (NSString *)[snapshot childSnapshotForPath:@"bio"].value;
        self.favDrink = (NSString *)[snapshot childSnapshotForPath:@"favDrink"].value;
        self.firstLogin = (NSNumber *)[snapshot childSnapshotForPath:@"firstLogin"].value;
        self.age = (NSNumber *)[snapshot childSnapshotForPath:@"age"].value;
        self.joinedCount = (NSNumber *)[snapshot childSnapshotForPath:@"joinedCount"].value;
        self.hostedCount = (NSNumber *)[snapshot childSnapshotForPath:@"hostedCount"].value;
    }
    
    return self;
}

+ (void)setCurrentUser:(User *)user {
    currentUser = user;
}

+ (User *)currentUser {
    return currentUser;
}

@end
