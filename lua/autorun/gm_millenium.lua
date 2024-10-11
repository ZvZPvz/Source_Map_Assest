if game.GetMap() == "gm_millenium" then --检测地图是否为gm_millenium
    hook.Add( "PostCleanupMap", "gm_millenium_cleanup", function()
	    local turrets = ents.FindByName("siminar_turret")
        local camera = ents.FindByName("siminar_camera")[1]
		camera:SetHealth(5124)
	    for _, turret in ipairs(turrets) do
	    	turret:SetCollisionGroup(20)
            turret:SetHealth(25000)
	    end
	end)
    local SpClasses = { --允许进入研讨会人员
        ["yuuka"] = true,
        ["yuka"] = true,
        ["noa"] = true,
        ["rio"] = true,
        ["sensei"] = true,
        ["诺亚"] = true,
        ["优香"] = true,
        ["先生"] = true,
        ["老师"] = true,
        ["莉音"] = true,
        ["ユウカ"] = true,
        ["ノア"] = true,
        ["リオ"] = true
    }
    local MpClasses = { --七大恶人
	    ["koyuki"] = true,
	    ["コユキ"] = true,
		["小雪"] = true
	}
    local excludedClasses = { --排除列表
        ["trigger_*"] = true,
        ["func_*"] = true,
        ["predicted_viewmodel"] = true,
	    ["physgun_beam"] = true,
        ["path_track"] = true,
        ["gmod_hands"] = true,
        ["info_*"] = true,
        ["env_*"] = true,
        ["light_*"] = true
    }
    hook.Add("OnTrainFuck", "TrainHurter", function() --当触发列车撞击事件
        local triggerAreas = ents.FindByName("train_pusha") --定义triggerAreas为获取targetname名为train_pusha的实体
        local train = ents.FindByName("train")[1] --定义trains为获取列表中targetname名为train的第一个实体

        local function shouldExclude(ent) --排除
            local class = ent:GetClass() --定义class为获取实体类别
            for pattern in pairs(excludedClasses) do
                if string.find(class, pattern) then --如果在排除列表中找到，则返回true
                    return true
                end
            end
            return false --否则返回false
        end

        local function processEntities(entities) --处理已过滤的实体
            if train:GetVelocity():Length() > 1000 then --检测火车动能是否超过1000
                for _, ent in ipairs(entities) do
                    if not shouldExclude(ent) then --如果不是排除列表中的实体则继续
                        local Pos = ent:GetPos() --定义Pos为获取实体方位
                        local message = string.format("%s block the train! ", ent) --定义message为 %触发实体% block the train!
                        print(message) --打印message
                        print("Defusing!!")
                        if ent:IsValid() and not ent:IsPlayer() then --如果实体存在并且不是玩家
							ent:SetMoveType(6) --设置移动类型为6（物理）
                            local Health = ent:Health() --定义Health为获取实体的生命值
                            local phys = ent:GetPhysicsObject() --定义phys为获取实体的物理对象
                            if Health != 0 and Health != nil and Health > 0 then --生命值大于零，并且不等于零和空
                                local dmgInfo = DamageInfo()
                                dmgInfo:SetAttacker(train) --设置伤害发起者为train
                                dmgInfo:SetInflictor(train) --设置加害者为train
                                dmgInfo:SetDamage(2400000) --2400000伤害
                                dmgInfo:SetDamageType(DMG_DIRECT) --伤害类型为DMG_DIRECT
                                ent:TakeDamageInfo(dmgInfo) --造成伤害
                                print("Damaging!!!")
                            elseif IsValid(phys) then --如果存在物理对象
							    phys:AddVelocity(Vector(2147483647, 2147483647, 2147483647)) 
								phys:AddAngleVelocity(Vector(2147483647, 2147483647, 2147483647)) --添加作用和角作用力
                                print("Pushing!!!")
                            elseif class == "move_rope" or "keyframe_rope" then --如果实体的类别是move_rope或keyframe_rope
                                ent:Remove() --删除实体
							else
                                local effectdata = EffectData() --定义effectdata为获取游戏内置特效库
                                effectdata:SetOrigin(Pos) --设置特效的方位在pos
                                util.Effect("Explosion", effectdata) --Explosion特效
                                ent:Remove()
                                print("Removing!!!")
                            end
                            if ent.Type == "nextbot" or ent:IsNextBot() then
                                local effectdata = EffectData()
                                effectdata:SetOrigin(Pos)
                                util.Effect("ManhackSparks", effectdata)
                                util.Effect("AR2Explosion", effectdata)
                                util.Effect("Explosion", effectdata)
                                ent:Fire("killhierarchy") --向实体输入killhierarchy（删除和这个实体有关的所有东西）
                                print("Removing hierarchy!!!")
                            end
                        elseif ent:IsPlayer() then
                            if ent:Alive() then --如果玩家还活着
                                ent:Kill() --杀死玩家
                                ent:ScreenFade(SCREENFADE.STAYOUT, Color(255, 0, 0, 255), 0, 0) --设置屏幕rgb效果为 255 0 0 255
                                print("Killing!!!")
                            else
                                ent:ScreenFade(SCREENFADE.STAYOUT, Color(255, 255, 255, 0), 0, 0)
                            end
                        end
                        print("Okay")
                    end
                end
            end
        end

        for _, triggerArea in ipairs(triggerAreas) do
            if IsValid(triggerArea) then --如果触发器范围有效
                local center = triggerArea:GetPos() --定义center为获取触发器范围的中心
                local nearbyEntities = ents.FindInSphere(center, 500) --定义nearbyEntities为获取以center为中心的500英寸半径内的实体

                for _, ent in ipairs(nearbyEntities) do --处理半径内的实体
                    if not shouldExclude(ent) then --如果不是排除列表中的实体则继续
                        if IsValid(ent) then
						    ent:SetParent(nil) --设置实体父级为空（清除父级）
                            local phys = ent:GetPhysicsObject()
					        if IsValid(phys) then
						        phys:EnableMotion(true) --使物理对象可以移动
						        phys:EnableDrag(true) --使物理对象可以拖拽
						        phys:Wake(true) --唤醒物理对象
						        phys:SetMass(50000) --设置重量为50000
						        phys:AddVelocity(Vector(2147483647, 2147483647, 2147483647))
						        phys:AddAngleVelocity(Vector(2147483647, 2147483647, 2147483647))
						    end
                            local Pos = ent:GetPos()
                            local effectdata = EffectData()
                            effectdata:SetOrigin(Pos)
                            util.Effect("Sparks", effectdata)
                            constraint.RemoveAll(ent) --清除所有约束
						    constraint.NoCollide(ent, ent) --为实体和实体之间添加无碰撞约束
						    constraint.NoCollide(ent, train) --为train和实体之间添加无碰撞约束
							timer.Simple( 1 , function() constraint.RemoveAll(ent) end ) --一秒后再次清除所有约束
						end
                    end
                end

                local mins = triggerArea:LocalToWorld(triggerArea:OBBMins())
                local maxs = triggerArea:LocalToWorld(triggerArea:OBBMaxs())
                local entities = ents.FindInBox(mins, maxs) --触发器方形范围
                processEntities(entities)
            end
        end
    end)
    hook.Add("SIMINAR_U", "siminar_defcon4", function() --警戒等级1
	    local siminarAreas = ents.FindByName("siminar_door_trigger") --定义triggerAreas为获取targetname名为train_pusha的实体
        for _, siminarArea in ipairs(siminarAreas) do
            local min, max = siminarArea:WorldSpaceAABB()
			local EntInsd = ents.FindInBox(min,max)
            for _, ply in ipairs(EntInsd) do
                if IsValid(ply) and ply:IsPlayer() then
			        local model = ply:GetModel() --
					local nick = ply:Nick()
				    local message = string.format("%s is entering Siminar ", nick)
                    print(message)
                    for pattern in pairs(SpClasses) do --如果是允许进入研讨会人员
                        if string.match(model, pattern) or string.match(nick, pattern) then
						    print("WelCome!")
						    local camera = ents.FindByName("siminar_camera")[1] --定义camera为获取targetname名为siminar_camera的第一个实体
						    local doors = ents.FindByClass("func_movelinear") --定义doors为所有类别为func_movelinear的实体
						    camera:AddEntityRelationship(ply, D_LI, 999) --设置camera对玩家的羁绊类别为D_LI（喜欢）
						    for _, door in ipairs(doors) do
						        door:Fire("Open") --开启所有门
						    end
			            end
					end
                    for pattern in pairs(MpClasses) do --如果是七大恶人
                        if string.match(model, pattern) or string.match(nick, pattern) then
                            hook.Run( 'SIMINAR_L2' ) --运行SIMINAR_L2事件
					    end
					end
				end
			end
		end
	end)
   hook.Add("SIMINAR_L1", "siminar_defcon3", function() --警戒等级2
	    local siminarAreas = ents.FindByName("siminar_door_trigger")
        for _, siminarArea in ipairs(siminarAreas) do
            local min, max = siminarArea:WorldSpaceAABB()
			local EntInsd = ents.FindInBox(min,max) --定义EntInsd为在触发器方形范围内的实体
            for _, ply in ipairs(EntInsd) do
                if IsValid(ply) and ply:IsPlayer() then --如果实体有效并且是玩家
			        local model = ply:GetModel() --定义model为获取玩家的模型
					local nick = ply:Nick() --定义nick为获取玩家的昵称
				    local message = string.format("%s is entering Siminar ", nick)
                    print(message)
                    for pattern in pairs(SpClasses) do --如果是允许进入研讨会人员
                        if string.match(model, pattern) or string.match(nick, pattern) then 
						    return --如果玩家的model或nick匹配里的东西则返回
			            else
                            
						end
					end
				end
			end
		end
	end)
   hook.Add("SIMINAR_L2", "siminar_defcon2", function() --警戒等级3
	    local siminarAreas = ents.FindByName("siminar_door_trigger")
        for _, siminarArea in ipairs(siminarAreas) do
            local min, max = siminarArea:WorldSpaceAABB()
			local EntInsd = ents.FindInBox(min,max)
            for _, ply in ipairs(EntInsd) do
                if IsValid(ply) and ply:IsPlayer() then
			        local model = ply:GetModel()
					local nick = ply:Nick()
                    local camera = ents.FindByName("siminar_camera")[1]
                    for pattern in pairs(SpClasses) do --如果是允许进入研讨会人员
                        if string.match(model, pattern) or string.match(nick, pattern) then
							camera:AddEntityRelationship(ply, D_NU, 999) --设置camera对玩家的羁绊类别为D_NU（中性）
							return
					    end
					end
                    for pattern in pairs(MpClasses) do --如果是七大恶人
                        if string.match(model, pattern) or string.match(nick, pattern) then
						    camera:AddEntityRelationship(ply, D_FR, 999) --设置camera对玩家的羁绊类别为D_FR（害怕）  --camera:我错了，已老实，求放过😨
						    camera:Fire("Disable") --关闭camera  --camera:若藻别杀我😭
						else
							camera:AddEntityRelationship(ply, D_HT, 999)
						    camera:Fire("SetAngry")
						end
					end
				end
			end
		end
	end)
   hook.Add("SIMINAR_L3", "siminar_defcon1", function() --警戒等级4
	    local siminarAreas = ents.FindByName("siminar_gate_trigger")
		local light = ents.FindByName("siminar_light")[1]
        for _, siminarArea in ipairs(siminarAreas) do
            local min, max = siminarArea:WorldSpaceAABB()
			local EntInsd = ents.FindInBox(min,max)
            for _, ply in ipairs(EntInsd) do
                if IsValid(ply) and ply:IsPlayer() then
			        local model = ply:GetModel()
					local nick = ply:Nick()
                    local camera = ents.FindByName("siminar_camera")[1]
                    for pattern in pairs(SpClasses) do
                        if string.match(model, pattern) or string.match(nick, pattern) then
							siminarArea:Fire("Disable")
						end
					end
                    for pattern in pairs(MpClasses) do
                        if string.match(model, pattern) or string.match(nick, pattern) then
						    siminarArea:Fire("Enable")
						    ply:SetMoveType(6)
							light:Fire("TurnOn")
						else
							siminarArea:Fire("Enable")
						end
					end
				end
			end
		end
	end)
   hook.Add("SIMINAR_L4", "siminar_defcon0", function() --警戒等级5
	    local siminarAreas = ents.FindByName("siminar_gate_trigger")
		local light = ents.FindByName("siminar_light")[1]
	    local turrets = ents.FindByName("siminar_turret")
        for _, siminarArea in ipairs(siminarAreas) do
            local center = siminarArea:GetPos()
            local nearbyEntities = ents.FindInSphere(center, 300)
            for _, ply in ipairs(nearbyEntities) do
                if IsValid(ply) and ply:IsPlayer() then
			        local model = ply:GetModel()
					local nick = ply:Nick()
                    local camera = ents.FindByName("siminar_camera")[1]
                    for _, turret in ipairs(turrets) do
                        for pattern in pairs(SpClasses) do
                            if string.match(model, pattern) or string.match(nick, pattern) then
							    turret:AddEntityRelationship(ply, D_LI, 999)
						    else
						        ply:SetMoveType(6)
						    end
					    end
                        for pattern in pairs(MpClasses) do
                            if string.match(model, pattern) or string.match(nick, pattern) then
						        turret:Fire("Enable")
						        turret:AddEntityRelationship(ply, D_HT, 999)
					        end
						end
					end
				end
			end
		end
	end)
end