//
//  ViewController.swift
//  XcakeTest5000
//
//  Created by Rodhan Hickey on 09/10/2018.
//  Copyright © 2018 Rodhan Hickey. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var planes = [UUID: VirtualPlane]()
    var ghostNode:SCNNode!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ghost.scn")!
        
        ghostNode = scene.rootNode.childNodes[2]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
        
        let referenceObjects = ARReferenceObject.referenceObjects(inGroupNamed: "haunted", bundle: nil)
        configuration.detectionObjects = referenceObjects!

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            addGhostToScene(atPoint: touch.location(in: sceneView))
        }
    }
    
    func hideAllVirtualPlanes() {
        planes.values.forEach { $0.planeGeometry.materials.first!.transparency = 0 }
    }
    
    func addGhostToScene(atPoint point: CGPoint) {
        let hits = sceneView.hitTest(point, types: .existingPlaneUsingExtent)
        guard hits.count > 0, let hit = hits.first else {
            return
        }
        
        SCNTransaction.animationDuration = 1.0
        
        if !sceneView.scene.rootNode.childNodes.contains(ghostNode) {
            hideAllVirtualPlanes()
            
            ghostNode!.scale = SCNVector3(x: 0.002, y: 0.002, z: 0.002)
            sceneView.scene.rootNode.addChildNode(ghostNode!)
        }
        
        ghostNode!.position = SCNVector3Make(hit.worldTransform.columns.3.x, hit.worldTransform.columns.3.y, hit.worldTransform.columns.3.z)
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let arPlaneAnchor = anchor as? ARPlaneAnchor {
            let plane = VirtualPlane(anchor: arPlaneAnchor)
            planes[arPlaneAnchor.identifier] = plane
            node.addChildNode(plane)
        } else if let _ = anchor as? ARObjectAnchor {
            print("Found haunted object!")
            
            hideAllVirtualPlanes()
            
            let newGhostNode = ghostNode!.clone()
            
            node.addChildNode(newGhostNode)
            
            newGhostNode.scale = SCNVector3(x: 0.0001, y: 0.0001, z: 0.0001)
            
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 3.0
            
            newGhostNode.scale = SCNVector3(x: 0.0008, y: 0.0008, z: 0.0008)
            
            SCNTransaction.commit()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let arPlaneAnchor = anchor as? ARPlaneAnchor, let plane = planes[arPlaneAnchor.identifier] {
            plane.updateWithNewAnchor(arPlaneAnchor)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if let arPlaneAnchor = anchor as? ARPlaneAnchor, let index = planes.index(forKey: arPlaneAnchor.identifier) {
            planes.remove(at: index)
        }
    }

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
