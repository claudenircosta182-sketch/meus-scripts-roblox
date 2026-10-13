-- [[ MENU MAQUIAVÉLICO - ADVANCED SPAM & ESP ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TextChatService = game:GetService("TextChatService")
local LocalPlayer = Players.LocalPlayer

-- Segurança para o executor: Remove instâncias antigas do menu se você reinjetar
if CoreGui:FindFirstChild("MenuMaquiavelicoGui") then
    CoreGui.MenuMaquiavelicoGui:Destroy()
end

-- Variáveis de Controle de Estado
local menuAberto = true
local espAtivo = false
local conexaoEsp = nil

-- Configuração do Canal de Chat (Compatível com o novo sistema de Chat do Roblox)
local chatChannel = nil
if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
    chatChannel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
end

-- Função Auxiliar para Enviar Mensagem Instantaneamente
local function enviarChat(mensagem)
    if chatChannel then
        chatChannel:SendAsync(mensagem)
    else
        -- Fallback para executores em servidores com chat antigo
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(mensagem, "All")
    end
end

-- [[ INTERFACE GRÁFICA (UI) ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MenuMaquiavelicoGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Botão Flutuante "W" para Abrir/Fechar
local BotaoAlternar = Instance.new("TextButton")
BotaoAlternar.Name = "BotaoW"
BotaoAlternar.Size = UDim2.new(0, 40, 0, 40)
BotaoAlternar.Position = UDim2.new(1, -260, 0.4, 0)
BotaoAlternar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BotaoAlternar.Text = "W"
BotaoAlternar.TextColor3 = Color3.fromRGB(255, 255, 255)
BotaoAlternar.Font = Enum.Font.SourceSansBold
BotaoAlternar.TextSize = 24
BotaoAlternar.Parent = ScreenGui

local UICornerW = Instance.new("UICorner")
UICornerW.CornerRadius = UDim.new(0, 8)
UICornerW.Parent = BotaoAlternar

-- Janela Principal (Retângulo Compacto Vertical no Lado Direito)
local FrameMenu = Instance.new("Frame")
FrameMenu.Name = "JanelaPrincipal"
FrameMenu.Size = UDim2.new(0, 200, 0, 480)
FrameMenu.Position = UDim2.new(1, -210, 0.2, 0)
FrameMenu.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Base para o Gradiente
FrameMenu.Visible = true
FrameMenu.Parent = ScreenGui

-- Tornar a Janela Arrastável (Draggable)
FrameMenu.Active = true
FrameMenu.Selectable = true
FrameMenu.Draggable = true

-- Efeito Gradiente Preto e Branco Maquiavélico
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),       -- Topo Preto
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))  -- Base Branca
})
UIGradient.Rotation = 90 -- Vertical (Cabeça para baixo)
UIGradient.Parent = FrameMenu

local UICornerMenu = Instance.new("UICorner")
UICornerMenu.CornerRadius = UDim.new(0, 10)
UICornerMenu.Parent = FrameMenu

-- Título do Menu
local LabelTitulo = Instance.new("TextLabel")
LabelTitulo.Size = UDim2.new(1, 0, 0, 30)
LabelTitulo.BackgroundTransparency = 1
LabelTitulo.Text = "Menu Maquiavélico"
LabelTitulo.TextColor3 = Color3.fromRGB(255, 0, 0) -- Vermelho Sangue para Destaque
LabelTitulo.Font = Enum.Font.SourceSansBold
LabelTitulo.TextSize = 18
LabelTitulo.Parent = FrameMenu

-- Container com Scroll para os Botões (Mantém o design compacto e pequeno)
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, -10, 1, -40)
ScrollContainer.Position = UDim2.new(0, 5, 0, 35)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 680) -- Altura interna regulável
ScrollContainer.ScrollBarThickness = 4
ScrollContainer.Parent = FrameMenu

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = ScrollContainer

-- Função para Gerar Botões Padronizados Estilo Dark
local function criarBotao(texto, layoutOrder, cliqueCallback)
    local Botao = Instance.new("TextButton")
    Botao.Size = UDim2.new(1, -10, 0, 30)
    Botao.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Botao.Text = texto
    Botao.TextColor3 = Color3.fromRGB(240, 240, 240)
    Botao.Font = Enum.Font.SourceSans
    Botao.TextSize = 14
    Botao.LayoutOrder = layoutOrder
    Botao.Parent = ScrollContainer
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = Botao
    
    Botao.MouseButton1Click:Connect(cliqueCallback)
    return Botao
end

-- [[ LÓGICA DO BOTÃO "W" (JANELA FLUTUANTE) ]] --
BotaoAlternar.MouseButton1Click:Connect(function()
    menuAberto = not menuAberto
    FrameMenu.Visible = menuAberto
end)

-- [[ SEÇÃO: COMANDOS SPAM INDIVIDUAIS ]] --
local listaSpam = {
    { text = "Spam: Tiro na Cabeça 🩸", msg = "/ . Tiro Na cabeça 🩸" },
    { text = "Spam: Render 🩸",       msg = "/ . Render 🩸" },
    { text = "Spam: Soco",            msg = "/ . soco" },
    { text = "Spam: Jab",             msg = "/ . Jab" },
    { text = "Spam: Chute",            msg = "/ . Chute" },
    { text = "Spam: Kit Carro",        msg = "/ . Kit Carro" },
    { text = "Spam: Kit Médico",       msg = "/ . Kit médico" },
    { text = "Spam: Cortar Com.",      msg = "/ . Cortar comunicação" },
    { text = "Spam: Acender",          msg = "/ . Acender" },
    { text = "Spam: Tragar",           msg = "/ . Tragar" },
    { text = "Spam: Tiro Cabeça / PD", msg = "/ . Tiro na cabeça 🩸 / PD" }
}

for i, dados in ipairs(listaSpam) do
    criarBotao(dados.text, i, function()
        enviarChat(dados.msg)
    end)
end

-- Separador Visual de Seção
local LabelSeparador1 = Instance.new("TextLabel")
LabelSeparador1.Size = UDim2.new(1, -10, 0, 20)
LabelSeparador1.BackgroundTransparency = 1
LabelSeparador1.Text = "-- MÚLTIPLOS 3X --"
LabelSeparador1.TextColor3 = Color3.fromRGB(0, 0, 0)
LabelSeparador1.Font = Enum.Font.SourceSansBold
LabelSeparador1.TextSize = 12
LabelSeparador1.LayoutOrder = 50
LabelSeparador1.Parent = ScrollContainer

-- [[ SEÇÃO: SPAM 3X RÁPIDO ]] --
local listaSpam3x = {
    { text = "3X: Tiro na Cabeça 🩸", msg = "/ .  Tiro na cabeça 🩸" },
    { text = "3X: Render 🩸",       msg = "/ . Render 🩸" },
    { text = "3X: Jab",             msg = "/ . Jab" },
    { text = "3X: Chute",            msg = "/ . Chute" }
}

for i, dados in ipairs(listaSpam3x) do
    criarBotao(dados.text, 50 + i, function()
        for _ = 1, 3 do
            enviarChat(dados.msg)
            task.wait(0.05) -- Intervalo milimétrico seguro para o chat aceitar e não ignorar
        end
    end)
end

-- Separador Visual de Seção
local LabelSeparador2 = Instance.new("TextLabel")
LabelSeparador2.Size = UDim2.new(1, -10, 0, 20)
LabelSeparador2.BackgroundTransparency = 1
LabelSeparador2.Text = "-- VISUAL --"
LabelSeparador2.TextColor3 = Color3.fromRGB(0, 0, 0)
LabelSeparador2.Font = Enum.Font.SourceSansBold
LabelSeparador2.TextSize = 12
LabelSeparador2.LayoutOrder = 100
LabelSeparador2.Parent = ScrollContainer

-- [[ SEÇÃO: SISTEMA DE ESP AVANÇADO ]] --
local BotaoEsp = criarBotao("ESP: OFF", 101, function() end)
BotaoEsp.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

-- Limpeza de elementos de ESP antigos do jogador
local function removerEspJogador(player)
    if player.Character then
        local cham = player.Character:FindFirstChild("EspChamsMaquiavelico")
        if cham then cham:Destroy() end
        
        local head = player.Character:FindFirstChild("Head")
        if head then
            local tag = head:FindFirstChild("EspTagMaquiavelica")
            if tag then tag:Destroy() end
        end
    end
end

-- Adiciona os efeitos visuais nos alvos
local function aplicarEspJogador(player)
    if player == LocalPlayer then return end
    
    local function criarElementos()
        local char = player.Character
        if not char then return end
        
        -- Efeito de silhueta vermelha estilo palito/esqueleto destacado pelas bordas
        if not char:FindFirstChild("EspChamsMaquiavelico") then
            local Chams = Instance.new("Highlight")
            Chams.Name = "EspChamsMaquiavelico"
            Chams.FillColor = Color3.fromRGB(0, 0, 0)
            Chams.FillTransparency = 0.85 -- Transparência interna quase invisível
            Chams.OutlineColor = Color3.fromRGB(255, 0, 0) -- Tracing de silhueta vermelho fino
            Chams.OutlineTransparency = 0 -- 100% Visível pelas paredes
            Chams.Adornee = char
            Chams.Parent = char
        end
        
        -- Nome e distância em fonte fina
        local head = char:WaitForChild("Head", 3)
        if head and not head:FindFirstChild("EspTagMaquiavelica") then
            local BillboardGui = Instance.new("BillboardGui")
            BillboardGui.Name = "EspTagMaquiavelica"
            BillboardGui.AlwaysOnTop = true
            BillboardGui.Size = UDim2.new(0, 200, 0, 50)
            BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
            BillboardGui.Adornee = head
            
            local TextLabel = Instance.new("TextLabel")
            TextLabel.Size = UDim2.new(1, 0, 1, 0)
            TextLabel.BackgroundTransparency = 1
            TextLabel.Text = player.Name .. " [0m]"
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextStrokeTransparency = 0.5
            TextLabel.Font = Enum.Font.SourceSansLight -- Letra Fina conforme pedido
            TextLabel.TextSize = 14
            TextLabel.Parent = BillboardGui
            
            BillboardGui.Parent = head
            
            -- Loop interno de atualização de metros em tempo real
            task.spawn(function()
                while espAtivo and char and head and BillboardGui:IsDescendantOf(game) do
                
