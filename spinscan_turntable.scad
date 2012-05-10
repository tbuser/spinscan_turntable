include <spinscan_turntable.inc>
use <MCAD/teardrop.scad>
use <MCAD/involute_gears.scad>

// forget rods, lets just use 2 x 1' square boards for most of the structure
assembly();

// laser_clamp();
// gear_large();
// gear_small();
// cam_mount();
// table();
// base_board();

module assembly() {
  %translate([0, 0, 50]) base_board();

  %translate([0, 0, 50+table_height]) lazy_susan();

  translate([0, 30.52+7.44, 5]) motor();

  translate([0, 0, -gear_height+50+table_height+lazy_susan_height]) gear_large();

  %translate([0, 0, 50+table_height+lazy_susan_height]) table();
  
  // angle markers
  rotate([0, 0, 15]) translate([0, 0, 50+table_height+lazy_susan_height]) rotate([90, 0, 0]) cylinder(r=1, h=table_diameter, center=false);
  rotate([0, 0, 30]) translate([0, 0, 50+table_height+lazy_susan_height]) rotate([90, 0, 0]) cylinder(r=1, h=table_diameter, center=false);
  rotate([0, 0, 45]) translate([0, 0, 50+table_height+lazy_susan_height]) rotate([90, 0, 0]) cylinder(r=1, h=table_diameter, center=false);
}

module gear_small() {  
  translate([0, 0, gear_height+7]) rotate([0, 180, 0]) {
    difference() {
      gear (circular_pitch=268,
        gear_thickness = gear_height,
        rim_thickness = gear_height,
        bore_diameter = 5,
        hub_thickness = gear_height+7,
        hub_diameter = 20,
        circles=0,
        number_of_teeth=10, $fn=20);
      translate([0,-4.5,gear_height+4.5])cube([5.5,2.3,9],center = true);
  		translate([0,0,gear_height+7/2])rotate([0,90,-90])cylinder(r=1.7,h=20);
    }
  }
}

module gear_large() {
  difference() {
    //cylinder(h=gear_height, r=gear_radius_large);
    gear(circular_pitch=268,
      gear_thickness = gear_height,
      rim_thickness = gear_height,
      hub_thickness = 0,
      bore_diameter=0,
      circles=0,      
      number_of_teeth=41);

    for (i=[0:3]) {
      rotate([0, 0, i*90]) translate([nut_radius*2, 0, -1]) cylinder(h=gear_height+2, r=3.3/2);
    }
  }
}

module motor() {
  union() {
    difference() {
      translate([-motor_width/2, -motor_width/2, 0]) cube([motor_width, motor_width, motor_height]);
      for (i=[0:3]) {
        rotate([0, 0, i*90]) translate([15, 15, motor_height-5]) cylinder(h=6, r=1.5);
      }
    }
    cylinder(h=motor_height+motor_shaft_height, r=motor_shaft_radius);
    translate([0, 0, motor_height]) cylinder(h=2, r=22/2);
    translate([0, 0, motor_height+motor_shaft_height-gear_height-7/2]) gear_small();
  }
}

module laser_clamp() {
  translate([-1.75, 0, laser_height/2]) {
  	difference() {
  		union() {
  			translate([-laser_width/4, 0, 0]) cube([laser_width/2, laser_length, laser_height], center=true);
  			translate([laser_width/4, 0, 0]) {
  				cylinder(h=laser_height, r=laser_length/2, center=true);
  			}
  			translate([laser_width/8, 0, 0]) {
  				cube([laser_width/4, laser_length, laser_height], center=true);
  			}
  		}

  		// laser hole
  		translate([rod_diameter-2, 0, 0]) {
  			cylinder(h=laser_height+2, r=laser_radius, center=true);
  		}

  		// bolt hole
  		translate([-rod_diameter/2, 0, 0]) {
  			rotate([90, -90, 0]) cylinder(h=laser_length+2, r=rod_radius, center=true);
  		}

  		// slit
  		translate([-laser_diameter/2, 0, 0]) {
  			cube([laser_width, laser_length/3, laser_height+2], center=true);
  		}
  	}
	}
}

module cam_mount() {
  translate([0, -2.97, cam_height/2]) rotate([180]) {
  	difference() {
  		union() {
  			difference() {
  				cube([cam_width, cam_length, cam_height], center=true);
  				translate([0, cam_length/4+1, -(cam_height-13)/2-1]) {
  					//box(cam_width+2, cam_length/2+1, cam_height-13+1, center=true);
  					cylinder(h=cam_height-13+1, r=(cam_width+cam_width/6)/2, center=true);
  				}
  			}

  			translate([-15, -cam_length/2+rod_diameter/2, 0]) {
  				cylinder(h=cam_height, r=rod_diameter+rod_diameter/4, center=true);
  			}
			
  			translate([15, -cam_length/2+rod_diameter/2, 0]) {
  				cylinder(h=cam_height, r=rod_diameter+rod_diameter/4, center=true);
  			}

  		}

  		// adjustable tripod mount hole for cameras whose lense is offset from the tripod screw hole
  		translate([0, 45-cam_length/2, 0]) {
  			// centered hole
  			//cylinder(cam_height+2, cam_bolt_diameter/2, cam_bolt_diameter/2, center=true);
  			// slot
  			cube([cam_width-6, cam_bolt_diameter, cam_height+2], center=true);
  		}

  		// top left hole
  		translate([-15, -cam_length/2+rod_diameter/2, 0]) {
  			translate([0, 0, -(cam_height+2)/2]) rod(cam_height+2);
  		}

  		// top right hole
  		translate([15, -cam_length/2+rod_diameter/2, 0]) {
  			translate([0, 0, -(cam_height+2)/2]) rod(cam_height+2);
  		}

  		// top center line
  		translate([0, 0, cam_height/2]) cube([1, cam_length-2, 2], center=true);

  		// top horizontal line
  		translate([0, -cam_length/2+rod_diameter/2, cam_height/2]) rotate([0, 0, 90]) cube([1, cam_width+rod_diameter, 2], center=true);
  	}
  }
}

module table() {
  difference() {
    cylinder(h=table_height, r=table_radius);
    
    for (i=[1:4]) {
      rotate([0, 0, i*90]) translate([nut_radius*2, 0, -1]) cylinder(h=table_height+2, r=3.3/2);
      rotate([0, 0, i*90]) translate([nut_radius*2, 0, table_height-5]) cylinder(h=table_height, r=5/2);
    }    
  }
}

module base_board() {
  // translate([0, -table_diameter/2, table_height/2]) cube(size = [table_diameter, table_diameter*2, table_height], center = true);
  // translate([0, 0, table_height/2]) cube(size = [8.5*25.4, 11*25.4, table_height], center = true);
  translate([0, -3*25.4, table_height/2]) cube(size = [12*25.4, 12*25.4, table_height], center = true);
}

module lazy_susan() {
  difference() {
    union() {
      // bottom
      translate([0, 0, 0.5]) {
        difference() {
          cube(size=[152, 152, 1], center=true);
          // bottom holes - 122mm apart
          translate([-152/2+15, -152/2+15, -1]) cylinder(r=3/2, h=2, center=false);
          translate([-152/2+15, 152/2-15, -1]) cylinder(r=3/2, h=2, center=false);
          translate([152/2-15, -152/2+15, -1]) cylinder(r=3/2, h=2, center=false);
          translate([152/2-15, 152/2-15, -1]) cylinder(r=3/2, h=2, center=false);
        }
      }

      // top
      rotate([0, 0, 45]) translate([0, 0, -0.5+lazy_susan_height]) {
        difference() {
          cube(size=[152, 152, 1], center=true);
          // top holes - 142mm apart
          translate([-152/2+5, -152/2+5, -1]) cylinder(r=6/2, h=2, center=false);
          translate([-152/2+5, 152/2-5, -1]) cylinder(r=6/2, h=2, center=false);
          translate([152/2-5, -152/2+5, -1]) cylinder(r=6/2, h=2, center=false);
          translate([152/2-5, 152/2-5, -1]) cylinder(r=6/2, h=2, center=false);
        }
      }
      
      // bearings
      cylinder(r=125/2, h=lazy_susan_height, center=false);
    }
    // center hole
    translate([0, 0, -1]) cylinder(r=117/2, h=lazy_susan_height+2, center=false);
  }
}

/* OLD CODE BELOW */

echo("Top Spoke Length (4): ", spoke_length_top);
echo("Bottom Spoke Length (4): ", spoke_length_bottom);
echo("Hub Diameter: ", hub_diameter);
echo("Hub Height: ", hub_height+hub_thickness);
echo("Gear Height: ", gear_height);

// layout();
// motor_layout();

// hub();
// hubcap("bearing");
// hubcap("holes");
// roller();
// laser_clamp();
// gear_large();
// gear_small();
// motor_mount();
// pcb_mount(); 

module hub() {
  difference() {
    // make it hollow
    rotate([0, 0, 45/2]) cylinder(h=hub_height+hub_thickness, r=hub_radius, $fn=8);
    // rotate([0, 0, 45/2]) linear_extrude(height=hub_height+hub_thickness) circle(hub_radius, $fn=8);
    rotate([0, 0, 45/2]) translate([0, 0, -1]) cylinder(h=hub_height+hub_thickness+2, r=hub_radius-hub_thickness, $fn=8);
    // rotate([0, 0, 45/2]) translate([0, 0, -1]) linear_extrude(height=hub_height+hub_thickness+2) circle(hub_radius-hub_thickness, $fn=8);
    
    // top holes
    for (i = [0:3]) {
      translate([0, 0, hub_height-hub_height/4]) rotate([0, 0, i*45]) teardrop(rod_radius, hub_diameter, 90);      
    }

    // bottom holes
    for (i = [0:3]) {
      translate([0, 0, hub_height/4]) rotate([0, 0, i*45]) teardrop(rod_radius, hub_diameter, 90);
    }
    
    // translate([0, 0, hub_height]) hubcap(); // this causes openscad error about too many elements in normalized tree...
    for (i = [0:3]) {
      rotate([0, 0, i*45]) translate([-hub_thickness/2, hub_radius, hub_height]) rotate([90, 0, 0]) cube([hub_thickness, hub_thickness+1, hub_diameter]);
    }    
  }
}

module hubcap(hubcap_type) {
  difference() {
    union () {
      rotate([0, 0, 45/2]) cylinder(h=hub_thickness, r=hub_radius-hub_thickness, $fn=8);

      intersection() {
        rotate([0, 0, 45/2]) cylinder(h=hub_thickness, r=hub_radius, $fn=8);
        for (i = [0:3]) {
          rotate([0, 0, i*45]) translate([-hub_thickness/2, hub_radius, 0]) rotate([90, 0, 0]) cube([hub_thickness, hub_thickness, hub_diameter]);
        }
      }
    }

    if (hubcap_type == "bearing") {
      translate([0, 0, -1]) cylinder(h=hub_thickness+2, r=bearing_radius);
    } else if (hubcap_type == "holes") {
      translate([0, 0, -1]) cylinder(h=hub_thickness+2, r=rod_radius);

      translate([-15, 0, -1]) cylinder(h=hub_thickness+2, r=rod_radius);
      translate([15, 0, -1]) cylinder(h=hub_thickness+2, r=rod_radius);
      translate([0, -15, -1]) cylinder(h=hub_thickness+2, r=rod_radius);
      translate([0, 15, -1]) cylinder(h=hub_thickness+2, r=rod_radius);
    } else if (hubcap_type == "stepper") {
      // TODO: maybe add mounting holes for nema17 stepper and shaft?
    }
  } 
}

module motor_mount() {
  translate([-hub_radius, hub_radius, hub_height]) rotate([0, 180, 0]) {
    difference() {
      union() {
        rotate([0, 0, 45/2]) cylinder(h=hub_height, r=hub_radius+hub_thickness/2, $fn=8);
        rotate([0, 0, 45]) translate([-45.4-8.1, 0, 0]) translate([-motor_width/2, -motor_width/2, motor_height]) cube([motor_width+hub_radius, motor_width, hub_height-motor_height]);
      }
    
      // inside cut
      rotate([0, 0, 45/2]) translate([0, 0, -1]) cylinder(h=hub_height+2, r=hub_radius, $fn=8);
    
      // cut in half
      translate([hub_diameter/4, hub_diameter/4, -1]) rotate([0, 0, 45]) translate([-hub_diameter/2-hub_thickness, -hub_diameter/2-hub_thickness/4, 0]) cube([hub_diameter+hub_thickness/2, hub_diameter+hub_thickness/2, hub_height+2]);
  
      // top holes
      for (i = [0:3]) {
        translate([0, 0, hub_height-hub_height/4]) rotate([180, 0, i*45]) teardrop(rod_radius, hub_diameter+hub_thickness/2-2, 90);
        rotate([0, 0, i*90]) translate([0, hub_radius+hub_thickness/2+nut_height/2+1, hub_height-hub_height/4]) rotate([90, 0, 0]) nut();
        rotate([0, 0, i*90]) translate([0, hub_radius+hub_thickness/2+nut_height/2+nut_height, hub_height-hub_height/4]) rotate([90, 0, 0]) nut();
      }
    
      // bottom holes
      for (i = [0:3]) {
        translate([0, 0, hub_height/4]) rotate([180, 0, i*45]) teardrop(rod_radius, hub_diameter+hub_thickness/2, 90);
      }
    
      // motor holes
      rotate([0, 0, 135]) {
        translate([0, motor_width+hub_radius/4+3, 0]) {
          // center shaft
          translate([0, 10, 0]) {
            translate([0, -13, 0]) cylinder(h=hub_height+1, r=11);
            translate([0, -1, hub_height/2]) cube([22,26,hub_height+1], center=true);
            translate([0, +13, 0]) cylinder(h=hub_height+1, r=11);
          }
          // mounting bolts
          translate([15-1.65, -15-5, 0]) cube([3.3, 39.5, hub_height+1]);
          translate([-15-1.65, -15-5, 0]) cube([3.3, 39.5, hub_height+1]);
        
          // #translate([15, -15, 0]) cylinder(h=hub_height+1, r=1.65);
          // #translate([15, 15, 0]) cylinder(h=hub_height+1, r=1.65);
          // #translate([-15, 15, 0]) cylinder(h=hub_height+1, r=1.65);
          // #translate([-15, -15, 0]) cylinder(h=hub_height+1, r=1.65);
        }
      }
    }
  }
}

module motor_layout() {
  hub();
  translate([0, 0, hub_height]) hubcap("bearing");
  %rotate([0, 0, 45]) translate([-45.4-8.1, 0, 0]) rotate([0, 0, 0]) motor();
  translate([-hub_radius, -hub_radius, hub_height]) rotate([0, 180, 0]) motor_mount();
}

module layout() {
  hub();
  translate([0, 0, hub_height]) hubcap("bearing");
  translate([0, 0, hub_height+hub_thickness+gear_height+1]) rotate([180, 0, 45]) gear_large();
  %translate([0, 0, hub_height+hub_thickness+gear_height+1]) table();

  translate([-table_radius, 0, 0]) hub();
  translate([table_radius, 0, 0]) hub();
  translate([0, -table_radius, 0]) hub();
  translate([0, table_radius, 0]) hub();

  // top spokes
  for (i=[0:3]) {
    translate([0, 0, hub_height-hub_height/4]) rotate([0, 0, i*90]) translate([-hub_radius+hub_thickness*2, 0, 0]) rotate([0, -90, 0]) rod(spoke_length_top);
  }
  
  // bottom spokes
  for (i=[0:3]) {
    rotate([0, 0, i*90]) translate([0, -table_radius, hub_height/4]) rotate([0, 0, -45]) translate([-hub_radius+hub_diameter/8+hub_thickness*2, 0, 0]) rotate([0, -90, 0]) rod(spoke_length_bottom);
  }
  
  // move -large gear pitch radius-small gear pitch radius
  rotate([0, 0, 45]) translate([-45.4-8.1, 0, 0]) rotate([0, 0, 0]) motor();
  
  translate([0, -table_radius, hub_height]) rotate([0, 0, 45]) hubcap("holes");
  translate([-15/1.4, -table_radius-15/1.4, hub_height-hub_thickness*2]) rod(table_radius);  
  translate([-5, -table_radius, table_radius]) rotate([90, 0, 0]) laser_clamp();
  
  for (i=[0:3]) {
    rotate([0, 0, i*90]) translate([0, -table_radius+hub_radius+nut_height*2, hub_height-hub_height/4]) rotate([90, 0, 0]) roller();
  }
  
  translate([-table_radius/2+20-rod_radius-2, -table_radius/2-20, (pcb_width+4)/2]) rotate([0, -90, -45]) pcb_mount();
  
  translate([-hub_radius, -hub_radius, hub_height]) rotate([0, 180, 0]) motor_mount();
  
  rotate([0, 0, 45*3]) translate([-table_radius-hub_diameter*2, 0, 0]) {
    hub();
    translate([0, 0, hub_height]) hubcap("holes");
    translate([0, -15, hub_height]) rod(table_radius);
    translate([0, 15, hub_height]) rod(table_radius);
    
    rotate([0, 180, 90]) translate([0, -20, -cam_height-hub_height*2]) cam_mount();
  }
  
  translate([0, 0, hub_height-hub_height/4]) rotate([45, 90, 0]) translate([0, 0, 15]) rod(table_diameter);
}

module nut() {
  color([0/255, 0/255, 255/255]) cylinder(h=nut_height, r=nut_radius, $fn=6);
}

module rod(length) {
  color([0/255, 0/255, 255/255]) cylinder(h=length, r=rod_radius);
}


module roller() {
  difference() {
    cylinder(h=bearing_height, r=roller_radius);
    translate([0, 0, -1]) cylinder(h=bearing_height+2, r=bearing_radius);
  }
}

module pcb_mount() {
  translate([-(pcb_width+4)/2, -(pcb_height+10)/2-rod_radius, 0]) {
    difference() {
      union() {
        cube([pcb_width+4, pcb_height+10, pcb_length+6]);
        translate([hub_height/4, (pcb_height+10)+rod_radius/1.5, 0]) cylinder(h=pcb_length*0.75, r=rod_radius+3);
      }

      // rod hole
      translate([hub_height/4, (pcb_height+10)+rod_radius/1.5, 0]) translate([0, 0, -1]) cylinder(h=pcb_length*0.75+2, r=rod_radius+0.3);
  
      // top opening
      translate([3, -2.5, 3]) cube([pcb_width-2, pcb_height+10, pcb_length]);
  
      // pcb slot
      translate([1.75, 5-2.5, 1.75]) cube([pcb_width+0.5, pcb_height, pcb_length]);

      // make shorter
      translate([-1, -1, pcb_length*0.5]) cube([pcb_width+6, pcb_height+12+rod_diameter*2, pcb_length+6]);
    }
  }
}

