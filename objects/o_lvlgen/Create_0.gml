/// @description Map Initalization

// Grid Size and Tile size constants set here
#macro mapWidth		16  												// world size is set here - max Height is 99
#macro mapHeight	16 												

#macro tileWidth	30													// tile size is dependant on the sprite being used
#macro tileHeight	24													

#macro totalRooms	19													// Rooms are binary 0 - 15 plus custom rooms
#macro totalDoors    4													// rooms have 4 doors
#macro randRooms	16													// first 16 rooms can be randomly chosen

viewWidth = (mapWidth+1)  *  tileWidth									// adjust window size to map dimensions
viewHeight = (mapHeight+1) * tileHeight
camera_set_view_size(view_camera[0], viewWidth, viewHeight);
camera_set_view_pos(view_camera[0], 0, 0);
window_set_size( viewWidth, viewHeight);
surface_resize(application_surface,viewWidth,viewHeight);
													
gridEntropy = ds_grid_create(mapWidth+2,mapHeight+2);					// Grid of entropy value for each cell
gridIndex =   ds_grid_create(mapWidth+2,mapHeight+2);					// Grid of room indexes
gridRooms =   ds_grid_create(totalDoors,totalRooms)						// Grid of door states of all rooms
																		
Entropy = -1;															// Entropy of the entire map														
																		
#region																	// fill gridRooms with data
																		
//						╔════ 0 ════╗									// doors are numbered clockwise, with the top door starting at 0
//						║           ║									// ═ 0 ═ 1 ═ 2 ═ 3 ═ 
//						3           1														
//						║           ║														
//						╚════ 2 ════╝														
																		
ds_grid_set_region(gridRooms,0,0,totalDoors,totalRooms,0)				// all doors start at zero ( open )
																		
for (var _RoomIndex = 0; _RoomIndex < randRooms; _RoomIndex += 1; ) {	// First 16 rooms are generated as 4 digit binary 0 - 15
	if ( _RoomIndex  >=  8 )										ds_grid_set(gridRooms,0,_RoomIndex,1) // door0
	if ( _RoomIndex mod 8  >=  4 ) && ( _RoomIndex mod 8  <=  7 )	ds_grid_set(gridRooms,1,_RoomIndex,1) // door1
	if ( _RoomIndex mod 4  >=  2 ) && ( _RoomIndex mod 4  <=  3 )	ds_grid_set(gridRooms,2,_RoomIndex,1) // door2
	if ( _RoomIndex mod 2  ==  1 )									ds_grid_set(gridRooms,3,_RoomIndex,1) // door3 
}


			
// Custom rooms follow

// room_222222
ds_grid_set(gridRooms, 0, 16, 2);
ds_grid_set(gridRooms, 1, 16, 2);
ds_grid_set(gridRooms, 2, 16, 2);
ds_grid_set(gridRooms, 3, 16, 2);

// two vertical rooms
// room 0121
ds_grid_set(gridRooms, 0, 17, 0);
ds_grid_set(gridRooms, 1, 17, 1);
ds_grid_set(gridRooms, 2, 17, 2);
ds_grid_set(gridRooms, 3, 17, 1);
// room 2101
ds_grid_set(gridRooms, 0, 18, 2);
ds_grid_set(gridRooms, 1, 18, 1);
ds_grid_set(gridRooms, 2, 18, 0);
ds_grid_set(gridRooms, 3, 18, 1);


#endregion

#region																		// create knock out lists for each doorway & type

listNotStart =	 ds_list_create(); ds_list_add (listNotStart, 222);		// start room knockout - any room on this list cannot be a start room
listRandRoom =	 ds_list_create(); ds_list_add (listRandRoom, 15, 222); // room '15' with no entrances is not allowed to be chosen
																
listDoor0_0 =	 ds_list_create(); ds_list_add ( listDoor0_0, 222);		// 0th door not open
listDoor0_1 =	 ds_list_create(); ds_list_add ( listDoor0_1, 222);		// 0th door not closed
listDoor0_2 =	 ds_list_create(); ds_list_add ( listDoor0_2, 222);		// 0th door not wide	
				 				 								 
listDoor1_0 =	 ds_list_create(); ds_list_add ( listDoor1_0, 222);		// 1st door not open
listDoor1_1 =	 ds_list_create(); ds_list_add ( listDoor1_1, 222);		// 1st door not closed
listDoor1_2 =	 ds_list_create(); ds_list_add ( listDoor1_2, 222);		// 1st door not wide	
				 				 								 
listDoor2_0 =	 ds_list_create(); ds_list_add ( listDoor2_0, 222);		// 2nd door not open
listDoor2_1 =	 ds_list_create(); ds_list_add ( listDoor2_1, 222);		// 2nd door not closed
listDoor2_2 =	 ds_list_create(); ds_list_add ( listDoor2_2, 222);		// 2nd door not wide
				 				 								 
listDoor3_0 =	 ds_list_create(); ds_list_add ( listDoor3_0, 222);		// 3rd door not open
listDoor3_1 =	 ds_list_create(); ds_list_add ( listDoor3_1, 222);		// 3rd door not closed
listDoor3_2 =	 ds_list_create(); ds_list_add ( listDoor3_2, 222);		// 3rd door not wide  


for (var _RoomIndex = 0; _RoomIndex < totalRooms; _RoomIndex += 1; ){		// cycle through all rooms & add them to lists depending on their door state
	for (var _DoorIndex = 0; _DoorIndex < totalDoors; _DoorIndex += 1; ) {					
		var _DoorRoom = ds_grid_get(gridRooms, _DoorIndex, _RoomIndex)						
		switch _DoorIndex {
		case 0: switch (_DoorRoom) {										
			case 0: ds_list_add ( listDoor0_1, _RoomIndex); 
					ds_list_add ( listDoor0_2, _RoomIndex); break; 
			case 1: ds_list_add ( listDoor0_0, _RoomIndex); 
					ds_list_add ( listDoor0_2, _RoomIndex); break; 
			case 2: ds_list_add ( listDoor0_0, _RoomIndex);
					ds_list_add ( listDoor0_1, _RoomIndex); break; 
			} break;															
		case 1: switch (_DoorRoom) {	
			case 0: ds_list_add ( listDoor1_1, _RoomIndex); 
					ds_list_add ( listDoor1_2, _RoomIndex); break;  
			case 1: ds_list_add ( listDoor1_0, _RoomIndex); 
					ds_list_add ( listDoor1_2, _RoomIndex); break;  
			case 2: ds_list_add ( listDoor1_0, _RoomIndex); 
					ds_list_add ( listDoor1_1, _RoomIndex); break;  
			} break;															
		case 2: switch (_DoorRoom) {
			case 0: ds_list_add ( listDoor2_1, _RoomIndex); 
					ds_list_add ( listDoor2_2, _RoomIndex); break;  
			case 1: ds_list_add ( listDoor2_0, _RoomIndex); 
					ds_list_add ( listDoor2_2, _RoomIndex); break;  
			case 2: ds_list_add ( listDoor2_0, _RoomIndex); 
					ds_list_add ( listDoor2_1, _RoomIndex); break;  
			} break;											
		case 3: switch (_DoorRoom) {
			case 0: ds_list_add ( listDoor3_1, _RoomIndex); 
					ds_list_add ( listDoor3_2, _RoomIndex); break;  
			case 1: ds_list_add ( listDoor3_0, _RoomIndex); 
					ds_list_add ( listDoor3_2, _RoomIndex); break;  
			case 2: ds_list_add ( listDoor3_0, _RoomIndex); 
					ds_list_add ( listDoor3_1, _RoomIndex); break;  
			} break;																
		}
	}
}

#endregion

gridCol0 = c_white
backCol0 = c_black

gridCol1 = make_colour_rgb(243,182,67);
backCol1 = make_colour_rgb(47, 85, 57);

gridCol2 = make_colour_rgb(86,230,180);
backCol2 = make_colour_rgb(59,36,21);

gridCol3 = make_colour_rgb(34,205,242);
backCol3 = make_colour_rgb(78,12,37);

gridCol4 = make_colour_rgb(255,229,145);
backCol4 = make_colour_rgb(110,6,4);

gridCol5 = make_colour_rgb(100,252,143);
backCol5 = make_colour_rgb(71,14,69);

gridCol6 = make_colour_rgb(128,118,255);
backCol6 = make_colour_rgb(21,59,76);

gridCol7 = make_colour_rgb(197,255,0);
backCol7 = make_colour_rgb(5,63,106);

gridCol8 = make_colour_rgb(252,111,115);
backCol8 = make_colour_rgb(48,42,62);