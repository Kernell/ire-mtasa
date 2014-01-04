-- Innovation Roleplay Engine
--
-- Author		Kenix
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CUIRadio
{
	BANDS		= 40;
	
	Color		= { R = 0; G = 255; B = 255; A = 100 };
	
	m_iChangeTick	= 0;
	m_iPrevTick		= 0;
	
	CUIRadio	= function( this )
		this.m_fWidth	= 300;
		this.m_fHeight	= 250;
		
		this.m_fX	= 10;
		this.m_fY	= g_iScreenY - this.m_fHeight - 50;
		
		this.m_iColor = tocolor( this.Color.R, this.Color.G, this.Color.B, this.Color.A );
		
		this.m_FFT = {};
		
		for i = 1, this.BANDS do
			this.m_FFT[ i ] = 0;
		end
		
		this:Reset();
		
		function this.__Draw()
			this:Draw();
		end
		
		function this.__OnClientVehicleEnter( pPlayer, iSeat )
			this:OnClientVehicleEnter( source, pPlayer, iSeat );
		end
		
		function this.__OnClientVehicleExit( pPlayer, iSeat )
			this:OnClientVehicleExit( source, pPlayer, iSeat );
		end
		
		function this.__Next()
			setRadioChannel( 0 );
			
			if getTickCount() - this.m_iChangeTick > 500 then
				this.m_iChangeTick = getTickCount();
				
				this:Next();
			end
		end
		
		function this.__Prev()
			setRadioChannel( 0 );
			
			if getTickCount() - this.m_iChangeTick > 500 then
				this.m_iChangeTick = getTickCount();
				
				this:Prev();
			end
		end
		
		addEventHandler( "onClientRender", root, this.__Draw );
		addEventHandler( "onClientVehicleEnter", root, this.__OnClientVehicleEnter );
		addEventHandler( "onClientVehicleExit", root, this.__OnClientVehicleExit );
		
		bindKey( "radio_next", 		"down", this.__Next );
		bindKey( "radio_previous", 	"down", this.__Prev );
		
		if CLIENT:IsInVehicle() then
			this.m_pVehicle = CLIENT:GetVehicle();
		end
	end;
	
	_CUIRadio	= function( this )
		removeEventHandler( "onClientRender", root, this.__Draw );
		removeEventHandler( "onClientVehicleEnter", root, this.__OnClientVehicleEnter );
		removeEventHandler( "onClientVehicleExit", root, this.__OnClientVehicleExit );
		
		unbindKey( "radio_next", 		"down", this.__Next );
		unbindKey( "radio_previous", 	"down", this.__Prev );
		
		this.__Draw 				= NULL;
		this.__OnClientVehicleEnter = NULL;
		this.__OnClientVehicleExit 	= NULL;
		this.__Next 				= NULL;
		this.__Prev 				= NULL;
	end;
	
	OnClientVehicleEnter	= function( this, pVehicle, pPlayer, iSeat )
		if pPlayer == CLIENT then
			setRadioChannel( 0 );
			
			this:Reset();
			
			this.m_pVehicle = pVehicle;
		end
	end;
	
	OnClientVehicleExit		= function( this, pVehicle, pPlayer, iSeat )
		if pPlayer == CLIENT then
			this.m_pVehicle = NULL;
		end
	end;
	
	Reset		= function( this )
		this.m_iTextAlpha1		= 0;
		this.m_iTextAlpha2		= this.Color.A;
		this.m_bColorFade		= false;
		this.m_iTextTick		= 0;
		this.m_iTextChangeTick	= getTickCount() + 4000;
	end;
	
	Draw		= function( this )
		local pVehicle = this.m_pVehicle;
		
		if not pVehicle then
			return;
		end

		local iTick		= getTickCount();
		
		local pSound	= NULL;
		local pMeta		= NULL;
		
		local pRadio = pVehicle.m_pRadio;
		
		if pRadio then
			pSound	= pRadio.m_pSound;
		end
		
		if pSound then
			local pFFTData 	= pSound:GetFFTData( 4096, this.BANDS );
			pMeta			= pSound:GetMetaTags();
			
			for iBand = 1, this.BANDS do
				local fX = ( iBand * ( this.m_fWidth / this.BANDS ) ) + this.m_fX;
				local fY = this.m_fY + this.m_fHeight;
				
				if pFFTData then
					local iPeak = pFFTData[ iBand ];
					
					if iPeak then
						if this.m_FFT[ iBand ] == NULL then
							this.m_FFT[ iBand ] = 0;
						end
						
						if pFFTData[ iBand ] >= this.m_FFT[ iBand ] then
							this.m_FFT[ iBand ] = pFFTData[ iBand ];
						end
						
						local fHeight = math.sqrt( iPeak ) * 3 * ( this.m_fHeight - 4 );
						
						if fHeight > 200 + this.m_fHeight then
							fHeight = this.m_fHeight + 200;
						end
						
						fHeight = fHeight - 1;
						
						if fHeight >= -1 then
							dxDrawRectangle( fX, fY, 5, -math.max( ( fHeight + 1 ) / 4, 1 ), this.m_iColor );
						end
					else
						this.m_FFT[ iBand ] = NULL;
					end
				end
				
				local iPeak = this.m_FFT[ iBand ];
				
				if iPeak then
					local fHeight = math.sqrt( iPeak ) * 3 * ( this.m_fHeight - 4 );
						
					if fHeight > 200 + this.m_fHeight then
						fHeight = this.m_fHeight + 200;
					end
					
					fHeight = fHeight + 12;
					
					if fHeight >= -1 then
						dxDrawRectangle( fX, fY - math.max( fHeight / 4, 1 ), 5, 3, tocolor( this.Color.R, this.Color.G, this.Color.B, 200 ) );
					end
					
					this.m_FFT[ iBand ] = math.max( 0, this.m_FFT[ iBand ] - ( ( iTick - this.m_iPrevTick ) * 0.0001 ) );
				end
			end
		end
		
		if this.m_iTextChangeTick ~= 0 and iTick - this.m_iTextChangeTick > 4000 then
			this.m_iTextChangeTick	= 0;
			this.m_iTextTick		= iTick + 3000;
		end
		
		if this.m_iTextTick ~= 0 then
			local fProgress = 1.0 - ( this.m_iTextTick - iTick ) / 3000;
			
			if this.m_bColorFade then
				this.m_iTextAlpha1 = Lerp( this.m_iTextAlpha1, 0, fProgress );
				this.m_iTextAlpha2 = Lerp( this.m_iTextAlpha2, this.Color.A, fProgress );
			else
				this.m_iTextAlpha1 = Lerp( this.m_iTextAlpha1, this.Color.A, fProgress );
				this.m_iTextAlpha2 = Lerp( this.m_iTextAlpha2, 0, fProgress );
			end
			
			if fProgress >= 1.0 and pRadio then
				this.m_iTextTick		= 0.0;
				this.m_iTextChangeTick	= iTick + 4000;
				
				this.m_bColorFade	= not this.m_bColorFade;
			end
		end
		
		local fX	= this.m_fX + 5;
		local fY	= this.m_fY + this.m_fHeight;
		
		if pMeta then
			local iColor = tocolor( this.Color.R, this.Color.G, this.Color.B, this.m_iTextAlpha1 );
			
			local sArtist	= pMeta.artist or pMeta.stream_title or "Unknown artist";
			local sTitle	= NULL;
			
			local aNames = sArtist:split( "–-" );
			
			if table.getn( aNames ) == 2 then
				sArtist	= aNames[ 1 ];
				sTitle	= aNames[ 2 ];
			end
			
			if sTitle == NULL then
				sTitle = pMeta.title or pMeta.stream_name or "Unknown title";
			end
			
			dxDrawText( sArtist:trim(),	fX, fY, fX, fY, iColor, 0.4, DXFont( "Segoe UI", 24 ) );
			dxDrawText( sTitle:trim(),	fX, fY + 15, fX, fY + 15, iColor, 0.5, DXFont( "Segoe UI", 24 ) );
		end
		
		do
			local iColor = tocolor( this.Color.R, this.Color.G, this.Color.B, this.m_iTextAlpha2 );
			
			local sTitle	= "Радио выключено";
			
			if pRadio and VEHICLE_RADIO[ pVehicle.m_pData.m_iRadioID ] then
				sTitle = VEHICLE_RADIO[ pVehicle.m_pData.m_iRadioID ][ 1 ];
			end
			
			dxDrawText( sTitle:trim(),	fX, fY, fX, fY, iColor, 0.5, DXFont( "Segoe UI", 32 ) );
		end
		
		this.m_iPrevTick = iTick;
	end;
	
	Next		= function( this )
		local pVehicle = CLIENT:GetVehicle();
		
		if pVehicle then
			this:Select( pVehicle.m_pData.m_iRadioID + 1 );
		end
	end;
	
	Prev		= function( this )
		local pVehicle = CLIENT:GetVehicle();
		
		if pVehicle then
			this:Select( pVehicle.m_pData.m_iRadioID - 1 );
		end
	end;
	
	Select		= function( this, iChannelID )
		local pVehicle = CLIENT:GetVehicle();
		
		if pVehicle then
			iChannelID = iChannelID % ( table.getn( VEHICLE_RADIO ) + 1 );
			
			SERVER.Radio__SelectChannel( iChannelID );
			
			playSoundFrontEnd( iChannelID == 0 and 38 or 37 );
			
			this:Reset();
		end
	end;
};
