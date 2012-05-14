use <../pin_connectors/pins.scad>


lazy_susan_height = 10;
// distance is horizontal distance between 2 holes
lazy_susan_bottom_hole_distance = 122;
lazy_susan_top_hole_distance = 142;

motor_width = 43;
motor_height = 33;
motor_shaft_height = 25;
motor_shaft_diameter = 5;
motor_shaft_radius = motor_shaft_diameter/2;

table_diameter = 8.5 * 25.4;
table_radius = table_diameter/2;
table_thickness = 0.25 * 25.4;

table_connector_height = lazy_susan_height + table_thickness;
table_connector_tab_diameter = 4;
table_connector_tab_radius = table_connector_tab_diameter/2;
table_connector_tab_distance = 20;
table_connector_diameter = table_connector_tab_distance + (table_connector_tab_diameter*2);
table_connector_radius = table_connector_diameter/2;

hub_height = 5+motor_height+(motor_shaft_height-lazy_susan_height-table_thickness);
hub_width = lazy_susan_bottom_hole_distance/2;

echo(str("Total Table Height: ", hub_height+lazy_susan_height+table_thickness));

part = "assembly";
// part = "hub";
// part = "hub_leg";
// part = "pinpeg";
// part = "table_connector";
// part = "table_top";
print_part(part);

module assembly() {
  %translate([0, 0, hub_height+lazy_susan_height]) table_top();
  rotate([0, 0, 45]) translate([0, 0, hub_height]) lazy_susan();
  translate([0, 0, 5]) motor();
  hub();
  for (i=[0:3]) {
    rotate([0, 0, i*90]) hub_leg();
  }
  rotate([0, 0, 45]) translate([0, 0, hub_height+lazy_susan_height+table_thickness-table_connector_height]) table_connector();
}

module print_part(name) {
  if (name == "assembly") {
    assembly();
  } else if (name == "hub") {
    // 1 copy
    // 4 x M3 16mm bolts
    translate([0, 0, hub_height]) rotate([180, 0, 0]) hub();
  } else if (name == "hub_leg") {
    // 4 copies
    // 4 x M4 10mm bolts
    // 4 x M4 nuts
    translate([0, -hub_width, hub_height]) rotate([180, 0, 0]) hub_leg();
  } else if (name == "pinpeg") {
    // 4 copies
    pinpeg();
  } else if (name == "table_connector") {
    // 1 copy
    // 1 x M3 grub screw or small bolt
    // 1 x M3 nut
    table_connector();
  } else if (name == "table_top") {
    // laser cut or hand drill
    projection(cut = true) table_top();
  }
}

module hub() {
  difference() {
    union() {
      difference() {
        // main body
        rotate([0, 0, 0]) translate([0, 0, hub_height/2]) cube(size=[hub_width, hub_width, hub_height], center=true);
        // rotate([0, 0, 22.5]) cylinder(r=hub_width/2, h=hub_height, center=false, $fn=8);
        
        // side openings
        // translate([0, 0, 0]) rotate([90, 0, 0]) cylinder(r=hub_height/2, h=motor_width*2, center=true);
        // translate([0, 0, 0]) rotate([0, 90, 0]) cylinder(r=hub_height/2, h=motor_width*2, center=true);
        
        // side curves
        for (i=[0:3]) {
          rotate([0, 0, i*90+45]) translate([0, -hub_width+3, -1]) cylinder(r=hub_width/1.8, h=hub_height+2, center=false);
          // rotate([0, 0, i*90]) translate([-hub_width/2, -hub_width/2, hub_height/2]) rotate([0, 0, 45]) cube(size=[10, 10, hub_height+2], center=true);
        }
      }

      // for (i=[0:3]) {
      //   rotate([0, 0, i*90]) translate([-hub_width/2+2.5, -hub_width/2+2.5, hub_height/2]) rotate([0, 0, 45]) cube(size=[5, 12.5, hub_height], center=true);
      // }
      
      //rotate([0, 0, 45]) translate([0, -72, hub_height/2]) cube(size=[10, 65, hub_height], center=true);
    }
    // motor space
    translate([0, 0, ((5+motor_height+1)/2)-1]) cube(size=[motor_width+1, motor_width+1, 5+motor_height+1], center=true);
    
    // shaft opening
    cylinder(r=table_connector_radius+2, h=hub_height+1, center=false);
    
    // motor holes
    for (i=[0:3]) {
      rotate([0, 0, i*90]) translate([15.5, 15.5, 0]) cylinder(h=hub_height+2, r=1.5+0.1);
    }

    // leg connector holes
    for (i=[0:3]) {
      rotate([0, 0, i*90]) translate([-hub_width/2, 0, hub_height-6]) rotate([0, 90, 0]) pinhole();
    }
    
    // wire space
    translate([0, 0, 15/2-1]) cube(size=[motor_width+6, motor_width+6, 15+1], center=true);
  }
}

module hub_leg() {
  translate([0, -hub_width, 0])
  difference() {
    translate([0, 0, hub_height/2]) cube(size=[15, hub_width, hub_height], center=true);
    translate([0, hub_width/4, 0]) rotate([0, 90, 0]) cylinder(r=hub_width/2, h=20, center=true);
    translate([0, hub_width/2, hub_height-6]) rotate([90, 0, 0]) pinhole();
    translate([0, -hub_width/2+5, hub_height-10]) cylinder(r=3/2+0.1, h=11, center=false);
  }
}

module table_connector() {
  difference() {
    union() {
      cylinder(r=table_connector_radius, h=table_connector_height-table_thickness, center=false);
      
      // tabs
      for (i=[0:3]) {
        rotate([0, 0, i*90]) translate([0, -table_connector_tab_distance/2, table_connector_height-table_thickness]) cylinder(r=table_connector_tab_radius, h=table_thickness, center=false);
      }
    }
    
    translate([0, 0, -1]) cylinder(r=motor_shaft_radius+0.2, h=table_connector_height+2, center=false);
    
    translate([0, -4.5, 4.5-0.1]) cube([5.5, 2.3, 9], center=true);
    translate([0, 0, 7/2]) rotate([0, 90, -90]) cylinder(r=1.7, h=table_connector_radius);
  }
}

module table_top() {
  difference() {
    cylinder(r=table_radius, h=table_thickness, center=false);

    translate([0, 0, -1]) cylinder(r=motor_shaft_radius, h=table_thickness+2, center=false);

    for (i=[0:3]) {
      rotate([0, 0, i*90+45]) translate([0, -table_connector_tab_distance/2, -1]) cylinder(r=table_connector_tab_radius, h=table_thickness+2, center=false);
    }

    for (i=[0:3]) {
      rotate([0, 0, i*90]) translate([-lazy_susan_top_hole_distance/2, -lazy_susan_top_hole_distance/2, -1]) cylinder(r=4/2, h=table_thickness+2, center=false);
    }
  }
}

module lazy_susan() {
  difference() {
    union() {
      // bottom
      translate([0, 0, 0.5]) {
        difference() {
          cube(size=[152, 152, 1], center=true);
          // bottom holes - 122mm apart
          for (i=[0:3]) {
            rotate([0, 0, i*90]) translate([-lazy_susan_bottom_hole_distance/2, -lazy_susan_bottom_hole_distance/2, -1]) cylinder(r=6/2, h=2, center=false);
          }
        }
      }

      // top
      rotate([0, 0, 45]) translate([0, 0, -0.5+lazy_susan_height]) {
        difference() {
          cube(size=[152, 152, 1], center=true);
          // top holes - 142mm apart
          for (i=[0:3]) {
            rotate([0, 0, i*90]) translate([-lazy_susan_top_hole_distance/2, -lazy_susan_top_hole_distance/2, -1]) cylinder(r=6/2, h=2, center=false);
          }
        }
      }
      
      // bearings
      cylinder(r=125/2, h=lazy_susan_height, center=false);
    }
    // center hole
    translate([0, 0, -1]) cylinder(r=117/2, h=lazy_susan_height+2, center=false);
  }
}

module motor() {
  union() {
    difference() {
      translate([-motor_width/2, -motor_width/2, 0]) cube([motor_width, motor_width, motor_height]);
      for (i=[0:3]) {
        rotate([0, 0, i*90]) translate([15.5, 15.5, motor_height-5]) cylinder(h=6, r=1.5);
      }
    }
    cylinder(h=motor_height+motor_shaft_height, r=motor_shaft_radius);
    translate([0, 0, motor_height]) cylinder(h=2, r=22/2);
  }
}
