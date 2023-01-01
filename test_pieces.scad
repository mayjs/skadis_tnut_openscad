use <alignment_guide.scad>;
use <dimensions.scad>;

$fn = 100;

module simple_console(base_size = [85, 50], wall_thickness=3, fence_height=5) {
    full_base_size = fence_height == 0 ? [base_size.x, base_size.y + wall_thickness] : [base_size.x + 2 * wall_thickness, base_size.y + 2 * wall_thickness];

    translate([0,0,-wall_thickness])
    linear_extrude(wall_thickness)
    square(full_base_size);

    if(fence_height != 0) {
	linear_extrude(fence_height)
	difference() {
	    square([full_base_size.x, full_base_size.y]);
	    translate([wall_thickness, wall_thickness])
	    square([full_base_size.x - 2*wall_thickness, full_base_size.y - 2*wall_thickness]);
	}
    }

    translate([0,0,fence_height]) {
	covered_holes = floor((full_base_size.x - skadis_alignment_area_size().x) / skadis_horizontal_hole_spacing());
	mount_distance = covered_holes * skadis_horizontal_hole_spacing();
	covered_width = mount_distance + skadis_alignment_area_size().x;
	x_positions = [0, mount_distance];
	x_offset = (full_base_size.x - covered_width) / 2 + skadis_alignment_area_size().x/2;
	mount_positions = [for (x=x_positions) [x_offset + x,0,skadis_alignment_area_size().y/2]];

	// The main mounting plate
	difference() {
	    linear_extrude(skadis_alignment_area_size().y)
	    square([full_base_size.x, wall_thickness]);

	    for(p=mount_positions) {
		translate(p)
		translate([0,wall_thickness+.1,0])
		rotate([90,0,0])
		cylinder(r=skadis_tnut_mounting_hole_dia("m2.5") / 2, h=wall_thickness + .2);
	    }
	}

	for(p=mount_positions) {
	    translate(p)
	    skadis_tnut_alignment_guide_vertical();
	}
    }
}

module simple_square_hook(width=10, depth=20, insert_height=10, wall_thickness=2) {
    mounting_hole_dia = skadis_tnut_mounting_hole_dia("m2.5");

    screw_clearance = skadis_alignment_area_size().y / 2 - mounting_hole_dia / 2;

    add_height = max(insert_height + wall_thickness - screw_clearance, 0);
    echo(add_height);

    additional_height = insert_height < skadis_alignment_area_size().y / 2 - mounting_hole_dia ? skadis_alignment_area_size().y : skadis_alignment_area_size().y + insert_height;

    hook_height = skadis_step_from_hole([0,0], "u").y + skadis_alignment_area_size().y + add_height;

    first_mount_position = [skadis_alignment_area_size().y / 2, 0, width/2];
    second_mount_position = [skadis_step_from_hole([0, first_mount_position.x], "u").y, 0, width/2];

    mount_positions = [first_mount_position, second_mount_position];
    
    difference() {
	translate([hook_height,0,0])
	rotate([0,0,90])
	linear_extrude(width) {
	    difference() {
		square([depth + 2*wall_thickness, insert_height + wall_thickness]);
		translate([wall_thickness, wall_thickness])
		square([depth, insert_height]);
	    }

	    square([wall_thickness, hook_height]);
	}

	union() {
	    for(location=mount_positions) {
		translate(location)
		translate([0,-.1,0])
		rotate([-90,0,0])
		cylinder(r=mounting_hole_dia / 2, h=width+.2); 
	    }
	}
    }

    for(location=mount_positions) {
	translate(location) 
	skadis_tnut_alignment_guide_horizontal();
    }
}

simple_console();
//simple_square_hook();
