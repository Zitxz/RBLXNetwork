--// General Array

local Network = {
	ClientServer = {},

	Remotes = {
		Events = {},
		Functions = {}
	}	
}

--// Set Types

type FunctionsClientServer = { Client: <a>(a) -> (), Server: <b>(b) -> () }
type RemotesData = { Events: { string : RemoteEvent}, Functions: { string : RemoteFunction } }

--// Set Variables

local RunService: RunService = game:GetService("RunService")
local HttpService: HttpService = game:GetService("HttpService")

local ClientServer: FunctionsClientServer = Network.ClientServer
local MyRemotes: RemotesData = Network.Remotes

--// Options

local RemotesToGUID : boolean = false

--// Options - Proposital Anti Data-Loss

local StringLimiterLength: number = 100

local TableLimiter: boolean = true 
local TableExceeded: number = 5

--// Common Functions

local function GetRemote(RemoteType: string, RemoteName: string) : Instance?
	local CurrentRemote: Instance? = MyRemotes[RemoteType][RemoteName]

	if not CurrentRemote then
		warn(`Remote {RemoteType}: {RemoteName} has not found`)
		return
	end

	return CurrentRemote
end

local function GetNewParameters(...) : any --// Anti Data-Loss Proposital Client
	local Args = {...}

	local Counts = {}

	local function VerifyTable(Table, BaseGUID)
		local function ResetCount()
			Counts = {}	
		end

		for Key, Value in pairs(Table) do
			if typeof(Value) ~= "table" then continue end

			local GUID = nil

			if not BaseGUID then
				GUID = HttpService:GenerateGUID()
				Counts[GUID] = 0
			end

			local CurrentGUID = BaseGUID or GUID
			Counts[CurrentGUID] += 1 

			if Counts[CurrentGUID] >= TableExceeded then
				return true
			end

			local Response = VerifyTable(Value, CurrentGUID)

			if Response then
				ResetCount()				
				return true
			end
		end

		ResetCount()		
		return false
	end

	local function GetArgParameter(Arg: any)
		if typeof(Arg) == "string" then
			if utf8.len(Arg) == nil then
				return "255"
			elseif #Arg >= StringLimiterLength then
				return string.sub(Arg, 1, StringLimiterLength)
			end
		end

		if typeof(Arg) == "table" and TableLimiter then
			if VerifyTable(Arg) then return {} end
		end

		if Arg ~= Arg then return 1 end

		return Arg
	end

	for Index, Arg in ipairs(Args) do
		local ToIndex = GetArgParameter(Arg)
		Args[Index] = ToIndex
	end

	return unpack(Args)
end

local function UpdateRemotes(RemoteTable: RemotesData)
	Network.Remotes =  RemoteTable
	MyRemotes = RemoteTable
end

--// Network Functions

function Network:FireServer(RemoteName: string, ...)
	local Remote = GetRemote("Events", RemoteName)

	if not Remote then return end

	Remote:FireServer(GetNewParameters(...))
end

function Network:InvokeServer(RemoteName: string, ...) : any
	local Remote = GetRemote("Functions", RemoteName)

	if not Remote then return end

	return Remote:InvokeServer(GetNewParameters(...))
end

function Network:FireAllClients(RemoteName: string, ...)
	local Remote = GetRemote("Events", RemoteName)

	if not Remote then return end

	Remote:FireAllClients(...)
end

function Network:FireClient(RemoteName: string, ...)
	local Remote = GetRemote("Events", RemoteName)

	if not Remote then return end

	Remote:FireClient(...)
end

function Network:CreateConnectionOf(Type: string, RemoteName: string, Function: <a>(a) -> (), ...)
	local Remote: Instance = GetRemote(Type, RemoteName)
	local ConnectionType: string = "On" .. self.Current .. (Type == "Events" and "Event" or "Invoke")

	local AdditionalArgs: {any} = {...}

	if not Remote then return end

	if Type == "Events" then --// Remote Events

		Remote[ConnectionType]:Connect(function(...)
			Function(unpack(AdditionalArgs), ...)
		end)

		return
	end

	--// Remote Functions

	Remote[ConnectionType] = function(...)
		Function(AdditionalArgs[1], AdditionalArgs[2], ...)
	end
end

--// Client-Server Inits

function ClientServer:Client()
	local Player: Player = game.Players.LocalPlayer

	local InfoRemote: RemoteFunction = Player:WaitForChild("_getInfo")	
	local MyInfo = InfoRemote:InvokeServer()

	UpdateRemotes(MyInfo)
end

function ClientServer:Server()

	--// Changing Remotes Names

	for _, Remote in ipairs(self.RemotesFolder:GetDescendants()) do
		if not Remote:IsA("RemoteEvent") and not Remote:IsA("RemoteFunction") then continue end

		MyRemotes[Remote:IsA("RemoteEvent") and "Events" or "Functions"][Remote.Name] = Remote

		Remote.Name = RemotesToGUID and HttpService:GenerateGUID(true) or ""
	end	

	UpdateRemotes(self.Remotes)

	--// Connection Create - Give information to player

	game.Players.PlayerAdded:Connect(function(Player: Player)
		local PlayerRemote: RemoteFunction = Instance.new("RemoteFunction")
		PlayerRemote.Name = "_getInfo"
		PlayerRemote.Parent = Player

		PlayerRemote.OnServerInvoke = function(PlayerInvoked: Player)
			if Player ~= PlayerInvoked or PlayerRemote.Name ~= "_getInfo" then return end

			task.delay(.4, function()
				PlayerRemote:Destroy()
			end)	

			PlayerRemote.Name = "_used"

			return MyRemotes
		end
	end)
end

--// StartUp

function Network:Init(RemoteFolder: Folder) 
	self.RemotesFolder = RemoteFolder
	self.Current = RunService:IsClient() and "Client" or "Server"

	print("Inited: " .. self.Current)

	return ClientServer[self.Current](Network)
end

return setmetatable(Network, {
	__mode = "k"
})
