--检测地图是否为gm_millenium
if game.GetMap() != "gm_millenium" then return end

local nadmod = false
if file.Exists("autorun/server/nadmod_pp.lua", "LUA") then
    nadmod = true
end

if nadmod then
	function NADMOD.GetPropOwner(ent)
		local propData = NADMOD.Props[ent:EntIndex()]
		if propData then
			if propData.SteamID == "W" or propData.SteamID == "O" then
				return nil
			end
			return player.GetBySteamID(propData.SteamID)
		end
		return nil
	end
end

util.AddNetworkString("zh")
util.AddNetworkString("train_color")

net.Receive( "zh", function( len, ply )
    if net.ReadBool() then
        ply.IsZh = true
    else
        ply.IsZh = false
    end
end)

local SpClasses = {     --允许进入研讨会人员
    "yuuka",
    "yuka",
    "noa",
    "rio",
    "sensei",
    "诺亚",
    "优香",
    "諾亞",
    "優香",
    "先生",
    "老师",
    "莉音",
    "ユウカ",
    "ノア",
    "リオ"
}

local MpClasses = {     --七罪人..etc
    "yostar",
    "Isakusan",
    "mx2j",
    "<key>",
    "kei",
	"wakamo",
	"akira",
	"kai",
	"akemi",
    "ケイ",
	"ワカモ",
	"アキラ",
	"カイ",
	"アケミ",
    "梁永宁",
    "朴炳林",
    "李衡達",
    "悠星",
    "凯伊",
    "钥匙",
    "鑰匙",
	"若藻",
	"清澄",
	"申谷海",
	"栗浜",
	"栗濱"
}

local TrainPart = {
    "train_door",
    "train_hurt",
    "train_push",
    "train_pusha",
    "train_pushb",
    "train_phys",
    "train_music",
    "train_halo",
    "train_chair_model",
    "train_chair"
}

local excludedClasses = {
    "worldspawn",
    "trigger_",
    "point_combine_ball_launcher",
    "func_",
    "predicted_",
    "physgun_beam",
    "path_track",
    "gmod_hands",
    "info_",
    "env_",
    "light_",
    "phys_bone_follower",
    "ambient_",
    "prop_vehicle_prisoner_pod"
}

local IsCleanMap = false
local IsFullyLoaded = false

local function IsTrainPart(ent)
    local class = ent:GetName()

    for _, pattern in ipairs(TrainPart) do
        if string.find(class, pattern) or class == "train" then
            return true
        end
    end

    return false
end

local function shouldExclude(ent)
    local class = ent:GetClass()

    for _, pattern in ipairs(excludedClasses) do
        if string.find(class, pattern) then
            return true
        end
    end

    return false
end

function gm_millenium_preload()
    IsFullyLoaded = true
    for _, ent in ipairs(ents.GetAll()) do
        if IsTrainPart(ent) and !IsCleanMap then
            ent:Remove()
        end 
    end
end

hook.Add("PreCleanupMap", "gm_millenium_preClean", function()
    IsCleanMap = true
end)

hook.Add("PostCleanupMap", "gm_millenium_postClean", function()
    IsCleanMap = false
end)

hook.Add("OnMapSpawn", "gm_millenium_spawn", function()
    timer.Simple(0.01, function()
        timer.Simple(0.1, function()
            for _, ent in ipairs(ents.FindByName("train_chair")) do
                ent:SetTable({
                    VehicleTable = {
                    Members = {
                        HandleAnimation = function(_, ply)
                        return ply:SelectWeightedSequence(ACT_GMOD_SIT_ROLLERCOASTER)
                        end
                    }
                    }
                })
                --ent:SetKeyValue("vehiclescript", "")
                ent:SetNoDraw(true)
            end
        end)
        local box = ents.FindByName("train_phys")[1]
        local train = ents.FindByName("train")[1]
        for _, ent in ipairs(ents.GetAll()) do
            if !IsTrainPart(ent) then continue end
            --print(ent:GetName())
            constraint.NoCollide(box, ent)
        end
        
        train:AddEFlags(16, 2097152, 536870912, 1073741824)
        train:SetUnFreezable(true)
    end)
end)

local function doFunnyCombineBall(ent)
    local owner
    if ent:GetOwner():IsPlayer() then 
        owner = ent:GetOwner()
    end
    local train = ents.FindByName("train")[1]
    print("Rebounding!!")
    for i = 1, 30 do
        local cballspawner = ents.Create("point_combine_ball_launcher")
        cballspawner:SetAngles(ent:GetAngles())
        cballspawner:SetPos(ent:GetPos())
        cballspawner:SetKeyValue("minspeed", 150)
        cballspawner:SetKeyValue("maxspeed", 2000)
        cballspawner:SetKeyValue("ballradius", "20")
        cballspawner:SetKeyValue("ballcount", "1")
        cballspawner:SetKeyValue("maxballbounces", "300")
        cballspawner:SetKeyValue("launchconenoise", 1800)
        cballspawner:Spawn()
        cballspawner:Activate()
        cballspawner:Fire("LaunchBall")
        cballspawner:Fire("kill", "", 0)

        local pos = ent:GetPos()

        timer.Simple(0.01, function()
            for k, v in pairs(ents.FindInSphere(pos, 20)) do
                if string.find(v:GetClass(), "prop_combine_ball") and not IsValid(v:GetOwner()) then
                    local yuukaball = ents.Create("prop_dynamic")
                    yuukaball:SetAngles(v:GetAngles())
                    yuukaball:SetPos(v:GetPos())
                    yuukaball:SetModel("models/azimuth/bluearchive/yuuka/hayase_yuuka.mdl")
                    yuukaball:Spawn()
                    yuukaball:Activate()
                    yuukaball:SetNotSolid(true)
                    yuukaball:SetParent(v)
                    yuukaball:Fire("kill", "", 6)
                    v:SetOwner(train)
                    v.IsChball = true
                    v:SetNoDraw(true)
                    v:GetPhysicsObject():AddGameFlag(FVPHYSICS_WAS_THROWN)
                    v:Fire("explode", "", 6)

                    if IsValid(owner) then
                        local ownerPos = owner:GetPos()
                        local ballPos = v:GetPos()
                        local direction = (ownerPos - ballPos):GetNormalized()
                        local speed = 100
                        local velocity = direction * speed
                        yuukaball:SetColor(Color(math.random(0, 255), math.random(0, 255), math.random(0, 255)))
                        v:GetPhysicsObject():SetVelocity(velocity)
                        constraint.NoCollide(v, train)
                        v:GetPhysicsObject():AddGameFlag(FVPHYSICS_DMG_DISSOLVE)
                        v:SetSolid(0)
                        timer.Create("CheckYuukaClipCollision", 0.1, 0, function()
                            if IsValid(v) and IsValid(owner) then
                                if owner:GetPos():Distance(v:GetPos()) <= 200 then
                                    if owner:IsPlayer() then
                                        owner:SendLua("EmitSound('funking_time.mp3', LocalPlayer():GetPos(), -1)")
                                    end
                                    owner:Dissolve()
                                    timer.Remove("CheckYuukaClipCollision")
                                end
                            else
                                timer.Remove("CheckYuukaClipCollision")
                            end
                        end)
                    else
                        local randomVelocity = Vector(math.Rand(150, 5000), math.Rand(150, 5000), math.Rand(150, 5000))
                        local trainVelocity = train:GetPhysicsObject():GetVelocity()
                        local trainAngle = train:GetPhysicsObject():GetAngleVelocity()
                        local randomAngle = Vector(math.Rand(-0.360, 0.360), math.Rand(-0.360, 0.360), math.Rand(-0.360, 0.360))

                        v:GetPhysicsObject():SetAngleVelocity(trainAngle * 2000 + randomAngle)
                        v:GetPhysicsObject():SetVelocity(trainVelocity * 2000 + randomVelocity)
                    end
                end
            end
        end)
    end
end

local function processEntities(entities)
    local train = ents.FindByName("train")[1]           --定义trains为获取列表中targetname名为train的第一个实体
	
    for _, ent in ipairs(entities) do
        if shouldExclude(ent) then continue end
		
        local Pos = ent:GetPos()                                       --定义Pos为获取实体方位
        print(string.format("%s block the train! ", ent))                                                 --打印message
        print("Defusing!!")

        if ent:GetClass() == "npc_combinedropship" then
            ent:Fire("becomeragdoll")
            return
        end
			
        if not ent:IsPlayer() then
            ent:SetMoveType(6)                                         --设置移动类型为6（物理）

            local health = ent:Health()                                --定义Health为获取实体的生命值
            local phys = ent:GetPhysicsObject()                        --定义phys为获取实体的物理对象

            if health > 0 then
                local tmphealth = ent:Health()
                local dmgInfo = DamageInfo()
                dmgInfo:SetAttacker(train)                             --设置伤害发起者为train
                dmgInfo:SetInflictor(train)                            --设置加害者为train
                dmgInfo:SetDamage(2400000)                             --2400000伤害
                dmgInfo:SetDamageType(DMG_CRUSH + DMG_DIRECT)
                ent:TakeDamageInfo(dmgInfo)                            --造成伤害
                print("Damaging!!!")
                if ent:Health() == tmphealth then
                    print(string.format("%s has god mode, frocing takedamage!!", ent))
                    ent:SetHealth(ent:Health() - info:GetDamage())
                end
                return
            end

            if ent.Type == "nextbot" or ent:IsNextBot() then
                local effectdata = EffectData()
                effectdata:SetOrigin(Pos)
                util.Effect("ManhackSparks", effectdata)
                util.Effect("AR2Explosion", effectdata)
                util.Effect("Explosion", effectdata)
                ent:Fire("killhierarchy")     --向实体输入killhierarchy（删除和这个实体有关的所有东西）
                print("Removing hierarchy!!!")
            end
			
            if ent:GetClass() == "prop_combine_ball" and !ent.IsChball then
                doFunnyCombineBall(ent)
                return
            end

            if IsValid(phys) and ent:GetClass() != "npc_combinedropship" and ent:GetClass() != "prop_combine_ball" then     --如果存在物理对象
                phys:SetVelocity(train:GetBaseVelocity() * 2000)
                phys:AddVelocity(train:GetVelocity() + phys:GetVelocity() * 100)
                phys:SetAngleVelocity(train:GetPhysicsObject():GetAngleVelocity() * 2000)
                phys:AddAngleVelocity(phys:GetAngleVelocity() * 100)
                phys:SetAngles(train:GetAngles() * math.Rand(1, 2))
                phys:SetAngles(train:GetAngles() + phys:GetAngles() * math.Rand(0.01, 0.1))     --添加作用和角作用力
                print("Pushing!!!")
                return
            end

            if ent:GetClass() == "move_rope" or "keyframe_rope" then                       --如果实体的类别是move_rope或keyframe_rope
                ent:Remove()                                                          --删除实体
                return
            end

            local effectdata = EffectData()                                       --定义effectdata为获取游戏内置特效库
            effectdata:SetOrigin(Pos)                                             --设置特效的方位在pos
            util.Effect("Explosion", effectdata)                                  --Explosion特效

            ent:Remove()
            print("Removing!!!")
        end

        if ent:IsPlayer() then
            if ent:Alive() then                                                     --如果玩家还活着
                ent:GodDisable()
                local dmgInfo = DamageInfo()
                dmgInfo:SetAttacker(train)                             --设置伤害发起者为train
                dmgInfo:SetInflictor(train)                            --设置加害者为train
                dmgInfo:SetDamage(2400000)                             --2400000伤害
                dmgInfo:SetDamageType(DMG_CRUSH + DMG_DIRECT)
                ent:TakeDamageInfo(dmgInfo)                                                       --杀死玩家
                if ent:Alive() then ent:Kill() end
                ent:ScreenFade(SCREENFADE.STAYOUT, Color(255, 0, 0, 255), 0, 0)     --设置屏幕rgb效果为 255 0 0 255
                ent:GetRagdollEntity():SetVelocity(train:GetAbsVelocity() * ent:GetBaseVelocity())
                print("Killing!!!")

                return
            end

            ent:ScreenFade(SCREENFADE.STAYOUT, Color(255, 255, 255, 0), 0, 0)
        end

        print("Okay")
    end
end

hook.Add("AcceptInput", "gm_millenium_IO", function( ent, name, activator, caller, data )
    if ent:GetName() == "siminar_key" and activator:IsPlayer() then
        activator:SendLua("EmitSound('funking_time.mp3', LocalPlayer():GetPos(), -1)")
        activator.AuthSiminar = true
    end
    if ent:GetName() == "train_case" and activator:IsPlayer() then
        local trainref = ents.FindByName("train_ref")[1]
        local train = ents.FindByName("train")[1]
        if data == 1 then
            if IsValid(trainref) then trainref:SetColor(Color(0,0,0)) end
            if activator.IsZh then
                activator:PrintMessage(HUD_PRINTTALK, "列车现在已经安全地移除了")
            else
                activator:PrintMessage(HUD_PRINTTALK, "The train is now safety removed")
            end
            train.IsStop = true
            IsCleanMap = true
            for _, ent in ipairs(ents.GetAll()) do
                if IsTrainPart(ent) then
                    ent:Remove()
                end
            end
        elseif data == 2 then
            if IsValid(trainref) then trainref:SetColor(Color(255,255,255)) end
            if activator.IsZh then
                activator:PrintMessage(HUD_PRINTTALK, "列车已重新生成")
            else
                activator:PrintMessage(HUD_PRINTTALK, "Train has respawned")
            end
            ents.FindByName("train_template")[1]:Fire("forcespawn")
            IsCleanMap = false
            timer.Simple(0.1, function()
                for _, ent in ipairs(ents.FindByName("train_chair")) do
                    ent:SetTable({
                        VehicleTable = {
                        Members = {
                            HandleAnimation = function(_, ply)
                            return ply:SelectWeightedSequence(ACT_GMOD_SIT_ROLLERCOASTER)
                            end
                        }
                        }
                    })
                    --ent:SetKeyValue("vehiclescript", "")
                    ent:SetNoDraw(true)
                end
            end)
        end
    end
end)

hook.Add("OnTrainFuck", "TrainHurter", function()       --当触发列车撞击事件
    local train = ents.FindByName("train")[1]           --定义trains为获取列表中targetname名为train的第一个实体
    local triggerAreas = ents.FindByName("train_pusha") --定义triggerAreas为获取targetname名为train_pusha的实体

    for _, triggerArea in ipairs(triggerAreas) do
        if not IsValid(triggerArea) then continue end

        local center = triggerArea:GetPos()                   --定义center为获取触发器范围的中心
        local nearbyEntities = ents.FindInSphere(center, 500) --定义nearbyEntities为获取以center为中心的500英寸半径内的实体

        if train:GetVelocity():Length() <= 500 then return end

        for _, ent in ipairs(nearbyEntities) do               --处理半径内的实体
            if ent:IsPlayer() or shouldExclude(ent) or ent:GetModel() == "models/azimuth/bluearchive/yuuka/hayase_yuuka.mdl" or IsTrainPart(ent) then continue end

            ent:SetParent(nil)                        --设置实体父级为空（清除父级）

            local phys = ent:GetPhysicsObject()
            if IsValid(phys) then
                phys:EnableMotion(true) --使物理对象可以移动
                phys:EnableDrag(true)   --使物理对象可以拖拽
                phys:Wake(true)         --唤醒物理对象
                phys:SetMass(50000)     --设置重量为50000
            end

            local Pos = ent:GetPos()
            local effectdata = EffectData()
            effectdata:SetOrigin(Pos)
            util.Effect("Sparks", effectdata)

            constraint.RemoveAll(ent)                                 --清除所有约束
            constraint.NoCollide(ent, ent)                            --为实体和实体之间添加无碰撞约束
            for _, train in ipairs(TrainPart) do
                --print(ent:GetName())
                constraint.NoCollide(ent, train)
            end                          --为train和实体之间添加无碰撞约束
            local solid = ent:GetSolid()

            --ent:SetSolid(0)
            timer.Simple(0.5, function() if IsValid(ent) then constraint.RemoveAll(ent) ent:SetSolid(solid) end end) --0.1秒后再次清除所有约束
        end

        local mins = triggerArea:LocalToWorld(triggerArea:OBBMins())
        local maxs = triggerArea:LocalToWorld(triggerArea:OBBMaxs())
        local entities = ents.FindInBox(mins, maxs) --触发器方形范围
		for _, ent in ipairs(entities) do
			if nadmod and IsValid(NADMOD.GetPropOwner(ent)) then
				table.insert(entities, NADMOD.GetPropOwner(ent))
			end
		end
        processEntities(entities)
    end
end)

local function playerModelAndNameHaveMatchingString(ply, pattern)
    local model = ply:GetModel()
    local nick = ply:Nick()

    return string.match(model, pattern) or string.match(nick, pattern)
end

local function loopOverPlayersSiminarAreas(func)
    for _, siminarArea in ipairs(ents.FindByName("siminar_door_trigger")) do
        local min, max = siminarArea:WorldSpaceAABB()
        local EntInsd = ents.FindInBox(min, max)

        for _, ply in ipairs(EntInsd) do
            if not ply:IsPlayer() then continue end

            func(ply)
        end
    end
end

local function loopOverPlayersSiminarGateAreas(func)
    for _, siminarArea in ipairs(ents.FindByName("siminar_door_trigger")) do
        local min, max = siminarArea:WorldSpaceAABB()
        local EntInsd = ents.FindInBox(min, max)

        for _, ply in ipairs(EntInsd) do
            if not ply:IsPlayer() then continue end

            func(ply)
        end
    end
end

hook.Add("SIMINAR_U", "siminar_defcon4", function()                  --警戒等级1
    loopOverPlayersSiminarAreas(function(ply)
        local nick = ply:Nick()

        print(string.format("%s is entering Siminar ", nick))

        for _, pattern in ipairs(SpClasses) do     --如果是允许进入研讨会人员
            if not playerModelAndNameHaveMatchingString(ply, pattern) and not ply.AuthSiminar then continue end
            
            print("WelCome!")

            local camera = ents.FindByName("siminar_camera")[1]   --定义camera为获取targetname名为siminar_camera的第一个实体
            local doors = ents.FindByClass("func_movelinear")     --定义doors为所有类别为func_movelinear的实体
            if IsValid(camera) then
                camera:AddEntityRelationship(ply, D_LI, 999)          --设置camera对玩家的羁绊类别为D_LI（喜欢
            end
            for _, door in ipairs(doors) do
                if IsValid(door) then
                    door:Fire("Open")                                 --开启所有门
                end
            end
        end

        for _, pattern in ipairs(MpClasses) do     --如果是七罪人
            if not playerModelAndNameHaveMatchingString(ply, pattern) then continue end

            hook.Run('SIMINAR_L2')         --运行SIMINAR_L2事件
        end
    end)
end)

hook.Add("SIMINAR_L1", "siminar_defcon3", function()     --警戒等级2
    loopOverPlayersSiminarAreas(function(ply)
        local nick = ply:Nick()                 --定义nick为获取玩家的昵称

        print(string.format("%s is entering Siminar ", nick))

        for _, pattern in ipairs(SpClasses) do     --如果是允许进入研讨会人员
            if not playerModelAndNameHaveMatchingString(ply, pattern) and not ply.AuthSiminar then continue end

            return
        end
    end)
end)

hook.Add("SIMINAR_L2", "siminar_defcon2", function()     --警戒等级3
    loopOverPlayersSiminarAreas(function(ply)
        local camera = ents.FindByName("siminar_camera")[1]

        for _, pattern in ipairs(SpClasses) do                       --如果是允许进入研讨会人员
            if not playerModelAndNameHaveMatchingString(ply, pattern) and not ply.AuthSiminar then continue end

            if IsValid(camera) then
                camera:AddEntityRelationship(ply, D_NU, 999)     --设置camera对玩家的羁绊类别为D_NU（中性）
            end
        end

        for _, pattern in ipairs(MpClasses) do                       --如果是七罪人
            if playerModelAndNameHaveMatchingString(ply, pattern) then
                if IsValid(camera) then
                    camera:AddEntityRelationship(ply, D_FR, 999)     --设置camera对玩家的羁绊类别为D_FR（害怕）  --camera:我错了，已老实，求放过😨
                    camera:Fire("Disable")                           --关闭camera  --camera:若藻别杀我😭
                end

                continue
            end
            if IsValid(camera) then
                camera:AddEntityRelationship(ply, D_HT, 999)
                camera:Fire("SetAngry")
            end
        end
    end)
end)

hook.Add("SIMINAR_L3", "siminar_defcon1", function()     --警戒等级4
    loopOverPlayersSiminarGateAreas(function(ply)
        for _, pattern in ipairs(SpClasses) do
            if playerModelAndNameHaveMatchingString(ply, pattern) or ply.AuthSiminar then
                for _, siminarArea in ipairs(ents.FindByName("siminar_gate_trigger")) do
                    if IsValid(siminarArea) then
                        siminarArea:Fire("Disable")
                    end
                end
            else
                for _, siminarArea in ipairs(ents.FindByName("siminar_gate_trigger")) do
                    ents.FindByName("siminar_light")[1]:Fire("TurnOn")
                    if IsValid(siminarArea) then
                        siminarArea:Fire("Enable")
                    end
                end
            end
        end

        for _, pattern in ipairs(MpClasses) do
            if playerModelAndNameHaveMatchingString(ply, pattern) then
                for _, siminarArea in ipairs(ents.FindByName("siminar_gate_trigger")) do
                    if IsValid(siminarArea) then
                        siminarArea:Fire("Enable")
                    end
                end
                ply:SetMoveType(6)
                ents.FindByName("siminar_light")[1]:Fire("TurnOn")

                continue
            end
        end
    end)
end)

hook.Add("SIMINAR_L4", "siminar_defcon0", function()     --警戒等级5
    loopOverPlayersSiminarAreas(function(ply)
        for _, turret in ipairs(ents.FindByName("siminar_turret")) do
            if IsValid(turret) then
                for _, pattern in ipairs(SpClasses) do
                    if playerModelAndNameHaveMatchingString(ply, pattern) and not ply.AuthSiminar then
                        turret:AddEntityRelationship(ply, D_LI, 999)

                        continue
                    end

                    ply:SetMoveType(6)
                end

                for _, pattern in ipairs(MpClasses) do
                    if not playerModelAndNameHaveMatchingString(ply, pattern) then continue end

                    turret:Fire("Enable")
                    turret:AddEntityRelationship(ply, D_HT, 999)
                end
            end
        end
    end)
end)

hook.Add( "CanDrive", "CanDriveTrain", function( ply, ent )
	if IsTrainPart(ent) then
        for _, pattern in ipairs(SpClasses) do
            if playerModelAndNameHaveMatchingString(ply, pattern) and not ply.AuthSiminar then
                return true
            else
                if ply.IsZh then
                    ply:PrintMessage(HUD_PRINTTALK, "有基沃托斯驾驶证吗？")
                else
                    ply:PrintMessage(HUD_PRINTTALK, "did u have driver's license of Kivotos?")
                end
                return false
            end
        end
    end
end)

hook.Add( "CanTool", "CanToolTrain", function( ply, tr, toolname, tool, button )
	local target = tr.Entity
    if IsValid(target) and IsTrainPart(target) then
        if ply.IsZh then
            ply:PrintMessage(HUD_PRINTTALK, "普通的工具枪无法操作高贵的千禧年列车")
        else
            ply:PrintMessage(HUD_PRINTTALK, "normal tools gun can not control noble millennium train")
        end
        return false
    end
end)

hook.Add( "CanProperty", "CanPropertyTrain", function( ply, property, ent )
	local target = ent
    if IsValid(target) and IsTrainPart(target) then
        if property != "drive" and property != "remover" and property != "collision" then
            if ply.IsZh then
                ply:PrintMessage(HUD_PRINTTALK, "你无法操作神秘的崇高属性")
            else
                ply:PrintMessage(HUD_PRINTTALK, "You can not control the property of the Mystic")
            end
            return false
        elseif property == "remover" then
            if ply.IsZh then
                ply:PrintMessage(HUD_PRINTTALK, "千禧年列车的列车是无敌")
            else
                ply:PrintMessage(HUD_PRINTTALK, "millennium's train is invisible")
            end
            return false
        elseif property == "collision" then
            if ply.IsZh then
                ply:PrintMessage(HUD_PRINTTALK, "你没有力量使神秘的实体面反转")
            else
                ply:PrintMessage(HUD_PRINTTALK, "You didn't have power to reverse the substance of Mystic")
            end
            return false
        end
    end
end )

local TrainArmor = "Normal"
local InfoArmor = "Normal"
local dmgscale = 1

hook.Add("EntityTakeDamage", "TrainRecDamage", function(target, info)
    --print(info:GetAttacker():GetName() .. " " .. target:GetName())
    if not IsTrainPart(target) and not target.IsTrainProtected or info:GetAttacker():IsWorld() then return end

    local attacker = info:GetAttacker()
    if attacker:GetName() == "train_phys" or attacker:GetName() == "train_hurt" or attacker:GetName() == "train" then return end --非常重要！！！！！
    local train = ents.FindByName("train")[1]
    local shield = ents.Create("prop_dynamic")
    for _, ent in ipairs(ents.FindByName("shield")) do
        if IsValid(ent) then shielded = true end
    end
    print("Under attack...")

    local finalColor = Color(0, 0, 0)
    local colorCount = 0

    if info:IsDamageType(DMG_GENERIC) or info:IsDamageType(DMG_BULLET) then
        finalColor.r = finalColor.r + 255
        finalColor.g = finalColor.g + 255
        finalColor.b = finalColor.b + 255
        colorCount = colorCount + 1
        InfoArmor = "Normal"
    end
    
    if info:IsDamageType(DMG_BLAST) or info:IsDamageType(DMG_CRUSH) or info:IsDamageType(DMG_VEHICLE) or info:IsDamageType(DMG_MISSILEDEFENSE) or info:IsDamageType(DMG_PHYSGUN) or info:IsDamageType(DMG_BLAST_SURFACE) or info:IsDamageType(DMG_BURN) then
        finalColor.r = finalColor.r + 255
        colorCount = colorCount + 1
        InfoArmor = "Explosive"
    end
    
    if info:IsDamageType(DMG_SLASH) or info:IsDamageType(DMG_SHOCK) or info:IsDamageType(DMG_ENERGYBEAM) or info:IsDamageType(DMG_PLASMA) or info:IsDamageType(DMG_AIRBOAT) or info:IsDamageType(DMG_SNIPER) then
        finalColor.r = finalColor.r + 255
        finalColor.g = finalColor.g + 255
        colorCount = colorCount + 1
        InfoArmor = "Piercing"
    end
    
    if info:IsDamageType(DMG_DISSOLVE) or info:IsDamageType(DMG_DROWN) or info:IsDamageType(DMG_ACID) or info:IsDamageType(DMG_PARALYZE) or info:IsDamageType(DMG_NERVEGAS) or info:IsDamageType(DMG_SLOWBURN) or info:IsDamageType(DMG_RADIATION) or info:IsDamageType(DMG_DROWNRECOVER) or info:IsDamageType(DMG_PREVENT_PHYSICS_FORCE) then
        finalColor.g = finalColor.g + 255
        finalColor.b = finalColor.b + 255
        colorCount = colorCount + 1
        InfoArmor = "Mystic"
    end
    
    if info:IsDamageType(DMG_SONIC) then
        finalColor.r = finalColor.r + 128
        finalColor.b = finalColor.b + 255
        colorCount = colorCount + 1
        InfoArmor = "Sonic"
    end
    
    if info:IsDamageType(DMG_CLUB) then
        finalColor.g = finalColor.g + 255
        colorCount = colorCount + 1
        InfoArmor = "Blunt"
    end
    
    if info:IsDamageType(DMG_DIRECT) then
        colorCount = colorCount + 1
        InfoArmor = "Direct"
    end
    
    finalColor.r = math.min(finalColor.r / colorCount, 255)
    finalColor.g = math.min(finalColor.g / colorCount, 255)
    finalColor.b = math.min(finalColor.b / colorCount, 255)

    if InfoArmor == TrainArmor and InfoArmor != "Normal" then
        dmgscale = 2
        MsgC( Color( 255, 128, 0), "Weak! :200% Damage return\n" )
    elseif (InfoArmor == "Mystic" and TrainArmor == "Sonic") or (InfoArmor == "Blunt" and TrainArmor == "Normal") or (InfoArmor == "Normal" and TrainArmor == "Blunt") then
        dmgscale = 1.5
        MsgC( Color( 255, 255, 192), "Effective? :150% Damage return\n" )
    elseif (InfoArmor == "Explosive" and TrainArmor == "Piercing") or (InfoArmor == "Mystic" and TrainArmor == "Piercing") or (InfoArmor == "Sonic" and TrainArmor == "Piercing") or (InfoArmor == "Explosive" and TrainArmor == "Mystic") or (InfoArmor == "Explosive" and TrainArmor == "Sonic") then
        dmgscale = 0.5
        MsgC( Color( 32, 0, 255), "Resist. :50% Damage return\n" )
    elseif InfoArmor == "Direct" then
        dmgscale = 100
        MsgC( Color( 255, 0, 0), "Cheat!!!!! :10000% Damage return\n" )
    elseif InfoArmor == "Normal" then
        dmgscale = 1
        MsgC( Color( 255, 255, 255), "Normal :100% Damage return\n" )
    end
    TrainArmor = InfoArmor

    info:SetAttacker(train)
    info:SetDamageType(DMG_CRUSH + DMG_DIRECT + info:GetDamageType())
    info:ScaleDamage(dmgscale)
    info:SetDamageForce(info:GetDamageForce() * 100)
    info:SetReportedPosition(target:GetPos())

	local attackers = {attacker}
	if IsValid(attacker:GetOwner()) then
		table.insert(attackers, attacker:GetOwner())
	end
	if nadmod and IsValid(NADMOD.GetPropOwner(attacker)) then
		table.insert(attackers, NADMOD.GetPropOwner(attacker))
	end
	if attacker:IsVehicle() and attacker:IsValid(attacker:GetDriver()) then
		table.insert(attackers, attacker:GetDriver())
	end

	for _, attacker in ipairs(attackers) do
        local tmphealth
		print(string.format("Attacker: %s, Damagetype: %s(%s), Damage: %f", attacker, InfoArmor, info:GetDamageType(), info:GetDamage()))
		if attacker:IsPlayer() and !attacker:HasGodMode() then
			attacker:SetVelocity(attacker:GetVelocity() - info:GetDamageForce())
			attacker:TakeDamageInfo(info)
			if attacker:GetMoveType() == MOVETYPE_NOCLIP then
                attacker:SetMoveType(MOVETYPE_WALK)
            end
		elseif attacker:IsPlayer() and attacker:HasGodMode() then
			attacker:SetVelocity(attacker:GetVelocity() - info:GetDamageForce())
			print("attacker has god mode, frocing takedamage!!")
			attacker:SetArmor(attacker:Armor() - info:GetDamage() * 2)
			if attacker:Armor() < 0 then attacker:SetArmor(0) end
			if attacker:Armor() <= 0 then
				attacker:SetHealth(attacker:Health() - info:GetDamage())
			else
				attacker:SetHealth(attacker:Health() - info:GetDamage() / attacker:Armor())
			end
			if attacker:Health() <= 0 then
                attacker:GodDisable()
                attacker:TakeDamageInfo(info)
                if attacker:Alive() then attacker:Kill() end
            end
            if attacker:GetMoveType() == MOVETYPE_NOCLIP then
                attacker:SetMoveType(MOVETYPE_WALK)
            end
		elseif attacker:IsNPC() then
			tmphealth = attacker:Health()
            info:SetDamageForce(info:GetDamageForce() * dmgscale)
			info:SetDamageType(info:GetDamageType() + DMG_CRUSH + DMG_AIRBOAT)
			attacker:TakePhysicsDamage(info)
			attacker:TakeDamageInfo(info)
			if attacker:Health() == tmphealth then
				print("attacker has god mode, frocing takedamage!!")
				attacker:SetHealth(attacker:Health() - info:GetDamage())
			end
        else
			tmphealth = attacker:Health()
			info:SetInflictor(target)
			info:SetDamageType(info:GetDamageType() + DMG_CRUSH + DMG_BLAST + DMG_AIRBOAT + DMG_DIRECT)

			attacker:SetVelocity(attacker:GetVelocity() + info:GetDamageForce())
			attacker:TakePhysicsDamage(info)
			attacker:TakeDamageInfo(info)
			if attacker:Health() == tmphealth then
				print("attacker has god mode, frocing takedamage!!")
				attacker:SetHealth(attacker:Health() - info:GetDamage())
			end
			--print(attacker:Health())
		end
	end
    
    if !shielded then
        shield:SetPos(train:GetPos())
        shield:SetModel("models/effects/hexshield.mdl")
        shield:Spawn()
        shield:Activate()
        shield:SetParent(train)
        shield:Fire("kill", "", 3)
        shield:SetModelScale(10)
        shield:SetName("shield")
        net.Start("train_color")
        net.WriteEntity(shield)
        net.WriteColor(finalColor)
        net.Send(player.GetAll())
    end

    print("Opening protect shield...")
    timer.Simple(3, function() if IsValid(shield) then shield:Remove() shielded = false end end)

    for _, ent in ipairs(ents.FindInSphere( train:GetPos(), 676.78680419922)) do
        if ent != attacker then
            ent.IsTrainProtected = true
        end
        timer.Simple(3, function() ent.IsTrainProtected = false end)
    end

    print(string.format("Returning Scaled damage to attacker!!! New Damagetype: %s(%s), New damage: %f", TrainArmor, info:GetDamageType(), info:GetDamage()))
    info:ScaleDamage(0)
end)

local lastPosition = nil
local lastPath = nil
local stucktime = 0

timer.Create("CheckTrainStuck", 0.5, 0, function()
    if !IsFullyLoaded or IsCleanMap then return end

    local train = ents.FindByName("train")[1]
    local currentPosition = train:GetPos()

    if train.IsStop then return end
    
    if lastPosition and currentPosition:Distance(lastPosition) < 10 or train:GetVelocity():Length() < 500 and IsFullyLoaded then    
        print("Stuck! Retrying...")
		stucktime = stucktime + 1
        for _, ent in ipairs(ents.GetAll()) do
			if ent:GetClass() != "ffv_javelinswep" then continue end
			EffectData():SetOrigin(ent:GetPos())
            util.Effect("AR2Explosion", EffectData())
            ent:Remove()
            print(string.format("Funkking All %s", ent))
		end
		
		if stucktime > 3 then
			for _, ent in ipairs(ents.GetAll()) do
				if IsTrainPart(ent) and IsFullyLoaded then
					ent:Remove()
					stucktime = 0
					--print("removeing" .. " " .. ent:GetName())
				end
			end
		end
			
        local nearestPathTrack
        local shortestDistance = math.huge

        for _, path in pairs(ents.FindByClass("path_track")) do
            local distance = train:GetPos():Distance(path:GetPos())
            if distance < shortestDistance then
                shortestDistance = distance
                nearestPathTrack = path
            end
        end

        if nearestPathTrack then
            local name = nearestPathTrack:GetName()
            local parts = string.Split(name, "_")
            if #parts == 2 then
                local baseName = parts[1]
                local number = tonumber(parts[2])
                if number then
                    local newName = baseName .. "_" .. (number + 1)
                    train:Fire("teleporttopathtrack", newName)
                else
                    train:Fire("teleporttopathtrack", name)
                end
            end
            
            train:Fire("stop")
            train:Fire("setmaxspeed", "2000")
            train:Fire("setspeed", "2000")
            train:Fire("startforward")

            lastPath = nearestPathTrack
        end
    end

    lastPosition = currentPosition
end)

local calltime = 0

hook.Add("EntityRemoved", "TrainAliveChecker", function( ent, fullUpdate )
    if IsTrainPart(ent) and !IsCleanMap and IsFullyLoaded then
        if IsCleanMap then return end
        for _, ent in ipairs(ents.GetAll()) do
            if IsTrainPart(ent) and IsFullyLoaded then
                IsCleanMap = true
                ent:Remove()
                calltime = calltime + 1
                --print("removeing" .. " " .. ent:GetName())
            end
        end
        if calltime == 1 then
            local template = ents.FindByName("train_template")[1]
            if IsValid(template) then
                template:Fire("forcespawn")
                print("Train is disappear, Respawning...")
                timer.Simple(0.1, function()
                    for _, ent in ipairs(ents.FindByName("train_chair")) do
                        ent:SetTable({
                            VehicleTable = {
                            Members = {
                                HandleAnimation = function(_, ply)
                                return ply:SelectWeightedSequence(ACT_GMOD_SIT_ROLLERCOASTER)
                                end
                            }
                            }
                        })
                        --ent:SetKeyValue("vehiclescript", "")
                        ent:SetNoDraw(true)
                    end
                end)
            end
        end
        IsCleanMap = false
        calltime = 0
    end
end)