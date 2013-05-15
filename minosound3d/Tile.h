//
//  Tile.h
//  minosound3d
//
//  Created by 水島 雄太 on 13/05/15.
//  Copyright (c) 2013年 水島 雄太. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tile :NSObject
{
    Tile* beforeTile;
    BOOL isSearched;
    BOOL isShortcut;
    BOOL isMarked;
    NSInteger x;
    NSInteger y;
    NSInteger z;
    double freq;
}
@property (nonatomic, retain)Tile* beforeTile;
@property (nonatomic)BOOL isSearched;
@property (nonatomic)BOOL isShortcut;
@property (nonatomic)BOOL isMarked;
@property (nonatomic)NSInteger x;
@property (nonatomic)NSInteger y;
@property (nonatomic)NSInteger z;
@property (nonatomic)double freq;

@end

