/**
 *  minosound3dScene.m
 *  minosound3d
 *
 *  Created by 水島 雄太 on 2013/05/15.
 *  Copyright 水島 雄太 2013年. All rights reserved.
 */

#import "minosound3dScene.h"
#import "CC3PODResourceNode.h"
#import "CC3ActionInterval.h"
#import "CC3MeshNode.h"
#import "CC3Camera.h"
#import "CC3Light.h"
#import "CC3ParametricMeshNodes.h"
#import "Tile.h"

#define COLUMN 3
#define ROW 3
#define DEPTH 3

#define CELL_WIDTH 50
#define CELL_HEIGHT 50
#define CELL_DEPTH 50


@implementation minosound3dScene

-(void) dealloc {
	[super dealloc];
}

/**
 * Constructs the 3D scene.
 *
 * Adds 3D objects to the scene, loading a 3D 'hello, world' message
 * from a POD file, and creating the camera and light programatically.
 *
 * When adapting this template to your application, remove all of the content
 * of this method, and add your own to construct your 3D model scene.
 *
 * NOTES:
 *
 * 1) To help you find your scene content once it is loaded, the onOpen method below contains
 *    code to automatically move the camera so that it frames the scene. You can remove that
 *    code once you know where you want to place your camera.
 *
 * 2) The POD file used for the 'hello, world' message model is fairly large, because converting a
 *    font to a mesh results in a LOT of triangles. When adapting this template project for your own
 *    application, REMOVE the POD file 'hello-world.pod' from the Resources folder of your project.
 */
-(void) initializeScene {

	// Create the camera, place it back a bit, and add it to the scene
	CC3Camera* cam = [CC3Camera nodeWithName: @"Camera"];
	cam.location = cc3v( 0.0, 0.0, 6.0 );
	[self addChild: cam];

	// Create a light, place it back and to the left at a specific
	// position (not just directional lighting), and add it to the scene
	CC3Light* lamp = [CC3Light nodeWithName: @"Lamp"];
	lamp.location = cc3v( -2.0, 0.0, 0.0 );
	lamp.isDirectionalOnly = NO;
	[cam addChild: lamp];

	// This is the simplest way to load a POD resource file and add the
	// nodes to the CC3Scene, if no customized resource subclass is needed.
//	[self addContentFromPODFile: @"hello-world.pod"];

    CC3MeshNode* aNode;

    for(int i=0;i<5;i++){
        for(int j=0;j<5;j++){
            for(int l=0;l<5;l++){
                aNode = [CC3BoxNode nodeWithName: @"Simple box"];
                CC3BoundingBox bBox;
                bBox.minimum = cc3v(  0.0+i*1.2, 0.0+j*1.2, 0.0+l*1.2);
                bBox.maximum = cc3v( 1.0+i*1.2, 1.0+j*1.2, 1.0+l*1.2);
                [aNode populateAsSolidBox: bBox];
                [aNode setLocation:cc3v(-2,1,0)];
                aNode.material = [CC3Material material];

                CCActionInterval* partialRot = [CC3RotateBy actionWithDuration: 1.0
                                                                      rotateBy: cc3v(0.0, 30.0, 0.0)];
                [aNode runAction: [CCRepeatForever actionWithAction: partialRot]];


                [self addChild: aNode];
            }
        }
    }
	// Create OpenGL buffers for the vertex arrays to keep things fast and efficient, and to
	// save memory, release the vertex content in main memory because it is now redundant.
	[self createGLBuffers];
	[self releaseRedundantContent];
	
	// Select an appropriate shader program for each mesh node in this scene now. If this step
	// is omitted, a shader program will be selected for each mesh node the first time that mesh
	// node is drawn. Doing it now adds some additional time up front, but avoids potential pauses
	// as each shader program is loaded as needed the first time it is needed during drawing.
	[self selectShaderPrograms];
		
	// ------------------------------------------
	
	// That's it! The scene is now constructed and is good to go.
	
	// To help you find your scene content once it is loaded, the onOpen method below contains
	// code to automatically move the camera so that it frames the scene. You can remove that
	// code once you know where you want to place your camera.
	
	// If you encounter problems displaying your models, you can uncomment one or more of the
	// following lines to help you troubleshoot. You can also use these features on a single node,
	// or a structure of nodes. See the CC3Node notes for more explanation of these properties.
	// Also, the onOpen method below contains additional troubleshooting code you can comment
	// out to move the camera so that it will display the entire scene automatically.
	
	// Displays short descriptive text for each node (including class, node name & tag).
	// The text is displayed centered on the pivot point (origin) of the node.
//	self.shouldDrawAllDescriptors = YES;
	
	// Displays bounding boxes around those nodes with local content (eg- meshes).
//	self.shouldDrawAllLocalContentWireframeBoxes = YES;
	
	// Displays bounding boxes around all nodes. The bounding box for each node
	// will encompass its child nodes.
//	self.shouldDrawAllWireframeBoxes = YES;
	
	// If you encounter issues creating and adding nodes, or loading models from
	// files, the following line is used to log the full structure of the scene.
	LogInfo(@"The structure of this scene is: %@", [self structureDescription]);
	
	// ------------------------------------------

	// And to add some dynamism, we'll animate the 'hello, world' message
	// using a couple of actions...
	
	// Fetch the 'hello, world' object that was loaded from the POD file and start it rotating
	CC3MeshNode* helloTxt = (CC3MeshNode*)[self getNodeNamed: @"Hello"];
	CCActionInterval* partialRot = [CC3RotateBy actionWithDuration: 1.0
														  rotateBy: cc3v(0.0, 30.0, 0.0)];
	[self runAction: [CCRepeatForever actionWithAction: partialRot]];
//	[aNode runAction: [CCRepeatForever actionWithAction: partialRot]];

	// To make things a bit more appealing, set up a repeating up/down cycle to
	// change the color of the text from the original red to blue, and back again.
	GLfloat tintTime = 8.0f;
	ccColor3B startColor = helloTxt.color;
	ccColor3B endColor = { 50, 0, 200 };
	CCActionInterval* tintDown = [CCTintTo actionWithDuration: tintTime
														  red: endColor.r
														green: endColor.g
														 blue: endColor.b];
	CCActionInterval* tintUp = [CCTintTo actionWithDuration: tintTime
														red: startColor.r
													  green: startColor.g
													   blue: startColor.b];
//	 CCActionInterval* tintCycle = [CCSequence actionOne: tintDown two: tintUp];
//	[helloTxt runAction: [CCRepeatForever actionWithAction: tintCycle]];

    [self genTiles];

    [self initTiles];


}


#pragma mark Updating custom activity

/**
 * This template method is invoked periodically whenever the 3D nodes are to be updated.
 *
 * This method provides your app with an opportunity to perform update activities before
 * any changes are applied to the transformMatrix of the 3D nodes in the scene.
 *
 * For more info, read the notes of this method on CC3Node.
 */
-(void) updateBeforeTransform: (CC3NodeUpdatingVisitor*) visitor {}

/**
 * This template method is invoked periodically whenever the 3D nodes are to be updated.
 *
 * This method provides your app with an opportunity to perform update activities after
 * the transformMatrix of the 3D nodes in the scen have been recalculated.
 *
 * For more info, read the notes of this method on CC3Node.
 */
-(void) updateAfterTransform: (CC3NodeUpdatingVisitor*) visitor {
	// If you have uncommented the moveWithDuration: invocation in the onOpen: method, you
	// can uncomment the following to track how the camera moves, where it ends up, and what
	// the camera's clipping distances are, in order to determine how to position and configure
	// the camera to view the entire scene.
//	LogDebug(@"Camera: %@", activeCamera.fullDescription);
}


#pragma mark Scene opening and closing

/**
 * Callback template method that is invoked automatically when the CC3Layer that
 * holds this scene is first displayed.
 *
 * This method is a good place to invoke one of CC3Camera moveToShowAllOf:... family
 * of methods, used to cause the camera to automatically focus on and frame a particular
 * node, or the entire scene.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) onOpen {

	// Move the camera to frame the scene. You can uncomment the LogDebug line in the
	// updateAfterTransform: method to track how the camera moves, where it ends up, and
	// what the camera's clipping distances are, in order to determine how to position
	// and configure the camera to view your entire scene. Then you can remove this code.
	[self.activeCamera moveWithDuration: 3.0 toShowAllOf: self withPadding: 0.5f];

	// Uncomment this line to draw the bounding box of the scene.
//	self.shouldDrawWireframeBox = YES;
}

/**
 * Callback template method that is invoked automatically when the CC3Layer that
 * holds this scene has been removed from display.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) onClose {}


#pragma mark Handling touch events 

/**
 * This method is invoked from the CC3Layer whenever a touch event occurs, if that layer
 * has indicated that it is interested in receiving touch events, and is handling them.
 *
 * Override this method to handle touch events, or remove this method to make use of
 * the superclass behaviour of selecting 3D nodes on each touch-down event.
 *
 * This method is not invoked when gestures are used for user interaction. Your custom
 * CC3Layer processes gestures and invokes higher-level application-defined behaviour
 * on this customized CC3Scene subclass.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) touchEvent: (uint) touchType at: (CGPoint) touchPoint {}

/**
 * This callback template method is invoked automatically when a node has been picked
 * by the invocation of the pickNodeFromTapAt: or pickNodeFromTouchEvent:at: methods,
 * as a result of a touch event or tap gesture.
 *
 * Override this method to perform activities on 3D nodes that have been picked by the user.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) nodeSelected: (CC3Node*) aNode byTouchEvent: (uint) touchType at: (CGPoint) touchPoint {}




















-(void) genTiles{
    self.tileArray = [NSMutableArray array];
    for(int z=0;z<DEPTH;z++){
        for(int y=0;y<COLUMN;y++){
            for(int x=0;x<ROW;x++){
                [self initTileSize:CELL_WIDTH :CELL_HEIGHT :CELL_DEPTH X:x Y:y Z:z];
            }
        }
    }
}

-(void) initTiles{
    for(int z=0;z<DEPTH;z++){
        for(int y=0;y<COLUMN;y++){
            for(int x=0;x<ROW;x++){
                Tile* tile = [self getTileByX:x Y:y Z:z];
                tile.beforeTile = nil;
                tile.isSearched = NO;
                tile.isShortcut = NO;
                tile.isMarked = NO;
                tile.freq = 0;
            }
        }
    }

    Tile* tile = self.tileArray[0];
    tile.beforeTile = nil;
    tile.isSearched = YES;
    tile.isShortcut = YES;
    tile.isMarked = YES;
    tile.freq = 0;
    [self scan:tile];
}


-(Tile*)getTileByX:(NSInteger)x Y:(NSInteger)y Z:(NSInteger)z{
    if(x<0 || y <0 || z <0){
        return nil;
    }
    if(x>= ROW || y >= COLUMN || z >= DEPTH){
        return nil;
    }
    return self.tileArray[z*ROW*COLUMN + y*ROW + x];
}

-(BOOL) checkX:(NSInteger)x Y:(NSInteger)y Z:(NSInteger)z{
    if(x<0 || y<0 || z<0){
        return NO;
    }
    if(x>=ROW || y >= COLUMN || z >= DEPTH){
        return NO;
    }
    Tile* tile = [self getTileByX:x Y:y Z:z];
    if(tile.isSearched){
        return NO;
    }
    return YES;
}

-(NSMutableArray*)surroundTiles:(Tile *)tile{
    NSMutableArray* mArray = [NSMutableArray array];
    if([self checkX:tile.x Y:tile.y-1 Z:tile.z]){
        [mArray addObject:[self getTileByX:tile.x Y:tile.y-1 Z:tile.z]];
    }
    if([self checkX:tile.x+1 Y:tile.y Z:tile.z]){
        [mArray addObject:[self getTileByX:tile.x+1 Y:tile.y Z:tile.z]];
    }
    if([self checkX:tile.x Y:tile.y+1 Z:tile.z]){
        [mArray addObject:[self getTileByX:tile.x Y:tile.y+1 Z:tile.z]];
    }
    if([self checkX:tile.x-1 Y:tile.y Z:tile.z]){
        [mArray addObject:[self getTileByX:tile.x-1 Y:tile.y Z:tile.z]];
    }
    if([self checkX:tile.x Y:tile.y Z:tile.z+1]){
        [mArray addObject:[self getTileByX:tile.x Y:tile.y Z:tile.z+1]];
    }
    if([self checkX:tile.x Y:tile.y Z:tile.z-1]){
        [mArray addObject:[self getTileByX:tile.x Y:tile.y Z:tile.z-1]];
    }
    return mArray;
}

-(NSInteger)randomGet:(NSMutableArray*)array{
    if(array ==nil || [array count] == 0){
        return -1;
    }
    return arc4random() % [array count];
}

-(Tile*)choiceTile:(Tile *)tile{
    NSMutableArray* tiles = [self surroundTiles:tile];
    if([tiles count] > 0){
        int index = [self randomGet:tiles];
        Tile* choice = tiles[index];
        choice.beforeTile = tile;
        choice.isSearched = YES;
        return choice;
    }
    return [self choiceTile:tile.beforeTile];
}

-(void) scan:(Tile*)tile{
    NSInteger count = 0;
    for(int i=0;i<[self.tileArray count];i++){
        Tile* tile = self.tileArray[i];
        if(tile.isSearched){
            NSLog(@"tile x:%d y:%d z:%d beforex:%d beforey:%d beforez:%d",tile.x,tile.y,tile.z,tile.beforeTile.x,tile.beforeTile.y,tile.beforeTile.z);
            count++;
        }
    }
    if(count >= ROW*COLUMN*DEPTH){
        return;
    }else{
        return [self scan:[self choiceTile:tile]];
    }
}

-(void) initTileSize:(NSInteger)width :(NSInteger)height :(NSInteger)depth X:(NSInteger)x Y:(NSInteger)y Z:(NSInteger)z{
    Tile *tile = [[Tile alloc] init];
    tile.x = x;
    tile.y = y;
    tile.z = z;
    [self.tileArray addObject:tile];
}



@end

