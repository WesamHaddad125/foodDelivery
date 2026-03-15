extends Node

@export var rows : int = 9
@export var columns : int = 8

@onready var floor: TileMapLayer = $"../Floor"
@onready var house_objects: TileMapLayer = $"../HouseObjects"
@onready var room_cameras: TileMapLayer = $"../RoomCameras"
@onready var walking_player: WalkingPlayer = $"../WalkingPlayer"

@export var maxRooms := 8
var roomsCreated := 0
var starting_row_idx := 8
var starting_col_idx := 4
var finalMap : Array[Array]
var roomsToCheck : Queue = Queue.new()
@export var roomDepth = 5
var currDepth = 0
var chance_to_stop = 0.6

var rowDir : Array[int] = [-1, 0, 1, 0]
var colDir : Array[int] = [0, -1, 0, 1]

var doorTile : Vector2i = Vector2i(3,5)

func _ready() -> void:
	for row in rows:
		var arr : Array[int]
		arr.resize(columns)
		finalMap.append(arr)
	for row in rows:
		for col in columns:
			finalMap[row][col] = 0
	roomsToCheck.enqueue(Vector2(starting_row_idx, starting_col_idx))
	
	# Generate til we get a valid large room
	while roomsCreated <= maxRooms:
		generate_dungeon()
		
	finalMap[starting_row_idx][starting_col_idx] = 3 # entry room
	# Mark end rooms	
	for row in rows:
		for col in finalMap[row].size():
			var count = countNeighbors(row, col, true)
			if count >= 3 && finalMap[row][col] == 1:
				finalMap[row][col] = 2
	
	for row in rows:
		for col in finalMap[row].size():
			if finalMap[row][col] != 0:
				var spawnPos := Vector2i(col * 21, row * 29)
				createCamera(spawnPos)
				
				var entryRoomPattern : TileMapPattern = floor.tile_set.get_pattern(randi_range(0,1))
				var terrainDifficultyPattern : TileMapPattern = floor.tile_set.get_pattern(randi_range(6,6))
				
				floor.set_pattern(spawnPos, entryRoomPattern)
				house_objects.set_pattern(Vector2i(spawnPos.x + 1, spawnPos.y + 4), terrainDifficultyPattern)
				createDoors(col, row, spawnPos.x, spawnPos.y)
				if finalMap[row][col] == 3:
					var playerSpawn = floor.map_to_local(Vector2i(spawnPos.x + 10, spawnPos.y + 25))
					walking_player.global_position = Vector2(playerSpawn.x, playerSpawn.y)
	#debug generation
	#for row in rows:
		#print(finalMap[row])

func generate_dungeon() -> void:
	roomsCreated = 0
	for row in rows:
		for col in columns:
			finalMap[row][col] = 0
	roomsToCheck.EmptyQueue()
	roomsToCheck.enqueue(Vector2(starting_row_idx, starting_col_idx))
	
	while !roomsToCheck.isEmpty() && roomsCreated <= maxRooms:
		var mapLocation = roomsToCheck.getFront()
		roomsToCheck.dequeue()
		for i in range(4):
			var adjX : int = mapLocation.x + rowDir[i]
			var adjY : int = mapLocation.y + colDir[i]
			if isValid(adjX, adjY):
				roomsToCheck.enqueue(Vector2(adjX, adjY))
				finalMap[adjX][adjY] = 1			
				roomsCreated += 1
				currDepth += 1
			
func isValid(x, y) -> bool:
	if x < 0 || x >= rows || y < 0 || y >= columns:
		return false
			
	if finalMap[x][y] == 1:
		return false
		
	var neighbors = countNeighbors(x, y, false)
	if neighbors > 2:
		return false
		
	var randChange = randf()
	if randChange < chance_to_stop:
		return false
		
	return true
	
func countNeighbors(x, y, checkEmptyNeighbors : bool) -> int:
	var neighbors = 0
	for i in range(4):
		var adjX : int = x + rowDir[i]
		var adjY : int = y + colDir[i]
		
		if adjX < 0 || adjX >= rows || adjY < 0 || adjY >= columns:
			if checkEmptyNeighbors:
				neighbors += 1
			continue
			
		if checkEmptyNeighbors && finalMap[adjX][adjY] == 0:
			neighbors += 1
		elif !checkEmptyNeighbors && finalMap[adjX][adjY] == 1:
			neighbors += 1
	return neighbors
	
func createDoors(rowIdx, colIdx, x, y) -> void:
	# Create entrance/exit door
	if finalMap[colIdx][rowIdx] == 3:
		var doorPos = Vector2i(x + 10, y + 28) # BOTTOM
		
		house_objects.set_cell(doorPos, 3, Vector2i(0, 0), 5)
		for door in range(2):
			doorPos.x += door
			floor.set_cell(doorPos, 2, doorTile, 2)
			
	for i in range(4):
		var adjX : int = colIdx + rowDir[i]
		var adjY : int = rowIdx + colDir[i]
		
		if adjX < 0 || adjX >= rows || adjY < 0 || adjY >= columns:
			continue
		
		var doorPos : Vector2i
		var axisToIncrement : String
		if finalMap[adjX][adjY] != 0:
			if colDir[i] == -1 && rowDir[i] == 0:
				doorPos = Vector2i(x, y + 15) # LEFT
				for door in range(2):
					doorPos.y += door
					floor.set_cell(doorPos, 2, doorTile, 1)
			elif colDir[i] == 1 && rowDir[i] == 0:
				doorPos = Vector2i(x + 20, y + 15) # RIGHT
				for door in range(2):
					doorPos.y += door
					floor.set_cell(doorPos, 2, doorTile, 1)
			elif colDir[i] == 0 && rowDir[i] == -1:
				doorPos = Vector2i(x + 10, y) # TOP
				for door in range(2):
					doorPos.x += door
					floor.set_cell(doorPos, 2, doorTile, 1)
			elif colDir[i] == 0 && rowDir[i] == 1:
				doorPos = Vector2i(x + 10, y + 28) # BOTTOM
				for door in range(2):
					doorPos.x += door
					floor.set_cell(doorPos, 2, doorTile, 1)

func createCamera(spawnPos : Vector2i) -> void:
	var cameraPos : Vector2i = Vector2i(spawnPos.x + 10, spawnPos.y + 14)
	
	room_cameras.set_cell(cameraPos, 3, Vector2i(0, 0), 2)
	
	
	
	
	
