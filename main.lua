local W = workspace
local P = game:GetService("Players")
local R = game:GetService("RunService")
local U = game:GetService("UserInputService")
local PFS = game:GetService("PathfindingService")

local p = P.LocalPlayer
local camera = W.CurrentCamera
local sp, n, fl, esp, cs = false, false, false, false, 16
local bv, bg, eo, nc = nil, nil, {}, nil

local sg = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))
sg.Name = "COOLGUI_Loader"
sg.ResetOnSpawn = false

local f = Instance.new("Frame", sg)
f.Size = UDim2.new(0, 240, 0, 460)
f.Position = UDim2.new(0.5, -120, 0.5, -230)
f.BackgroundColor3 = Color3.new(0, 0, 0)
f.Active = true
f.Draggable = true

local s1 = Instance.new("UIStroke", f)
s1.Color = Color3.fromRGB(255, 0, 4)
s1.Thickness = 2

local tl = Instance.new("TextLabel", f)
tl.Size = UDim2.new(1, 0, 0, 50)
tl.BackgroundColor3 = Color3.new(0, 0, 0)
tl.Text = "COOLGUI"
tl.TextColor3 = Color3.fromRGB(255, 0, 4)
tl.TextSize = 24
tl.Font = Enum.Font.SourceSansBold

local l = Instance.new("UIListLayout", f)
l.Padding = UDim.new(0, 6)
l.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function cB(text, order)
	local b = Instance.new("TextButton", f)
	b.Size = UDim2.new(0, 210, 0, 35)
	b.BackgroundColor3 = Color3.new(0, 0, 0)
	b.Text = text
	b.TextColor3 = Color3.new(1, 1, 1)
	b.TextSize = 16
	b.Font = Enum.Font.SourceSansBold
	b.LayoutOrder = order
	local s = Instance.new("UIStroke", b)
	s.Color = Color3.fromRGB(255, 0, 4)
	return b
end

local nB = cB("Noclip", 1)
local fB = cB("Fly", 2)
local sB = cB("Speed", 3)
local tb = Instance.new("TextBox", f)
tb.Size = UDim2.new(0, 210, 0, 35)
tb.BackgroundColor3 = Color3.new(0, 0, 0)
tb.Text = "16"
tb.TextColor3 = Color3.new(1, 1, 1)
tb.TextSize = 16
tb.Font = Enum.Font.SourceSansBold
tb.LayoutOrder = 4
local s2 = Instance.new("UIStroke", tb)
s2.Color = Color3.fromRGB(255, 0, 4)

local wB = cB("Wallhack", 5)
local tB = cB("Teleport", 6)
local cB_Button = cB("fly with player", 7)

local tlS = Instance.new("ScrollingFrame", f)
tlS.Size = UDim2.new(0, 220, 0, 150)
tlS.Position = UDim2.new(1, 10, 0, 0)
tlS.BackgroundColor3 = Color3.new(0, 0, 0)
tlS.ScrollBarThickness = 6
tlS.ScrollBarImageColor3 = Color3.fromRGB(128, 128, 128)
tlS.ScrollBarImage = "rbxassetid://13504358693"
tlS.ClipsDescendants = true
tlS.Visible = false
local s3 = Instance.new("UIStroke", tlS)
s3.Color = Color3.fromRGB(255, 0, 4)
local ll = Instance.new("UIListLayout", tlS)
ll.Padding = UDim.new(0, 5)

sB.MouseButton1Click:Connect(function()
	local num = tonumber(tb.Text)
	if not num or num <= 16 then
		cs = 16
		sp = false
	else
		cs = num + 16
		sp = true
	end
end)

nB.MouseButton1Click:Connect(function()
	n = not n
	if n then
		nc = R.Stepped:Connect(function()
			local ch = p.Character
			if ch then
				for _, v in pairs(ch:GetChildren()) do
					if v:IsA("BasePart") then v.CanCollide = false end
				end
			end
		end)
	else
		if nc then nc:Disconnect() nc = nil end
		local ch = p.Character
		if ch then
			for _, v in pairs(ch:GetChildren()) do
				if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.CanCollide = true end
			end
		end
	end
end)

fB.MouseButton1Click:Connect(function()
	local ch = p.Character
	local h = ch and ch:FindFirstChild("Humanoid")
	local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
	if not hrp or not h then return end
	fl = not fl
	if fl then
		bv = Instance.new("BodyVelocity", hrp)
		bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bv.Velocity = Vector3.zero
		bg = Instance.new("BodyGyro", hrp)
		bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		bg.CFrame = hrp.CFrame
		bg.P = 3000
		h:ChangeState(Enum.HumanoidStateType.Physics)
	else
		if bv then bv:Destroy() bv = nil end
		if bg then bg:Destroy() bg = nil end
		h:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
end)

local isTPOpen = false
local function gTI(m)
	local cP = P:GetPlayerFromCharacter(m)
	if cP and cP.Team then return cP.Team.Name, cP.TeamColor.Color end
	return "No Team", Color3.fromRGB(255, 0, 4)
end

local function rE(m)
	if eo[m] then
		for _, v in pairs(eo[m].ins) do if v then v:Destroy() end end
		eo[m] = nil
	end
end
local function aE(m)
	if m == p.Character or eo[m] then return end
	local hrp = m:FindFirstChild("HumanoidRootPart")
	local h = m:FindFirstChild("Humanoid")
	if not hrp or not h then return end
	local tN, eC = gTI(m)
	local ins = {}
	local hl = Instance.new("Highlight", m)
	hl.FillColor = eC
	hl.FillTransparency = 0.5
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	table.insert(ins, hl)
	local bx = Instance.new("SelectionBox", hrp)
	bx.Color3 = eC
	bx.LineThickness = 0.04
	bx.Adornee = m
	table.insert(ins, bx)
	local bb = Instance.new("BillboardGui", hrp)
	bb.Size = UDim2.new(0, 300, 0, 50)
	bb.AlwaysOnTop = true
	bb.StudsOffset = Vector3.new(0, 4, 0)
	bb.Adornee = hrp
	table.insert(ins, bb)
	local lbl = Instance.new("TextLabel", bb)
	lbl.Size = UDim2.new(1, 0, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.TextColor3 = Color3.new(1, 1, 1)
	lbl.TextStrokeTransparency = 0
	lbl.TextSize = 14
	lbl.Font = Enum.Font.SourceSansBold
	lbl.Text = m.Name
	table.insert(ins, lbl)
	local pf = Instance.new("Folder", W)
	pf.Name = "PathNodes"
	table.insert(ins, pf)
	eo[m] = { ins = ins, lbl = lbl, pf = pf, hrp = hrp, h = h, tN = tN }
end

local function cNS(p1, p2, f)
	local d = (p1 - p2).Magnitude
	if d < 0.1 then return end
	local a = Instance.new("CylinderHandleAdornment", f)
	a.Radius = 0.12
	a.Height = d
	a.Color3 = Color3.fromRGB(0, 255, 255)
	a.AlwaysOnTop = true
	a.Adornee = workspace.CurrentCamera
	a.CFrame = CFrame.lookAt(p1, p2) * CFrame.new(0, 0, -d / 2)
end

local function d90(d, mH)
	local f = d.pf
	local sP = mH.Position - Vector3.new(0, 2.3, 0)
	local eP = d.hrp.Position - Vector3.new(0, 2.3, 0)
	if n then
		f:ClearAllChildren()
		cNS(sP, eP, f)
		return
	end
	local rp = RaycastParams.new()
	rp.FilterType = Enum.RaycastFilterType.Exclude
	rp.FilterDescendantsInstances = { p.Character, d.hrp.Parent, f }
	local rR = W:Raycast(mH.Position, Vector3.new(0, -500, 0), rp)
	local gY = rR and rR.Position.Y or eP.Y
	local mGP = Vector3.new(mH.Position.X, gY + 0.2, mH.Position.Z)
	if fl then
		local path = PFS:CreatePath({ AgentRadius = 2, AgentHeight = 5, AgentCanJump = true })
		local s, _ = pcall(function() path:ComputeAsync(eP, mGP) end)
		if s and path.Status == Enum.PathStatus.Success then
			local w = path:GetWaypoints()
			if #w >= 2 then
				f:ClearAllChildren()
				for i = 1, #w - 1 do
					cNS(w[i].Position + Vector3.new(0, 0.2, 0), w[i + 1].Position + Vector3.new(0, 0.2, 0), f)
				end
				cNS(w[#w].Position + Vector3.new(0, 0.2, 0), sP, f)
				return
			end
		end
	else
		local path = PFS:CreatePath({ AgentRadius = 2, AgentHeight = 5, AgentCanJump = true })
		local s, _ = pcall(function() path:ComputeAsync(eP, sP) end)
		if s and path.Status == Enum.PathStatus.Success then
			local w = path:GetWaypoints()
			if #w >= 2 then
				f:ClearAllChildren()
				for i = 1, #w - 1 do
					cNS(w[i].Position + Vector3.new(0, 0.2, 0), w[i + 1].Position + Vector3.new(0, 0.2, 0), f)
				end
				return
			end
		end
	end
	f:ClearAllChildren()
	cNS(sP, eP, f)
end

wB.MouseButton1Click:Connect(function()
	esp = not esp
	if esp then
		for _, v in pairs(W:GetDescendants()) do
			if v:IsA("Humanoid") then
				local m = v.Parent
				if m and m:IsA("Model") then aE(m) end
			end
		end
	else
		for m, _ in pairs(eo) do rE(m) end
	end
end)

local function rTL()
	for _, v in pairs(tlS:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
	for _, v in pairs(W:GetDescendants()) do
		if v:IsA("Humanoid") then
			local m = v.Parent
			if m and m:IsA("Model") and m ~= p.Character then
				local hrp = m:FindFirstChild("HumanoidRootPart")
				if hrp then
					local tN = gTI(m)
					local hp = math.round(v.Health)
					local r = Instance.new("TextButton", tlS)
					r.Size = UDim2.new(1, -6, 0, 30)
					r.BackgroundColor3 = Color3.new(0, 0, 0)
					r.TextColor3 = Color3.new(1, 1, 1)
					r.TextSize = 14
					r.Font = Enum.Font.SourceSansBold
					r.Text = "  " .. m.Name .. " [" .. tN .. " ] [" .. hp .. " HP]"
					r.TextXAlignment = Enum.TextXAlignment.Left
					local s = Instance.new("UIStroke", r)
					s.Color = Color3.fromRGB(255, 0, 4)
					r.MouseButton1Click:Connect(function()
						local mH = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
						if mH then mH.CFrame = hrp.CFrame * CFrame.new(0, 3, 0) end
					end)
				end
			end
		end
	end
end

tB.MouseButton1Click:Connect(function()
	isTPOpen = not isTPOpen
	tlS.Visible = isTPOpen
	if isTPOpen then rTL() end
end)

local cHA, cV = false, nil
local function fNV(mH)
	local cM, sD = nil, 20
	for _, v in pairs(W:GetDescendants()) do
		if v:IsA("Humanoid") then
			local m = v.Parent
			if m and m:IsA("Model") and m ~= p.Character and v.Health > 0 then
				local hrp = m:FindFirstChild("HumanoidRootPart")
				if hrp then
					local d = (mH.Position - hrp.Position).Magnitude
					if d < sD then sD = d cM = m end
				end
			end
		end
	end
	return cM
end

cB_Button.MouseButton1Click:Connect(function()
	local mH = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
	if not mH then return end
	cHA = not cHA
	if cHA then cV = fNV(mH) else cV = nil end
end)

R.Heartbeat:Connect(function()
	local ch = p.Character
	local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	if fl and bv and bg then
		local mD = Vector3.zero
		if U:IsKeyDown(Enum.KeyCode.W) then mD += camera.CFrame.LookVector end
		if U:IsKeyDown(Enum.KeyCode.S) then mD -= camera.CFrame.LookVector end
		if U:IsKeyDown(Enum.KeyCode.A) then mD -= camera.CFrame.RightVector end
		if U:IsKeyDown(Enum.KeyCode.D) then mD += camera.CFrame.RightVector end
		if U:IsKeyDown(Enum.KeyCode.Space) then mD += Vector3.new(0, 1, 0) end
		if U:IsKeyDown(Enum.KeyCode.LeftShift) then mD -= Vector3.new(0, 1, 0) end
		bg.CFrame = camera.CFrame
		bv.Velocity = mD.Magnitude > 0 and mD.Unit * (cs == 16 and 50 or cs) or Vector3.zero
	end
	if not fl and sp then
		local h = ch:FindFirstChild("Humanoid")
		if h and h.MoveDirection.Magnitude > 0 then
			local eS = cs - h.WalkSpeed
			local vB = h.MoveDirection.Unit * eS
			hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X + vB.X * 0.45, hrp.AssemblyLinearVelocity.Y, hrp.AssemblyLinearVelocity.Z + vB.Z * 0.45)
		end
	end
	if esp then
		for m, data in pairs(eo) do
			if not m.Parent or not data.hrp:IsDescendantOf(W) then rE(m) continue end
			local hp = math.round(data.h.Health)
			local d = math.round((hrp.Position - data.hrp.Position).Magnitude)
			data.lbl.Text = m.Name .. " [" .. data.tN .. "] [" .. hp .. " HP] [" .. d .. " Studs]"
			d90(data, hrp)
		end
	end
	if cHA and cV and cV.Parent then
		local vH = cV:FindFirstChild("HumanoidRootPart")
		local vM = cV:FindFirstChild("Humanoid")
		if vH then
			vH.AssemblyLinearVelocity = Vector3.zero
			vH.AssemblyAngularVelocity = Vector3.zero
			if vM then vM:ChangeState(Enum.HumanoidStateType.Physics) end
			vH.CFrame = hrp.CFrame * CFrame.new(0, 3.5, 0.5)
		end
	end
end)
