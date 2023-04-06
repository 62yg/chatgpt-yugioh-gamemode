-- card_library.lua (shared)
CardLibrary = {}

function CardLibrary:createCard(id, name, img, cardType, effect)
    local card = {
        id = id,
        name = name,
        img = img,
        cardType = cardType,
        effect = effect
    }
    return card
end
