class Fraction{
	constructor(name, magazineX, magazineY, magazineZ){
		_name = name;	
		_magazineX = magazineX;
		_magazineY = magazineY;
		_magazineZ = magazineZ;
		
		local file = io.file("database/fractions/" + _name, "r");
		if(file.isOpen){
			_leader = file.read(io_type.LINE);
		}
	}
	
	function setLeader(nick){
		local file = io.file("database/fractions/" + _name, "w");
		file.write(nick);
	}
	
	function magazinePosition(pid){
		local pos = getPlayerPosition(pid);
		if(getDistance3d(pos.x, pos.y, pos.z, _magazineX, _magazineY, _magazineZ)<600) return true;
		else return false;
	}
	
	_name = null;
	_leader = null;
	_magazineX = null;
	_magazineY = null;
	_magazineZ = null;
}
