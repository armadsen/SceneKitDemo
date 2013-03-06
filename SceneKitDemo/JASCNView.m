//
//  JASCNView.m
//  SceneKitDemo
//
//  Created by Jake Gundersen on 3/2/13.
//  Copyright (c) 2013 The Team. All rights reserved.
//

#import "JASCNView.h"
#import "ORSBluetoothAccelerometerBoard.h"

@interface JASCNView ()

@property (nonatomic, strong) SCNNode *torusNode;
@property (nonatomic, strong) SCNNode *beeNode;

@end

@implementation JASCNView

-(void)awakeFromNib
{
    self.backgroundColor = [NSColor whiteColor];
    
    SCNScene *scene = [SCNScene scene];
    self.scene = scene;
    
    SCNCamera *camera = [SCNCamera camera];
    camera.xFov = 10;
    camera.yFov = 45;
    
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = camera;
    
    cameraNode.position = SCNVector3Make(0, 0, 30);
    [scene.rootNode addChildNode:cameraNode];

    SCNLight *ambientLight = [SCNLight light];
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLight.type = SCNLightTypeAmbient;
    ambientLight.color = [NSColor colorWithCalibratedRed:0.643 green:0.616 blue:0.683 alpha:1.000];
    ambientLightNode.light = ambientLight;
    [self.scene.rootNode addChildNode:ambientLightNode];
    
//    SCNLight *omniLight = [SCNLight light];
//    SCNNode *omniLightNode = [SCNNode node];
//    omniLight.type = SCNLightTypeOmni;
//    omniLightNode.light = omniLight;
//    omniLightNode.position = SCNVector3Make(-30, 30, 50);
//    [self.scene.rootNode addChildNode:omniLightNode];
    
    
//    SCENEKIT_EXTERN NSString * const SCNLightTypeAmbient;
//    SCENEKIT_EXTERN NSString * const SCNLightTypeOmni;
//    SCENEKIT_EXTERN NSString * const SCNLightTypeDirectional;
//    SCENEKIT_EXTERN NSString * const SCNLightTypeSpot;
    
//    self.allowsCameraControl = YES;
    
    [self loadTorus];
//    [self addTextToNode:self.torusNode];
    
//    [self loadBeeFromSceneFile];
    
//    [self loadMaleScene];

}

-(void)addTextToNode:(SCNNode *)node
{
    SCNText *text = [SCNText textWithString:@"CocoaHeads!" extrusionDepth:4.f];
    SCNNode *textNode = [SCNNode nodeWithGeometry:text];
    textNode.position = SCNVector3Make(-1, 5, 0);
    textNode.transform = CATransform3DScale(textNode.transform, .1f, .1f, .1f);
    //textNode.transform = CATransform3DTranslate(textNode.transform, -10, 50, 0);
    [node addChildNode:textNode];
}

-(void)loadBeeFromSceneFile
{
    SCNScene *newScene = [self loadSceneFromFile:@"Bee2.dae"];
    SCNNode *bee = [newScene.rootNode childNodeWithName:@"Bee" recursively:YES];
    
    SCNMaterial *material = [SCNMaterial material];
    material.diffuse.contents  = [NSColor grayColor];
    material.specular.contents = [NSColor whiteColor];
    material.shininess = 1.0;
    
    bee.geometry.materials = @[material];
    [self.scene.rootNode addChildNode:bee];
    
    self.playing = YES;
	self.beeNode = bee;
}

-(void)loadMaleScene
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"male_large" withExtension:@"dae"];

    NSError * __autoreleasing error;
    SCNScene *scene = [SCNScene sceneWithURL:url options:nil error:&error];
    if (scene) {
        self.scene = scene;
	} else {
        NSLog(@"Yikes! You're going to do real error handling, right?");
	}
    
    self.playing = YES;
}

-(void)loadTorus
{
    
    SCNTorus *torus = [SCNTorus torusWithRingRadius:10 pipeRadius:3];
    SCNNode *torusNode = [SCNNode nodeWithGeometry:torus];
    CATransform3D torusTransform = CATransform3DMakeRotation(1.2, 0.0, 1.0, 0.0);
    torusNode.transform = torusTransform;
        
//    SCNMaterial *material = [SCNMaterial material];
//    material.diffuse.contents  = [NSColor blueColor];
//    material.diffuse.contents = [NSImage imageNamed:@"slccocoaheadswhite.png"];
//    material.normal.contents = [NSImage imageNamed:@"normalBrick.png"];
    
//    material.specular.contents = [NSColor whiteColor];
//    material.shininess = 1.0;
//    torus.materials = @[material];
    
    
    [self.scene.rootNode addChildNode:torusNode];
    
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    animation.values = [NSArray arrayWithObjects:
//                        [NSValue valueWithCATransform3D:CATransform3DRotate(torusNode.transform, 0 * M_PI / 2, 1.f, 0.5f, 0.f)],
//                        [NSValue valueWithCATransform3D:CATransform3DRotate(torusNode.transform, 1 * M_PI / 2, 1.f, 0.5f, 0.f)],
//                        [NSValue valueWithCATransform3D:CATransform3DRotate(torusNode.transform, 2 * M_PI / 2, 1.f, 0.5f, 0.f)],
//                        [NSValue valueWithCATransform3D:CATransform3DRotate(torusNode.transform, 3 * M_PI / 2, 1.f, 0.5f, 0.f)],
//                        [NSValue valueWithCATransform3D:CATransform3DRotate(torusNode.transform, 4 * M_PI / 2, 1.f, 0.5f, 0.f)],
//                        nil];
//    animation.duration = 9.f;
//    animation.repeatCount = HUGE_VALF;
//    
//    [torusNode addAnimation:animation forKey:@"transform"];
	
	self.torusNode = torusNode;
}

-(SCNScene *)loadSceneFromFile:(NSString *)filename
{
    NSString *name = [[filename lastPathComponent] stringByDeletingPathExtension];
    NSString *extension = [filename pathExtension];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:extension];

    NSError * __autoreleasing error;
    SCNScene *scene = [SCNScene sceneWithURL:url options:nil error:&error];
    if (scene) {
        self.scene = scene;
	} else {
        NSLog(@"Yikes! You're going to do real error handling, right?");
	}
    return scene;
}

//- (void)mouseDown:(NSEvent *)event
//{
//    NSPoint mouseLocation = [self convertPoint:[event locationInWindow] fromView:nil];
//    NSArray *hits = [self hitTest:mouseLocation options:nil];
//    
//    if ([hits count] > 0)
//    {
//        SCNHitTestResult *hit = hits[0];
//        SCNMaterial *material = [hit.node.geometry.materials objectAtIndex:0];
//        
//        CABasicAnimation *highlightAnimation = [CABasicAnimation animationWithKeyPath:@"contents"];
//        highlightAnimation.toValue = [NSColor redColor];
//        highlightAnimation.fromValue = [NSColor blackColor];
//        highlightAnimation.repeatCount = 1;
//        highlightAnimation.autoreverses = YES;
//        highlightAnimation.duration = 0.35;
//        highlightAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        
//        [material.emission addAnimation:highlightAnimation forKey:@"highlight"];
//    }
//    
//    [super mouseDown:event];
//}

#pragma mark - Properties

- (void)setOrientation:(ORSBluetoothAccelerometerOrientation *)orientation
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, orientation);
	float x = orientation.x / 9.8f;
	float y = orientation.y / 9.8f;
	float z = orientation.z / 9.8f;
	if (x == 0.0f || y == 0.0f || z == 0.0f) return;
	
	float roll = -atan2f(y, z);
	float pitch = atan2f(x, sqrtf(y*y + z*z));
	
	CATransform3D transform = CATransform3DMakeRotation(roll, 0.0, 0.0, 1.0);
	transform = CATransform3DRotate(transform, pitch, 1.0, 0.0, 0.0);
	self.torusNode.transform = transform;
}

@end
