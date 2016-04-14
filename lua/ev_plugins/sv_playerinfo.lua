/*-------------------------------------------------------------------------------------------------------------------------
	Player Info
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Player Info"
PLUGIN.Description = "When players join, show info about them."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = nil

function PLUGIN:ShowPlayerInfo( ply )
	local first = !ply:GetProperty( "LastJoin" )
	local lastjoin
	local lastnick
	
	if ( first ) then		
		ply:SetProperty( "Nick", ply:Nick() )
		ply:SetProperty( "LastJoin", os.time() )
		ply:SetProperty( "SteamID", ply:SteamID() )
		ply:SetProperty( "IPAddress", ply:IPAddress() )
		ply:SetProperty( "PlayTime", 0 )
		
		evolve:CommitProperties()
	else
		lastjoin = ply:GetProperty( "LastJoin" )
		lastnick = ply:GetProperty( "Nick" )
		
		ply:SetProperty( "Nick", ply:Nick() )
		ply:SetProperty( "LastJoin", os.time() )
		ply:SetProperty( "IPAddress", ply:IPAddress() )
		if ( !ply:GetProperty( "PlayTime" ) ) then ply:SetProperty( "PlayTime", 0 ) end
		
		evolve:CommitProperties()
	end
	
	local message = { evolve.colors.blue, ply:Nick(), evolve.colors.white }
	
	/*-------------------------------------------------------------------------------------------------------------------------
		Here for the first time or joined earlier?
	-------------------------------------------------------------------------------------------------------------------------*/

	
	/*-------------------------------------------------------------------------------------------------------------------------
		Did you pick a new name?
	-------------------------------------------------------------------------------------------------------------------------*/
	
	if ( !first and lastnick != ply:Nick() ) then
		table.insert( message, " as " .. lastnick )
	end
	
	table.insert( message, "." )
	
	evolve:Notify( unpack( message ) )
end

function PLUGIN:PlayerInitialSpawn( ply )
	ply.EV_IntroductionPending = true
end

function PLUGIN:PlayerSpawn( ply )
	if ( ply.EV_IntroductionPending ) then
		self:ShowPlayerInfo( ply )
		ply.EV_IntroductionPending = false
		
		ply.EV_LastPlaytimeSave = os.clock()
	end
end

function PLUGIN:PlayerDisconnected( ply )
	ply:SetProperty( "LastJoin", os.time() )
	ply:SetProperty( "PlayTime", ply:GetProperty( "PlayTime" ) + math.abs(os.difftime(os.clock(),ply.EV_LastPlaytimeSave)) )
	
	evolve:CommitProperties()
end
evolve:RegisterPlugin( PLUGIN )
