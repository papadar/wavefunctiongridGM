
wavefunctiongridGM
==================================

Implementation of a Wave Function Collapse in GameMaker Studio 2.x
by Aladar Apponyi

simplified square grid version of a Hex grid wave function collapse project
https://github.com/papadar/wavefunctionhexgridGM

based on work of Maxim Gumin
https://github.com/mxgmn/WaveFunctionCollapse

and processing example by solub
https://discourse.processing.org/t/wave-collapse-function-algorithm-in-processing/12983

------------- Room Doors ----------------

Grid cells are described as Rooms with 4 Doors
The 4 possible connections between each room are numbered clockwise;

		╔════ 0 ════╗
		║           ║
		3           1
		║           ║
		╚════ 2 ════╝

This allows all possible rooms with only open or closed doors ( 0 / 1 )
to be represented by binary numbers 0 - 15 ( 0000 - 1111 )

Connection type 2 is also handled,
only two rooms are added that use this connection, and are not randomly placed in this release

------------- lists ----------------

most work is done by two scripts that compare lists of possible rooms for each cell

ds_list_combine - adds any new values to an original list from a second list

ds_list_trim - removes any values from an original list that occur in the second list

