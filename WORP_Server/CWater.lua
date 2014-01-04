-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "CWater" ( CElement )

function CWater:CWater( vecPosition1, vecPosition2, vecPosition3, vecPosition4, bShallow )
	self.__instance = createWater(
		vecPosition1.X, vecPosition1.Y, vecPosition1.Z,
		vecPosition2.X, vecPosition2.Y, vecPosition2.Z,
		vecPosition3.X, vecPosition3.Y, vecPosition3.Z,
		vecPosition4.X, vecPosition4.Y, vecPosition4.Z,
		(bool)(bShallow)
	);
	
	self:CElement();
end

function CWater:_CWater()
	self:Destroy();
end

function CWater:SetVertex( iVertex, vecPosition )
	return setWaterVertexPosition( self.__instance, vecPosition.X, vecPosition.Y, vecPosition.Z );
end

function CWater:GetVertex( iVertex )
	return Vector3( getWaterVertexPosition( self.__instance ) );
end