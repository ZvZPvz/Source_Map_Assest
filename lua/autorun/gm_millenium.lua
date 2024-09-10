if game.GetMap() == "gm_millenium" then
    hook.Add("OnTrainFuck", "TrainHurter", function()
        local triggerAreas = ents.FindByName("train_pusha")
        local trains = ents.FindByName("train")
        local train = trains[1]

        local excludedClasses = {
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

        local function shouldExclude(ent)
            local class = ent:GetClass()
            for pattern in pairs(excludedClasses) do
                if string.find(class, pattern) then
                    return true
                end
            end
            return false
        end

        local function processEntities(entities)
            if train:GetVelocity():Length() > 1000 then
                for _, ent in ipairs(entities) do
                    if not shouldExclude(ent) then
                        local Pos = ent:GetPos()
                        local message = string.format("%s block the train! ", ent)
                        print(message)
                        print("Defusing!!")
                        if ent:IsValid() and not ent:IsPlayer() then
							ent:SetMoveType(6)
                            local Health = ent:Health()
                            local phys = ent:GetPhysicsObject()
                            if Health ~= 0 and Health ~= nil and Health > 0 then
                                local dmgInfo = DamageInfo()
                                dmgInfo:SetAttacker(train)
                                dmgInfo:SetInflictor(train)
                                dmgInfo:SetDamage(2400000)
                                dmgInfo:SetDamageType(DMG_DIRECT)
                                ent:TakeDamageInfo(dmgInfo)
                                print("Damaging!!!")
                            elseif IsValid(phys) then
							    phys:AddVelocity(Vector(2147483647, 2147483647, 2147483647))
								phys:AddAngleVelocity(Vector(2147483647, 2147483647, 2147483647))
                                print("Pushing!!!")
                            elseif class == "move_rope" or "keyframe_rope" then
                                ent:Remove()
							else
                                local effectdata = EffectData()
                                effectdata:SetOrigin(Pos)
                                util.Effect("Explosion", effectdata)
                                ent:Remove()
                                print("Removing!!!")
                            end
                            if ent.Type == "nextbot" or ent:IsNextBot() then
                                local effectdata = EffectData()
                                effectdata:SetOrigin(Pos)
                                util.Effect("ManhackSparks", effectdata)
                                util.Effect("AR2Explosion", effectdata)
                                util.Effect("Explosion", effectdata)
                                ent:Fire("killhierarchy")
                                print("Removing hierarchy!!!")
                            end
                        elseif ent:IsPlayer() then
                            if ent:Alive() then
                                ent:Kill()
                                ent:ScreenFade(SCREENFADE.STAYOUT, Color(255, 0, 0, 255), 0, 0)
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
            if IsValid(triggerArea) then
                local center = triggerArea:GetPos()
                local nearbyEntities = ents.FindInSphere(center, 500)

                for _, ent in ipairs(nearbyEntities) do
                    if not shouldExclude(ent) then
                        if IsValid(ent) then
						    ent:SetParent(nil)
                            local phys = ent:GetPhysicsObject()
					        if IsValid(phys) then
						        phys:EnableMotion(true)
						        phys:EnableDrag(true)
						        phys:Wake(true)
						        phys:SetMass(50000)
						        phys:AddVelocity(Vector(2147483647, 2147483647, 2147483647))
						        phys:AddAngleVelocity(Vector(2147483647, 2147483647, 2147483647))
						    end
                            local Pos = ent:GetPos()
                            local effectdata = EffectData()
                            effectdata:SetOrigin(Pos)
                            util.Effect("Sparks", effectdata)
                            constraint.RemoveAll(ent)
						    constraint.NoCollide(ent, ent)
						    constraint.NoCollide(ent, train)
							timer.Simple( 1 , function() constraint.RemoveAll(ent) end )
						end
                    end
                end

                local mins = triggerArea:LocalToWorld(triggerArea:OBBMins())
                local maxs = triggerArea:LocalToWorld(triggerArea:OBBMaxs())
                local entities = ents.FindInBox(mins, maxs)
                processEntities(entities)
            end
        end
    end)
end