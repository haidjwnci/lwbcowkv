-- ============================================================
-- 小贺脚本 V16 · 最终完整版
-- 作者：H831288he9  QQ群：1104880878
-- 包含：环绕甩飞 + 终极防甩飞 + 自瞄Pro + ESP + 角色特效 + 作者白名单
-- ============================================================

-- 防重复加载
if _G.HeScriptLoaded then
    pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="小贺脚本",Text="脚本已在运行，请勿重复执行",Duration=3}) end)
    return
end
_G.HeScriptLoaded=true
pcall(function()
    local pg=game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    for _,g in ipairs(pg:GetChildren()) do
        if g.Name=="HeUI_V16" or g.Name=="HeIntro" or g.Name=="FlyP_V16" or g.Name=="AimFOV" or g.Name=="ESP_V16" or g.Name=="PSel" or g.Name=="PlayerList" then
            g:Destroy()
        end
    end
end)

local TweenService=game:GetService("TweenService")
local Players=game:GetService("Players")
local UserInputService=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local HttpService=game:GetService("HttpService")
local Debris=game:GetService("Debris")
local LocalPlayer=Players.LocalPlayer
local PlayerGui=LocalPlayer:WaitForChild("PlayerGui")
local Camera=workspace.CurrentCamera
local AUTHOR_NAME="H831288he9"
local authorTags={}

local function safe(fn,name)
    return function(...)
        local ok,err=pcall(fn,...)
        if not ok then warn("[小贺V16]["..(name or "?").."] "..tostring(err)) end
    end
end

-- ===================== 作者白名单标签 =====================
local function createAuthorTag(plr)
    if authorTags[plr] then
        if not authorTags[plr].Parent then pcall(function() authorTags[plr]:Destroy() end);authorTags[plr]=nil else return end
    end
    local char=plr.Character;if not char then return end
    local head=char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart");if not head then return end
    local bb=Instance.new("BillboardGui");bb.Name="HeAuthorTag"
    bb.Size=UDim2.new(0,220,0,42);bb.StudsOffset=Vector3.new(0,3.8,0)
    bb.AlwaysOnTop=true;bb.MaxDistance=150;bb.LightInfluence=0;bb.Parent=head
    local frame=Instance.new("Frame");frame.Size=UDim2.fromScale(1,1)
    frame.BackgroundColor3=Color3.fromRGB(60,20,100);frame.BackgroundTransparency=0.15;frame.BorderSizePixel=0;frame.Parent=bb
    Instance.new("UICorner",frame).CornerRadius=UDim.new(0,10)
    local stroke=Instance.new("UIStroke");stroke.Thickness=2.5;stroke.Color=Color3.fromRGB(255,215,0);stroke.Transparency=0.1;stroke.Parent=frame
    local label=Instance.new("TextLabel");label.Size=UDim2.fromScale(1,1);label.BackgroundTransparency=1
    label.Text="✦ 小贺脚本作者 ✦";label.TextColor3=Color3.fromRGB(255,215,0)
    label.TextSize=17;label.Font=Enum.Font.GothamBold;label.TextStrokeTransparency=0.4;label.Parent=frame
    authorTags[plr]=bb
    task.spawn(function()
        while bb and bb.Parent do
            pcall(function()
                TweenService:Create(stroke,TweenInfo.new(0.9),{Color=Color3.fromRGB(200,100,255)}):Play()
                TweenService:Create(label,TweenInfo.new(0.9),{TextColor3=Color3.fromRGB(200,150,255)}):Play()
            end);task.wait(0.9)
            pcall(function()
                TweenService:Create(stroke,TweenInfo.new(0.9),{Color=Color3.fromRGB(255,215,0)}):Play()
                TweenService:Create(label,TweenInfo.new(0.9),{TextColor3=Color3.fromRGB(255,215,0)}):Play()
            end);task.wait(0.9)
        end
    end)
end
local function removeAuthorTag(plr)
    if authorTags[plr] then pcall(function() authorTags[plr]:Destroy() end);authorTags[plr]=nil end
end
local function scanAuthors()
    for _,plr in Players:GetPlayers() do
        if plr.Name==AUTHOR_NAME and plr.Character and(plr.Character:FindFirstChild("Head")or plr.Character:FindFirstChild("HumanoidRootPart"))then createAuthorTag(plr) end
    end
    for plr,tag in pairs(authorTags) do
        if not plr.Parent or not plr.Character or not tag.Parent then removeAuthorTag(plr) end
    end
end
Players.PlayerAdded:Connect(function(plr)
    if plr.Name==AUTHOR_NAME then plr.CharacterAdded:Connect(function() task.wait(1.2);createAuthorTag(plr) end) end
end)
Players.PlayerRemoving:Connect(removeAuthorTag)
for _,plr in Players:GetPlayers() do
    if plr.Name==AUTHOR_NAME then
        if plr.Character then task.wait(0.5);createAuthorTag(plr) end
        plr.CharacterAdded:Connect(function() task.wait(1.2);createAuthorTag(plr) end)
    end
end
RunService.Heartbeat:Connect(safe(scanAuthors,"作者标签"))
if LocalPlayer.Name==AUTHOR_NAME then
    task.wait(1);createAuthorTag(LocalPlayer)
    LocalPlayer.CharacterAdded:Connect(function() task.wait(1.2);createAuthorTag(LocalPlayer) end)
end

-- ===================== 魔幻开场 =====================
local IntroGui=Instance.new("ScreenGui")
IntroGui.Name="HeIntro";IntroGui.IgnoreGuiInset=true;IntroGui.ResetOnSpawn=false
IntroGui.DisplayOrder=9999;IntroGui.Parent=PlayerGui
local Bg=Instance.new("Frame");Bg.Size=UDim2.fromScale(1,1)
Bg.BackgroundColor3=Color3.fromRGB(8,4,20);Bg.BackgroundTransparency=1;Bg.Parent=IntroGui
for i=1,60 do
    local s=Instance.new("Frame");s.Size=UDim2.fromOffset(math.random(1,3),math.random(1,3))
    s.Position=UDim2.fromScale(math.random(),math.random())
    s.BackgroundColor3=Color3.fromRGB(math.random(180,255),math.random(160,230),255)
    s.BackgroundTransparency=1;s.BorderSizePixel=0;Instance.new("UICorner",s).CornerRadius=UDim.new(1,0)
    s.Parent=Bg;task.spawn(function() task.wait(math.random(0,0.5))
        TweenService:Create(s,TweenInfo.new(0.4),{BackgroundTransparency=math.random(3,7)/10}):Play() end)
end
local Core=Instance.new("TextLabel");Core.AnchorPoint=Vector2.new(0.5,0.5)
Core.Position=UDim2.fromScale(0.5,0.4);Core.Size=UDim2.fromOffset(120,120)
Core.BackgroundTransparency=1;Core.Text="✦";Core.TextColor3=Color3.fromRGB(200,160,255)
Core.TextSize=80;Core.Font=Enum.Font.GothamBold;Core.TextTransparency=1;Core.Parent=IntroGui
local function mkRing(sz,c,t)
    local r=Instance.new("Frame");r.AnchorPoint=Vector2.new(0.5,0.5)
    r.Position=UDim2.fromScale(0.5,0.4);r.Size=UDim2.fromOffset(sz,sz)
    r.BackgroundTransparency=1;r.Parent=IntroGui;Instance.new("UICorner",r).CornerRadius=UDim.new(1,0)
    local st=Instance.new("UIStroke");st.Thickness=t;st.Transparency=1;st.Color=c;st.Parent=r;return r,st
end
local R1,S1=mkRing(100,Color3.fromRGB(140,180,255),2)
local R2,S2=mkRing(170,Color3.fromRGB(200,120,255),2)
local R3,S3=mkRing(240,Color3.fromRGB(255,120,200),1)
local Title=Instance.new("TextLabel");Title.AnchorPoint=Vector2.new(0.5,0.5)
Title.Position=UDim2.fromScale(0.5,0.56);Title.Size=UDim2.fromOffset(400,50)
Title.BackgroundTransparency=1;Title.Text="";Title.TextColor3=Color3.new(1,1,1)
Title.TextSize=34;Title.Font=Enum.Font.GothamBold;Title.Parent=IntroGui
local Sub=Instance.new("TextLabel");Sub.AnchorPoint=Vector2.new(0.5,0.5)
Sub.Position=UDim2.fromScale(0.5,0.62);Sub.Size=UDim2.fromOffset(400,25)
Sub.BackgroundTransparency=1;Sub.Text="";Sub.TextColor3=Color3.fromRGB(180,160,255)
Sub.TextSize=13;Sub.Font=Enum.Font.Code;Sub.Parent=IntroGui
local Pbg=Instance.new("Frame");Pbg.AnchorPoint=Vector2.new(0.5,0.5)
Pbg.Position=UDim2.fromScale(0.5,0.70);Pbg.Size=UDim2.fromOffset(260,6)
Pbg.BackgroundColor3=Color3.fromRGB(25,15,50);Pbg.BackgroundTransparency=0.2;Pbg.Parent=IntroGui
Instance.new("UICorner",Pbg).CornerRadius=UDim.new(1,0)
local Pf=Instance.new("Frame");Pf.Size=UDim2.new(0,0,1,0)
Pf.BackgroundColor3=Color3.fromRGB(160,100,255);Pf.Parent=Pbg
Instance.new("UICorner",Pf).CornerRadius=UDim.new(1,0)
local Pt=Instance.new("TextLabel");Pt.AnchorPoint=Vector2.new(0.5,0.5)
Pt.Position=UDim2.fromScale(0.5,0.75);Pt.Size=UDim2.fromOffset(200,20)
Pt.BackgroundTransparency=1;Pt.Text="0%";Pt.TextColor3=Color3.fromRGB(180,160,255)
Pt.TextSize=12;Pt.Font=Enum.Font.Code;Pt.Parent=IntroGui
local function tw(o,txt,sp) for i=1,#txt do o.Text=string.sub(txt,1,i);task.wait(sp) end end
TweenService:Create(Bg,TweenInfo.new(0.5),{BackgroundTransparency=0}):Play();task.wait(0.3)
TweenService:Create(Core,TweenInfo.new(0.8,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{TextTransparency=0,TextSize=100}):Play()
TweenService:Create(S1,TweenInfo.new(0.8),{Transparency=0}):Play()
TweenService:Create(S2,TweenInfo.new(0.8),{Transparency=0}):Play()
TweenService:Create(S3,TweenInfo.new(0.8),{Transparency=0.5}):Play()
task.wait(0.3);tw(Title,"小贺脚本 V16",0.06);task.wait(0.1);tw(Sub,"SYSTEM LOADING...",0.04)
task.spawn(function() while IntroGui.Parent do R1.Rotation+=4;R2.Rotation-=3;R3.Rotation+=2;task.wait(0.02) end end)
for i=1,12 do task.spawn(function()
    local p=Instance.new("TextLabel");p.AnchorPoint=Vector2.new(0.5,0.5)
    p.Position=UDim2.fromScale(0.5,0.4);p.Size=UDim2.fromOffset(20,20)
    p.BackgroundTransparency=1;p.Text="✦";p.TextSize=math.random(8,18)
    p.TextColor3=Color3.fromRGB(math.random(150,255),math.random(100,200),255);p.Parent=IntroGui
    local a=math.rad(math.random(0,360));local d=math.random(100,280)
    TweenService:Create(p,TweenInfo.new(math.random(7,14)/10,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{
        Position=UDim2.fromScale(0.5+math.cos(a)*d/1000,0.4+math.sin(a)*d/1000),
        TextTransparency=1,Rotation=math.random(-180,180)}):Play()
    Debris:AddItem(p,1.5)
end);task.wait(0.03) end
for i=0,100,4 do Pf.Size=UDim2.new(i/100,0,1,0);Pt.Text=i.."%";task.wait(0.02) end
Pt.Text="100%";task.wait(0.3)
local Flash=Instance.new("Frame");Flash.Size=UDim2.fromScale(1,1)
Flash.BackgroundColor3=Color3.fromRGB(200,160,255);Flash.BackgroundTransparency=1;Flash.Parent=IntroGui
TweenService:Create(Flash,TweenInfo.new(0.2),{BackgroundTransparency=0}):Play();task.wait(0.15)
TweenService:Create(Bg,TweenInfo.new(0.5),{BackgroundTransparency=1}):Play()
TweenService:Create(Core,TweenInfo.new(0.5),{TextTransparency=1,TextSize=160}):Play()
TweenService:Create(S1,TweenInfo.new(0.5),{Transparency=1}):Play()
TweenService:Create(S2,TweenInfo.new(0.5),{Transparency=1}):Play()
TweenService:Create(S3,TweenInfo.new(0.5),{Transparency=1}):Play()
TweenService:Create(Title,TweenInfo.new(0.4),{TextTransparency=1}):Play()
TweenService:Create(Sub,TweenInfo.new(0.4),{TextTransparency=1}):Play()
TweenService:Create(Pbg,TweenInfo.new(0.4),{BackgroundTransparency=1}):Play()
TweenService:Create(Pt,TweenInfo.new(0.4),{TextTransparency=1}):Play()
TweenService:Create(Flash,TweenInfo.new(0.4),{BackgroundTransparency=1}):Play()
for _,s in ipairs(Bg:GetChildren()) do if s:IsA("Frame") then TweenService:Create(s,TweenInfo.new(0.4),{BackgroundTransparency=1}):Play() end end
task.wait(0.6);IntroGui:Destroy()

-- 反挂机
pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="小贺脚本",Text="反挂机已开启",Duration=3}) end)
local vu=game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function() pcall(function()
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    task.wait(1);vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end) end)

-- ===================== 主菜单UI =====================
local MainGui=Instance.new("ScreenGui")
MainGui.Name="HeUI_V16";MainGui.IgnoreGuiInset=true;MainGui.ResetOnSpawn=false
MainGui.DisplayOrder=900;MainGui.Parent=PlayerGui
local COL={Bg=Color3.fromRGB(15,10,35),Bg2=Color3.fromRGB(25,18,50),
    Accent=Color3.fromRGB(160,100,255),Accent2=Color3.fromRGB(80,180,255),
    Text=Color3.fromRGB(240,235,255),TextDim=Color3.fromRGB(160,155,190),
    Button=Color3.fromRGB(30,22,55),On=Color3.fromRGB(80,200,130),Off=Color3.fromRGB(55,48,80)}

local FloatBtn=Instance.new("TextButton")
FloatBtn.Size=UDim2.fromOffset(52,52);FloatBtn.Position=UDim2.new(0,16,0.5,-26)
FloatBtn.BackgroundColor3=COL.Accent;FloatBtn.Text="✦";FloatBtn.TextColor3=Color3.new(1,1,1)
FloatBtn.TextSize=26;FloatBtn.Font=Enum.Font.GothamBold;FloatBtn.AutoButtonColor=false;FloatBtn.Parent=MainGui
Instance.new("UICorner",FloatBtn).CornerRadius=UDim.new(1,0)
local FB=Instance.new("UIStroke");FB.Thickness=2;FB.Color=COL.Accent2;FB.Transparency=0.4;FB.Parent=FloatBtn
task.spawn(function() while FloatBtn.Parent do
    TweenService:Create(FloatBtn,TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundColor3=COL.Accent2}):Play()
    TweenService:Create(FB,TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Color=COL.Accent}):Play()
    task.wait(1)
    TweenService:Create(FloatBtn,TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundColor3=COL.Accent}):Play()
    TweenService:Create(FB,TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Color=COL.Accent2}):Play()
    task.wait(1)
end end)

local Panel=Instance.new("Frame")
Panel.AnchorPoint=Vector2.new(0.5,0.5);Panel.Position=UDim2.new(0.5,0,0.5,0)
Panel.Size=UDim2.new(0,640,0,440);Panel.BackgroundColor3=COL.Bg;Panel.BackgroundTransparency=1
Panel.Visible=false;Panel.Parent=MainGui
Instance.new("UICorner",Panel).CornerRadius=UDim.new(0,16)
local PB=Instance.new("UIStroke");PB.Thickness=2;PB.Color=COL.Accent;PB.Transparency=0.5;PB.Parent=Panel

local dbf=Instance.new("Frame");dbf.Size=UDim2.fromScale(1,1);dbf.BackgroundColor3=Color3.fromRGB(10,6,25)
dbf.ZIndex=1;dbf.Parent=Panel;Instance.new("UICorner",dbf).CornerRadius=UDim.new(0,16)
local g1=Instance.new("Frame");g1.Size=UDim2.fromOffset(220,220);g1.Position=UDim2.new(0,-60,0,-60)
g1.BackgroundColor3=Color3.fromRGB(130,70,210);g1.ZIndex=1;g1.Parent=dbf
Instance.new("UICorner",g1).CornerRadius=UDim.new(1,0)
local gg1=Instance.new("UIGradient");gg1.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)});gg1.Parent=g1
local g2=Instance.new("Frame");g2.Size=UDim2.fromOffset(200,200);g2.Position=UDim2.new(1,-90,1,-90)
g2.BackgroundColor3=Color3.fromRGB(70,150,230);g2.ZIndex=1;g2.Parent=dbf
Instance.new("UICorner",g2).CornerRadius=UDim.new(1,0)
local gg2=Instance.new("UIGradient");gg2.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)});gg2.Parent=g2
local dim=Instance.new("Frame");dim.Size=UDim2.fromScale(1,1);dim.BackgroundColor3=Color3.fromRGB(5,3,15)
dim.BackgroundTransparency=0.5;dim.ZIndex=2;dim.Parent=dbf;Instance.new("UICorner",dim).CornerRadius=UDim.new(0,16)
task.spawn(function() while dbf.Parent do
    TweenService:Create(g1,TweenInfo.new(2.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundTransparency=0.25}):Play()
    TweenService:Create(g2,TweenInfo.new(3,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundTransparency=0.35}):Play()
    task.wait(2.5)
    TweenService:Create(g1,TweenInfo.new(2.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundTransparency=0.55}):Play()
    TweenService:Create(g2,TweenInfo.new(3,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundTransparency=0.65}):Play()
    task.wait(2.5)
end end)

local Header=Instance.new("Frame");Header.Size=UDim2.new(1,0,0,44)
Header.BackgroundColor3=COL.Bg2;Header.BackgroundTransparency=0.3;Header.ZIndex=3;Header.Parent=Panel
Instance.new("UICorner",Header).CornerRadius=UDim.new(0,16)
local HT=Instance.new("TextLabel");HT.Size=UDim2.new(1,-100,1,0);HT.Position=UDim2.new(0,16,0,0)
HT.BackgroundTransparency=1;HT.Text="✦ 小贺脚本 V16";HT.TextColor3=COL.Text
HT.TextSize=16;HT.Font=Enum.Font.GothamBold;HT.TextXAlignment=Enum.TextXAlignment.Left;HT.ZIndex=4;HT.Parent=Header
local CloseBtn=Instance.new("TextButton");CloseBtn.Size=UDim2.fromOffset(36,36)
CloseBtn.Position=UDim2.new(1,-42,0,4);CloseBtn.BackgroundColor3=COL.Button
CloseBtn.Text="✕";CloseBtn.TextColor3=COL.TextDim;CloseBtn.TextSize=14
CloseBtn.AutoButtonColor=false;CloseBtn.ZIndex=4;CloseBtn.Parent=Header
Instance.new("UICorner",CloseBtn).CornerRadius=UDim.new(1,0)

local TabBar=Instance.new("Frame");TabBar.Size=UDim2.new(0,115,1,-52)
TabBar.Position=UDim2.new(0,8,0,50);TabBar.BackgroundColor3=COL.Bg2
TabBar.BackgroundTransparency=0.4;TabBar.ZIndex=3;TabBar.Parent=Panel
Instance.new("UICorner",TabBar).CornerRadius=UDim.new(0,10)
local TLL=Instance.new("UIListLayout");TLL.Padding=UDim.new(0,6);TLL.SortOrder=Enum.SortOrder.LayoutOrder;TLL.Parent=TabBar
local TPP=Instance.new("UIPadding");TPP.PaddingTop=UDim.new(0,8);TPP.PaddingLeft=UDim.new(0,6);TPP.PaddingRight=UDim.new(0,6);TPP.Parent=TabBar

local Content=Instance.new("ScrollingFrame");Content.Size=UDim2.new(1,-135,1,-52)
Content.Position=UDim2.new(0,127,0,50);Content.BackgroundTransparency=1;Content.BorderSizePixel=0
Content.ScrollBarThickness=6;Content.ScrollBarImageColor3=COL.Accent
Content.CanvasSize=UDim2.new(0,0,0,0);Content.AutomaticCanvasSize=Enum.AutomaticSize.Y;Content.ZIndex=3;Content.Parent=Panel

local Tabs={};local TabBtns={}
local function createTab(n)
    local c=Instance.new("Frame");c.Size=UDim2.new(1,0,0,0);c.BackgroundTransparency=1
    c.AutomaticSize=Enum.AutomaticSize.Y;c.Visible=false;c.ZIndex=4;c.Parent=Content
    local ll=Instance.new("UIListLayout");ll.Padding=UDim.new(0,6);ll.SortOrder=Enum.SortOrder.LayoutOrder;ll.Parent=c
    local pd=Instance.new("UIPadding");pd.PaddingTop=UDim.new(0,4);pd.PaddingBottom=UDim.new(0,10);pd.PaddingRight=UDim.new(0,4);pd.Parent=c
    Tabs[n]=c;return c
end
local function switchTab(n)
    for nm,t in pairs(Tabs) do t.Visible=(nm==n) end
    for nm,b in pairs(TabBtns) do
        if nm==n then b.BackgroundColor3=COL.Accent;b.TextColor3=Color3.new(1,1,1)
        else b.BackgroundColor3=COL.Button;b.TextColor3=COL.TextDim end
    end
end
local function addTabBtn(n,idx)
    local b=Instance.new("TextButton");b.Size=UDim2.new(1,0,0,38)
    b.BackgroundColor3=COL.Button;b.Text=n;b.TextColor3=COL.TextDim
    b.TextSize=13;b.Font=Enum.Font.GothamBold;b.AutoButtonColor=false;b.LayoutOrder=idx;b.ZIndex=4;b.Parent=TabBar
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
    b.MouseButton1Click:Connect(function() switchTab(n) end)
    TabBtns[n]=b
end
local function addLabel(c,txt)
    local l=Instance.new("TextLabel");l.Size=UDim2.new(1,0,0,20);l.BackgroundTransparency=1
    l.Text=txt;l.TextColor3=COL.TextDim;l.TextSize=11;l.Font=Enum.Font.Gotham
    l.TextXAlignment=Enum.TextXAlignment.Left;l.ZIndex=5;l.Parent=c;return l
end
local function addPara(c,t,d)
    local f=Instance.new("Frame");f.Size=UDim2.new(1,0,0,44);f.BackgroundColor3=COL.Bg2
    f.BackgroundTransparency=0.3;f.ZIndex=5;f.Parent=c;Instance.new("UICorner",f).CornerRadius=UDim.new(0,10)
    local t1=Instance.new("TextLabel");t1.Size=UDim2.new(1,-12,0,18);t1.Position=UDim2.new(0,10,0,4)
    t1.BackgroundTransparency=1;t1.Text=t;t1.TextColor3=COL.Accent;t1.TextSize=13
    t1.Font=Enum.Font.GothamBold;t1.TextXAlignment=Enum.TextXAlignment.Left;t1.ZIndex=6;t1.Parent=f
    local t2=Instance.new("TextLabel");t2.Size=UDim2.new(1,-12,0,16);t2.Position=UDim2.new(0,10,0,23)
    t2.BackgroundTransparency=1;t2.Text=d;t2.TextColor3=COL.Text;t2.TextSize=11
    t2.Font=Enum.Font.Gotham;t2.TextXAlignment=Enum.TextXAlignment.Left;t2.ZIndex=6;t2.Parent=f
end
local function addBtn(c,n,cb)
    local b=Instance.new("TextButton");b.Size=UDim2.new(1,0,0,38)
    b.BackgroundColor3=COL.Button;b.BackgroundTransparency=0.15;b.Text="  "..n
    b.TextColor3=COL.Text;b.TextSize=13;b.Font=Enum.Font.Gotham
    b.TextXAlignment=Enum.TextXAlignment.Left;b.AutoButtonColor=false;b.ZIndex=5;b.Parent=c
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)
    b.MouseButton1Click:Connect(safe(function()
        TweenService:Create(b,TweenInfo.new(0.1),{BackgroundColor3=COL.Accent}):Play()
        task.wait(0.1);TweenService:Create(b,TweenInfo.new(0.2),{BackgroundColor3=COL.Button}):Play()
        cb()
    end,"按钮:"..n))
end
local function addToggle(c,n,def,cb)
    local f=Instance.new("Frame");f.Size=UDim2.new(1,0,0,38);f.BackgroundColor3=COL.Button
    f.BackgroundTransparency=0.15;f.ZIndex=5;f.Parent=c;Instance.new("UICorner",f).CornerRadius=UDim.new(0,10)
    local l=Instance.new("TextLabel");l.Size=UDim2.new(1,-60,1,0);l.Position=UDim2.new(0,12,0,0)
    l.BackgroundTransparency=1;l.Text=n;l.TextColor3=COL.Text;l.TextSize=13
    l.Font=Enum.Font.Gotham;l.TextXAlignment=Enum.TextXAlignment.Left;l.ZIndex=6;l.Parent=f
    local t=Instance.new("TextButton");t.Size=UDim2.fromOffset(44,22);t.Position=UDim2.new(1,-52,0,8)
    t.BackgroundColor3=def and COL.On or COL.Off;t.Text="";t.AutoButtonColor=false;t.ZIndex=6;t.Parent=f
    Instance.new("UICorner",t).CornerRadius=UDim.new(1,0)
    local k=Instance.new("Frame");k.Size=UDim2.fromOffset(16,16)
    k.Position=def and UDim2.new(1,-19,0,3) or UDim2.new(0,3,0,3)
    k.BackgroundColor3=Color3.new(1,1,1);k.BorderSizePixel=0;k.ZIndex=7;k.Parent=t
    Instance.new("UICorner",k).CornerRadius=UDim.new(1,0)
    local st=def
    t.MouseButton1Click:Connect(safe(function()
        st=not st
        TweenService:Create(t,TweenInfo.new(0.2),{BackgroundColor3=st and COL.On or COL.Off}):Play()
        TweenService:Create(k,TweenInfo.new(0.2),{Position=st and UDim2.new(1,-19,0,3) or UDim2.new(0,3,0,3)}):Play()
        cb(st)
    end,"开关:"..n))
end
local function addSlider(c,n,mn,mx,def,cb)
    local f=Instance.new("Frame");f.Size=UDim2.new(1,0,0,48);f.BackgroundColor3=COL.Button
    f.BackgroundTransparency=0.15;f.ZIndex=5;f.Parent=c;Instance.new("UICorner",f).CornerRadius=UDim.new(0,10)
    local l=Instance.new("TextLabel");l.Size=UDim2.new(1,-12,0,16);l.Position=UDim2.new(0,10,0,5)
    l.BackgroundTransparency=1;l.Text=n.." : "..def;l.TextColor3=COL.Text;l.TextSize=12
    l.Font=Enum.Font.Gotham;l.TextXAlignment=Enum.TextXAlignment.Left;l.ZIndex=6;l.Parent=f
    local bar=Instance.new("Frame");bar.Size=UDim2.new(1,-20,0,6);bar.Position=UDim2.new(0,10,0,30)
    bar.BackgroundColor3=Color3.fromRGB(15,10,35);bar.ZIndex=6;bar.Parent=f
    Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0)
    local fill=Instance.new("Frame");fill.Size=UDim2.new((def-mn)/(mx-mn),0,1,0)
    fill.BackgroundColor3=COL.Accent;fill.ZIndex=7;fill.Parent=bar
    Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
    local btn=Instance.new("TextButton");btn.Size=UDim2.new(1,0,1,0);btn.BackgroundTransparency=1
    btn.Text="";btn.ZIndex=8;btn.Parent=bar
    local drag=false
    btn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and(i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement) then
            local p=math.clamp((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
            fill.Size=UDim2.new(p,0,1,0)
            local val=math.floor(mn+p*(mx-mn)+0.5)
            l.Text=n.." : "..val;cb(val)
        end
    end)
end

local function getChar() return LocalPlayer.Character end
local function getHum() local c=getChar();return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot() local c=getChar();return c and c:FindFirstChild("HumanoidRootPart") end

-- ===================== 玩家选择器（已修复） =====================
local function selectPlayer(cb,title)
    local plrs=Players:GetPlayers();local others={}
    for _,p in ipairs(plrs) do if p~=LocalPlayer then table.insert(others,p) end end
    if #others==0 then
        pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="小贺脚本",Text="服务器里没有其他玩家",Duration=3}) end)
        return
    end
    local sg=Instance.new("ScreenGui");sg.Name="PSel";sg.IgnoreGuiInset=true;sg.ResetOnSpawn=false;sg.DisplayOrder=99999;sg.Parent=PlayerGui
    local bg=Instance.new("TextButton");bg.Size=UDim2.fromScale(1,1);bg.BackgroundColor3=Color3.new(0,0,0)
    bg.BackgroundTransparency=0.6;bg.ZIndex=1;bg.Text="";bg.AutoButtonColor=false;bg.Parent=sg
    local fr=Instance.new("Frame");fr.Size=UDim2.new(0,320,0,440);fr.Position=UDim2.new(0.5,-160,0.5,-220)
    fr.BackgroundColor3=COL.Bg;fr.ZIndex=2;fr.Parent=sg;Instance.new("UICorner",fr).CornerRadius=UDim.new(0,14)
    local fbs=Instance.new("UIStroke");fbs.Thickness=2;fbs.Color=COL.Accent;fbs.Transparency=0.4;fbs.Parent=fr
    local tb=Instance.new("Frame");tb.Size=UDim2.new(1,0,0,44);tb.BackgroundColor3=COL.Bg2
    tb.BackgroundTransparency=0.3;tb.ZIndex=3;tb.Parent=fr;Instance.new("UICorner",tb).CornerRadius=UDim.new(0,14)
    local tt=Instance.new("TextLabel");tt.Size=UDim2.new(1,-90,1,0);tt.Position=UDim2.new(0,14,0,0)
    tt.BackgroundTransparency=1;tt.ZIndex=4;tt.Text=(title or "选择玩家").." ("..#others.."人)"
    tt.TextColor3=COL.Text;tt.TextSize=16;tt.Font=Enum.Font.GothamBold;tt.TextXAlignment=Enum.TextXAlignment.Left;tt.Parent=tb
    local rf=Instance.new("TextButton");rf.Size=UDim2.fromOffset(36,36);rf.Position=UDim2.new(1,-82,0,4)
    rf.BackgroundColor3=COL.Button;rf.Text="↻";rf.TextColor3=COL.Accent2;rf.TextSize=16
    rf.AutoButtonColor=false;rf.ZIndex=4;rf.Parent=tb;Instance.new("UICorner",rf).CornerRadius=UDim.new(1,0)
    local cl=Instance.new("TextButton");cl.Size=UDim2.fromOffset(36,36);cl.Position=UDim2.new(1,-40,0,4)
    cl.BackgroundColor3=COL.Button;cl.Text="✕";cl.TextColor3=COL.TextDim;cl.TextSize=14
    cl.AutoButtonColor=false;cl.ZIndex=4;cl.Parent=tb;Instance.new("UICorner",cl).CornerRadius=UDim.new(1,0)
    local sc=Instance.new("ScrollingFrame");sc.Size=UDim2.new(1,-16,1,-56);sc.Position=UDim2.new(0,8,0,50)
    sc.BackgroundTransparency=1;sc.BorderSizePixel=0;sc.ScrollBarThickness=4
    sc.ScrollBarImageColor3=COL.Accent;sc.CanvasSize=UDim2.new(0,0,0,0)
    sc.AutomaticCanvasSize=Enum.AutomaticSize.Y;sc.ZIndex=3;sc.Parent=fr
    local sll=Instance.new("UIListLayout");sll.Padding=UDim.new(0,6);sll.SortOrder=Enum.SortOrder.LayoutOrder;sll.Parent=sc
    local spp=Instance.new("UIPadding");spp.PaddingTop=UDim.new(0,4);spp.PaddingBottom=UDim.new(0,8);spp.Parent=sc
    local function rebuild()
        for _,c in sc:GetChildren() do if c:IsA("TextButton") then c:Destroy() end end
        local cur=Players:GetPlayers();local list={}
        for _,p in ipairs(cur) do if p~=LocalPlayer then table.insert(list,p) end end
        tt.Text=(title or "选择玩家").." ("..#list.."人)"
        local myRoot=getRoot()
        for idx,p in ipairs(list) do
            local b=Instance.new("TextButton");b.Size=UDim2.new(1,0,0,52)
            b.BackgroundColor3=COL.Button;b.BackgroundTransparency=0.1;b.LayoutOrder=idx;b.ZIndex=4;b.AutoButtonColor=false;b.Parent=sc
            Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)
            if p.Team then local bar=Instance.new("Frame");bar.Size=UDim2.new(0,5,1,-14)
                bar.Position=UDim2.new(0,6,0,7);bar.BackgroundColor3=p.Team.TeamColor.Color
                bar.BorderSizePixel=0;bar.ZIndex=5;bar.Parent=b;Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0) end
            local nl=Instance.new("TextLabel");nl.Size=UDim2.new(1,-90,0,22);nl.Position=UDim2.new(0,18,0,6)
            nl.BackgroundTransparency=1;nl.ZIndex=6;nl.Text=p.Name;nl.TextColor3=COL.Text
            nl.TextSize=14;nl.Font=Enum.Font.GothamBold;nl.TextXAlignment=Enum.TextXAlignment.Left;nl.Parent=b
            local dl=Instance.new("TextLabel");dl.Size=UDim2.new(1,-90,0,16);dl.Position=UDim2.new(0,18,0,28)
            dl.BackgroundTransparency=1;dl.ZIndex=6
            local dt=""
            if p.DisplayName and p.DisplayName~=p.Name then dt="@"..p.DisplayName end
            if p.Team then dt=dt.." ["..p.Team.Name.."]" end
            if p.Name==AUTHOR_NAME then dt=dt.." ✦作者✦" end
            dl.Text=dt;dl.TextColor3=COL.TextDim;dl.TextSize=11;dl.Font=Enum.Font.Gotham
            dl.TextXAlignment=Enum.TextXAlignment.Left;dl.Parent=b
            local dtl=Instance.new("TextLabel");dtl.Size=UDim2.new(0,70,1,0);dtl.Position=UDim2.new(1,-78,0,0)
            dtl.BackgroundTransparency=1;dtl.ZIndex=6
            local tr=myRoot and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            dtl.Text=tr and string.format("%.0fm",(tr.Position-myRoot.Position).Magnitude) or "在场"
            dtl.TextColor3=COL.Accent2;dtl.TextSize=13;dtl.Font=Enum.Font.GothamBold
            dtl.TextXAlignment=Enum.TextXAlignment.Right;dtl.Parent=b
            b.MouseButton1Click:Connect(safe(function()
                sg:Destroy()
                if p and p.Parent and p.Character then cb(p)
                else pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="小贺脚本",Text="目标已离开或无角色",Duration=2}) end) end
            end,"玩家选择"))
        end
    end
    rebuild()
    rf.MouseButton1Click:Connect(rebuild)
    cl.MouseButton1Click:Connect(function() sg:Destroy() end)
    bg.MouseButton1Click:Connect(function() sg:Destroy() end)
end

-- ===================== 在线玩家列表（已修复） =====================
local function showPlayerList()
    local plrs=Players:GetPlayers()
    local sg=Instance.new("ScreenGui");sg.Name="PlayerList";sg.IgnoreGuiInset=true;sg.ResetOnSpawn=false;sg.DisplayOrder=99998;sg.Parent=PlayerGui
    local bg=Instance.new("TextButton");bg.Size=UDim2.fromScale(1,1);bg.BackgroundColor3=Color3.new(0,0,0)
    bg.BackgroundTransparency=0.6;bg.ZIndex=1;bg.Text="";bg.AutoButtonColor=false;bg.Parent=sg
    local fr=Instance.new("Frame");fr.Size=UDim2.new(0,340,0,460);fr.Position=UDim2.new(0.5,-170,0.5,-230)
    fr.BackgroundColor3=COL.Bg;fr.ZIndex=2;fr.Parent=sg;Instance.new("UICorner",fr).CornerRadius=UDim.new(0,14)
    local fbs=Instance.new("UIStroke");fbs.Thickness=2;fbs.Color=COL.Accent;fbs.Transparency=0.4;fbs.Parent=fr
    local tb=Instance.new("Frame");tb.Size=UDim2.new(1,0,0,44);tb.BackgroundColor3=COL.Bg2
    tb.BackgroundTransparency=0.3;tb.ZIndex=3;tb.Parent=fr;Instance.new("UICorner",tb).CornerRadius=UDim.new(0,14)
    local tt=Instance.new("TextLabel");tt.Size=UDim2.new(1,-50,1,0);tt.Position=UDim2.new(0,14,0,0)
    tt.BackgroundTransparency=1;tt.ZIndex=4;tt.Text="在线玩家 ("..#plrs..")"
    tt.TextColor3=COL.Text;tt.TextSize=16;tt.Font=Enum.Font.GothamBold;tt.TextXAlignment=Enum.TextXAlignment.Left;tt.Parent=tb
    local cl=Instance.new("TextButton");cl.Size=UDim2.fromOffset(36,36);cl.Position=UDim2.new(1,-40,0,4)
    cl.BackgroundColor3=COL.Button;cl.Text="✕";cl.TextColor3=COL.TextDim;cl.TextSize=14
    cl.AutoButtonColor=false;cl.ZIndex=4;cl.Parent=tb;Instance.new("UICorner",cl).CornerRadius=UDim.new(1,0)
    local sc=Instance.new("ScrollingFrame");sc.Size=UDim2.new(1,-16,1,-56);sc.Position=UDim2.new(0,8,0,50)
    sc.BackgroundTransparency=1;sc.BorderSizePixel=0;sc.ScrollBarThickness=4
    sc.ScrollBarImageColor3=COL.Accent;sc.CanvasSize=UDim2.new(0,0,0,0)
    sc.AutomaticCanvasSize=Enum.AutomaticSize.Y;sc.ZIndex=3;sc.Parent=fr
    local sll=Instance.new("UIListLayout");sll.Padding=UDim.new(0,5);sll.SortOrder=Enum.SortOrder.LayoutOrder;sll.Parent=sc
    local spp=Instance.new("UIPadding");spp.PaddingTop=UDim.new(0,4);spp.PaddingBottom=UDim.new(0,8);spp.Parent=sc
    local myRoot=getRoot()
    for idx,p in ipairs(plrs) do
        local b=Instance.new("TextButton");b.Size=UDim2.new(1,0,0,44)
        b.BackgroundColor3=COL.Button;b.BackgroundTransparency=0.1;b.LayoutOrder=idx;b.ZIndex=4;b.AutoButtonColor=false;b.Parent=sc
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
        local nl=Instance.new("TextLabel");nl.Size=UDim2.new(1,-80,0,20);nl.Position=UDim2.new(0,10,0,4)
        nl.BackgroundTransparency=1;nl.ZIndex=5;nl.Text=p.Name
        nl.TextColor3=p==LocalPlayer and COL.Accent2 or(p.Name==AUTHOR_NAME and Color3.fromRGB(255,215,0) or COL.Text)
        nl.TextSize=13;nl.Font=Enum.Font.GothamBold;nl.TextXAlignment=Enum.TextXAlignment.Left;nl.Parent=b
        local dl=Instance.new("TextLabel");dl.Size=UDim2.new(1,-80,0,14);dl.Position=UDim2.new(0,10,0,24)
        dl.BackgroundTransparency=1;dl.ZIndex=5
        local dt=p.Team and "["..p.Team.Name.."]" or ""
        if p==LocalPlayer then dt=dt.." (你)" end
        if p.Name==AUTHOR_NAME then dt=dt.." ✦作者✦" end
        dl.Text=dt;dl.TextColor3=COL.TextDim;dl.TextSize=10;dl.Font=Enum.Font.Gotham
        dl.TextXAlignment=Enum.TextXAlignment.Left;dl.Parent=b
        local dtl=Instance.new("TextLabel");dtl.Size=UDim2.new(0,70,1,0);dtl.Position=UDim2.new(1,-78,0,0)
        dtl.BackgroundTransparency=1;dtl.ZIndex=5
        local tr=myRoot and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        dtl.Text=tr and string.format("%.0fm",(tr.Position-myRoot.Position).Magnitude) or "-"
        dtl.TextColor3=COL.Accent2;dtl.TextSize=12;dtl.Font=Enum.Font.GothamBold
        dtl.TextXAlignment=Enum.TextXAlignment.Right;dtl.Parent=b
    end
    cl.MouseButton1Click:Connect(function() sg:Destroy() end)
    bg.MouseButton1Click:Connect(function() sg:Destroy() end)
end

-- ===================== 飞行系统 =====================
local flyActive=false;local flySpeed=50;local flyUpSpeed=30
local flyBv=nil;local flyBg=nil;local flyConn=nil;local flyDiedConn=nil
local function cleanupFly()
    flyActive=false
    if flyConn then pcall(function() flyConn:Disconnect() end);flyConn=nil end
    if flyDiedConn then pcall(function() flyDiedConn:Disconnect() end);flyDiedConn=nil end
    if flyBv then pcall(function() flyBv:Destroy() end);flyBv=nil end
    if flyBg then pcall(function() flyBg:Destroy() end);flyBg=nil end
    local h=getHum()
    if h then pcall(function() h.PlatformStand=false;h.GravityScale=1;h.JumpPower=50 end) end
end
local function startFly()
    local h=getHum();local r=getRoot()
    if not h or not r then pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="飞行",Text="等待角色加载",Duration=2}) end);return false end
    flyActive=true
    pcall(function() h.PlatformStand=true;h.GravityScale=0;h.JumpPower=0 end)
    flyBv=Instance.new("BodyVelocity");flyBv.Name="FlyBV"
    flyBv.MaxForce=Vector3.new(math.huge,math.huge,math.huge);flyBv.Velocity=Vector3.new(0,0,0);flyBv.P=12000;flyBv.Parent=r
    flyBg=Instance.new("BodyGyro");flyBg.Name="FlyBG"
    flyBg.MaxTorque=Vector3.new(math.huge,math.huge,math.huge);flyBg.P=10000;flyBg.CFrame=r.CFrame;flyBg.Parent=r
    flyDiedConn=h.Died:Connect(function() cleanupFly() end)
    flyConn=RunService.Heartbeat:Connect(safe(function()
        local hh=getHum();local rr=getRoot()
        if not hh or not rr or not flyBv or not flyBg then return end
        local cam=Camera
        local look=cam.CFrame.LookVector
        local lookH=Vector3.new(look.X,0,look.Z)
        if lookH.Magnitude<0.01 then lookH=Vector3.new(0,0,-1) end
        lookH=lookH.Unit
        local right=cam.CFrame.RightVector*Vector3.new(1,0,1)
        if right.Magnitude<0.01 then right=Vector3.new(1,0,0) end
        right=right.Unit
        local move=hh.MoveDirection
        local vel=Vector3.new(0,0,0)
        if move.Magnitude>0.1 then
            local fwd=move:Dot(lookH);local rgt=move:Dot(right)
            vel=lookH*fwd*flySpeed+right*rgt*flySpeed
        end
        if look.Y>0.15 then vel=vel+Vector3.new(0,flyUpSpeed,0)
        elseif look.Y<-0.15 then vel=vel+Vector3.new(0,-flyUpSpeed,0) end
        flyBv.Velocity=vel
        flyBg.CFrame=CFrame.new(rr.Position,rr.Position+lookH)
    end,"飞行"))
    pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="飞行",Text="✈ 已开启（摇杆控制方向，视角上下控制升降）",Duration=3}) end)
    return true
end
local function stopFly()
    cleanupFly()
    pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="飞行",Text="已关闭",Duration=2}) end)
end
LocalPlayer.CharacterAdded:Connect(function() task.wait(0.5);if flyActive then cleanupFly() end end)

local FlyGui=nil
local function createFlyPanel()
    if FlyGui then pcall(function() FlyGui:Destroy() end);FlyGui=nil end
    FlyGui=Instance.new("ScreenGui");FlyGui.Name="FlyP_V16";FlyGui.IgnoreGuiInset=true
    FlyGui.ResetOnSpawn=false;FlyGui.DisplayOrder=950;FlyGui.Parent=PlayerGui
    local F=Instance.new("Frame");F.Name="FF";F.BackgroundColor3=Color3.fromRGB(163,255,137)
    F.BorderColor3=Color3.fromRGB(103,221,213);F.Position=UDim2.new(0.1,0,0.38,0)
    F.Size=UDim2.new(0,190,0,57);F.Active=true;F.Draggable=true;F.Parent=FlyGui
    local function mkBtn(nam,col,pos,sz,txt)
        local b=Instance.new("TextButton");b.Name=nam;b.Parent=F
        b.BackgroundColor3=col;b.Position=pos;b.Size=sz
        b.Font=Enum.Font.SourceSans;b.Text=txt;b.TextColor3=Color3.new(0,0,0)
        b.TextSize=14;b.AutoButtonColor=false;return b
    end
    local up=mkBtn("up",Color3.fromRGB(79,255,152),UDim2.new(0,0,0,0),UDim2.new(0,44,0,28),"上")
    local down=mkBtn("down",Color3.fromRGB(215,255,121),UDim2.new(0,0,0.49,0),UDim2.new(0,44,0,28),"下")
    local onof=mkBtn("onof",Color3.fromRGB(255,249,74),UDim2.new(0.70,0,0.49,0),UDim2.new(0,56,0,28),"飞行")
    local title=mkBtn("title",Color3.fromRGB(242,60,255),UDim2.new(0.47,0,0,0),UDim2.new(0,100,0,28),"小贺 V16飞行")
    title.TextScaled=true;title.AutoButtonColor=false
    local plus=mkBtn("plus",Color3.fromRGB(133,145,255),UDim2.new(0.23,0,0,0),UDim2.new(0,45,0,28),"加速");plus.TextScaled=true
    local spd=mkBtn("spd",Color3.fromRGB(255,85,0),UDim2.new(0.47,0,0.49,0),UDim2.new(0,44,0,28),tostring(flySpeed));spd.TextScaled=true
    local mine=mkBtn("mine",Color3.fromRGB(123,255,247),UDim2.new(0.23,0,0.49,0),UDim2.new(0,45,0,29),"减速");mine.TextScaled=true
    local cbtn=mkBtn("cbtn",Color3.fromRGB(225,25,0),UDim2.new(0,0,-1,27),UDim2.new(0,45,0,28),"关闭")
    local mini=mkBtn("mini",Color3.fromRGB(192,150,230),UDim2.new(0,44,-1,27),UDim2.new(0,45,0,28),"隐藏")
    local mini2=mkBtn("mini2",Color3.fromRGB(192,150,230),UDim2.new(0,44,-1,57),UDim2.new(0,45,0,28),"+");mini2.Visible=false;mini2.TextSize=24
    local upHeld=false;local downHeld=false
    onof.MouseButton1Click:Connect(safe(function()
        if flyActive then stopFly();onof.BackgroundColor3=Color3.fromRGB(255,249,74);onof.Text="飞行"
        else if startFly() then onof.BackgroundColor3=Color3.fromRGB(80,255,80);onof.Text="飞行中" end end
    end,"飞行开关"))
    up.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then upHeld=true end end)
    up.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then upHeld=false end end)
    down.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then downHeld=true end end)
    down.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then downHeld=false end end)
    RunService:BindToRenderStep("FlyBtn",Enum.RenderPriority.Character.Value+1,function()
        if not flyActive or not flyBv then return end
        if upHeld then flyBv.Velocity=Vector3.new(flyBv.Velocity.X,flyUpSpeed,flyBv.Velocity.Z)
        elseif downHeld then flyBv.Velocity=Vector3.new(flyBv.Velocity.X,-flyUpSpeed,flyBv.Velocity.Z) end
    end)
    plus.MouseButton1Click:Connect(safe(function() flySpeed=math.min(flySpeed+10,300);spd.Text=tostring(flySpeed) end,"飞行加速"))
    mine.MouseButton1Click:Connect(safe(function() flySpeed=math.max(flySpeed-10,10);spd.Text=tostring(flySpeed) end,"飞行减速"))
    cbtn.MouseButton1Click:Connect(safe(function()
        if flyActive then stopFly() end
        RunService:UnbindFromRenderStep("FlyBtn")
        FlyGui:Destroy();FlyGui=nil
    end,"飞行面板关闭"))
    mini.MouseButton1Click:Connect(function()
        up.Visible=false;down.Visible=false;onof.Visible=false;plus.Visible=false;spd.Visible=false
        mine.Visible=false;mini.Visible=false;mini2.Visible=true;F.BackgroundTransparency=1
        cbtn.Position=UDim2.new(0,0,-1,57)
    end)
    mini2.MouseButton1Click:Connect(function()
        up.Visible=true;down.Visible=true;onof.Visible=true;plus.Visible=true;spd.Visible=true
        mine.Visible=true;mini.Visible=true;mini2.Visible=false;F.BackgroundTransparency=0
        cbtn.Position=UDim2.new(0,0,-1,27)
    end)
end

-- ===================== 终极防甩飞 V3 =====================
local antiKb=false;local antiKbConn=nil;local lastSafePos=nil;local kbLockUntil=0
local function setAntiKb(v)
    antiKb=v
    if v then
        local r=getRoot();if r then lastSafePos=r.Position end
        antiKbConn=RunService.Heartbeat:Connect(safe(function()
            if flyActive then return end
            local r=getRoot();local h=getHum()
            if not r or not h then return end
            local vel=r.AssemblyLinearVelocity
            local ang=r.AssemblyAngularVelocity
            local pos=r.Position
            local now=tick()
            local triggered=false

            -- 【检测1】线速度超过80（普通跑步最多20左右，被甩飞瞬间几百）
            if vel.Magnitude>80 then triggered=true end
            -- 【检测2】角速度超过15（被旋转碰撞箱打中会疯狂转）
            if ang.Magnitude>15 then triggered=true end
            -- 【检测3】Y方向极速上升超过120
            if vel.Y>120 then triggered=true end
            -- 【检测4】Y方向极速下降超过150
            if vel.Y<-150 then triggered=true end
            -- 【检测5】一帧位置突变超过10格（被撞飞瞬移）
            if lastSafePos and(pos-lastSafePos).Magnitude>10 then triggered=true end
            -- 【检测6】周围8格内有高速移动的陌生Part（甩飞工具），自动推开
            pcall(function()
                for _,p in ipairs(workspace:GetPartBoundsInRadius(pos,10)) do
                    if p and p.Parent and p~=r and not p:IsDescendantOf(getChar()) then
                        if p.Velocity and p.Velocity.Magnitude>200 and p.CanCollide then
                            -- 把甩飞工具炸飞
                            p.Velocity=Vector3.new(math.random(-1000,1000),2000,math.random(-1000,1000))
                            p.AssemblyLinearVelocity=p.Velocity
                        end
                    end
                end
            end)

            if triggered or now<kbLockUntil then
                -- 【防御1】清零一切线速度和角速度
                r.AssemblyLinearVelocity=Vector3.new(0,math.min(vel.Y,20),0)
                r.AssemblyAngularVelocity=Vector3.new(0,0,0)
                r.Velocity=Vector3.new(0,math.min(vel.Y,20),0)
                r.RotVelocity=Vector3.new(0,0,0)
                -- 【防御2】平台站立0.5秒，稳住不被连续推
                pcall(function() h.PlatformStand=true end)
                kbLockUntil=now+0.5
                -- 【防御3】如果被甩得太远，拉回安全位置
                if lastSafePos and(pos-lastSafePos).Magnitude>25 then
                    r.CFrame=CFrame.new(lastSafePos+Vector3.new(0,3,0))
                    r.AssemblyLinearVelocity=Vector3.new(0,0,0)
                end
                -- 【防御4】夺取网络所有权
                pcall(function() r:SetNetworkOwner(nil) end)
                task.delay(0.5,function()
                    local hh=getHum()
                    if hh and antiKb and not flyActive then pcall(function() hh.PlatformStand=false end) end
                    local rr=getRoot()
                    if rr then pcall(function() rr:SetNetworkOwner(LocalPlayer) end) end
                end)
            else
                -- 【持续防御】正常状态下强力水平阻尼，消耗任何残余动量
                r.AssemblyLinearVelocity=Vector3.new(vel.X*0.7,vel.Y,vel.Z*0.7)
                if ang.Magnitude>1 then r.AssemblyAngularVelocity=ang*0.3 end
            end
            -- 记录安全位置（在地面上且速度正常时）
            if h.FloorMaterial~=Enum.Material.Air and vel.Magnitude<50 then
                lastSafePos=pos
            end
        end,"终极防甩飞V3"))
        pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="小贺脚本",Text="🛡 终极防甩飞V3已开启",Duration=2}) end)
    else
        if antiKbConn then pcall(function() antiKbConn:Disconnect() end);antiKbConn=nil end
        local h=getHum();if h then pcall(function() h.PlatformStand=false end) end
    end
end

-- ===================== 防坠落 =====================
local antiFall=false;local antiFallConn=nil;local lastSafe=nil;local jumpProt=0;local fallStart=nil
local function setAntiFall(v)
    antiFall=v
    if v then
        local r=getRoot();if r then lastSafe=r.CFrame end
        local jc=UserInputService.JumpRequest:Connect(function() jumpProt=tick() end)
        antiFallConn=RunService.Heartbeat:Connect(safe(function()
            if flyActive then return end
            local r=getRoot();local h=getHum()
            if not r or not h then return end
            local vel=r.AssemblyLinearVelocity
            local onGround=h.FloorMaterial~=Enum.Material.Air
            local now=tick()
            if onGround and vel.Magnitude<30 then lastSafe=r.CFrame;fallStart=nil;return end
            if now-jumpProt<0.6 then fallStart=nil;return end
            local falling=h:GetState()==Enum.HumanoidStateType.FreeFall
            if(r.Position.Y<-100)or(vel.Y<-100 and falling)then
                if not fallStart then fallStart=now
                elseif now-fallStart>0.35 then
                    if lastSafe then
                        r.CFrame=lastSafe;r.AssemblyLinearVelocity=Vector3.new(0,0,0)
                        r.AssemblyAngularVelocity=Vector3.new(0,0,0);fallStart=nil
                        pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="小贺脚本",Text="🛡 防坠落触发",Duration=2}) end)
                    end
                end
            else fallStart=nil end
        end,"防坠落"))
    else
        if antiFallConn then pcall(function() antiFallConn:Disconnect() end);antiFallConn=nil end
    end
end

-- ===================== 移动辅助 =====================
local ijConn=nil
local function setIJ(v)
    if v then ijConn=UserInputService.JumpRequest:Connect(safe(function()
        local h=getHum();if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end,"无限跳"))
    else if ijConn then pcall(function() ijConn:Disconnect() end);ijConn=nil end end
end
local ncConn=nil
local function setNC(v)
    if v then ncConn=RunService.Stepped:Connect(safe(function()
        local c=getChar();if not c then return end
        for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
    end,"穿墙"))
    else
        if ncConn then pcall(function() ncConn:Disconnect() end);ncConn=nil end
        local c=getChar();if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then p.CanCollide=true end end end
    end
end
local spinOn=false;local spinConn=nil;local spinSpd=0.10
local function setSpin(v)
    spinOn=v
    if v then spinConn=RunService.Heartbeat:Connect(safe(function()
        local r=getRoot();if not r or flyActive then return end
        r.CFrame=r.CFrame*CFrame.Angles(0,spinSpd,0)
    end,"自转"))
    else if spinConn then pcall(function() spinConn:Disconnect() end);spinConn=nil end end
end
local noFallDmg=false;local noFallConn=nil
local function setNoFallDmg(v)
    noFallDmg=v
    if v then noFallConn=RunService.Heartbeat:Connect(safe(function()
        local h=getHum();if h then h:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end,"无坠落伤害"))
    else if noFallConn then pcall(function() noFallConn:Disconnect() end);noFallConn=nil end end
end
local autoJump=false;local autoJumpConn=nil
local function setAutoJump(v)
    autoJump=v
    if v then autoJumpConn=RunService.Heartbeat:Connect(safe(function()
        local h=getHum();if h and h.MoveDirection.Magnitude>0.1 then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end,"自动跳"))
    else if autoJumpConn then pcall(function() autoJumpConn:Disconnect() end);autoJumpConn=nil end end
end

-- ===================== 自瞄Pro =====================
local aimOn=false;local aimFOV=200;local aimSmooth=0.10;local aimPred=0.20;local aimPart="Head";local aimTeam=false
local aimConn=nil;local aimGui=nil;local aimCircle=nil
local aimParts={"Head","UpperTorso","HumanoidRootPart"};local aimIdx=1
local function createAimGui()
    local g=Instance.new("ScreenGui");g.Name="AimFOV";g.IgnoreGuiInset=true
    g.ResetOnSpawn=false;g.DisplayOrder=999;g.Parent=PlayerGui
    local c=Instance.new("Frame");c.AnchorPoint=Vector2.new(0.5,0.5);c.Position=UDim2.fromScale(0.5,0.5)
    c.Size=UDim2.fromOffset(aimFOV*2,aimFOV*2);c.BackgroundTransparency=1;c.BorderSizePixel=0;c.Parent=g
    Instance.new("UICorner",c).CornerRadius=UDim.new(1,0)
    local st=Instance.new("UIStroke");st.Thickness=1.5;st.Color=Color3.fromRGB(255,60,60);st.Transparency=0.3;st.Parent=c
    local dot=Instance.new("Frame");dot.AnchorPoint=Vector2.new(0.5,0.5);dot.Position=UDim2.fromScale(0.5,0.5)
    dot.Size=UDim2.fromOffset(4,4);dot.BackgroundColor3=Color3.fromRGB(255,60,60);dot.BorderSizePixel=0;dot.Parent=g
    Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
    return g,c
end
local function isTeam(plr)
    if not aimTeam then return false end
    return plr.Team and LocalPlayer.Team and plr.Team==LocalPlayer.Team
end
local function getAimPart(char)
    local p=char:FindFirstChild(aimPart)
    if p then return p end
    if aimPart=="UpperTorso" then p=char:FindFirstChild("Torso")or char:FindFirstChild("LowerTorso") end
    return p or char:FindFirstChild("HumanoidRootPart")
end
local function setAim(v)
    aimOn=v
    if v then
        if not aimGui then aimGui,aimCircle=createAimGui() end
        aimGui.Enabled=true
        aimConn=RunService.RenderStepped:Connect(safe(function()
            local cam=Camera;local vp=cam.ViewportSize;local center=Vector2.new(vp.X/2,vp.Y/2)
            if aimCircle then aimCircle.Size=UDim2.fromOffset(aimFOV*2,aimFOV*2) end
            local target=nil;local minD=math.huge
            for _,plr in Players:GetPlayers() do
                if plr==LocalPlayer or isTeam(plr) then continue end
                local char=plr.Character;if not char then continue end
                local hum=char:FindFirstChildOfClass("Humanoid");if not hum or hum.Health<=0 then continue end
                local part=getAimPart(char);if not part then continue end
                local sp,on=cam:WorldToViewportPoint(part.Position)
                if not on or sp.Z<=0 then continue end
                local d=(Vector2.new(sp.X,sp.Y)-center).Magnitude
                if d<=aimFOV and d<minD then minD=d;target=part end
            end
            if target then
                local pred=target.Position+target.AssemblyLinearVelocity*aimPred
                local ac=CFrame.new(cam.CFrame.Position,pred)
                cam.CFrame=cam.CFrame:Lerp(ac,aimSmooth)
                if aimCircle then for _,ch in aimCircle:GetChildren() do if ch:IsA("UIStroke") then ch.Color=Color3.fromRGB(60,255,60) end end end
            else
                if aimCircle then for _,ch in aimCircle:GetChildren() do if ch:IsA("UIStroke") then ch.Color=Color3.fromRGB(255,60,60) end end end
            end
        end,"自瞄"))
        pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="小贺脚本",Text="🎯 自瞄已开启",Duration=2}) end)
    else
        if aimConn then pcall(function() aimConn:Disconnect() end);aimConn=nil end
        if aimGui then aimGui.Enabled=false end
    end
end

-- ===================== 子弹追踪 =====================
local bulletTrack=false;local bulletTrackConn=nil
local function setBulletTrack(v)
    bulletTrack=v
    if v then
        bulletTrackConn=RunService.Heartbeat:Connect(safe(function()
            local myRoot=getRoot();if not myRoot then return end
            local nearest=nil;local minDist=math.huge
            for _,plr in Players:GetPlayers() do
                if plr==LocalPlayer then continue end
                local char=plr.Character;if not char then continue end
                local root=char:FindFirstChild("HumanoidRootPart");if not root then continue end
                local d=(root.Position-myRoot.Position).Magnitude
                if d<minDist then minDist=d;nearest=root end
            end
            if nearest then
                for _,obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and not obj.Anchored then
                        local vel=obj.Velocity
                        if vel.Magnitude>50 and(obj.Name:find("Bullet")or obj.Name:find("Projectile")or obj.Name:find("Pellet")or obj.Size.Magnitude<3)then
                            local dir=(nearest.Position-obj.Position).Unit
                            obj.Velocity=dir*vel.Magnitude
                        end
                    end
                end
            end
        end,"子弹追踪"))
        pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="小贺脚本",Text="🔫 子弹追踪已开启",Duration=2}) end)
    else
        if bulletTrackConn then pcall(function() bulletTrackConn:Disconnect() end);bulletTrackConn=nil end
    end
end

-- ===================== 强制视角 =====================
local forceView=false;local forceViewConn=nil
local function setForceView(v)
    forceView=v
    if v then
        forceViewConn=RunService.RenderStepped:Connect(safe(function()
            local myRoot=getRoot();if not myRoot then return end
            local nearest=nil;local minDist=math.huge
            for _,plr in Players:GetPlayers() do
                if plr==LocalPlayer then continue end
                local char=plr.Character;if not char then continue end
                local root=char:FindFirstChild("HumanoidRootPart");if not root then continue end
                local d=(root.Position-myRoot.Position).Magnitude
                if d<minDist then minDist=d;nearest=root end
            end
            if nearest then
                local cam=Camera
                cam.CFrame=CFrame.new(cam.CFrame.Position,nearest.Position)
            end
        end,"强制视角"))
        pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="小贺脚本",Text="👁 强制视角已开启",Duration=2}) end)
    else
        if forceViewConn then pcall(function() forceViewConn:Disconnect() end);forceViewConn=nil end
    end
end

-- ===================== 碰撞箱修改 =====================
local hitboxOn=false;local hitboxSize=2;local hitboxConn=nil;local hitboxCache={}
local function setHitbox(v)
    hitboxOn=v
    if v then
        hitboxConn=RunService.Heartbeat:Connect(safe(function()
            for _,plr in Players:GetPlayers() do
                if plr==LocalPlayer then continue end
                local char=plr.Character;if not char then continue end
                for _,p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then
                        if not hitboxCache[p] then hitboxCache[p]=p.Size end
                        pcall(function() p.Size=hitboxCache[p]*hitboxSize end)
                    end
                end
            end
        end,"碰撞箱修改"))
        pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="小贺脚本",Text="📦 碰撞箱修改已开启",Duration=2}) end)
    else
        if hitboxConn then pcall(function() hitboxConn:Disconnect() end);hitboxConn=nil end
        for p,orig in pairs(hitboxCache) do
            if p and p.Parent then pcall(function() p.Size=orig end) end
        end
        hitboxCache={}
    end
end

-- ===================== ESP透视 =====================
local espOn=false;local espBox=true;local espLine=true;local espInfo=true;local espHp=true
local espTeam=false;local espDist=500;local espBoxSize=1.0;local espBoxAlpha=0.4
local espGui=nil;local espConn=nil;local espHL=nil;local espCache={}
local function createEspGui()
    local g=Instance.new("ScreenGui");g.Name="ESP_V16";g.IgnoreGuiInset=true
    g.ResetOnSpawn=false;g.DisplayOrder=800;g.Parent=PlayerGui;return g
end
local function clearEspCache()
    for _,o in espCache do pcall(function() o:Destroy() end) end
    espCache={}
end
local function getCharBox(char)
    local cam=Camera;local root=char:FindFirstChild("HumanoidRootPart");local head=char:FindFirstChild("Head")
    if not root then return nil end
    local top=head or root
    local bPos=root.Position-Vector3.new(0,3,0);local tPos=top.Position+Vector3.new(0,1.5,0)
    local bS,bO=cam:WorldToViewportPoint(bPos);local tS,tO=cam:WorldToViewportPoint(tPos)
    if not bO and not tO then return nil end
    if bS.Z<=0 or tS.Z<=0 then return nil end
    local h=math.abs(bS.Y-tS.Y);if h<5 then return nil end
    local w=h*0.55;local cx=(bS.X+tS.X)/2;local cy=(bS.Y+tS.Y)/2
    return {x=cx-w/2,y=cy-h/2,w=w,h=h,cx=cx,cy=cy,by=bS.Y,on=bO or tO}
end
local function drawLine(p,x1,y1,x2,y2,c,t)
    local len=math.sqrt((x2-x1)^2+(y2-y1)^2);if len<1 then return end
    local f=Instance.new("Frame");f.Size=UDim2.new(0,len,0,t or 1);f.Position=UDim2.new(0,x1,0,y1)
    f.BackgroundColor3=c;f.BorderSizePixel=0;f.BackgroundTransparency=0.3
    f.Rotation=math.deg(math.atan2(y2-y1,x2-x1));f.AnchorPoint=Vector2.new(0,0.5);f.Parent=p
end
local function renderEsp()
    if not espGui then return end
    for _,c in espGui:GetChildren() do if c:IsA("Frame")or c:IsA("TextLabel")then c:Destroy() end end
    local cam=Camera;local myR=getRoot();if not myR then return end
    for _,plr in Players:GetPlayers() do
        if plr==LocalPlayer then continue end
        if espTeam and plr.Team and LocalPlayer.Team and plr.Team==LocalPlayer.Team then continue end
        local char=plr.Character;if not char then continue end
        local hum=char:FindFirstChildOfClass("Humanoid");local root=char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then continue end
        local dist=(root.Position-myR.Position).Magnitude
        if dist>espDist then
            if espHL and espHL:FindFirstChild(plr.Name) then pcall(function() espHL[plr.Name]:Destroy() end) end
            if espCache[plr] then pcall(function() espCache[plr]:Destroy() end);espCache[plr]=nil end
            continue
        end
        if espBox then
            local box=espCache[plr]
            if not box then
                box=Instance.new("Part");box.Name="WhiteBoxESP";box.Shape=Enum.PartType.Block
                box.CanCollide=false;box.Anchored=true;box.BrickColor=BrickColor.new("White")
                box.Material=Enum.Material.SmoothPlastic;box.Parent=workspace;espCache[plr]=box
            end
            box.Transparency=espBoxAlpha
            local s=math.clamp(espBoxSize,0.2,8)
            box.Size=Vector3.new(2.8*s,5.5*s,1.8*s);box.CFrame=root.CFrame
        else
            if espCache[plr] then pcall(function() espCache[plr]:Destroy() end);espCache[plr]=nil end
        end
        if espHL and not espHL:FindFirstChild(plr.Name) then
            local hl=Instance.new("Highlight");hl.Name=plr.Name
            hl.FillColor=Color3.fromRGB(180,80,255);hl.FillTransparency=0.7
            hl.OutlineColor=Color3.fromRGB(255,80,80);hl.OutlineTransparency=0
            hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;hl.Adornee=char;hl.Parent=espHL
        end
        local bx=getCharBox(char);if not bx or not bx.on then continue end
        if espBox then
            local bf=Instance.new("Frame");bf.Size=UDim2.new(0,bx.w,0,bx.h)
            bf.Position=UDim2.new(0,bx.x,0,bx.y);bf.BackgroundTransparency=1;bf.BorderSizePixel=0;bf.Parent=espGui
            local bs=Instance.new("UIStroke");bs.Thickness=1.5;bs.Color=Color3.fromRGB(255,255,255);bs.Transparency=0.2;bs.Parent=bf
        end
        if espLine then
            local vp=cam.ViewportSize;drawLine(espGui,vp.X/2,vp.Y,bx.cx,bx.by,Color3.fromRGB(255,255,255),1)
        end
        if espInfo then
            local inf=Instance.new("TextLabel");inf.Size=UDim2.new(0,bx.w+40,0,16)
            inf.Position=UDim2.new(0,bx.x-20,0,bx.y-18);inf.BackgroundTransparency=1
            inf.Text=plr.Name..string.format(" %.0fm",dist);inf.TextColor3=Color3.fromRGB(255,255,255)
            inf.TextSize=11;inf.Font=Enum.Font.Code;inf.TextXAlignment=Enum.TextXAlignment.Center;inf.Parent=espGui
        end
        if espHp and hum.MaxHealth>0 then
            local pct=hum.Health/hum.MaxHealth
            local hb=Instance.new("Frame");hb.Size=UDim2.new(0,5,0,bx.h);hb.Position=UDim2.new(0,bx.x-10,0,bx.y)
            hb.BackgroundColor3=Color3.fromRGB(40,40,40);hb.BorderSizePixel=0;hb.Parent=espGui
            local hf=Instance.new("Frame");hf.Size=UDim2.new(1,0,pct,0);hf.Position=UDim2.new(0,0,1-pct,0)
            hf.BackgroundColor3=pct>0.5 and Color3.fromRGB(80,255,80)or(pct>0.25 and Color3.fromRGB(255,200,0)or Color3.fromRGB(255,60,60))
            hf.BorderSizePixel=0;hf.Parent=hb
        end
    end
end
local function setEsp(v)
    espOn=v
    if v then
        if not espGui then espGui=createEspGui() end
        if not espHL then espHL=Instance.new("Folder");espHL.Name="ESP_HL";espHL.Parent=game:GetService("CoreGui") end
        espConn=RunService.RenderStepped:Connect(safe(renderEsp,"ESP"))
    else
        if espConn then pcall(function() espConn:Disconnect() end);espConn=nil end
        if espGui then pcall(function() espGui:Destroy() end);espGui=nil end
        if espHL then pcall(function() espHL:Destroy() end);espHL=nil end
        clearEspCache()
    end
end

-- ===================== 环绕甩飞 =====================
local flingActive={}
local function flingPlayer(tp)
    local tc=tp.Character
    if not tc then
        pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="甩飞",Text=tp.Name.." 没有角色",Duration=2}) end)
        return
    end
    local tr=tc:FindFirstChild("HumanoidRootPart")
    if not tr then
        pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="甩飞",Text="找不到目标根部位",Duration=2}) end)
        return
    end
    if flingActive[tp] then
        pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="甩飞",Text=tp.Name.." 正在被甩飞中",Duration=2}) end)
        return
    end
    flingActive[tp]=true
    pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="甩飞",Text="🌀 环绕甩飞启动: "..tp.Name,Duration=2}) end)
    local hammers={}
    local phases={0,math.rad(120),math.rad(240)}
    for i=1,3 do
        local h=Instance.new("Part")
        h.Name="OrbitFling"
        h.Size=Vector3.new(6,6,6)
        h.Anchored=false
        h.CanCollide=true
        h.CanTouch=true
        h.Massless=false
        h.Transparency=0.5
        h.Color=Color3.fromRGB(255,40,40)
        h.Material=Enum.Material.Neon
        h.Parent=workspace
        pcall(function() h.CustomPhysicalProperties=PhysicalProperties.new(100,0.1,0.2,100,100) end)
        table.insert(hammers,{part=h,phase=phases[i]})
    end
    local angle=0
    local radius=4.5
    local spinSpeed=0.35
    local duration=2.5
    local elapsed=0
    local conn
    conn=RunService.Heartbeat:Connect(safe(function(dt)
        elapsed=elapsed+dt
        if elapsed>duration or not tr or not tr.Parent then
            conn:Disconnect()
            for _,hd in ipairs(hammers) do pcall(function() hd.part:Destroy() end) end
            flingActive[tp]=nil
            pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="甩飞",Text="✓ 甩飞完成: "..tp.Name,Duration=2}) end)
            return
        end
        angle=angle+spinSpeed
        for _,hd in ipairs(hammers) do
            local h=hd.part
            local a=angle+hd.phase
            local offset=Vector3.new(math.cos(a)*radius,0,math.sin(a)*radius)
            h.CFrame=CFrame.new(tr.Position+offset)
            local tangent=Vector3.new(-math.sin(a),0,math.cos(a))
            h.Velocity=tangent*4000+Vector3.new(0,300,0)
            h.AssemblyLinearVelocity=tangent*4000+Vector3.new(0,300,0)
        end
        if math.floor(elapsed*10)%3==0 then
            pcall(function()
                tr:ApplyImpulse(Vector3.new(
                    math.random(-2500,2500),
                    math.random(1500,3500),
                    math.random(-2500,2500)
                ))
            end)
        end
    end,"环绕甩飞"))
end

-- ===================== 传送玩家 =====================
local function tpPlayer(tp)
    local tc=tp.Character
    if not tc then
        pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="传送",Text=tp.Name.." 没有角色",Duration=2}) end)
        return
    end
    local mr=getRoot()
    if not mr then
        pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="传送",Text="你的角色未加载",Duration=2}) end)
        return
    end
    local target=tc:FindFirstChild("HumanoidRootPart")or tc:FindFirstChild("Torso")or tc:FindFirstChild("Head")
    if not target then
        pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="传送",Text="找不到目标位置",Duration=2}) end)
        return
    end
    pcall(function() mr:SetNetworkOwner(nil) end)
    local offset=Vector3.new(math.random(-3,3),2,math.random(-3,3))
    mr.CFrame=CFrame.new(target.Position+offset)
    mr.Velocity=Vector3.new(0,0,0)
    mr.AssemblyLinearVelocity=Vector3.new(0,0,0)
    task.wait(0.15)
    pcall(function() mr:SetNetworkOwner(LocalPlayer) end)
    pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="传送",Text="✓ 已传送到 "..tp.Name,Duration=2}) end)
end

-- ===================== 角色特效 =====================
local charFx={rainbow=false,glow=false,particle=false,halo=false,fireTrail=false,invisible=false}
local fxConns={};local fxParts={}
local particleType="Fire"
local function setRainbow(v)
    charFx.rainbow=v
    if v then
        fxConns.rainbow=RunService.Heartbeat:Connect(safe(function()
            local c=getChar();if not c then return end
            local col=Color3.fromHSV(tick()%1,0.8,1)
            for _,p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then pcall(function() p.Color=col end) end
            end
        end,"彩虹色"))
    else
        if fxConns.rainbow then pcall(function() fxConns.rainbow:Disconnect() end);fxConns.rainbow=nil end
    end
end
local function setGlow(v)
    charFx.glow=v
    local c=getChar();if not c then return end
    for _,p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then
            pcall(function() p.Material=v and Enum.Material.Neon or Enum.Material.Plastic end)
        end
    end
end
local function setInvisible(v)
    charFx.invisible=v
    local c=getChar();if not c then return end
    for _,p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then
            pcall(function() p.Transparency=v and 1 or(p.Name=="HumanoidRootPart" and 1 or 0) end)
        elseif p:IsA("Decal")or p:IsA("Texture") then
            pcall(function() p.Transparency=v and 1 or 0 end)
        end
    end
end
local function setParticle(v)
    charFx.particle=v
    local r=getRoot();if not r then return end
    if v then
        local att=Instance.new("Attachment");att.Name="CharParticle";att.Parent=r
        local pe=Instance.new("ParticleEmitter");pe.Parent=att
        pe.Rate=40;pe.Lifetime=NumberRange.new(0.5,1.5);pe.Speed=NumberRange.new(3,8)
        pe.SpreadAngle=Vector2.new(30,30);pe.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)})
        if particleType=="Fire" then
            pe.Texture="rbxassetid://154966922";pe.Color=ColorSequence.new(Color3.fromRGB(255,100,0),Color3.fromRGB(255,200,0))
            pe.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,2),NumberSequenceKeypoint.new(1,5)})
        elseif particleType=="Heart" then
            pe.Texture="rbxassetid://154966922";pe.Color=ColorSequence.new(Color3.fromRGB(255,50,100))
            pe.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,3)})
        else
            pe.Texture="rbxassetid://154966922";pe.Color=ColorSequence.new(Color3.fromRGB(255,255,100))
            pe.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,4)})
        end
        fxParts.particle=att
    else
        if fxParts.particle then pcall(function() fxParts.particle:Destroy() end);fxParts.particle=nil end
    end
end
local function setHalo(v)
    charFx.halo=v
    local c=getChar();local head=c and c:FindFirstChild("Head")
    if not head then return end
    if v then
        local halo=Instance.new("Part");halo.Name="CharHalo";halo.Shape=Enum.PartType.Cylinder
        halo.Size=Vector3.new(0.3,3,3);halo.CanCollide=false;halo.Anchored=false
        halo.Material=Enum.Material.Neon;halo.Color=Color3.fromRGB(255,215,0);halo.Transparency=0.2
        halo.Parent=head
        local mw=Instance.new("Motor6D");mw.Part0=head;mw.Part1=halo
        mw.C0=CFrame.new(0,2,0)*CFrame.Angles(0,0,math.rad(90));mw.Parent=head
        fxParts.halo=halo
        fxConns.halo=RunService.Heartbeat:Connect(safe(function()
            if halo and halo.Parent then halo.CFrame=halo.CFrame*CFrame.Angles(0,0.05,0) end
        end,"光环旋转"))
    else
        if fxConns.halo then pcall(function() fxConns.halo:Disconnect() end);fxConns.halo=nil end
        if fxParts.halo then pcall(function() fxParts.halo:Destroy() end);fxParts.halo=nil end
    end
end
local function setFireTrail(v)
    charFx.fireTrail=v
    local r=getRoot();if not r then return end
    if v then
        local att=Instance.new("Attachment");att.Name="FireTrail";att.Parent=r
        local tr=Instance.new("Trail");tr.Parent=att
        tr.Attachment0=att;tr.Lifetime=0.6;tr.WidthScale=NumberSequence.new({NumberSequenceKeypoint.new(0,3),NumberSequenceKeypoint.new(1,0)})
        tr.Color=ColorSequence.new(Color3.fromRGB(255,100,0),Color3.fromRGB(255,200,0),Color3.fromRGB(255,50,0))
        tr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)})
        tr.LightEmission=1;fxParts.fireTrail=att
    else
        if fxParts.fireTrail then pcall(function() fxParts.fireTrail:Destroy() end);fxParts.fireTrail=nil end
    end
end
local function setCharSize(v)
    local h=getHum();if not h then return end
    pcall(function()
        h.BodyHeightScale.Value=v;h.BodyWidthScale.Value=v
        h.BodyDepthScale.Value=v;h.HeadScale.Value=v
    end)
end
local function copyAppearance(tp)
    local desc=nil
    pcall(function() desc=Players:GetHumanoidDescriptionFromUserId(tp.UserId) end)
    if desc then
        local h=getHum()
        if h then pcall(function() h:ApplyDescriptionReset(desc) end) end
        pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="角色",Text="已复制 "..tp.Name,Duration=2}) end)
    end
end
local function randomAppearance()
    local ids={1,2,3,4,5,6,7,8,9,10}
    local rid=ids[math.random(#ids)]
    local desc=nil
    pcall(function() desc=Players:GetHumanoidDescriptionFromUserId(rid) end)
    if desc then
        local h=getHum();if h then pcall(function() h:ApplyDescriptionReset(desc) end) end
    end
end
local function playEmote(id)
    local h=getHum();if not h then return end
    pcall(function()
        local anim=Instance.new("Animation");anim.AnimationId="http://www.roblox.com/asset/?id="..id
        local track=h:LoadAnimation(anim);track:Play()
        Debris:AddItem(anim,5)
    end)
end
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if charFx.glow then setGlow(true) end
    if charFx.invisible then setInvisible(true) end
    if charFx.rainbow then setRainbow(true) end
end)

-- ===================== 实时翻译 =====================
local transOn=false;local transConns={};local transCache={}
local function hasCN(t) for i=1,#t do local b=string.byte(t,i);if b>=228 and b<=233 then return true end end;return false end
local function doTrans(t,cb)
    local url="https://api.mymemory.translated.net/get?q="..HttpService:UrlEncode(t).."&langpair=auto|zh-CN"
    task.spawn(function()
        local ok,r=pcall(function() return game:HttpGet(url,true) end)
        if ok and r then
            local o,d=pcall(function() return HttpService:JSONDecode(r) end)
            if o and d and d.responseData and d.responseData.translatedText then cb(d.responseData.translatedText)
            else cb(nil) end
        else cb(nil) end
    end)
end
local function showTrans(name,org,tr)
    local nf=Instance.new("Frame");nf.Size=UDim2.new(0,300,0,60)
    nf.Position=UDim2.new(1,-320,0,100+#transCache*70);nf.BackgroundColor3=Color3.fromRGB(15,10,35)
    nf.BackgroundTransparency=0.1;nf.BorderSizePixel=0;nf.Parent=MainGui
    Instance.new("UICorner",nf).CornerRadius=UDim.new(0,10)
    local t1=Instance.new("TextLabel");t1.Size=UDim2.new(1,-10,0,16);t1.Position=UDim2.new(0,10,0,4)
    t1.BackgroundTransparency=1;t1.Text="🌐 "..name;t1.TextColor3=Color3.fromRGB(120,200,255)
    t1.TextSize=11;t1.Font=Enum.Font.GothamBold;t1.TextXAlignment=Enum.TextXAlignment.Left;t1.Parent=nf
    local t2=Instance.new("TextLabel");t2.Size=UDim2.new(1,-10,0,16);t2.Position=UDim2.new(0,10,0,20)
    t2.BackgroundTransparency=1;t2.Text=string.sub(org,1,45);t2.TextColor3=Color3.fromRGB(180,175,200)
    t2.TextSize=10;t2.Font=Enum.Font.Gotham;t2.TextXAlignment=Enum.TextXAlignment.Left;t2.Parent=nf
    local t3=Instance.new("TextLabel");t3.Size=UDim2.new(1,-10,0,18);t3.Position=UDim2.new(0,10,0,36)
    t3.BackgroundTransparency=1;t3.Text="→ "..string.sub(tr,1,50);t3.TextColor3=Color3.fromRGB(120,255,170)
    t3.TextSize=11;t3.Font=Enum.Font.GothamBold;t3.TextXAlignment=Enum.TextXAlignment.Left;t3.Parent=nf
    transCache[#transCache+1]=nf
    if #transCache>20 then local old=table.remove(transCache,1);pcall(function() old:Destroy() end) end
    task.delay(5,function()
        TweenService:Create(nf,TweenInfo.new(0.4),{BackgroundTransparency=1}):Play()
        for _,c in nf:GetChildren() do if c:IsA("TextLabel") then TweenService:Create(c,TweenInfo.new(0.4),{TextTransparency=1}):Play() end end
        task.wait(0.5);pcall(function() nf:Destroy() end)
        for i,v in ipairs(transCache) do if v==nf then table.remove(transCache,i) end end
    end)
end
local function handleChat(plr,msg)
    if not transOn or plr==LocalPlayer or not msg or #msg<2 then return end
    if hasCN(msg)or transCache[msg] then return end
    transCache[msg]=true;if #transCache>30 then table.remove(transCache,1) end
    doTrans(msg,function(tr) if tr and tr~=msg then showTrans(plr.Name,msg,tr) end end)
end
local function setTrans(v)
    transOn=v
    if v then
        local c1=Players.PlayerChatted:Connect(function(p,m) handleChat(p,m) end);table.insert(transConns,c1)
        local TCS=game:GetService("TextChatService")
        if TCS and TCS.TextChannels then
            for _,ch in ipairs(TCS.TextChannels:GetChildren()) do
                if ch:IsA("TextChannel") then
                    local c2=ch.MessageReceived:Connect(function(m)
                        local p=Players:GetPlayerByUserId(m.TextSource and m.TextSource.UserId or 0)
                        if p then handleChat(p,m.Text) end
                    end);table.insert(transConns,c2)
                end
            end
        end
        pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="小贺脚本",Text="🌐 翻译已开启",Duration=2}) end)
    else
        for _,c in transConns do pcall(function() c:Disconnect() end) end;transConns={}
    end
end

-- ===================== FPS/夜视 =====================
local fpsOn=false;local fpsConn=nil;fpsLabel=nil
local function setFPS(v)
    fpsOn=v
    if v then
        fpsLabel=Instance.new("TextLabel");fpsLabel.Size=UDim2.new(0,100,0,26)
        fpsLabel.Position=UDim2.new(0,10,0,10);fpsLabel.BackgroundColor3=Color3.fromRGB(0,0,0)
        fpsLabel.BackgroundTransparency=0.5;fpsLabel.Text="FPS: --";fpsLabel.TextColor3=Color3.fromRGB(0,255,0)
        fpsLabel.TextSize=13;fpsLabel.Font=Enum.Font.Code;fpsLabel.Parent=MainGui
        Instance.new("UICorner",fpsLabel).CornerRadius=UDim.new(0,6)
        local lt=tick();local fr=0
        fpsConn=RunService.RenderStepped:Connect(function()
            fr=fr+1;local now=tick()
            if now-lt>=1 then fpsLabel.Text="FPS: "..fr;fr=0;lt=now end
        end)
    else
        if fpsConn then pcall(function() fpsConn:Disconnect() end);fpsConn=nil end
        if fpsLabel then pcall(function() fpsLabel:Destroy() end);fpsLabel=nil end
    end
end
local function setNight(v)
    if v then
        game.Lighting.Ambient=Color3.new(1,1,1);game.Lighting.OutdoorAmbient=Color3.new(1,1,1)
        game.Lighting.Brightness=3
    else
        game.Lighting.Ambient=Color3.new(0,0,0);game.Lighting.OutdoorAmbient=Color3.new(0.5,0.5,0.5)
        game.Lighting.Brightness=1
    end
end

-- ===================== 面板开关/拖动 =====================
local panelOpen=false
local function openPanel()
    panelOpen=true;FloatBtn.Visible=false;Panel.Visible=true
    Panel.BackgroundTransparency=1;PB.Transparency=1
    TweenService:Create(Panel,TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{BackgroundTransparency=0}):Play()
    TweenService:Create(PB,TweenInfo.new(0.3),{Transparency=0.4}):Play()
end
local function closePanel()
    panelOpen=false
    TweenService:Create(Panel,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{BackgroundTransparency=1}):Play()
    TweenService:Create(PB,TweenInfo.new(0.25),{Transparency=1}):Play()
    task.wait(0.25);Panel.Visible=false;FloatBtn.Visible=true
end
FloatBtn.MouseButton1Click:Connect(function() if panelOpen then closePanel() else openPanel() end end)
CloseBtn.MouseButton1Click:Connect(closePanel)
local dragging=false;local ds=nil;local sp=nil;local dt=nil
FloatBtn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true;ds=i.Position;sp=FloatBtn.Position;dt=FloatBtn end end)
Header.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true;ds=i.Position;sp=Panel.Position;dt=Panel end end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and(i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement) then
        local d=i.Position-ds;dt.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)

-- ===================== 构建9个标签页 =====================
addTabBtn("主页",1);local tHome=createTab("主页")
addPara(tHome,"作者","小贺 (H831288he9)")
addPara(tHome,"版本","V16 · 最终完整版")
addPara(tHome,"QQ群","1104880878")
addLabel(tHome,"此脚本完全免费，禁止倒卖")
addLabel(tHome,"执行器: "..identifyexecutor())
addLabel(tHome,"用户名: "..LocalPlayer.Name)
if LocalPlayer.Name==AUTHOR_NAME then addLabel(tHome,"✦ 你是作者，白名单已激活 ✦") end
addBtn(tHome,"在线玩家列表",showPlayerList)
addBtn(tHome,"关闭全部功能",function()
    if flyActive then stopFly() end
    setIJ(false);setNC(false);setAntiFall(false);setAntiKb(false)
    setSpin(false);setNoFallDmg(false);setAutoJump(false)
    setAim(false);setBulletTrack(false);setForceView(false);setHitbox(false)
    setEsp(false);setTrans(false);setFPS(false)
    setRainbow(false);setGlow(false);setParticle(false);setHalo(false)
    setFireTrail(false);setInvisible(false);setNight(false)
    pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="小贺脚本",Text="已关闭全部",Duration=2}) end)
end)

addTabBtn("移动",2);local tMove=createTab("移动")
addBtn(tMove,"飞行面板",createFlyPanel)
addToggle(tMove,"无限跳",false,setIJ)
addToggle(tMove,"穿墙",false,setNC)
addToggle(tMove,"防坠落",false,setAntiFall)
addToggle(tMove,"终极防甩飞",false,setAntiKb)
addToggle(tMove,"无坠落伤害",false,setNoFallDmg)
addToggle(tMove,"自动跳",false,setAutoJump)
addToggle(tMove,"人物自转",false,setSpin)
addSlider(tMove,"自转速度",1,50,10,function(v) spinSpd=v/100 end)
addSlider(tMove,"移动速度",16,200,16,function(v) local h=getHum();if h then h.WalkSpeed=v end end)
addSlider(tMove,"跳跃高度",50,300,50,function(v) local h=getHum();if h then h.JumpPower=v end end)
addSlider(tMove,"重力设置",0,300,196,function(v) workspace.Gravity=v end)

addTabBtn("战斗",3);local tCombat=createTab("战斗")
addLabel(tCombat,"=== 自瞄Pro ===")
addToggle(tCombat,"自瞄开关",false,setAim)
addBtn(tCombat,"瞄准部位: 头部/上身/全身",function()
    aimIdx=aimIdx%#aimParts+1;aimPart=aimParts[aimIdx]
    local names={Head="头部",UpperTorso="上身",HumanoidRootPart="全身"}
    pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="自瞄",Text="部位: "..(names[aimPart]or aimPart),Duration=2}) end)
end)
addSlider(tCombat,"FOV圈大小",50,500,200,function(v) aimFOV=v end)
addSlider(tCombat,"瞄准平滑度",2,30,10,function(v) aimSmooth=v/100 end)
addSlider(tCombat,"移动预判",0,50,20,function(v) aimPred=v/100 end)
addToggle(tCombat,"自瞄队伍检测",false,function(v) aimTeam=v end)
addLabel(tCombat,"=== 其他战斗 ===")
addToggle(tCombat,"子弹追踪",false,setBulletTrack)
addToggle(tCombat,"强制视角",false,setForceView)
addToggle(tCombat,"碰撞箱修改",false,setHitbox)
addSlider(tCombat,"碰撞箱倍数",1,10,2,function(v) hitboxSize=v end)
addBtn(tCombat,"甩飞玩家(环绕旋转)",function() selectPlayer(function(p) flingPlayer(p) end,"甩飞目标") end)
addBtn(tCombat,"传送玩家",function() selectPlayer(function(p) tpPlayer(p) end,"传送目标") end)
addBtn(tCombat,"自杀/重置",function() local h=getHum();if h then h.Health=0 end end)
addBtn(tCombat,"清空背包",function()
    local c=getChar();if c then for _,i in c:GetChildren() do if i:IsA("Tool") then i:Destroy() end end end
    local bp=LocalPlayer:FindFirstChild("Backpack");if bp then for _,i in bp:GetChildren() do if i:IsA("Tool") then i:Destroy() end end end
end)

addTabBtn("透视",4);local tEsp=createTab("透视")
addToggle(tEsp,"透视总开关",false,setEsp)
addToggle(tEsp,"白色正方形碰撞箱",true,function(v) espBox=v end)
addSlider(tEsp,"碰撞箱大小",2,80,10,function(v) espBoxSize=v/10 end)
addSlider(tEsp,"碰撞箱透明度",0,10,4,function(v) espBoxAlpha=v/10 end)
addToggle(tEsp,"2D方框",true,function(v) espBox=v end)
addToggle(tEsp,"追踪线",true,function(v) espLine=v end)
addToggle(tEsp,"信息文字",true,function(v) espInfo=v end)
addToggle(tEsp,"血条",true,function(v) espHp=v end)
addToggle(tEsp,"队伍检测(只透视敌人)",false,function(v) espTeam=v end)
addSlider(tEsp,"透视最大距离",100,1200,500,function(v) espDist=v end)

addTabBtn("角色",5);local tChar=createTab("角色")
addLabel(tChar,"=== 外观特效（别人能看见）===")
addToggle(tChar,"彩虹色循环",false,setRainbow)
addToggle(tChar,"发光(Neon)",false,setGlow)
addToggle(tChar,"隐身/透明",false,setInvisible)
addSlider(tChar,"角色大小",5,30,10,function(v) setCharSize(v/10) end)
addLabel(tChar,"=== 粒子特效 ===")
addToggle(tChar,"粒子特效",false,setParticle)
addBtn(tChar,"粒子: 火焰",function() particleType="Fire";if charFx.particle then setParticle(false);task.wait(0.1);setParticle(true) end end)
addBtn(tChar,"粒子: 爱心",function() particleType="Heart";if charFx.particle then setParticle(false);task.wait(0.1);setParticle(true) end end)
addBtn(tChar,"粒子: 星星",function() particleType="Star";if charFx.particle then setParticle(false);task.wait(0.1);setParticle(true) end end)
addToggle(tChar,"头顶光环",false,setHalo)
addToggle(tChar,"火焰拖尾",false,setFireTrail)
addLabel(tChar,"=== 外观操作 ===")
addBtn(tChar,"复制别人外观",function() selectPlayer(function(p) copyAppearance(p) end,"复制外观") end)
addBtn(tChar,"随机外观",randomAppearance)
addBtn(tChar,"恢复默认外观",function()
    local h=getHum();if h then pcall(function() h:ApplyDescriptionReset(Players:GetHumanoidDescriptionFromUserId(LocalPlayer.UserId)) end) end
end)
addLabel(tChar,"=== 动作 ===")
addBtn(tChar,"跳舞",function() playEmote("180426354") end)
addBtn(tChar,"挥手",function() playEmote("180426354") end)
addBtn(tChar,"坐下",function() local h=getHum();if h then h.Sit=true end end)

addTabBtn("渲染",6);local tRender=createTab("渲染")
addToggle(tRender,"全亮夜视",false,setNight)
addToggle(tRender,"FPS显示",false,setFPS)
addSlider(tRender,"FOV视野",50,120,70,function(v) Camera.FieldOfView=v end)
addBtn(tRender,"时间-白天",function() game.Lighting.ClockTime=12 end)
addBtn(tRender,"时间-黑夜",function() game.Lighting.ClockTime=0 end)
addBtn(tRender,"画质-最低",function() settings().Rendering.QualityLevel=Enum.QualityLevel.Level01 end)
addBtn(tRender,"画质-最高",function() settings().Rendering.QualityLevel=Enum.QualityLevel.Level21 end)

addTabBtn("翻译",7);local tTrans=createTab("翻译")
addToggle(tTrans,"实时翻译开关",false,setTrans)
addPara(tTrans,"说明","开启后自动识别聊天外语翻译成中文")
addPara(tTrans,"支持","英日韩法德西等多语言")
addLabel(tTrans,"来源：MyMemory免费API")

addTabBtn("外部",8);local tExt=createTab("外部")
addLabel(tExt,"需要Http权限")
local exts={
    {"光影","https://pastebin.com/raw/arzRCgwS"},
    {"画质","https://pastebin.com/raw/jHBfJYmS"},
    {"旋转","https://pastebin.com/raw/r97d7dS0"},
    {"飞车","https://pastebin.com/raw/MHE1cbWF"},
    {"工具挂","https://raw.githubusercontent.com/Bebo-Mods/BeboScripts/main/StandAwekening.lua"},
    {"人物无敌","https://pastebin.com/raw/H3RLCWWZ"},
    {"速度更改","https://pastebin.com/raw/Zuw5T7DP"},
    {"爬墙","https://pastebin.com/raw/zXk4Rq2r"},
    {"动作","https://pastebin.com/raw/Zj4NnKs6"},
    {"电脑键盘","https://raw.githubusercontent.com/advxzivhsjjdhxhsidifvsh/mobkeyboard/main/main.txt"},
    {"铁拳","https://raw.githubusercontent.com/0Ben1/fe/main/obf_rf6iQURzu1fqrytcnLBAvW34C9N55kS9g9G3CKz086rC47M6632sEd4ZZYB0AYgV.lua.txt"},
    {"吸取全部玩家","https://pastebin.com/raw/hQSBGsw2"},
    {"死亡笔记","https://raw.githubusercontent.com/dingding123hhh/tt/main/%E6%AD%BB%E4%BA%A1%E7%AC%94%E8%AE%B0%20(1).txt"},
    {"甩人","https://pastebin.com/raw/zqyDSUWX"},
    {"踏空","https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float"},
    {"无限跳(外部)","https://pastebin.com/raw/V5PQy3y0"},
}
for _,s in ipairs(exts) do
    addBtn(tExt,s[1],function()
        pcall(function()
            loadstring(game:HttpGet(s[2],true))()
            game:GetService("StarterGui"):SetCore("SendNotification",{Title="外部",Text=s[1].." 已加载",Duration=2})
        end)
    end)
end

switchTab("主页")

print("✦ 小贺脚本 V16 最终版启动完成 ✦")
print("作者白名单: "..AUTHOR_NAME)
print("QQ群：1104880878")
print("终极防甩飞V3 + 环绕甩飞 + 自瞄Pro + ESP + 角色特效 + 作者标签")
