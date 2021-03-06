--[[
Copyright (c) 2009 Muhammad Lukman Nasaruddin (ai-chan)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and 
associated documentation files (the "Software"), to deal in the Software without restriction, 
including without limitation the rights to use, copy, modify, merge, publish, distribute, 
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is 
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial 
portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT 
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES 
OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 Automation script: Gradient Corporation

]]

script_name = "Doki Gradient"
script_description = "Color gradient generator by ai-chan, improved by TheThing"
script_author = "Muhammad Lukman Nasaruddin (ai-chan), Jonatan Nilsson (TheThing)"
script_version = "1.9"
script_modified = "16 October 2012"

include("karaskel.lua")

if not corporation then corporation = {} end

corporation.conf = {
    [1] = { class = "label"; x = 0; y = 0; height = 1; width = 5; label = string.format("%s %s by ai-chan (updated %s)", script_name, script_version, script_modified) }
    ,
    [3] = { label = "Apply to"; class = "label"; x = 0; y = 1; height = 1; width = 1 }
    ,
    [4] = { name = "applyto"; class = "dropdown"; x = 1; y = 1; height = 1; width = 4; items = { }; value = nil }
    ,
    [5] = { label = "Mode"; class = "label"; x = 0; y = 2; height = 1; width = 1 }
    ,
    [6] = { name = "mode"; class = "dropdown"; x = 1; y = 2; height = 1; width = 4; 
        items = { "Smooth", "Smooth (Vertical)"}; value = "Smooth"
        -- Removing "By character" and "By syllable" cause not supported "yet"
    }
    ,
    [8] = { label = "Pixel per strip (for Smooth modes)"; class = "label"; x = 0; y = 3; height = 1; width = 3 }
    ,
    [9] = { name = "stripx"; class = "intedit"; x = 3; y = 3; height = 1; width = 2; min = 1; max = 100; value = 1 }
    ,
    [10] = { label = "Karaoke"; class = "label"; x = 0; y = 4; height = 1; width = 1 }
    ,
    [11] = { name = "karamode"; class = "dropdown"; x = 1; y = 4; height = 1; width = 4; 
        items = { "As Is", "Strip karaoke", "\\k", "\\kf", "\\ko" }; value = "As Is"
    }
    ,
    [12] = { label = "Primary"; class = "label"; x = 1; y = 5; height = 1; width = 1 }
    ,
    [13] = { name = "primary_mode"; class = "dropdown"; x = 1; y = 6; height = 1; width = 1; 
        items = { }; value = "Ignore"
    }
    ,
    [14] = { label = "Secondary"; class = "label"; x = 2; y = 5; height = 1; width = 1 }
    ,
    [15] = { name = "secondary_mode"; class = "dropdown"; x = 2; y = 6; height = 1; width = 1; 
        items = { }; value = "Ignore"
    }
    ,
    [16] = { label = "Outline"; class = "label"; x = 3; y = 5; height = 1; width = 1 }
    ,
    [17] = { name = "outline_mode"; class = "dropdown"; x = 3; y = 6; height = 1; width = 1; 
        items = { }; value = "Ignore"
    }
    ,
    [18] = { label = "Shadow"; class = "label"; x = 4; y = 5; height = 1; width = 1 }
    ,
    [19] = { name = "shadow_mode"; class = "dropdown"; x = 4; y = 6; height = 1; width = 1; 
        items = { }; value = "Ignore"
    }
    ,
    [20] = { label = "Colors"; class = "label"; x = 0; y = 6; height = 1; width = 1 }
    ,
    [21] = { label = "Color 1"; class = "label"; x = 0; y = 7; height = 1; width = 1 }
    ,
    [22] = { name = "primary_color1"; class = "color"; x =1; y = 7; height = 1; width = 1 }
    ,
    [23] = { name = "secondary_color1"; class = "color"; x = 2; y = 7; height = 1; width = 1 }
    ,
    [24] = { name = "outline_color1"; class = "color"; x = 3; y = 7; height = 1; width = 1 }
    ,
    [25] = { name = "shadow_color1"; class = "color"; x = 4; y = 7; height = 1; width = 1 }
    ,
    [26] = { label = "Color 2"; class = "label"; x = 0; y = 8; height = 1; width = 1 }
    ,
    [27] = { name = "primary_color2"; class = "color"; x = 1; y = 8; height = 1; width = 1 }
    ,
    [28] = { name = "secondary_color2"; class = "color"; x = 2; y = 8; height = 1; width = 1 }
    ,
    [29] = { name = "outline_color2"; class = "color"; x = 3; y = 8; height = 1; width = 1 }
    ,
    [30] = { name = "shadow_color2"; class = "color"; x = 4; y = 8; height = 1; width = 1 }
    ,
    [31] = { label = "Color 3"; class = "label"; x = 0; y = 9; height = 1; width = 1 }
    ,
    [32] = { name = "primary_color3"; class = "color"; x = 1; y = 9; height = 1; width = 1 }
    ,
    [33] = { name = "secondary_color3"; class = "color"; x = 2; y = 9; height = 1; width = 1 }
    ,
    [34] = { name = "outline_color3"; class = "color"; x = 3; y = 9; height = 1; width = 1 }
    ,
    [35] = { name = "shadow_color3"; class = "color"; x = 4; y = 9; height = 1; width = 1 }
}

corporation.config_keys = { 4, 6, 9, 11, 13, 15, 17, 19 }

corporation.last_run = 0

corporation.color_comp_count = 3

corporation.colorkeys = { [1] = "primary"; [2] = "secondary"; [3] = "outline"; [4] = "shadow" }


function corporation.save_config(config)
    for _, i in ipairs(corporation.config_keys) do
        corporation.conf[i].value = config[corporation.conf[i].name]
    end
    for j = 1, corporation.color_comp_count do
        local jk = 17 + 5*j
        for k = jk, jk + 3 do
             corporation.conf[k].value = config[corporation.conf[k].name]
        end
    end
end

function corporation.serialize_config(config)
    local scfg = string.format("%d ", corporation.last_run)
    for _, i in ipairs(corporation.config_keys) do
        scfg = scfg .. config[corporation.conf[i].name] .. string.char(2)
    end
    for j = 1, corporation.color_comp_count do
        local jk = 17 + 5*j
        for k = jk, jk + 3 do
             scfg = scfg .. config[corporation.conf[k].name] .. string.char(2)
        end
    end
    return string.trim(scfg)
end

function corporation.unserialize_config(scfg)
    local c = 0
    local cfgtime, scfg = string.headtail(string.trim(scfg))
    local keys_count = #corporation.config_keys
    if tonumber(cfgtime) > corporation.last_run then
        for g in string.gmatch(scfg, "[^"..string.char(2).."]+") do
            c = c + 1
            if c <= keys_count then
                   corporation.conf[corporation.config_keys[c]].value = g
             else
                 local kc = 20 + c - keys_count
                 if kc % 5 == 1 then c, kc = c + 1, kc + 1 end
                 if not corporation.conf[kc] then corporation.append_color_components() end
                    corporation.conf[kc].value = g
             end
        end
    end
end

function corporation.append_color_components()
    corporation.color_comp_count = corporation.color_comp_count + 1
    corporation.conf[16 + corporation.color_comp_count * 5] = { label = "Color " .. corporation.color_comp_count; class = "label"; x = 0; y = corporation.color_comp_count + 6; height = 1; width = 1 }
    for i = 1, 4 do
        corporation.conf[i + 16 + corporation.color_comp_count * 5] = { 
            name = corporation.colorkeys[i] .. "_color" .. corporation.color_comp_count; 
            class = "color"; x = i; y = corporation.color_comp_count + 6; height = 1; width = 1 }
    end
end

function corporation.unappend_color_components()
    for i = 0, 4 do
        corporation.conf[i + 16 + corporation.color_comp_count * 5] = nil
    end
    corporation.color_comp_count = corporation.color_comp_count - 1
end

function corporation.process(meta, styles, config, subtitles, selected_lines, active_line)
    corporation.save_config(config)
    corporation.last_run = os.time()
    local scfg = corporation.serialize_config(config)
    -- Get colors
    local colors_count = { primary = 0; secondary = 0; outline = 0; shadow = 0 }
    local colors = { primary = {}; secondary = {}; outline = {}; shadow = {} }
    for k = 1,4 do
        local key = corporation.colorkeys[k]
        if config[key .. "_mode"] ~= "Ignore" then 
            count, _ = string.headtail(config[key .. "_mode"])
            colors_count[key] = tonumber(count)
        end
        for j = 1,colors_count[key] do
            local htmlcolor = config[key .. "_color" .. j]
            local r, g, b = string.match(htmlcolor, "(%x%x)(%x%x)(%x%x)")
            colors[key][j] = ass_color(tonumber(r,16), tonumber(g,16), tonumber(b,16))
        end
    end
    
    if colors_count["primary"] + colors_count["secondary"]+ colors_count["outline"] + colors_count["shadow"] == 0 then 
        aegisub.debug.out(0, "Operation failed because you did not configure gradient count for primary/secondary/outline/shadow colors.")
        return false
    end
    
    -- Mode
    local mode_digest = { ["Smooth"] = 1; ["Smooth (Vertical)"] = 2; ["By character"] = 3; ["By syllable"] = 4 }
    config.mode = mode_digest[config.mode]
    

    -- karaoke tag function
    config.karatagfn = function(syl) return "" end
    if config.karamode ~= "Strip karaoke" then
       if config.karamode == "As Is" then
              config.karatagfn = function(syl) return string.format("{\\%s%d}", syl.tag, syl.kdur) end
       else
              config.karatagfn = function(syl) return string.format("{%s%d}", config.karamode, syl.kdur) end
       end
    end

    -- Get lines indexes
    local subs = {}
    local applyto_type, applyto_more = string.headtail(config.applyto)

    if applyto_type == "All" then
        for i = 1, #subtitles do 
            if subtitles[i].class == "dialogue" and not subtitles[i].comment and not corporation.has_gradient(subtitles[i]) then 
               table.insert(subs,i)
            end 
        end
    elseif applyto_type == "Selected" then
        subs = selected_lines
    elseif applyto_type == "Style" then
        local _, applytostyle = string.headtail(applyto_more)
        for i = 1, #subtitles do 
            if subtitles[i].class == "dialogue" and not subtitles[i].comment and not corporation.has_gradient(subtitles[i]) and subtitles[i].style == applytostyle then
                table.insert(subs,i)
            end
        end
    elseif applyto_type == "Actor" then
        local _, applytoactor = string.headtail(applyto_more)
        for i = 1, #subtitles do 
            if subtitles[i].class == "dialogue" and not subtitles[i].comment and not corporation.has_gradient(subtitles[i])
                and subtitles[i].actor == applytoactor then table.insert(subs,i) end
        end
    end

    -- process them
    local subtitles2 = {}
    local lasti = 0
    local count = 0
    local newlines = 0
    local configstored = false

    for _, i in pairs(subs) do
        count = count + 1
        aegisub.progress.set(count * 100 / #subs)
        if aegisub.progress.is_cancelled() then 
            return false
        end

        for j = lasti + 1, i - 1 do
            if not configstored then
                if subtitles[j].class == "clear" then
                    local iline = {
                        class = "info",
                        section = "Script Info";
                        key = "GradientCorporation";
                        value = scfg
                    }
                    table.insert(subtitles2, iline)
                    configstored = true
                elseif subtitles[j].class == "info" and subtitles[j].key == "GradientCorporation" then
                    local iline = table.copy(subtitles[j])
                    iline.value = scfg
                    subtitles[j] = iline
                    configstored = true
                end
            end
            table.insert(subtitles2, subtitles[j])
        end

        local line = subtitles[i]
        karaskel.preproc_line(subtitles, meta, styles, line)
        local res = corporation.do_line(meta, styles, config, colors, line)

        for j = 1, #res do
            table.insert(subtitles2, res[j])
            newlines = newlines + 1
        end

        lasti = i
        aegisub.progress.task(count .. " / " .. #subs .. " lines processed")
    end

    for j = lasti + 1, #subtitles do
        table.insert(subtitles2, subtitles[j])
    end

    -- clear subtitles and rebuild
    subtitles.deleterange(1, #subtitles)
    subtitles.delete(1)
    for j = 1, #subtitles2 do
        subtitles[0] = subtitles2[j]
    end

    return true
end


function corporation.do_line(meta, styles, config, colors, line)

    local outline = line.styleref.outline
    local shadow = line.styleref.shadow
    local width = line.width
    local height = line.height
    local _, __, baseLine = string.find(line.text, "({[^}]+)")
    
    nline = table.copy(line)
    nline.comment = true
    nline.effect = "gradient original"
    results = { [1] = nline }
    if #line.kara > 0 then
        for s, syl in ipairs(line.kara) do
            linetext = linetext .. config.karatagfn(syl) .. syl.text_stripped
        end
    else
        linetext = line.text_stripped
    end
    
    -- Check if \fs is specified and if it is, override style default
    if string.find(line.text, "\\fs(%d+)") or
       string.find(line.text, "\\fn(%d+)") then
        style = line.styleref
        local hasSize, e, newSize = string.find(line.text, "{[^}]*\\fs(%d+).*}")
        local hasFont, e, newfont = string.find(line.text, "\\fn([^\\}]+)")
        if hasFont then
            style.fontname = newfont
        end
        if hasSize then
            style.fontsize = newSize
        end
        newWidth, newHeight = aegisub.text_extents(style, linetext)
        
        width = newWidth
        height = newHeight
    end
    
    -- Check if \bord is specified and if it is, override style default
    if string.find(line.text, "\\bord(%d+)") then
        local b, e, newoutline = string.find(line.text, "{[^}]*\\bord(%d+).*}")
        outline = tonumber(newoutline)
    end
    
    -- Check if \shad is specified and if it is, override style default
    if string.find(line.text, "\\shad(%d+)") then
        local b, e, newshadow = string.find(line.text, "{[^}]*\\shad(%d+).*}")
        shadow = tonumber(newshadow)
    end
    
    local mode = config.mode
    if #line.kara == 0 and mode == 4 then mode = 3 end
    local linewidth = width + outline * 2 + shadow
    local lineheight = height + outline * 2 + shadow
    local lineleft = line.left - outline
    local lineright = line.right + outline * 2 + shadow
    local linetop = line.top - outline
    local linebottom = line.bottom + outline * 2 + shadow
    math.randomseed(os.time()+line.start_time)
    local randomtag = math.random(273, 4095)
    
    if width ~= line.width or height ~= line.height then
        if line.styleref.align <= 3 then
            linetop = linetop - (lineheight - line.height)
        elseif line.styleref.align <= 6 then
            linetop = linetop - (lineheight - line.height) / 2
            linebottom = linebottom + (lineheight - line.height) / 2
        else
            linebottom = linebottom + (lineheight - line.height)
        end
        if line.styleref.align % 3 == 1 then
            lineright = lineright + (linewidth - line.width)
        elseif line.styleref.align % 3 == 2 then
            lineleft = lineleft - (linewidth - line.width) / 2
            lineright = lineright + (linewidth - line.width) / 2
        else
            lineleft = lineleft - (linewidth - line.width)
        end
        
        -- Check if anchor points are different
        local hasAn, e, newAn = string.find(line.text, "{[^}]*\\an(%d).*}")
        if hasAn and tonumber(newAn) ~= line.styleref.align then
            -- 
            -- Begin calcuation the difference between the different anchor points
            --
            newAn = tonumber(newAn)
            if line.styleref.align <= 3 then -- Going from BottomAlign
                if newAn >= 4 and newAn <= 6 then -- To MiddleAlign
                    linetop = linetop + lineheight / 2
                    linebottom = linebottom + lineheight / 2
                elseif newAn >= 7 and newAn <= 9 then -- To TopAlign
                    linetop = linetop + lineheight
                    linebottom = linebottom + lineheight
                end
            elseif line.styleref.align <= 6 then -- Going from MiddleAlign
                if newAn >= 7 then -- To TopAlign
                    linetop = linetop + lineheight / 2
                    linebottom = linebottom + lineheight / 2
                elseif newAn >= 1 and newAn <= 3 then -- To BottomAlign
                    linetop = linetop - lineheight / 2
                    linebottom = linebottom - lineheight / 2
                end
            else -- Going from TopAlign
                if newAn >= 4 and newAn <= 6 then -- To MiddleAlign
                    linetop = linetop - lineheight / 2
                    linebottom = linebottom - lineheight / 2
                elseif newAn >= 1 and newAn <= 3 then -- To BottomAlign
                    linetop = linetop - lineheight
                    linebottom = linebottom - lineheight
                end
            end
            
            if line.styleref.align % 3 == 1 then -- Going from LeftAlign
                if newAn % 3 == 2 then -- To CenterAlign
                    lineleft = lineleft - linewidth / 2
                    lineright = lineright - linewidth / 2
                elseif newAn % 3 == 0 then -- To RightAlign
                    lineleft = lineleft - linewidth
                    lineright = lineright - linewidth
                end
            elseif line.styleref.align % 3 == 2 then -- Going from CenterAlign
                if newAn % 3 == 0 then -- To RightAlign
                    lineleft = lineleft - linewidth / 2
                    lineright = lineright - linewidth / 2
                elseif newAn % 3 == 1 then -- To LeftAlign
                    lineleft = lineleft + linewidth / 2
                    lineright = lineright + linewidth / 2
                end
            else -- Going from RightAlign
                if newAn % 3 == 2 then -- To CenterAlign
                    lineleft = lineleft + linewidth / 2
                    lineright = lineright + linewidth / 2
                elseif newAn % 3 == 1 then -- To LeftAlign
                    lineleft = lineleft + linewidth
                    lineright = lineright + linewidth
                end
            end
        end
    end
    
    -- new in 2.0: preserve everything
    local pos_tag = 0, string.format("\\pos(%d,%d)", line.x, line.y)
    local dx, dy, dy1, dy2, animtimes = 0, 0, 0, 0, ""
    local pos_s, _, pos_x, pos_y = string.find(line.text, "{[^}]*\\pos%(([^,%)]*),([^,%)]*)%).*}")
    local coordparse = function(h) local i = string.headtail(string.trim(tostring(h))); i = tonumber(i); if not i then i = 0 end; return i end
    if pos_s and (not mov_s or pos_s < mov_s) and (not movt_s or pos_s < movt_s) then
        pos_x, pos_y = coordparse(pos_x), coordparse(pos_y)
        dx, dy = pos_x - line.x, pos_y - line.y
    end

    local generate_line_clip = function(x1, y1, x2, y2, color, text)
        return string.format("%s\\clip(%d,%d,%d,%d)%s}%s", baseLine, x1+dx, y1+dy, x2+dx, y2+dy, color, text)
    end

    if mode == 1 then
        local left, right = 0, config.stripx
        local count = 0
        local nlinewidth = linewidth-config.stripx
        repeat
            nline = table.copy(line)
            nlinetext = generate_line_clip(left + lineleft,
                                           linetop,
                                           right + lineleft,
                                           linebottom,
                                           corporation.color_interpolator(left, nlinewidth, colors),
                                           linetext)
            nline.text = nlinetext
            count = count + 1
            nline.effect = string.format("gradient @%x %00d", randomtag, count)
            table.insert(results, nline)
            left = right
            right = right + config.stripx
        until left + lineleft >= lineright or aegisub.progress.is_cancelled()
    elseif mode == 2 then
        local top, bottom = 0, config.stripx
        local count = 0
        local nlineheight = lineheight-config.stripx
        repeat
            nline = table.copy(line)
            nlinetext = generate_line_clip(lineleft,
                                           linetop + top,
                                           lineright,
                                           linetop + bottom,
                                           corporation.color_interpolator(top, nlineheight, colors),
                                           linetext)
            nline.text = nlinetext
            count = count + 1
            nline.effect = string.format("gradient @%x %00d", randomtag, count)
            table.insert(results, nline)
            top = bottom
            bottom = bottom + config.stripx
        until linetop + top >= linebottom or aegisub.progress.is_cancelled()
    -- Following modes are broken as for now
    elseif mode == 3 then
        if #line.kara > 0 and config.karamode ~= "Strip karaoke" then
            for s, syl in ipairs(line.kara) do
                local left, right, syltext = syl.left,0,""
                for char in unicode.chars(syl.text_stripped) do
                    width, height, descent, ext_lead = aegisub.text_extents(line.styleref, char)
                    right = left + width
                    local colortags = corporation.color_interpolator(corporation.calc_j(left, right, line.width), line.width, colors)
                    if colortags ~= "" then colortags = "{" .. colortags .. "}" end
                    syltext = syltext .. colortags .. char
                    left = right
                end
                linetext = linetext .. config.karatagfn(syl) .. syltext
            end
        else
            local left, right = 0,0
            for char in unicode.chars(line.text_stripped) do
                local width, height, descent, ext_lead = aegisub.text_extents(line.styleref, char)
                right = left + width
                local colortags = corporation.color_interpolator(corporation.calc_j(left, right, line.width), line.width, colors)
                if colortags ~= "" then colortags = "{" .. colortags .. "}" end
                linetext = linetext .. colortags .. char
                left = right
            end
        end
        -- Todo: Fix and update with new 'preserve everything' method
        if pos_mode > 0 then linetext = string.format("{%s}%s", pos_tag, linetext) end
    elseif mode == 4 then
        for s, syl in ipairs(line.kara) do
            local colortags = corporation.color_interpolator(corporation.calc_j(syl.left, syl.right, line.width), line.width, colors)
            if colortags ~= "" then colortags = "{" .. colortags .. "}" end
            local syltext = config.karatagfn(syl) .. colortags .. syl.text_stripped
            linetext = linetext .. syltext
        end
        -- Todo: Fix and update with new 'preserve everything' method
        if pos_mode > 0 then linetext = string.format("{%s}%s", pos_tag, linetext) end
    end
    
    if mode > 2 then
        nline = table.copy(line)
        nline.text = linetext
        results = { [1] = nline }
    end
    
    return results
end

function corporation.calc_j(left, right, width)
    if left + right < width then 
        return left + ((right - left) * left / width)
    else
        return left + ((right - left) * right / width)
    end
end

function corporation.color_interpolator(j, maxj, colors)
    local colors_out = ""
    for c = 1,4 do
        local dcolors = colors[corporation.colorkeys[c]]
        local cc = #dcolors
        if cc > 1 then
            local nmaxj = maxj/(cc-1)
            local k = clamp(math.floor(j/nmaxj), 0, cc-2)
            local nj = j - (k*nmaxj)
            colors_out = colors_out .. string.format("\\%dc%s",c,interpolate_color(nj/nmaxj, dcolors[k+1], dcolors[k+2]))
        end
    end
    return colors_out
end

function corporation.prepareconfig(styles, subtitles, selected)
    local applyto = 4
    corporation.conf[applyto].items = {}
    oldapplytovalue = corporation.conf[applyto].value
    if #selected > 0 then 
        applytoselected = string.format("Selected lines (%d)", #selected)
        table.insert(corporation.conf[applyto].items, applytoselected)
        corporation.conf[applyto].value = applytoselected
    end
    table.insert(corporation.conf[applyto].items, "All lines") 
    if oldapplytovalue == "All lines" then corporation.conf[applyto].value = "All lines" end
    for i, style in ipairs(styles) do
        itemname = string.format("Style = %s", style.name)
        table.insert(corporation.conf[applyto].items, itemname)
        if oldapplytovalue == itemname then corporation.conf[applyto].value = itemname end
    end
    local actors = {}
    for i = 1, #subtitles do 
        if subtitles[i].class == "dialogue" and not subtitles[i].comment and subtitles[i].actor ~= "" then
            if not actors[subtitles[i].actor] then
                actors[subtitles[i].actor] = true
                itemname = string.format("Actor = %s", subtitles[i].actor)
                table.insert(corporation.conf[applyto].items, itemname)
                   if oldapplytovalue == itemname then corporation.conf[applyto].value = itemname end
            end
        end
    end
    for i = 1, 4 do
        local j = 11 + i * 2
        local found, item = (corporation.conf[j].value == "Ignore"), ""
        corporation.conf[j].items = { [1] = "Ignore" }
        for k = 2, corporation.color_comp_count do
            item = string.format("%d colors", k)
            corporation.conf[j].items[k] = item
            if corporation.conf[j].value == item then found = true end
        end
        if not found then corporation.conf[j].value = item end
    end
end

function corporation.macro_process(subtitles, selected_lines, active_line)
    local meta, styles = karaskel.collect_head(subtitles)

    -- configuration
    if meta["gradientcorporation"] ~= nil then
       corporation.unserialize_config(meta["gradientcorporation"])
    end
    
    -- filter selected_lines
    local subs = {}
    for _, i in ipairs(selected_lines) do
        if not subtitles[i].comment and not corporation.has_gradient(subtitles[i]) then 
           table.insert(subs,i)
       end 
    end
    selected_lines = subs
    
    -- display dialog
    local cfg_res, config
    repeat
        corporation.prepareconfig(styles, subtitles, selected_lines)
        local dlgbuttons = {"Generate","+colors","-colors","Cancel"}
        if corporation.color_comp_count <= 2 then dlgbuttons = {"Generate","+colors","Cancel"} end
        cfg_res, config = aegisub.dialog.display(corporation.conf, dlgbuttons)
        if cfg_res == "+colors" then
           corporation.save_config(config)
           corporation.append_color_components()
        elseif cfg_res == "-colors" then
           corporation.save_config(config)
           corporation.unappend_color_components()
        end
    until cfg_res ~= "+colors" and cfg_res ~= "-colors"
        
    if cfg_res == "Generate" then
        result = corporation.process(meta, styles, config, subtitles, selected_lines, active_line)
        if result then
            aegisub.set_undo_point("Generate color gradient")
            aegisub.progress.task("Done")
        else
            aegisub.progress.task("Failed");
        end
    else
        aegisub.progress.task("Cancelled");    
    end
end

function corporation.macro_undo(subtitles, selected_lines, active_line)
    local tag = string.match(subtitles[selected_lines[1]].effect, "@%x+")
    local pattern = "^gradient " .. tag .. " (%d+)$" 
    local subtitles2 = {}
    
    for i = 1, #subtitles do
        local nline = table.copy(subtitles[i])
        if subtitles[i].class == "dialogue" then
            local c = string.match(subtitles[i].effect, pattern)
            if c == "0" then 
                nline.comment = false
                nline.effect = ""
                table.insert(subtitles2, nline)
            elseif c == nil then
                table.insert(subtitles2, nline)
            end
        else
            table.insert(subtitles2, nline)
        end
    end
    
    subtitles.deleterange(1, #subtitles)
    subtitles.delete(1)
    for j = 1, #subtitles2 do
        subtitles[0] = subtitles2[j]
    end
    
    aegisub.set_undo_point("Un-gradient")
end

function corporation.validate_undo(subtitles, selected_lines, active_line)
    if not (#selected_lines > 0) then return false end
    return corporation.has_gradient(subtitles[selected_lines[1]])
end

function corporation.has_gradient(line)
    return (nil ~= string.match(line.effect, "^gradient @%x+ %d+$"))
end


-- register macros
aegisub.register_macro("Doki Gradient", "Generate color gradient", corporation.macro_process)
-- Removing for now
-- aegisub.register_macro("Un-gradient", "Un-gradient", corporation.macro_undo, corporation.validate_undo)