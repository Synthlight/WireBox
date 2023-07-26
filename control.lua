local function getEntityOrNilFromDict(haystack, needle)
    for i, entity in pairs(haystack) do
        if entity == needle then
            return entity
        end
    end
    return nil
end

local function on_player_selected_area(event)
    if event.item == "wire-box-tool" then
        local playerSettings = settings.get_player_settings(event.player_index)
        local entities = event.entities

        -- Sort entities by their position in a left-to-right, top-to-bottom order
        table.sort(entities, function(a, b)
            if a.position.y == b.position.y then
                return a.position.x < b.position.x
            else
                return a.position.y < b.position.y
            end
        end)

        local lastEntity = nil

        for i = 1, #entities do
            local entity = entities[i]

            -- Check if the entity is a container or an electric pole
            if entity and (entity.type == "electric-pole" or entity.type == "container") then
                if lastEntity then
                    local isBoth = playerSettings["wire-box-tool-mode"].value == "red-green"
                    local isRed = isBoth or playerSettings["wire-box-tool-mode"].value == "red-only"
                    local isGreen = isBoth or playerSettings["wire-box-tool-mode"].value == "green-only"

                    if isRed then
                        pcall(function() lastEntity.connect_neighbour({wire = defines.wire_type.red, target_entity = entity}) end)
                    end

                    if isGreen then
                        pcall(function() lastEntity.connect_neighbour({wire = defines.wire_type.green, target_entity = entity}) end)
                    end
                end

                -- The current entity becomes the last entity for the next iteration
                lastEntity = entity
            end
        end
    end
end

local function on_player_alt_selected_area(event)
    game.print("Alt mode activated")  -- This will print to the screen when alt mode is activated

    if event.item == "wire-box-tool" then
        local playerSettings = settings.get_player_settings(event.player_index)
        local entities = event.entities

        -- Sort entities by their position in a left-to-right, top-to-bottom order
        table.sort(entities, function(a, b)
            if a.position.y == b.position.y then
                return a.position.x < b.position.x
            else
                return a.position.y < b.position.y
            end
        end)

        local lastEntity = nil

        for i = 1, #entities do
            local entity = entities[i]

            -- Check if the entity is a container
            if entity and entity.type == "container" then
                if lastEntity then
                    local isBoth = playerSettings["wire-box-tool-mode"].value == "red-green"
                    local isRed = isBoth or playerSettings["wire-box-tool-mode"].value == "red-only"
                    local isGreen = isBoth or playerSettings["wire-box-tool-mode"].value == "green-only"

                    if isRed then
                        pcall(function() lastEntity.connect_neighbour({wire = defines.wire_type.red, target_entity = entity}) end)
                    end

                    if isGreen then
                        pcall(function() lastEntity.connect_neighbour({wire = defines.wire_type.green, target_entity = entity}) end)
                    end
                end

                -- The current entity becomes the last entity for the next iteration
                lastEntity = entity
            end
        end
    end
end

function tableContains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

script.on_event(defines.events.on_player_selected_area, on_player_selected_area)
script.on_event(defines.events.on_player_alt_selected_area, on_player_alt_selected_area)
