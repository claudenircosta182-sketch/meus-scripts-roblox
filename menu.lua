-- [[ MENU MAQUIAVÉLICO - VERSÃO ULTRA COMPATÍVEL ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Segurança: Deleta o menu anterior se já existir
if CoreGui:FindFirstChild("MenuMaquiavelicoGui") then
    CoreGui.MenuMaquiavelicoGui:Destroy()
end

-- Avisar no chat local que o script injetou com sucesso
game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
    Text = "[MENU MAQUIAVÉLICO]: Injetado com sucesso! Clique em 'W' para abrir/fechar.";
    Color = Color3.fromRGB(255, 0, 0);
    Font = Enum.Font.SourceSansBold;
})

-- Variáveis de Controle
local menuAberto = true
local espAtivo = false
local conexaoEsp = nil

-- Função Universal de Chat (Funciona em QUALQUER executor e chat antigo/novo)
local function enviarChat(mensagem)
    local sayMessage = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents") 
        and game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
    
    if sayMessage then
        sayMessage:FireServer(mensagem, "All")
    else
        -- Novo sistema de chat do Roblox
        pcall(function()
            local tcs = game:GetService("TextChatService")
            if tcs and tcs.ChatVersion == Enum.ChatVersion.TextChatService then
                local channel = tcs.TextChannels:FindFirstChild("RBXGeneral")
                if channel then channel:SendAsync(mensagem) end
            end
        end)
    end
end

-- [[ INTERFACE GRÁFICA (UI) ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MenuMaquiavelicoGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Botão Flutuante "W"
local BotaoAlternar = Instance.new("TextButton")
BotaoAlternar.Name = "BotaoW"
BotaoAlternar.Size = UDim2.new(0, 45, 0, 45)
BotaoAlternar.Position = UDim2.new(1, -260, 0.4, 0)
BotaoAlternar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BotaoAlternar.Text = "W"
BotaoAlternar.TextColor3 = Color3.fromRGB(255, 255, 255)
BotaoAlternar.Font = Enum.Font.SourceSansBold
BotaoAlternar.TextSize = 24
BotaoAlternar.Active = true
BotaoAlternar.Draggable = true -- Você pode arrastar o botão W se quiser
BotaoAlternar.Parent = ScreenGui

local UICornerW = Instance.new("UICorner")
UICornerW.CornerRadius = UDim.new(0, 8)
UICornerW.Parent = BotaoAlternar

-- Janela Principal (Compacta no Lado Direito)
local FrameMenu = Instance.new("Frame")
FrameMenu.Name = "JanelaPrincipal"
FrameMenu.Size = UDim2.new(0, 190, 0, 450)
FrameMenu.Position = UDim2.new(1, -205, 0.2, 0)
FrameMenu.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FrameMenu.Visible = true
FrameMenu.Active = true
FrameMenu.Draggable = true
FrameMenu.Parent = ScreenGui

-- Gradiente Preto e Branco
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
UIGradient.Rotation = 90
UIGradient.Parent = FrameMenu

local UICornerMenu = Instance.new("UICorner")
UICornerMenu.CornerRadius = UDim.new(0, 10)
UICornerMenu.Parent = FrameMenu

-- Título
local LabelTitulo = Instance.new("TextLabel")
LabelTitulo.Size = UDim2.new(1, 0, 0, 30)
LabelTitulo.BackgroundTransparency = 1
LabelTitulo.Text = "Menu Maquiavélico"
LabelTitulo.TextColor3 = Color3.fromRGB(255, 0, 0)
LabelTitulo.Font = Enum.Font.SourceSansBold
LabelTitulo.TextSize = 16
LabelTitulo.Parent = FrameMenu

-- Rolagem (Scrolling)
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, -10, 1, -40)
ScrollContainer.Position = UDim2.new(0, 5, 0, 35)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 720)
ScrollContainer.ScrollBarThickness = 3
ScrollContainer.Parent = FrameMenu

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.Parent = ScrollContainer

-- Criador de botões limpo
local function criarBotao(texto, ordem, callback)
    local Botao = Instance.new("TextButton")
    Botao.Size = UDim2.new(1, -6, 0, 28)
    Botao.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Botao.Text = texto
    Botao.TextColor3 = Color3.fromRGB(255, 255, 255)
    Botao.Font = Enum.Font.SourceSans
    Botao.TextSize = 13
    Botao.LayoutOrder = ordem
    Botao.Parent = ScrollContainer
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = Botao
    
    Botao.MouseButton1Click:Connect(callback)
    return Botao
end

-- Lógica de abrir/fechar
BotaoAlternar.MouseButton1Click:Connect(function()
    menuAberto = not menuAberto
    FrameMenu.Visible = menuAberto
end)

-- [[ SPAMS INDIVIDUAIS ]] --
local listaSpam = {
    { t = "Tiro na Cabeça 🩸", m = "/ . Tiro Na cabeça 🩸" },
    { t = "Render 🩸",       m = "/ . Render 🩸" },
    { t = "Soco",            m = "/ . soco" },
    { t = "Jab",             m = "/ . Jab" },
    { t = "Chute",            m = "/ . Chute" },
    { t = "Kit Carro",        m = "/ . Kit Carro" },
    { t = "Kit Médico",       m = "/ . Kit médico" },
    { t = "Cortar Com.",      m = "/ . Cortar comunicação" },
    { t = "Acender",          m = "/ . Acender" },
    { t = "Tragar",           m = "/ . Tragar" },
    { t = "Tiro Cabeça / PD", m = "/ . Tiro na cabeça 🩸 / PD" }
}

for i, v in ipairs(listaSpam) do
    criarBotao(v.t, i, function() enviarChat(v.m) end)
end

-- Separador 1
local Sep1 = Instance.new("TextLabel")
Sep1.Size = UDim2.new(1, 0, 0, 20)
Sep1.BackgroundTransparency = 1
Sep1.Text = "-- MÚLTIPLOS 3X --"
Sep1.TextColor3 = Color3.fromRGB(0, 0, 0)
Sep1.Font = Enum.Font.SourceSansBold
Sep1.TextSize = 11
Sep1.LayoutOrder = 50
Sep1.Parent = ScrollContainer

-- [[ SPAMS 3X ]] --
local lista3x = {
    { t = "3X: Tiro Cabeça 🩸", m = "/ .  Tiro na cabeça 🩸" },
    { t = "3X: Render 🩸",       m = "/ . Render 🩸" },
    { t = "3X: Jab",             m = "/ . Jab" },
    { t = "3X: Chute",            m = "/ . Chute" }
}

for i, v in ipairs(lista3x) do
    criarBotao(v.t, 50 + i, function()
        for _ = 1, 3 do
            enviarChat(v.m)
            task.wait(0.08)
        end
    end)
end

-- Separador 2
local Sep2 = Instance.new("TextLabel")
Sep2.Size = UDim2.new(1, 0, 0, 20)
Sep2.BackgroundTransparency = 1
Sep2.Text = "-- VISUAL --"
Sep2.TextColor3 = Color3.fromRGB(0, 0, 0)
Sep2.Font = Enum.Font.SourceSansBold
Sep2.TextSize = 11
Sep2.LayoutOrder = 100
Sep2.Parent = ScrollContainer

-- [[ SISTEMA ESP COM HIGHLIGHT ULTRA LEVE ]] --
local BotaoEsp = criarBotao("ESP: OFF", 101, function() end)
BotaoEsp.BackgroundColor3 = Color3.fromRGB(180, 0, 0)

local function limparEsp(p)
    if p.Character then
        local h = p.Character:FindFirstChild("MaquiavelHighlight")
        if h then h:Destroy() end
        local head = p.Character:FindFirstChild("Head")
        if head then
            local b = head:FindFirstChild("MaquiavelBB")
            if b then b:Destroy() end
        end
    end
end

local function darEsp(p)
    if p == LocalPlayer or not p.Character then return end
    local char = p.Character
    
    -- Outline Vermelho estilo esqueleto pelas paredes
    if not char:FindFirstChild("MaquiavelHighlight") then
        local hl = Instance.new("Highlight")
        hl.Name = "MaquiavelHighlight"
        hl.FillColor = Color3.fromRGB(0,0,0)
        hl.FillTransparency = 1 -- Foca apenas no traçado das linhas do corpo
        hl.OutlineColor = Color3.fromRGB(255, 0, 0)
        hl.OutlineTransparency = 0
        hl.Adornee = char
        hl.Parent = char
    end
    
    -- Nome e Distância Fina
    local head = char:WaitForChild("Head", 2)
    if head and not head:FindFirstChild("MaquiavelBB") then
        local bb = Instance.new("BillboardGui")
        bb.Name = "MaquiavelBB"
        bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 150, 0, 40)
        bb.StudsOffset = Vector3.new(0, 2, 0)
        bb.Adornee = head
        
        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1, 0, 1, 0)
        txt.BackgroundTransparency = 1
        txt.Text = p.Name .. " [Calculando...]"
        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
        txt.Font = Enum.Font.SourceSansLight
        txt.TextSize = 12
        txt.Parent = bb
        bb.Parent = head
        
        task.spawn(function()
            while espAtivo and char and head and bb:IsDescendantOf(game) do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("HumanoidRootPart") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                    txt.Text = string.format("%s\n[%d Metros]", p.Name, math.floor(dist))
                end
                task.wait(0.3)
            end
        end)
    end
end

BotaoEsp.MouseButton1Click:Connect(function()
    espAtivo = not espAtivo
    if espAtivo then
        BotaoEsp.Text = "ESP: ONLINE"
        BotaoEsp.BackgroundColor3 = Color3.fromRGB(0, 140, 0)
        for _, p in ipairs(Players:GetPlayers()) do darEsp(p) end
        conexaoEsp = Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function()
                if espAtivo then task.wait(0.5) darEsp(p) end
            end)
        end)
    else
        BotaoEsp.Text = "ESP: OFF"
        BotaoEsp.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        if conexaoEsp then conexaoEsp:Disconnect() conexaoEsp = nil end
        for _, p in ipairs(Players:GetPlayers()) do limparEsp(p) end
    end
end)
