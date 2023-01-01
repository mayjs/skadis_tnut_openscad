use <dimensions.scad>;
$fn = 100;

alignment_area_width = skadis_alignment_area_size().x;
alignment_area_total_height = skadis_alignment_area_size().y;

module skadis_tnut_alignment_guide_horizontal_single(extrusion_height=.8, overhang=50) {
    // The horizontal intersection point of the triangular parts base and the t nut keepout area circumference
    // measured from the center of the keep out area
    triang_intersection_location = sqrt(pow(skadis_tnut_keep_out_dia() / 2, 2) - pow(alignment_area_width / 2, 2));
    triang_intersection_rel_to_aligment_circle = alignment_area_total_height / 2 - alignment_area_width / 2 - triang_intersection_location;
    
    // The basic 2D footprint for the alignment guide
    module base_part(inset=0) {
	circle_rad=alignment_area_width/2 - inset;

	// The half-circle	
	translate([0, circle_rad])
	difference() {
	    circle(r=circle_rad);
	    translate([0,-alignment_area_width/2])
	    square([alignment_area_width, alignment_area_width]);
	}

	// The triangle connecting the half-circle to the keepout area
	polygon([
	    [0,0],
	    [triang_intersection_rel_to_aligment_circle - inset, 0],
	    [0, circle_rad*2],
	]);
    }

    // The 3D alignment guide
    module extruded() {
	// Calculate the inset in mm from the configured overhang angle
	inset = sin(90 - overhang) / sin(overhang) * extrusion_height;
	hull() {
	    // We create a convex hull of two very thin extrusions of the base shape to build the complete guide
	    flat_extrusion = .001;

	    linear_extrude(flat_extrusion)
	    base_part();

	    translate([inset/2,inset,extrusion_height-flat_extrusion])
	    linear_extrude(flat_extrusion)
	    base_part(inset);
	}
    }

    translate([0,-alignment_area_width / 2])
    extruded();
}

module skadis_tnut_alignment_guide_vertical_single(extrusion_height=.8, overhang=50) {
    circle_rad=alignment_area_width/2;
    // Calculate the inset in mm from the configured overhang angle
    inset = sin(90 - overhang) / sin(overhang) * extrusion_height;

    module base_part() {
	// Half circle
	translate([0, circle_rad])
	difference() {
	    circle(r=circle_rad);
	    translate([0,-alignment_area_width/2])
	    square([alignment_area_width, alignment_area_width]);
	}

	square([skadis_alignment_area_size().y / 2 - circle_rad - skadis_tnut_keep_out_dia() / 2, skadis_alignment_area_size().x]);
    }

    translate([0,-skadis_alignment_area_size().x / 2, 0]) {
	// We create a convex hull of two very thin extrusions of the base shape to build the complete guide
	flat_extrusion = .001;
	
	hull() {
	    linear_extrude(flat_extrusion)
	    base_part();

	    translate([0,0,extrusion_height-flat_extrusion])
	    linear_extrude(flat_extrusion)
	    offset(delta=-inset)
	    base_part();
	}
    }
}

module skadis_tnut_alignment_guide_horizontal(extrusion_height=.8, overhang=50) {
    rotate([90,0,0]) {
	translate([-alignment_area_total_height / 2 + alignment_area_width/2, 0])
	skadis_tnut_alignment_guide_horizontal_single();
	
	mirror([1,0,0])
	translate([-alignment_area_total_height / 2 + alignment_area_width/2, 0])
	skadis_tnut_alignment_guide_horizontal_single();
    }
}

module skadis_tnut_alignment_guide_vertical(extrusion_height=.8, overhang=50) {
    rotate([90,0,0])
    translate([0, -skadis_alignment_area_size().y/2 + skadis_alignment_area_size().x/2]) {
	translate([0, skadis_alignment_area_size().y - skadis_alignment_area_size().x])
	rotate([0,0,-90]) 
	skadis_tnut_alignment_guide_vertical_single();
	
	rotate([0,0,90])
	skadis_tnut_alignment_guide_horizontal_single();
    }
}

