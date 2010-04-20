# WordTree

## What is WordTree?

The best way to describe it is software as art. WordTree was developed in collaboration with Ann Ford as part of her Master's of Fine Arts (Graphic Design) exhibition at Virginia Commonwealth University. Ann Ford is now a professor at Virginia State University and the driving force behind Chamber's Design.

## How do I use it?

### Single words or phrases:

Run the application. Type a few characters. Hit enter. Watch your words grow.

### Entire text files:

Use File -> Open to select a text document. WordTree will "play" the contents of the document.

## How does it work?

The WordTree application is built on top of many features that are built into the Mac OS X operating system, first introduced in Mac OS X (10.5) Leopard. The capabilities of Core Animation, Core Image, Core Text and WebKit are combined to provide dynamically positioned, layered, typographic animations on top of a scaleable vector graphic (SVG) image. 

The background "lamp" is drawn using the SVG support built into WebKit. The positions of the tree branches are determined by calling JavaScript that is embedded into the extensible hypertext markup language (XHTML) document that hosts the SVG image. Once the positions are determined, the background WebKit display becomes a passive participant in the application's display.

Core Animation layers provide the surfaces into which each letter is rendered. Core Text is used to determine the typographic bounds of the characters for exact positioning on the tree. Core Animation also provides the animations that are used to alter the letters over time. Each letter's color is manipulated by applying a Core Image filter. A letter's rotation angle, size and position is animated by manipulating properties associated with the letter layer's bounding frame rectangle.

The result is a very fluid and interactive typographic illustration.

## How can I get it?

You can download it from the downloads section: http://github.com/mscottford/WordTree/downloads