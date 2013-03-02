//
//  JASCNView.m
//  SceneKitDemo
//
//  Created by Jake Gundersen on 3/2/13.
//  Copyright (c) 2013 The Team. All rights reserved.
//

#import "JASCNView.h"
#import "ORSBluetoothAccelerometerBoard.h"

@implementation JASCNView

-(void)awakeFromNib {
    self.backgroundColor = [NSColor blackColor];
    
    SCNScene *scene = [SCNScene scene];
    self.scene = scene;
    
    SCNCamera *camera = [SCNCamera camera];
    camera.xFov = 10;
    camera.yFov = 45;
    
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = camera;
    
    cameraNode.position = SCNVector3Make(0, 0, 30);
    [scene.rootNode addChildNode:cameraNode];

    SCNTorus *torus = [SCNTorus torusWithRingRadius:10 pipeRadius:3];
    SCNNode *torusNode = [SCNNode nodeWithGeometry:torus];
    CATransform3D torusTransform = CATransform3DMakeRotation(1.2, 0.0, 1.0, 0.0);
    torusNode.transform = torusTransform;
    
//    SCNBox *box = [SCNBox boxWithWidth:10 height:10 length:10 chamferRadius:0];
//    SCNNode *boxNode = [SCNNode nodeWithGeometry:box];
//    CATransform3D boxTransform = CATransform3DMakeRotation(1.2, 0.0, 1.0, 0.0);
//    boxNode.transform = boxTransform;

    SCNMaterial *material = [SCNMaterial material];
    material.diffuse.contents  = [NSColor blueColor];
    material.specular.contents = [NSColor whiteColor];
    material.shininess = 1.0;
    torus.materials = @[material];
    
    
    
    [scene.rootNode addChildNode:torusNode];
//    [scene.rootNode addChildNode:boxNode];
    
    SCNLight *ambientLight = [SCNLight light];
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLight.type = SCNLightTypeAmbient;
    ambientLight.color = [NSColor colorWithCalibratedRed:0.643 green:0.616 blue:0.683 alpha:1.000];
    ambientLightNode.light = ambientLight;
    [scene.rootNode addChildNode:ambientLightNode];
    
    SCNLight *diffuseLight = [SCNLight light];
    SCNNode *diffuseLightNode = [SCNNode node];
    diffuseLight.type = SCNLightTypeOmni;
    diffuseLightNode.light = diffuseLight;
    diffuseLightNode.position = SCNVector3Make(-30, 30, 50);
    [scene.rootNode addChildNode:diffuseLightNode];
    
    
}

@end
