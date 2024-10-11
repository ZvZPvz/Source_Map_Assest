if game.GetMap() == "gm_ba_classroom" then --检测地图是否为gm_ba_classroom
    if game.SinglePlayer() then --检测游戏模式是否为单人模式
        local hdrlevel = GetConVar("mat_hdr_level"):GetInt() --定义hdrlevel为获取mat_hdr_level的整数值
		local sun = ents.FindByName("sun")[1] --定义sun为列表中targetname名为sun的第一个实体
        if hdrlevel == 1 then
	        sun:Fire("addoutput,181 203 221 630") --输入
			print("HDR ON, LDR OFF, turning light darker")
		elseif hdrlevel == 2 then
	        sun:Fire("turnon")
	        sun:Fire("addoutput,181 203 221 1260")
			print("HDR/LDR ON, all light features enable")
		else
		    sun:Fire("addoutput,181 203 221 0")
			print("HDR/LDR OFF! all light features disable")
	    end
	else --单人以外不就是服务器吗
	    sun:Fire("turnoff")
		print("Running an Dedicated Server, disabling light features...")
	end
end