-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

--[[ 
mass  							Float  			1.0  		100000.0
turnMass  						Float  			0.0  		1000000.0
dragCoeff  						Float  			-200.0		200.0
centerOfMass  					{ fX, fY, fZ }  -10.0  		10.0
percentSubmerged				Integer  		1  			99999
tractionMultiplier				Float  			-100000.0  	100000.0
tractionLoss  					Float  			0.0  		100.0   
tractionBias  					Float  			0.0  		1.0   
numberOfGears 					Integer  		1  			5   
maxVelocity  					Float  			0.1  		200000.0   
engineAcceleration  			Float  			0.0  		100000.0   
engineInertia  					Float  			-1000.0 	1000.0		Inertia of 0 can cause a LSOD. (Unable to divide by zero)  
driveType  						String  		N/A  		N/A  		Use 'rwd', 'fwd' or 'awd'.  
engineType  					String  		N/A  		N/A  		Use 'petrol', 'diesel' or 'electric'.  
brakeDeceleration  				Float  			0.1  		100000.0   
brakeBias  						Float  			0.0  		1.0   
ABS  							Boolean  		true  		false  		Has no effect.  
steeringLock  					Float  			0.0  		360.0   
suspensionForceLevel			Float  			0.0  		100.0   
suspensionDamping  				Float  			0.0  		100.0   
suspensionHighSpeedDamping		Float  			0.0  		600.0   
suspensionUpperLimit  			Float  			-50.0  		50.0  		Can't be equal to suspensionLowerLimit.  
suspensionLowerLimit  			Float  			-50.0  		50.0  		Can't be equal to suspensionUpperLimit.  
suspensionFrontRearBias  		Float  			0.0  		1.0  		Hardcoded maximum is 3.0, but values above 1.0 have no effect.  
suspensionAntiDiveMultiplier	Float  			0.0  		30.0   
seatOffsetDistance  			Float  			-20.0  		20.0   
collisionDamageMultiplier  		Float  			0.0  		10.0   
monetary  						Integer  		0  			230195200  	Read only 
modelFlags  					Hex/Dec  		N/A  		N/A  		Property uses a decimal value, generated by a hex value. Either use 0x12345678 or tonumber ( "0x12345678" ). 
handlingFlags					Hex/Dec  		N/A  		N/A  		Property uses a decimal value, generated by a hex value. Either use 0x12345678 or tonumber ( "0x12345678" ).  
headLight  						Integer  		N/A  		N/A  		Read only  
tailLight  						Integer  		N/A  		N/A  		Read only  
animGroup  						Integer  		??  		??  		Read only due to people not knowing this property was vehicle-based and caused crashes.  
]]

local handling	=
{
	[ AMBULAN ] =
	{
		steeringLock	= 40;
	};
	[ BARRACKS ] =
	{
		steeringLock	= 40;
	};
	[ ENFORCER ] =
	{
		steeringLock	= 40;
	};
	[ BUFFALO ] =
	{
		mass 							= 1642;
		turnMass 						= 6000;
		dragCoeff 						= 2.0;
		centerOfMass 					= { 0.0, 0.1, -0.1, };
		percentSubmerged 				= 70;
		tractionMultiplier				= 1.0;
		tractionLoss 					= 0.5;
		tractionBias 					= 0.6;
		numberOfGears 					= 5;
		maxVelocity						= 250.0;
		engineAcceleration				= 9.0;
		engineInertia					= 9.0;
		driveType						= "rwd";
		engineType 						= "petrol";
		brakeDeceleration 				= 6;
		brakeBias 						= 0.6;
		ABS 							= true;
		steeringLock 					= 45.0;
		suspensionForceLevel 			= 1.0;
		suspensionDamping 				= 1.0;
		suspensionHighSpeedDamping 		= 0.0;
		suspensionUpperLimit 			= 0.2;
		suspensionLowerLimit 			= -0.05;
		suspensionFrontRearBias 		= 0.5;
		seatOffsetDistance 				= 0.25;
		collisionDamageMultiplier 		= 0.5;
		suspensionAntiDiveMultiplier 	= 0.0;
		modelFlags 						= 0x2004;
		handlingFlags 					= 0x1000000;
	};
	[ ELEGANT ] =
	{
		mass 							= 1565;
		turnMass 						= 5000;
		dragCoeff 						= 1.8;
		centerOfMass 					= { 0.0, 0.0, -0.1, };
		percentSubmerged 				= 50;
		tractionMultiplier				= 0.7;
		tractionLoss 					= 0.8;
		tractionBias 					= 0.55;
		numberOfGears 					= 5;
		maxVelocity 					= 235.0;
		engineAcceleration 				= 10.0;
		engineInertia 					= 10.0;
		driveType						= "rwd";
		engineType 						= "petrol";
		brakeDeceleration 				= 6;
		brakeBias 						= 0.55;
		ABS 							= false;
		steeringLock 					= 45.0;
		suspensionForceLevel 			= 1;
		suspensionDamping 				= 0.1;
		suspensionHighSpeedDamping 		= 0;
		suspensionUpperLimit 			= 0.35;
		suspensionLowerLimit 			= -0.05;
		suspensionFrontRearBias 		= 0.5;
		seatOffsetDistance 				= 0.2;
		collisionDamageMultiplier 		= 0.3;
		suspensionAntiDiveMultiplier 	= 0.3;
		modelFlags 						= 0x0;
		handlingFlags 					= 0x400002;
	};
	[ EMPEROR ] =
	{
		mass 							= 1530;
		turnMass 						= 5000;
		dragCoeff 						= 2.0;
		centerOfMass 					= { 0.0, 0.0, -0.15 };
		percentSubmerged 				= 50;
		tractionMultiplier				= 0.7;
		tractionLoss 					= 0.8;
		tractionBias 					= 0.5;
		numberOfGears 					= 5;
		maxVelocity 					= 240.0;
		engineAcceleration 				= 11.0;
		engineInertia 					= 20.0;
		driveType						= "rwd";
		engineType 						= "petrol";
		brakeDeceleration 				= 6;
		brakeBias 						= 0.55;
		ABS 							= false;
		steeringLock 					= 45.0;
		suspensionForceLevel 			= 1;
		suspensionDamping 				= 0.1;
		suspensionHighSpeedDamping 		= 0;
		suspensionUpperLimit 			= 0.35;
		suspensionLowerLimit 			= -0.05;
		suspensionFrontRearBias 		= 0.4;
		seatOffsetDistance 				= 0.2;
		collisionDamageMultiplier 		= 0.3;
		suspensionAntiDiveMultiplier 	= 0.3;
		modelFlags 						= 0x0;
		handlingFlags 					= 0x404400;
	};
	[ PATRIOT ] =
	{
		steeringLock	= 40;
	};
	[ FBIRANCH ] =
	{
		mass							= 4500.0;
		turnMass						= 12000.0;
		dragCoeff						= 2.0;
		centerOfMass					= { 0.0, 0.0, -0.35 };
		percentSubmerged				= 50;
		tractionMultiplier				= 0.9;
		tractionLoss 					= 0.7;
		tractionBias					= 0.5;
		numberOfGears					= 5;
		maxVelocity						= 170.0;
		engineAcceleration				= 10.0;
		engineInertia					= 30.0;
		driveType						= "awd";
		engineType						= "petrol";
		brakeDeceleration 				= 8.5;
		brakeBias						= 0.5;
		ABS								= false;
		steeringLock					= 45.0;
		suspensionForceLevel			= 1.2;
		suspensionDamping				= 0.5;
		suspensionHighSpeedDamping		= 0.0;
		suspensionUpperLimit			= 0.34;
		suspensionLowerLimit			= -0.1;
		suspensionFrontRearBias			= 0.5;
		suspensionAntiDiveMultiplier	= 0.0;
		seatOffsetDistance				= 0.44;
		collisionDamageMultiplier		= 0.3;
		modelFlags						= 0x40002001;
		handlingFlags					= 0x500000;
	};
	[ PREMIER ] = -- Dodge Charger R/T 2007
	{
		mass							= 1828.0;
		turnMass						= 7000.0;
		dragCoeff						= 2.0;
		centerOfMass					= { 0.0, 0.0, -0.1 };
		percentSubmerged				= 70;
		tractionMultiplier				= 0.6;
		tractionLoss 					= 0.9;
		tractionBias					= 0.5;
		numberOfGears					= 5;
		maxVelocity						= 250.0;
		engineAcceleration				= 9.0;
		engineInertia					= 9.0;
		driveType						= "rwd";
		engineType						= "petrol";
		brakeDeceleration 				= 6.0;
		brakeBias						= 0.55;
		ABS								= true;
		steeringLock					= 45.0;
		suspensionForceLevel			= 1.0;
		suspensionDamping				= 0.2;
		suspensionHighSpeedDamping		= 0.0;
		suspensionUpperLimit			= 0.2;
		suspensionLowerLimit			= -0.1;
		suspensionFrontRearBias			= 0.5;
		suspensionAntiDiveMultiplier	= 0;
		seatOffsetDistance				= 0.2;
		collisionDamageMultiplier		= 0.5;
		modelFlags						= 0x40002000;
		handlingFlags					= 0x1004400;
	};
	[ VINCENT ] = -- Subaru Impreza WRX STI 2005
	{
		mass							= 1425.0;
		turnMass						= 6000.0;
		dragCoeff						= 2.0;
		centerOfMass					= { 0.0, 0.0, -0.1 };
		percentSubmerged				= 70;
		tractionMultiplier				= 0.7;
		tractionLoss 					= 0.8;
		tractionBias					= 0.525;
		numberOfGears					= 5;
		maxVelocity						= 240.0;
		engineAcceleration				= 9.0;
		engineInertia					= 20.0;
		driveType						= "awd";
		engineType						= "petrol";
		brakeDeceleration 				= 5.0;
		brakeBias						= 0.5;
		ABS								= true;
		steeringLock					= 45.0;
		suspensionForceLevel			= 1.2;
		suspensionDamping				= 0.15;
		suspensionHighSpeedDamping		= 0.0;
		suspensionUpperLimit			= 0.28;
		suspensionLowerLimit			= -0.05;
		suspensionFrontRearBias			= 0.5;
		suspensionAntiDiveMultiplier	= 0.3;
		seatOffsetDistance				= 0.26;
		collisionDamageMultiplier		= 0.5;
		modelFlags						= 0x800;
		handlingFlags					= 0x5084402;
	};
	[ SULTAN ] = -- Mitsubishi Lancer Evolution VIII GSR
	{
		mass							= 1410;
		turnMass						= 6000.0;
		dragCoeff						= 2.0;
		centerOfMass					= { 0.0, 0.1, -0.1 };
		percentSubmerged				= 75;
		tractionMultiplier				= 0.7;
		tractionLoss 					= 0.8;
		tractionBias					= 0.5;
		numberOfGears					= 5;
		maxVelocity						= 250.0;
		engineAcceleration				= 9.0;
		engineInertia					= 35.0;
		driveType						= "awd";
		engineType						= "petrol";
		brakeDeceleration 				= 5.0;
		brakeBias						= 0.5;
		ABS								= true;
		steeringLock					= 45.0;
		suspensionForceLevel			= 1.2;
		suspensionDamping				= 0.15;
		suspensionHighSpeedDamping		= 0.0;
		suspensionUpperLimit			= 0.28;
		suspensionLowerLimit			= -0.05;
		suspensionFrontRearBias			= 0.5;
		suspensionAntiDiveMultiplier	= 0.3;
		seatOffsetDistance				= 0.26;
		collisionDamageMultiplier		= 0.5;
		modelFlags						= 0x800;
		handlingFlags					= 0x5084402;
	};
	[ HOTRINB ] =
	{
		mass							= 1560;
		turnMass						= 6000.0;
		dragCoeff						= 2.0;
		centerOfMass					= { 0.0, 0.1, -0.2 };
		percentSubmerged				= 75;
		tractionMultiplier				= 0.8;
		tractionLoss 					= 0.8;
		tractionBias					= 0.525;
		numberOfGears					= 5;
		maxVelocity						= 255.0;
		engineAcceleration				= 9.0;
		engineInertia					= 50.0;
		driveType						= "awd";
		engineType						= "petrol";
		brakeDeceleration 				= 5.0;
		brakeBias						= 0.55;
		ABS								= true;
		steeringLock					= 45.0;
		suspensionForceLevel			= 1.2;
		suspensionDamping				= 0.15;
		suspensionHighSpeedDamping		= 0.0;
		suspensionUpperLimit			= 0.29;
		suspensionLowerLimit			= -0.05;
		suspensionFrontRearBias			= 0.5;
		suspensionAntiDiveMultiplier	= 0.4;
		seatOffsetDistance				= 0.26;
		collisionDamageMultiplier		= 0.6;
		modelFlags						= 0x40000204;
		handlingFlags					= 0x1C00000;
	};
};

for model, data in pairs( handling ) do
	for property, value in pairs( data ) do
		setModelHandling( model, property, value );
	end
end