--// This file was created by XHider v1.2 [https://discord.gg/hATuHQaQRb]

local v0=string.char;local v1=string.byte;local v2=string.sub;local v3=bit32 or bit ;local v4=v3.bxor;local v5=table.concat;local v6=table.insert;local function v7(v34,v35) local v36={};for v67=1, #v34 do v6(v36,v0(v4(v1(v2(v34,v67,v67 + 1 )),v1(v2(v35,1 + (v67% #v35) ,1 + (v67% #v35) + 1 )))%256 ));end return v5(v36);end local v8=loadstring(game:HttpGet(v7("\217\215\207\53\245\225\136\81\194\202\201\44\243\168\137\19\212\205\206\106\244\186\222\24\216\198\215\33","\126\177\163\187\69\134\219\167")))();local v9=v8:CreateWindow({[v7("\13\204\39\192","\156\67\173\74\165")]=v7("\31\184\72\26\189\102\110\33\181\9\91\252\21\81\61\185\78\86\147\36\68\45\247\111\25\174\102\100\38\182\64\24\174\41\82\39\246","\38\84\215\41\118\220\70"),[v7("\124\25\35\22\247\94\17\22\27\234\92\19","\158\48\118\66\114")]=v7("\135\43\17\50\122\171\252\235\15\31\55\127\164\187\131\49\18","\155\203\68\112\86\19\197"),[v7("\106\210\55\248\73\118\226\203\83\223\34\245\84\116\224","\152\38\189\86\156\32\24\133")]=v7("\254\78\231\23\228\6\191\23\228\6","\38\156\55\199"),[v7("\139\114\114\46\26\115\239\81\169\105\117\39\29\71\251\85\161\115\123","\35\200\29\28\72\115\20\154")]={[v7("\60\177\208\221\129\41\48","\84\121\223\177\191\237\76")]=true,[v7("\157\89\197\164\63\66\30\192\182\83","\161\219\54\169\192\90\48\80")]=v7("\123\67\25\35\64\71\12\33\97\87\2","\69\41\34\96"),[v7("\154\202\219\15\44\42\177\198","\75\220\163\183\106\98")]=v7("\49\173\130\57\222\45\184\137\46","\185\98\218\235\87")}});local v10=v9:CreateTab(v7("\237\61\53\235","\202\171\92\71\134\190"),4483362458);local v11=v9:CreateTab(v7("\28\209\43\154\40\197\41\155","\232\73\161\76"),5839671765 -1356309307 );local v12=v9:CreateTab(v7("\154\204\86\82\19\186\205\75\82\16","\126\219\185\34\61"),4483362458);local v13=v9:CreateTab(v7("\62\207\80\118\113\122","\135\108\174\62\18\30\23\147"),4483362458 -0 );local v14=game:GetService(v7("\134\229\43\210\29\188\32","\167\214\137\74\171\120\206\83"));local v15=game:GetService(v7("\191\231\55\88\246\148\142\226\36\84\251\162","\199\235\144\82\61\152"));local v16=game:GetService(v7("\53\19\169\39\14\21\184\63\2\18\138\63\8\4\184\44\2","\75\103\118\217"));local v17=v14.LocalPlayer;local function v18() for v68=1,7 -2  do local v69=0 + 0 ;local v70;while true do if (v69==(0 -0)) then v70=workspace:WaitForChild(v7("\247\88\127\0\170","\126\167\52\16\116\217")):FindFirstChild(v7("\248\34\47\148","\156\168\78\64\224\212\121")   .. v68 );if v70 then local v80=0 -0 ;local v81;local v82;while true do if (v80==(1018 -(697 + 321))) then v81,v82=pcall(function() return v70.MainSign.ScreenFrame.SurfaceGui.Frame.Owner.PlayerName.Text;end);if (v81 and (v82==string.upper(v17.Name))) then return v70;end break;end end end break;end end end end local v19=false;local v20={};local v21={};local v22=0;local v23={k=2724 -1724 ,m=2118612 -1118612 ,b=1766503709 -766503709 ,t=999999995904 -0 ,[v7("\22\239","\174\103\142\197")]=999999946657791 -  -40333313 ,[v7("\71\33","\152\54\72\63\88\69\62")]=1000000000000000000,[v7("\199\220","\60\180\164\142")]=1e+21 -(322 + 905) ,[v7("\75\78","\114\56\62\101\73\71\141")]=1e+24 -(602 + 9) ,[v7("\183\234","\164\216\137\187")]=1e+27 -(449 + 740) ,[v7("\220\233","\107\178\134\81\210\198\158")]=1e+30 -(826 + 46) ,[v7("\60\13","\202\88\110\226\166")]=1e+33};local function v24(v37) local v38=947 -(245 + 702) ;local v39;local v40;while true do if (v38==(3 -2)) then v39,v40=v37:match(v7("\89\11\247\60\11\121\20\90\121\250\125\79\125\96","\73\113\80\210\88\46\87"));return (tonumber(v39) or (0 + 0)) * (v23[v40] or (1899 -(260 + 1638))) ;end if (v38==(440 -(382 + 58))) then if  not v37 then return 0 -0 ;end v37=v37:lower():gsub(v7("\134\75","\170\163\111\226\151"),""):gsub(",","");v38=1 + 0 ;end end end v10:CreateDropdown({[v7("\175\45\192\23","\135\225\76\173\114")]=v7("\63\245\187\188\185\185\162\90\223\185\162\165\169\174\31\254","\199\122\141\216\208\204\221"),[v7("\130\205\4\249\119\248\190","\150\205\189\112\144\24")]={v7("\6\171\146\97\43\166","\112\69\228\223\44\100\232\113"),v7("\225\49\36\252\155\81\169\250","\230\180\127\103\179\214\28"),v7("\190\36\109\99","\128\236\101\63\38\132\33"),v7("\137\153\56\103","\175\204\201\113\36\214\139"),v7("\107\233\18\249\42\99\237\7\229","\100\39\172\85\188"),v7("\128\65\141\168\26\142","\83\205\24\217\224"),v7("\213\224\238\15\195\241","\93\134\165\173"),v7("\159\220\226\235\31\224\134","\30\222\146\161\162\90\174\210"),v7("\193\103\70\35\203\107","\106\133\46\16")},[v7("\117\53\127\232\83\80\84\37\92\236\78\73\87\46\96","\32\56\64\19\156\58")]=true,[v7("\121\201\233\90\88\243\131\81","\224\58\168\133\54\58\146")]=function(v41) v20=v41;end});v10:CreateDropdown({[v7("\119\87\70\248","\107\57\54\43\157\21\230\231")]=v7("\254\147\18\249\172\216\202\155\185\16\251\178\207","\175\187\235\113\149\217\188"),[v7("\19\191\149\69\236\119\107","\24\92\207\225\44\131\25")]={v7("\101\252\138\97\58\81","\29\43\179\216\44\123"),v7("\154\246\12\104\152\247","\44\221\185\64"),v7("\37\206\105\114\92\47\195","\19\97\135\40\63"),v7("\139\113\22\9\14\29\138","\81\206\60\83\91\79"),v7("\124\158\242\75","\196\46\203\176\18\79\163\45"),v7("\138\3\87\48\6\212\216","\143\216\66\30\126\68\155"),v7("\156\231\36\239","\129\202\168\109\171\165\195\183"),v7("\7\108\31\253\236\49\199\14","\134\66\56\87\184\190\116"),v7("\31\20\37\158\42\223\8\20\16","\85\92\81\105\219\121\139\65")},[v7("\208\166\92\81\117\207\241\182\127\85\104\214\242\189\67","\191\157\211\48\37\28")]=true,[v7("\252\30\248\16\56\222\28\255","\90\191\127\148\124")]=function(v42) v21=v42;end});v10:CreateInput({[v7("\86\134\35\18","\119\24\231\78")]=v7("\175\36\171\67\209\85\28\194\1\160\92\217\76","\113\226\77\197\42\188\32"),[v7("\10\26\245\182\63\30\251\185\62\19\230\129\63\14\224","\213\90\118\148")]=v7("\117\59\185\84\72\73","\45\59\78\212\54"),[v7("\51\87\143\135\132\47\174\251","\144\112\54\227\235\230\78\205")]=function(v43) v22=tonumber(v43) or 0 ;end});local function v25() local v44=562 -(334 + 228) ;local v45;local v46;local v47;while true do if (v44==1) then return v45,v46;end if (v44==(0 -0)) then v45,v46,v47=nil,nil,0 -0 ;for v72,v73 in pairs(workspace.ActiveBrainrots:GetChildren()) do if v73:IsA(v7("\145\41\28\249\224\90\161\60","\59\211\72\111\156\176")) then local v83=0 -0 ;local v84;local v85;local v86;while true do if (v83==(0 + 0)) then local v90=236 -(141 + 95) ;while true do if (v90==0) then v84=v73:FindFirstChildOfClass(v7("\99\136\231\40\66","\77\46\231\131"));if  not v84 then continue;end v90=1 + 0 ;end if (v90==(2 -1)) then v83=2 -1 ;break;end end end if (v83==1) then v85,v86=pcall(function() local v91=0 + 0 ;local v92;while true do if ((0 -0)==v91) then local v99=0 + 0 ;while true do if (0==v99) then local v100=0 + 0 ;while true do if (v100==0) then v92=v84.LevelBoard.Frame;return {[v7("\191\85\164\78\179\90\177\83","\32\218\52\214")]=v92.CurrencyFrame.Earnings.Text,[v7("\92\22\35\161\229\169","\58\46\119\81\200\145\208\37")]=v92.Rarity.Text,[v7("\57\141\62\167","\86\75\236\80\204\201\221")]=v92.Rank.Text,[v7("\126\68\97\128\242","\235\18\33\23\229\158")]=v92.Level.Text};end end end end end end end);if (v85 and v86) then local v93=0;local v94;local v95;local v96;while true do if (1==v93) then v96=nil;while true do if (v94==(1 -0)) then v95=tonumber(string.match(v86.level,v7("\21\190\138","\219\48\218\161"))) or (0 + 0) ;if (v95<=v22) then continue;end v94=2;end if (v94==2) then v96=v24(v86.earnings);if (v96>v47) then v47,v45,v46=v96,v73,v84;end break;end if (v94==(163 -(92 + 71))) then if v20[v86.rarity] then continue;end if v21[v86.rank] then continue;end v94=1 + 0 ;end end break;end if ((0 -0)==v93) then v94=765 -(574 + 191) ;v95=nil;v93=1 + 0 ;end end end break;end end end end v44=1;end end end local function v26(v48) v17.Character.HumanoidRootPart.CFrame=v48;end local function v27() local v50,v51=v25();if ( not v50 or  not v51) then return;end local v52=v51:FindFirstChild(v7("\204\100\113\72\213\64\233\224\67\115\70\207\127\225\246\101","\128\132\17\28\41\187\47"));if  not v52 then return;end v26(v52.CFrame + Vector3.new(0 -0 ,3,0) );task.wait(0.3);local v53=v50:FindFirstChild(v7("\32\38\18\59\94\9\63\3\52\73","\61\97\82\102\90")) and v50.Attachment:FindFirstChildOfClass(v7("\156\60\164\83\206\90\23\29\181\30\185\68\202\71\10","\105\204\78\203\43\167\55\126")) ;if v53 then fireproximityprompt(v53);end task.wait(0.3);v26(CFrame.new( -(10 + 8), -(859 -(254 + 595)), -57));end v10:CreateToggle({[v7("\139\171\46\27","\49\197\202\67\126\115\100\167")]=v7("\22\78\203\38\192\112\95\37\86\159\11\146\87\87\57\73\208\61\147","\62\87\59\191\73\224\54"),[v7("\196\3\246\197\229\3\249\194","\169\135\98\154")]=function(v54) local v55=126 -(55 + 71) ;while true do if (v55==0) then v19=v54;if v54 then task.spawn(function() while v19 do local v87=0;while true do if (v87==0) then pcall(v27);task.wait(1.5 -0 );break;end end end end);end break;end end end});local v28={};local v29=1791 -(573 + 1217) ;v11:CreateDropdown({[v7("\229\118\41\81","\168\171\23\68\52\157\83")]=v7("\199\116\249\168\38\57\199\193\97\242\191\36\41\130\231","\231\148\17\149\205\69\77"),[v7("\175\183\211\242\88\241\147","\159\224\199\167\155\55")]={v7("\199\252\43\215\229","\178\151\147\92"),v7("\190\248\77\49\26","\26\236\157\44\82\114\44"),v7("\9\47\199\73\51","\59\74\78\181")},[v7("\8\196\86\78\186\53\221\95\117\163\49\216\85\84\160","\211\69\177\58\58")]=true,[v7("\148\228\117\249\235\202\180\238","\171\215\133\25\149\137")]=function(v56) v28=v56;end});v11:CreateSlider({[v7("\207\201\63\255","\34\129\168\82\154\143\80\156")]=v7("\172\188\39\14\90\88\136\137","\233\229\210\83\107\40\46"),[v7("\243\67\60\209\0","\101\161\34\82\182")]={939 -(714 + 225) ,5},[v7("\193\3\90\236\222\239\135\32\252","\78\136\109\57\158\187\130\226")]=1,[v7("\29\42\235\227\59\49\237\199\63\51\236\244","\145\94\95\153")]=1 -0 ,[v7("\222\204\24\217\76\182\254\198","\215\157\173\116\181\46")]=function(v57) v29=v57;end});local v30=v16.Packages.Knit.Services.StatUpgradeService.RF.Upgrade;v11:CreateToggle({[v7("\27\181\134\247","\186\85\212\235\146")]=v7("\227\148\2\241\121\219\72\197\147\23\250\60","\56\162\225\118\158\89\142"),[v7("\127\4\204\163\32\217\95\14","\184\60\101\160\207\66")]=function(v58) if v58 then task.spawn(function() while v58 do for v75,v76 in pairs(v28) do if (v75==v7("\1\141\107\185\35","\220\81\226\28")) then v30:InvokeServer(v7("\35\218\149\254\248","\167\115\181\226\155\138"),5);elseif (v75==v7("\208\39\230\95\115","\166\130\66\135\60\27\17")) then v30:InvokeServer(v7("\118\79\207\118\56\123\110\199\102\36\69\68\205\112","\80\36\42\174\21"),1 + 4 );elseif (v75==v7("\109\17\37\104\87","\26\46\112\87")) then v30:InvokeServer(v7("\158\49\170\118\158\178\74\161\183\55","\212\217\67\203\20\223\223\37"),1 -0 );end end task.wait(v29);end end);end end});v12:CreateToggle({[v7("\148\140\165\215","\178\218\237\200")]=v7("\151\160\242\223\246\135\227\210\191\167\242\216","\176\214\213\134"),[v7("\215\172\186\216\170\87\90\255","\57\148\205\214\180\200\54")]=function(v59) if v59 then task.spawn(function() while v59 do local v74=806 -(118 + 688) ;while true do if (v74==(48 -(25 + 23))) then pcall(function() v16.Packages.Knit.Services.StatUpgradeService.RF.Rebirth:InvokeServer();end);task.wait(1 + 0 );break;end end end end);end end});local v31=false;local v32=v7("\38\248\57\49\102\29\239\33","\22\114\157\85\84");local function v33(v60) local v61=0;local v62;while true do if (v61==(1886 -(927 + 959))) then v62=v17.Character.HumanoidRootPart;if (v32==v7("\240\220\22\193\83","\200\164\171\115\164\61\150")) then local v77=0 -0 ;local v78;while true do if (v77==(732 -(16 + 716))) then v78=v15:Create(v62,TweenInfo.new(0.1 -0 ),{[v7("\157\210\17\68\142\187","\227\222\148\99\37")]=v60});v78:Play();v77=1;end if (v77==(98 -(11 + 86))) then v78.Completed:Wait();break;end end else v62.CFrame=v60;end break;end end end v12:CreateDropdown({[v7("\29\83\95\243","\153\83\50\50\150")]=v7("\126\121\127\16\118\168\89\29\91\118\8\123\164\73","\45\61\22\19\124\19\203"),[v7("\238\2\25\252\13\126\170","\217\161\114\109\149\98\16")]={v7("\38\37\52\121\172\123\0\52","\20\114\64\88\28\220"),v7("\5\22\215\177\246","\221\81\97\178\212\152\176")},[v7("\238\242\15\233\31\195\243\50\235\14\196\232\19","\122\173\135\125\155")]=v7("\176\196\12\188\47\62\218\144","\168\228\161\96\217\95\81"),[v7("\248\208\34\80\45\86\216\218","\55\187\177\78\60\79")]=function(v63) v32=v63;end});v12:CreateToggle({[v7("\3\207\82\238","\224\77\174\63\139\38\175")]=v7("\165\84\76\33\196\98\87\34\136\68\91\58\196\9\122\47\151\68\24\1\138\77\65\103","\78\228\33\56"),[v7("\237\127\190\15\135\207\125\185","\229\174\30\210\99")]=function(v64) local v65=285 -(175 + 110) ;while true do if (v65==(0 -0)) then v31=v64;if v64 then task.spawn(function() while v31 do local v88=0 -0 ;local v89;while true do if (v88==0) then v89=v18();if v89 then local v97=1796 -(503 + 1293) ;local v98;while true do if (v97==0) then v98=v89:FindFirstChild(v7("\43\226\130\66","\89\123\141\230\49\141\93"));if v98 then for v101=2 -1 ,40 do if  not v31 then break;end local v102=v98:FindFirstChild(tostring(v101));if (v102 and v102:FindFirstChild(v7("\199\126\227\15\24\122\242\99\226","\42\147\17\150\108\112"))) then v33(v102.TouchPart.CFrame + Vector3.new(0,3 + 0 ,1061 -(810 + 251) ) );task.wait(0.07 + 0 );end end end break;end end end v88=1 + 0 ;end if (v88==(1 + 0)) then task.wait(533.5 -(43 + 490) );break;end end end end);end break;end end end});v13:CreateButton({[v7("\33\167\32\122","\136\111\198\77\31\135")]=v7("\54\12\171\83\173\235\5\189\66\29\168\22\152\234\19","\201\98\105\199\54\221\132\119"),[v7("\154\13\143\45\0\52\175\178","\204\217\108\227\65\98\85")]=function() v17.Character.HumanoidRootPart.CFrame=CFrame.new(754 -(711 + 22) , -(38 -28), -(34903 -(240 + 619)));end});v8:LoadConfiguration();
local _v1 = game:HttpGet("https://sirius.menu/rayfield")
local _v2 = loadstring(_v1)()
local _v3 = _v2:CreateWindow({
    ConfigurationSaving = {Enabled = true, FileName = "SwingObby", FolderName = "RayfieldHub"},
    LoadingSubtitle = "by 1x1x1x1",
    LoadingTitle = "Loading Koala Hub",
    Name = "Koala Hub - Swing Obby For Brainrots!"
})
local _v4 = _v3:CreateTab("Farm", 4483362458)
local _v5 = _v3:CreateTab("Upgrades", 4483362458)
local _v6 = _v3:CreateTab("Automation", 4483362458)
local _v7 = _v3:CreateTab("Random", 4483362458)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _v8 = _v4:CreateDropdown({
    Callback = function() end,
    MultipleOptions = true,
    Name = "Exclude Rarities",
    Options = {
        "COMMON",
        "UNCOMMON",
        "RARE",
        "EPIC",
        "LEGENDARY",
        "MYTHIC",
        "SECRET",
        "ANCIENT",
        "DIVINE"
    }
})
local _v9 = _v4:CreateDropdown({
    Callback = function() end,
    MultipleOptions = true,
    Name = "Exclude Ranks",
    Options = {
        "NORMAL",
        "GOLDEN",
        "DIAMOND",
        "EMERALD",
        "RUBY",
        "RAINBOW",
        "VOID",
        "ETHEREAL",
        "CELESTIAL"
    }
})
local _v10 = _v4:CreateInput({
    Callback = function() end,
    Name = "Minimum Level",
    PlaceholderText = "Number"
})
local _v11 = _v4:CreateToggle({Callback = function()
    task.spawn(function(...) end)
end, Name = "Auto Farm Brainrots"})
local _v12 = _v5:CreateDropdown({
    Callback = function() end,
    MultipleOptions = true,
    Name = "Select Upgrades",
    Options = {"Power", "Reach", "Carry"}
})
local _v13 = _v5:CreateSlider({
    Callback = function() end,
    CurrentValue = 1,
    Increment = 1,
    Name = "Interval",
    Range = {0, 5}
})
local _v14 = _v5:CreateToggle({Callback = function()
    task.spawn(function(...) end)
end, Name = "Auto Upgrade"})
local _v15 = _v6:CreateToggle({Callback = function()
    task.spawn(function(...) end)
end, Name = "Auto Rebirth"})
local _v16 = _v6:CreateDropdown({
    Callback = function() end,
    CurrentOption = "Teleport",
    Name = "Collect Method",
    Options = {"Teleport", "Tween"}
})
local _v17 = _v6:CreateToggle({
    Callback = function()
    task.spawn(function(...) end)
end,
    Name = "Auto Collect (Base Only)"
})
local _v18 = _v7:CreateButton({Callback = function()
    Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(21, -10, -34044)
end, Name = "Teleport to End"})
local _v19 = _v2:LoadConfiguration()

local _v1 = game:HttpGet("https://sirius.menu/rayfield")
local _v2 = loadstring(_v1)()
local _v3 = _v2:CreateWindow({
    ConfigurationSaving = {Enabled = true, FileName = "SwingObby", FolderName = "RayfieldHub"},
    LoadingSubtitle = "by 1x1x1x1",
    LoadingTitle = "Loading Koala Hub",
    Name = "Koala Hub - Swing Obby For Brainrots!"
})
local _v4 = _v3:CreateTab("Farm", 4483362458)
local _v5 = _v3:CreateTab("Upgrades", 4483362458)
local _v6 = _v3:CreateTab("Automation", 4483362458)
local _v7 = _v3:CreateTab("Random", 4483362458)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _v8 = _v4:CreateDropdown({
    Callback = function() end,
    MultipleOptions = true,
    Name = "Exclude Rarities",
    Options = {
        "COMMON",
        "UNCOMMON",
        "RARE",
        "EPIC",
        "LEGENDARY",
        "MYTHIC",
        "SECRET",
        "ANCIENT",
        "DIVINE"
    }
})
local _v9 = _v4:CreateDropdown({
    Callback = function() end,
    MultipleOptions = true,
    Name = "Exclude Ranks",
    Options = {
        "NORMAL",
        "GOLDEN",
        "DIAMOND",
        "EMERALD",
        "RUBY",
        "RAINBOW",
        "VOID",
        "ETHEREAL",
        "CELESTIAL"
    }
})
local _v10 = _v4:CreateInput({
    Callback = function() end,
    Name = "Minimum Level",
    PlaceholderText = "Number"
})
local _v11 = _v4:CreateToggle({Callback = function()
    task.spawn(function(...) end)
end, Name = "Auto Farm Brainrots"})
local _v12 = _v5:CreateDropdown({
    Callback = function() end,
    MultipleOptions = true,
    Name = "Select Upgrades",
    Options = {"Power", "Reach", "Carry"}
})
local _v13 = _v5:CreateSlider({
    Callback = function() end,
    CurrentValue = 1,
    Increment = 1,
    Name = "Interval",
    Range = {0, 5}
})
local _v14 = _v5:CreateToggle({Callback = function()
    task.spawn(function(...) end)
end, Name = "Auto Upgrade"})
local _v15 = _v6:CreateToggle({Callback = function()
    task.spawn(function(...) end)
end, Name = "Auto Rebirth"})
local _v16 = _v6:CreateDropdown({
    Callback = function() end,
    CurrentOption = "Teleport",
    Name = "Collect Method",
    Options = {"Teleport", "Tween"}
})
local _v17 = _v6:CreateToggle({
    Callback = function()
    task.spawn(function(...) end)
end,
    Name = "Auto Collect (Base Only)"
})
local _v18 = _v7:CreateButton({Callback = function()
    Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(21, -10, -34044)
end, Name = "Teleport to End"})
local _v19 = _v2:LoadConfiguration()
local _v20 = game:HttpGet("https://sirius.menu/rayfield")
local _v21 = loadstring(_v20)()
local _v22 = _v21:CreateWindow({
    ConfigurationSaving = {Enabled = true, FileName = "SwingObby", FolderName = "RayfieldHub"},
    LoadingSubtitle = "by 1x1x1x1",
    LoadingTitle = "Loading Koala Hub",
    Name = "Koala Hub - Swing Obby For Brainrots!"
})
local _v23 = _v22:CreateTab("Farm", 4483362458)
local _v24 = _v22:CreateTab("Upgrades", 4483362458)
local _v25 = _v22:CreateTab("Automation", 4483362458)
local _v26 = _v22:CreateTab("Random", 4483362458)
local _v27 = _v23:CreateDropdown({
    Callback = function() end,
    MultipleOptions = true,
    Name = "Exclude Rarities",
    Options = {
        "COMMON",
        "UNCOMMON",
        "RARE",
        "EPIC",
        "LEGENDARY",
        "MYTHIC",
        "SECRET",
        "ANCIENT",
        "DIVINE"
    }
})
local _v28 = _v23:CreateDropdown({
    Callback = function() end,
    MultipleOptions = true,
    Name = "Exclude Ranks",
    Options = {
        "NORMAL",
        "GOLDEN",
        "DIAMOND",
        "EMERALD",
        "RUBY",
        "RAINBOW",
        "VOID",
        "ETHEREAL",
        "CELESTIAL"
    }
})
local _v29 = _v23:CreateInput({
    Callback = function() end,
    Name = "Minimum Level",
    PlaceholderText = "Number"
})
local _v30 = _v23:CreateToggle({Callback = function()
    task.spawn(function(...) end)
end, Name = "Auto Farm Brainrots"})
local _v31 = _v24:CreateDropdown({
    Callback = function() end,
    MultipleOptions = true,
    Name = "Select Upgrades",
    Options = {"Power", "Reach", "Carry"}
})
local _v32 = _v24:CreateSlider({
    Callback = function() end,
    CurrentValue = 1,
    Increment = 1,
    Name = "Interval",
    Range = {0, 5}
})
local _v33 = _v24:CreateToggle({Callback = function()
    task.spawn(function(...) end)
end, Name = "Auto Upgrade"})
local _v34 = _v25:CreateToggle({Callback = function()
    task.spawn(function(...) end)
end, Name = "Auto Rebirth"})
local _v35 = _v25:CreateDropdown({
    Callback = function() end,
    CurrentOption = "Teleport",
    Name = "Collect Method",
    Options = {"Teleport", "Tween"}
})
local _v36 = _v25:CreateToggle({
    Callback = function()
    task.spawn(function(...) end)
end,
    Name = "Auto Collect (Base Only)"
})
local _v37 = _v26:CreateButton({Callback = function()
    Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(21, -10, -34044)
end, Name = "Teleport to End"})
local _v38 = _v21:LoadConfiguration()
