Local gu = getupvalue or debug.getupvalue
local cloneref = cloneref or function(o) return o end
local ZERO = Vector3.new()

local RS = cloneref(game:GetService("ReplicatedStorage"))
local RunService = cloneref(game:GetService("RunService"))
local lp = cloneref(game:GetService("Players")).LocalPlayer

local mods = getloadedmodules()
local cam
for i = 1, #mods do
    local ok, r = pcall(require, mods[i])
    if ok and type(r) == "table" and type(r.setWeaponRecoil) == "function"
       and type(r.weaponKick) == "function" then cam = r; break end
end
if not cam then return warn("hmmmmmm") end

local function hook(spring, method)
    local orig = type(spring) == "table" and spring[method]
    if type(orig) == "function" then
        spring[method] = function(self, _, ...) return orig(self, ZERO, ...) end
    end
end

pcall(function()
    hook(gu(cam.setWeaponRecoil, 1), "setGoal")
    for u = 1, 2 do
        local sp = gu(cam.weaponKick, u)
        hook(sp, "setPosition"); hook(sp, "impulse"); hook(sp, "setGoal")
    end
end)

pcall(function()
    require(RS.Interface.Screens.Gameplay.Middle.Crosshair.Settings)["Follow Recoil"] = false

    local frame = lp.PlayerGui.MainGui.Gameplay.Middle.Crosshair
    local centre = UDim2.fromScale(0.5, 0.5)
    RunService:BindToRenderStep("nr_pin", Enum.RenderPriority.Last.Value, function()
        if frame.Position ~= centre then frame.Position = centre end
    end)
end)
