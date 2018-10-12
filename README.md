This is a basic Xcode project to demonstrate some of ARKit 2 capabilities at the [Xcake Apple Developer meetup](https://www.meetup.com/Xcake-Mobile-app-development-with-an-Appley-flavour/events/255179042/).

This was based on a talk I did at the Digital Hub Developer Lunch and Learn meetup last year called [Elf Yourself... On a Shelf!](https://github.com/rodhan/ElfYourselfOnAShelf).

# Steps

## Live Coding Part I - Displaying a Model
1. Create simple Augmented Reality iOS app using Xcode template
2. Find free 3D model from [TurboSquid](https://www.turbosquid.com) or similar service, I used this nice [ghost](https://www.turbosquid.com/3d-models/3ds-max-ghost/224143) 
3. Convert the model to a suitable format for Xcode, e.g. [COLLADA](https://en.wikipedia.org/wiki/COLLADA) (see steps below)
4. Add model to Xcode and convert to SceneKit format
5. Run the app

## Live Coding Part II - Detecting Planes
1. Add `VirtualPlane` or similar custom SceneKit node to project to make planes visible
2. Set configuration of ARKit to detect horizontal planes
3. Implement delegate methods to place a `VirtualPlane` in the scene where a plane is detected.
4. Add touch event and code to add the model from Part I to the scene where the user has touched.

## Live Coding Part III - Detecting (Haunted) Objects
1. Use Apple’s [ARKit Scanner app](https://developer.apple.com/documentation/arkit/scanning_and_detecting_3d_objects) to scan an object and generate a 'reference object file'
2. Add the reference object file to your app’s Asset Catalog
3. Update configuration of ARKit to detect objects
4. Update the delegate method to display your model from Part I when an object is detected.

#### Appendix: Converting a 3D Studio Max model to COLLADA (DAE) the hard way!

Many free 3D models are available as 3D Studio Max files which SceneKit in Xcode can’t load.  If you have access to 3D Studio Max it is simple to export to a format that SceneKit is comfortable with, but if you don’t it can be tricky to work with these models.  I have found these steps work consistently to get from a 3DS model to a DAE file.

You will need a 3DS file, e.g. this ghost model from Turbosquid [3ds max ghost](https://www.turbosquid.com/3d-models/3ds-max-ghost/224143), and the open source [Blender 3D modelling application](https://www.blender.org/download/) on your computer.

##### Steps

1. Convert the model to an OBJ file using [Yobi3D - Free 3D Models Search Engine](https://www.yobi3d.com/3d-file-convert)
2. Create new file in Blender
3. Hide the initial Cube node
4. Import the converted OBJ file
5. Export to COLLADA (DAE) format

