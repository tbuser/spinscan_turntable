use <../pin_connectors/pins.scad>

// should probably be at least 5
felt_thickness = 5.5;

motor_width = 43;
motor_height = 33;
motor_shaft_height = 25;
motor_shaft_diameter = 5;
motor_shaft_radius = motor_shaft_diameter/2;

table_diameter = 8 * 25.4;
table_radius = table_diameter/2;
table_thickness = 0.25 * 25.4;

table_connector_height = felt_thickness + table_thickness;
table_connector_tab_diameter = 6;
table_connector_tab_radius = table_connector_tab_diameter/2;
table_connector_tab_distance = 20;
table_connector_diameter = table_connector_tab_distance + (table_connector_tab_diameter*2);
table_connector_radius = table_connector_diameter/2;

hub_height = 5+motor_height+(motor_shaft_height-felt_thickness-table_thickness);
hub_width = 60;

hub_leg_length = table_radius-(hub_width/2);

laser_diameter = 12;
laser_radius = laser_diameter/2;

total_height = hub_height+felt_thickness+table_thickness;

echo(str("Total Table Height: ", total_height));

// part = "assembly";
// part = "hub";
// part = "hub_leg";
// part = "pinpeg";
// part = "table_connector";
// part = "table_top";
part = "laser_clamp";
print_part(part);

module assembly() {
  %translate([0, 0, hub_height+felt_thickness]) table_top();
  translate([0, 0, 5]) motor();
  hub();
  for (i=[0:3]) {
    rotate([0, 0, i*90]) translate([0, -hub_leg_length/2-hub_width/2, 0]) hub_leg();
  }
  translate([0, 0, hub_height+felt_thickness+table_thickness-table_connector_height]) table_connector();
  
  // blocking out webcam/laser mount
  
  color([255, 0, 0]) {
    // laser line at 30 degrees
    rotate([0, 0, -30]) translate([0, -(24*25.4)/2, 0.5+(total_height)]) cube(size=[1, (24*25.4), 1], center=true);
    rotate([0, 0, 30]) translate([0, -(24*25.4)/2, 0.5+(total_height)]) cube(size=[1, (24*25.4), 1], center=true);

    // laser line at 15 degrees
    rotate([0, 0, -15]) translate([0, -(24*25.4)/2, 0.5+(total_height)]) cube(size=[1, (24*25.4), 1], center=true);
    rotate([0, 0, 15]) translate([0, -(24*25.4)/2, 0.5+(total_height)]) cube(size=[1, (24*25.4), 1], center=true);
  }
  
  // cam 1 foot away from table
  translate([0, -(12*25.4), 20+(total_height)]) cube(size=[90, 40, 40], center=true);

  // adjustable laser arms
  translate([-90, -(12*25.4), 20+(total_height)]) cube(size=[90, 40, 20], center=true);
  translate([-180, -(12*25.4), 20+(total_height)]) cube(size=[90, 40, 20], center=true);

  translate([90, -(12*25.4), 20+(total_height)]) cube(size=[90, 40, 20], center=true);
  translate([180, -(12*25.4), 20+(total_height)]) cube(size=[90, 40, 20], center=true);
  
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
    // 8 felt tabs
    translate([0, 0, hub_height]) rotate([180, 0, 0]) hub_leg();
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
  } else if (name == "laser_clamp") {
    laser_clamp();
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
          rotate([0, 0, i*90+45]) translate([0, -hub_width/2-10, -1]) cylinder(r=hub_width/4, h=hub_height+2, center=false);
          // rotate([0, 0, i*90]) translate([-hub_width/2, -hub_width/2, hub_height/2]) rotate([0, 0, 45]) cube(size=[10, 10, hub_height+2], center=true);
        }
      }

      // for (i=[0:3]) {
      //   rotate([0, 0, i*90]) translate([-hub_width/2+2.5, -hub_width/2+2.5, hub_height/2]) rotate([0, 0, 45]) cube(size=[5, 12.5, hub_height], center=true);
      // }
      
      //rotate([0, 0, 45]) translate([0, -72, hub_height/2]) cube(size=[10, 65, hub_height], center=true);
    }
    // motor space
    translate([0, 0, (motor_height+5)/2]) cube(size=[motor_width+0.5, motor_width+0.5, motor_height+5], center=true);
    
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
  difference() {
    union() {
      translate([0, 0, hub_height/2]) cube(size=[11, hub_leg_length, hub_height], center=true);

      // felt tabs
      translate([0, -hub_leg_length/2+10, -5/2+hub_height]) cylinder(r=10, h=5, center=true);
      translate([0, hub_leg_length/2-10, -5/2+hub_height]) cylinder(r=10, h=5, center=true);
    }

    // center cutout
    translate([0, 0, hub_height-((hub_leg_length-22)/2)-11]) rotate([0, 90, 0]) cylinder(r=(hub_leg_length-11)/2, h=20, center=true);
    translate([0, 0, (hub_height/4)-0.5]) cube(size=[17, (hub_leg_length-22), (hub_height/2)+1], center=true);
    
    // hub side hole
    translate([0, hub_leg_length/2, hub_height-6]) rotate([90, 0, 0]) pinhole();
    
    // outside holes for possible future expansion use
    translate([0, -hub_leg_length/2, hub_height-6]) rotate([-90, 0, 0]) pinhole();
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
    
    // shaft hole
    translate([0, 0, -1]) cylinder(r=motor_shaft_radius+0.2, h=table_connector_height+2, center=false);
    
    // trapped nut
    rotate([0, 0, 45]) translate([0, -motor_shaft_radius-2, (table_connector_height-table_thickness)/2]) cube([5.5, 2.3, table_connector_height-table_thickness+2], center=true);
    translate([0, 0, (table_connector_height-table_thickness)/2]) rotate([0, 90, -45]) cylinder(r=1.7, h=table_connector_radius+1);
    rotate([0, 0, 45]) translate([0, -table_connector_radius+table_connector_radius/4-motor_shaft_radius, (table_connector_height-table_thickness)/2]) cube(size=[6, table_connector_radius/2, table_connector_height-table_thickness+2], center=true);
  }
}

module table_top() {
  difference() {
    cylinder(r=table_radius, h=table_thickness, center=false);

    translate([0, 0, -1]) cylinder(r=motor_shaft_radius, h=table_thickness+2, center=false);

    for (i=[0:3]) {
      rotate([0, 0, i*90]) translate([0, -table_connector_tab_distance/2, -1]) cylinder(r=table_connector_tab_radius, h=table_thickness+2, center=false);
    }
  }
}

module laser_clamp() {
  translate([-((laser_radius+4)), 0, 0]) 
  difference() {
    union() {
      cylinder(r=laser_radius+4, h=15, center=false);
      translate([((laser_radius+4)+20)/2, 0, 15/2]) cube(size=[(laser_radius+4)+20, (laser_radius+4)*2, 15], center=true);
    }
    
    // side mounting gap
    translate([((laser_radius+4)+20)/2+0.5, 0, 15/2]) cube(size=[(laser_radius+4)+20+1, (laser_radius+1)*2-2, 15+2], center=true);

    // laser hole
    translate([0, 0, -1]) cylinder(r=laser_radius+0.5, h=15+2, center=false);
    
    // rod holes
    translate([laser_radius+6+10, 0, 15/2]) rotate([90, 0, 0]) cylinder(r=4+0.2, h=laser_radius+4+20, center=true);
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

