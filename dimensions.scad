function skadis_tnut_clearance() = .3;
function skadis_tnut_mounting_hole_dia(kind) = kind == "m2" ? 2.3 : 2.8;
function skadis_tnut_keep_out_dia() = 7;

function skadis_horizontal_hole_spacing() = 40;
function skadis_next_row_hole_horizontal_offset() = 20;
function skadis_row_vertical_spacing() = 20;

function skadis_alignment_area_size() = [5, 15];

function skadis_step_from_hole(coords, step) = 
    step == "r" ? [coords.x + skadis_horizontal_hole_spacing(), coords.y] :
    step == "l" ? [coords.x - skadis_horizontal_hole_spacing(), coords.y] :
    step == "d" ? [coords.x, coords.y - skadis_row_vertical_spacing() * 2] :
    step == "u" ? [coords.x, coords.y + skadis_row_vertical_spacing() * 2] :
    step == "ur" ? [coords.x + skadis_next_row_hole_horizontal_offset(), coords.y + skadis_row_vertical_spacing()] :
    step == "ul" ? [coords.x - skadis_next_row_hole_horizontal_offset(), coords.y + skadis_row_vertical_spacing()] :
    step == "dr" ? [coords.x + skadis_next_row_hole_horizontal_offset(), coords.y - skadis_row_vertical_spacing()] :
    step == "dl" ? [coords.x - skadis_next_row_hole_horizontal_offset(), coords.y - skadis_row_vertical_spacing()] : undef;

