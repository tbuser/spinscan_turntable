lazy_susan_height = 10;

motor_width = 43;
motor_height = 33;
motor_shaft_height = 25;
motor_shaft_diameter = 5;
motor_shaft_radius = motor_shaft_diameter/2;

rod_diameter = 8.3;
rod_radius = rod_diameter/2;

nut_diameter = 14.5;
nut_radius = nut_diameter/2;
nut_height = 7;

hub_thickness = 5;
hub_height = 50;
// hub_height = motor_height+2;
// hub_diameter = motor_width*1.75+hub_thickness;
hub_diameter = 60;
hub_radius = hub_diameter/2;

bearing_diameter = 22.3;
bearing_radius = bearing_diameter/2;
bearing_height = 7;

table_diameter = 215.9; // 8 1/2"
table_radius = table_diameter/2;
table_height = 6.35; // 1/4" wood

gear_height = lazy_susan_height-2;

//spoke_length_top = table_radius-hub_radius-hub_thickness*4;
//spoke_length_bottom = (table_radius-hub_radius) * sqrt(2) - hub_thickness/2;

spoke_length_top = (table_radius) - hub_radius;
spoke_length_bottom = (table_radius * sqrt(2)) - hub_radius;

roller_radius = (hub_height+hub_thickness+gear_height+1) - (hub_height-hub_height/4);
roller_diameter = roller_radius*2;

laser_diameter = 10;
laser_radius = laser_diameter/2;
laser_width = rod_diameter*3;
laser_length = laser_diameter*2;
laser_height = rod_diameter*2.5;

pcb_width = 53;
pcb_length = 68;
pcb_height = 2;

cam_width = 45;
cam_length = 55;
cam_height = 25;
// standard tripod mount screw is 1/4"
cam_bolt_diameter = 6.35;

