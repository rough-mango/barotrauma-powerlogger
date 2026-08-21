if CLIENT then

    local ticks = 0
    local roundhasstarted = false
    local playerreactor = ''

    Hook.Add("think", "PowerLogger", function ()
        if roundhasstarted == false then return end
        ticks = ticks + 1
        if ticks < 20 then
            return
        end
        ticks = 0

        if GUI.PauseMenuOpen or GUI.SettingsMenuOpen then
            if Game.IsMultiplayer == false then
                return
            end
        end

        for reactor in Util.GetItemsById('reactor1') do
            if reactor.Submarine.Info.IsPlayer then
                playerreactor = reactor
            end
        end

        local engineGui = playerreactor.GetComponentString("Reactor")
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
    end)

    Hook.Add("roundStart", "start stuff", function ()
        roundhasstarted = true
        File.Write('C:\\Program Files (x86)\\Steam\\steamapps\\common\\Barotrauma\\LocalMods\\PowerLogger\\REACTORLOG.csv', "TIMESTAMP (s),LOAD (kw),REACTOR_OUTPUT (kw),TURBINE_OUTPUT (%),FISSION_RATE (%),TEMPERATURE (K)\n")
        File.Write('C:\\Program Files (x86)\\Steam\\steamapps\\common\\Barotrauma\\LocalMods\\PowerLogger\\GRIDLOG.csv', "TIMESTAMP (s),AVG JUNCTION VOLTAGE (V),AVG JUNCTION LOAD (kv),AVG JUNCTION EXTRA LOAD (kv),AVG BATTERY CHARGE (kv),AVG BATTERY CHARGE (%),AVG BATTERY CHARGE SPEED (%),AVG BATTERY OUTPUT (kv)\n")
    end)

    Hook.Add("roundEnd", "reset stuff", function ()
        roundhasstarted = false
        ticks = 0
    end)
end