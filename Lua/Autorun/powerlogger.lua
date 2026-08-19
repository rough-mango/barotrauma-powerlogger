if CLIENT then

    local ticks = 0

    Hook.Add("think", "PowerLogger", function ()
        if Character.Controlled == nil then return end
        ticks = ticks + 1
        if ticks < 20 then
            return
        end
        ticks = 0
        for reactor in Util.GetItemsById('reactor1') do
            if reactor.Submarine.Info.IsPlayer then
                local engineGui = reactor.GetComponentString("Reactor")
                local f = assert(io.open('C:\\Program Files (x86)\\Steam\\steamapps\\common\\Barotrauma\\LocalMods\\PowerLogger\\REACTORLOG.csv', "rb"))
                local contentreactor = f:read("*all")
                f:close()
                File.Write('C:\\Program Files (x86)\\Steam\\steamapps\\common\\Barotrauma\\LocalMods\\PowerLogger\\REACTORLOG.csv', 
                    tostring(contentreactor) ..
                    tostring(math.floor(Game.GameSession.RoundDuration * 100 + 0.5) / 100) .. "," ..
                    tostring(math.floor(engineGui.get_Load() * 100 + 0.5) / 100) .. "," ..
                    tostring(math.floor(-engineGui.CurrPowerConsumption * 100 + 0.5) / 100) .. "," ..
                    tostring(math.floor(engineGui.turbineOutput * 100 + 0.5) / 100) .. "," ..
                    tostring(math.floor(engineGui.fissionRate * 100 + 0.5) / 100) .. "," ..
                    tostring(math.floor(engineGui.temperature * 100 * 100 + 0.5) / 100) .. "\n")
                
                local f = assert(io.open('C:\\Program Files (x86)\\Steam\\steamapps\\common\\Barotrauma\\LocalMods\\PowerLogger\\GRIDLOG.csv', "rb"))
                local contentgrid = f:read("*all")
                f:close()

                local junctionboxamount = 0
                local totalvoltage = 0
                local totalload = 0
                local totalextraload = 0
                local averagevoltage = 0
                local averageload = 0
                local averageextraload = 0

                local batteryamount = 0
                local totalcharge = 0
                local averagecharge = 0
                local totalpoweroutput = 0
                local averagepoweroutput = 0
                local totalchargepercent = 0
                local averagechargepercent = 0
                local totalchargespeed = 0
                local averagechargespeed = 0

                for item in Submarine.MainSub.GetItems(false) do
                    if item.Prefab.Identifier == "junctionbox" then
                        junctionboxamount = junctionboxamount + 1
                        local junctionGuiTransfer = item.GetComponentString("PowerTransfer")
                        local junctionGuiPowered = item.GetComponentString("Powered")
                        totalload = totalload + junctionGuiTransfer.PowerLoad
                        totalvoltage = totalvoltage + junctionGuiPowered.voltage 
                        totalextraload = totalextraload + junctionGuiTransfer.ExtraLoad 
                    elseif item.Prefab.Identifier == "battery" then
                        batteryamount = batteryamount + 1
                        local batteryGuiContainer = item.GetComponentString("PowerContainer")
                        totalchargepercent = totalchargepercent + batteryGuiContainer.ChargePercentage
                        totalcharge = totalcharge + batteryGuiContainer.charge
                        totalpoweroutput = totalpoweroutput + batteryGuiContainer.CurrPowerOutput
                        totalchargespeed = totalchargespeed + batteryGuiContainer.rechargeSpeed
                    end
                end
                averagevoltage = totalvoltage/junctionboxamount
                averageload = totalload/junctionboxamount
                averageextraload = totalextraload/junctionboxamount
                averagecharge = totalcharge/batteryamount
                averagechargepercent = totalchargepercent/batteryamount
                averagepoweroutput = totalpoweroutput/batteryamount
                averagechargespeed = totalchargespeed/batteryamount

                File.Write('C:\\Program Files (x86)\\Steam\\steamapps\\common\\Barotrauma\\LocalMods\\PowerLogger\\GRIDLOG.csv', 
                    tostring(contentgrid) ..
                    tostring(math.floor(Game.GameSession.RoundDuration * 100 + 0.5) / 100) .. "," ..
                    tostring(math.floor(averagevoltage * 100 + 0.5) / 100) .. "," ..
                    tostring(math.floor(averageload * 100 + 0.5) / 100) .. "," ..
                    tostring(math.floor(averageextraload * 100 + 0.5) / 100) .. "," ..
                    tostring(math.floor(averagecharge * 100 + 0.5) / 100) .. "," ..
                    tostring(math.floor(averagechargepercent * 100 + 0.5) / 100) .. "," ..
                    tostring(math.floor(averagechargespeed * 100 + 0.5) / 100)/5 .. "," ..
                    tostring(math.floor(averagepoweroutput * 100 + 0.5) / 100) .. "\n")
            end
        end
    end)
end