//
//  User.m
//  Predrink
//
//  Created by Viktor Georgiev on 4/1/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "User.h"

#import "FirebaseUtils.h"
#import <FirebaseAuth/FirebaseAuth.h>
#import <FirebaseDatabase/FirebaseDatabase.h>

@implementation User

static User *currentUser;

- (instancetype)initWithSnapshot:(FIRDataSnapshot *)snapshot {
    if (self = [super init]) {
        self.uid = (NSString *)[snapshot childSnapshotForPath:@"uid"].value;
        self.fid = (NSString *)[snapshot childSnapshotForPath:@"fid"].value;
        self.firstName = (NSString *)[snapshot childSnapshotForPath:@"firstName"].value;
        self.lastName = (NSString *)[snapshot childSnapshotForPath:@"lastName"].value;
        self.birthday = (NSString *)[snapshot childSnapshotForPath:@"birthday"].value;
        self.profilePictureUri = (NSString *)[snapshot childSnapshotForPath:@"profilePictureUri"].value;
        self.bio = (NSString *)[snapshot childSnapshotForPath:@"bio"].value;
        self.favDrink = (NSString *)[snapshot childSnapshotForPath:@"favDrink"].value;
        self.firstLogin = [NSNumber numberWithInt:((NSNumber *)[snapshot childSnapshotForPath:@"firstLogin"].value).intValue];
        self.age = [NSNumber numberWithInt:((NSNumber *)[snapshot childSnapshotForPath:@"age"].value).intValue];
        self.joinedCount = (NSNumber *)[snapshot childSnapshotForPath:@"joinedCount"].value;
        self.hostedCount = (NSNumber *)[snapshot childSnapshotForPath:@"hostedCount"].value;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)userDictionary {
    if (self = [super init]) {
        self.uid = (NSString *)[userDictionary objectForKey:@"uid"];
        self.fid = (NSString *)[userDictionary objectForKey:@"fid"];
        self.firstName = (NSString *)[userDictionary objectForKey:@"firstName"];
        self.lastName = (NSString *)[userDictionary objectForKey:@"lastName"];
        self.birthday = (NSString *)[userDictionary objectForKey:@"birthday"];
        self.profilePictureUri = (NSString *)[userDictionary objectForKey:@"profilePictureUri"];
        self.bio = (NSString *)[userDictionary objectForKey:@"bio"];
        self.favDrink = (NSString *)[userDictionary objectForKey:@"favDrink"];
        self.firstLogin = (NSNumber *)[userDictionary objectForKey:@"firstLogin"];
        self.age = (NSNumber *)[userDictionary objectForKey:@"age"];
        self.joinedCount = (NSNumber *)[userDictionary objectForKey:@"joinedCount"];
        self.hostedCount = (NSNumber *)[userDictionary objectForKey:@"hostedCount"];
    }
    
    return self;
}

+ (NSMutableDictionary *)getUserAsDictionary:(User *)user {
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [userDictionary setObject:user.uid forKey:@"uid"];
    [userDictionary setObject:user.fid forKey:@"fid"];
    [userDictionary setObject:user.firstName forKey:@"firstName"];
    [userDictionary setObject:user.lastName forKey:@"lastName"];
    [userDictionary setObject:user.birthday forKey:@"birthday"];
    [userDictionary setObject:user.profilePictureUri forKey:@"profilePictureUri"];
    [userDictionary setObject:user.bio forKey:@"bio"];
    [userDictionary setObject:user.favDrink forKey:@"favDrink"];
    [userDictionary setObject:@(user.firstLogin.intValue) forKey:@"firstLogin"];
    [userDictionary setObject:user.age forKey:@"age"];
    [userDictionary setObject:user.joinedCount forKey:@"joinedCount"];
    [userDictionary setObject:user.hostedCount forKey:@"hostedCount"];
    
    return userDictionary;
}

+ (void)setCurrentUser:(User *)user {
    currentUser = user;
}

+ (User *)currentUser {
    if(currentUser != nil) {
        return currentUser;
    } else {
//        [[[FirebaseUtils getUsersReference] child:[FIRAuth auth].currentUser.uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//            
//            User *user = [[User alloc] initWithSnapshot:snapshot];
//            [User setCurrentUser:user];
//            
//            return user;
//         
//        }];
    }
    
    return currentUser;
}

@end
