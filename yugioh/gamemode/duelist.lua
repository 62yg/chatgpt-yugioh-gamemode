Duelist = {}
Duelist.__index = Duelist

function Duelist:new(name)
    local self = {}
    setmetatable(self, Duelist)

    self.name = name
    self.deck = {}
    self.hand = {}
    self.field = { monsterZones = {}, spellTrapZones = {} }
    self.lifePoints = STARTING_LP

    return self
end

function Duelist:shuffleDeck()
    table.Shuffle(self.deck)
end

function Duelist:drawCard()
    local card = table.remove(self.deck, 1)
    table.insert(self.hand, card)
end

function Duelist:drawStartingHand()
    for i = 1, STARTING_HAND_SIZE do
        self:drawCard()
    end
end
