include<BOSL2/std.scad>
include<BOSL2/threading.scad>

$fn  =60;

l= 82;
d = 8; //Diameter of Bearing
thread_length = 15;
pitch = 1;
d_thread = d+pitch;
d_thread_small = 5;
tol = 0.1;
spiral_pos=thread_length/2+2;





STAND       = 1;
AXLE        = 0;
SPIRAL      = 0;
POINTER     = 0;
WHEEL       = 0;
BEARING     = 0;
SNAPLOCK    = 0;
MOTORMOUNT  = 0;
SCALE       = 0;
MOTORCASE   = 0;
WATERTANK   = 0; 
SCREW       = 0;


difference(){
union(){
if(WATERTANK)down(95)watertank();


if(SNAPLOCK)translate([0,-15,2.7])snaplock();

// n = 3.5,4.5,5.5,6.5
if(SPIRAL)
down(4.2)color("blue")fwd(spiral_pos)spiral();

if(AXLE){
    color("green")axle();
    translate([0,-14.5,1])rotate([0,0,45])snaplockC(14,"A");
    }

if(BEARING)
for(i=[-1,1,1.35])fwd(i*30)rotate([-90,0,0])translate([-128,-128,-3.5])import("608.stl");


if(WHEEL)
rotate([0,144,0])back(7)wheel();
if(POINTER){
    down(0.5)color("orange")fwd(35+5)pointer();
    translate([0,-14.5,38.25])snaplockC(10.5,"P");
    translate([0,-44.2,-64.52])rotate([90,0,0])snaplockB(5.3);
    }

if(STAND)
color("green")stand();
*LockScrew(l=12);
}
*cube(200);
}

if(SCREW){
    LockScrew(l=9,15,4);
    }


if(MOTORMOUNT){
    translate([90,-49,-40])motorConnect();
    color("green")translate([0,-40,-40])rotate([90,0,0])nut();
    color("orange")translate([180,-40,-48])rotate([90,90,0]){
        motorMount();
        up(4.2)left(10)snaplockB(6.5);
        }
    

    }

if(SCALE){
    back(36+tol)rotate([0,0,180])ampScale();    
    color("tomato")for(k=[-1,1])translate([k*40,38,-80])LockScrew();
    }



if(MOTORCASE)translate([180,-10,-88])motorStand();



module motorStand(){
    module motor(){
       l=22;
       d=12.05;
       h=10.05;

       intersection(){
          ycyl(d=d,h=l);
          cuboid([d,l,h]);
          }
          fwd(l/2+9.3/2)cuboid([d,9.7,h]);
          }
          
          
    difference(){
    hull(){
        up(40)cuboid([20,40,20],rounding=2,except=FRONT);
        cuboid([40,40,4],anchor=BOTTOM,rounding=2,except=[BOTTOM,FRONT]);
        }
        cuboid([20,40,2],anchor=BOTTOM);
       hull(){
        up(2)cuboid([20,40,2],anchor=BOTTOM);
        up(8)cuboid([25,40,1],anchor=BOTTOM);
      } 
    up(40)motor();
    hull(){
    translate([0,5,15])cuboid([30,15,2],anchor=BOTTOM+FRONT);
    translate([0,5,38])cuboid([16,15,10],anchor=BOTTOM+FRONT);
    }
    translate([0,-10,15])cuboid([3,10,10],chamfer=1.5,edges=[TOP+LEFT,TOP+RIGHT],anchor=BOTTOM+BACK);

    }
    module screwhole(){
    difference(){
        translate([0,5,0])ycyl(d=6,h=13,anchor=FRONT);
        translate([0,5,0])ycyl(d=2.5,h=13,anchor=FRONT);
        }
    }
    for(i=[-1,1])translate([-6.5*i,0,46])screwhole();
    for(i=[-1,1])translate([-13.5*i,0,17])screwhole();
    
    
    tol = 0.15;
    difference(){
        union(){
        cuboid([20-tol,40,2],anchor=BOTTOM);
           hull(){
            up(2)cuboid([20-tol,40,2-tol],anchor=BOTTOM);
            up(8)cuboid([25-tol,40,1-tol/2],anchor=BOTTOM);
            }
            }
        for(i=[-1,1])fwd(10*i)cyl(d=3,h=7,anchor=BOTTOM)cyl(d1=3,d2=6,h=3)cyl(d=8,h=10,anchor=BOTTOM);
            }
}


module motorStand2(){
    h = 50;
    difference(){
    cuboid([50,30,h],anchor = BOTTOM+FRONT,rounding = 2, except = [BOTTOM,FRONT]);
    //motor cutout
    #back(2)up(h-20)ycyl(d = 37+tol, h = 30,anchor=FRONT)up(7)ycyl(d=12+tol,h=40,anchor=BACK);
    //cutout for mount
    union(){
    cuboid([20,100,2],anchor=BOTTOM);
    hull(){
        up(2)cuboid([20,100,2],anchor=BOTTOM);
        up(8)cuboid([25,100,1],anchor=BOTTOM);
      } 
      }
      }
}


module ampScale(){
    d = 240;
    h = 2;
    difference(){
        ycyl(d = d,h =h,anchor = FRONT);
        ycyl(d = 180,h =2,anchor = FRONT);
         rotate([-90,0,0])for(i=[-41:10:220])rotate([0,0,i])rotate_extrude(2)left(103)square([15,4],anchor = FRONT);
            rotate([-90,0,0])for(i=[-41:10:210])rotate([0,0,i+5])rotate_extrude(2)left(108)square([5,4],anchor = FRONT);
                    #for(k=[-1,1])translate([k*40,0,-80])ycyl(d=9,h=h,anchor=FRONT);

            down(d/2-40)cuboid([d,h,d],anchor=TOP+FRONT);
        }
        color("red"){back(2)rotate([-90,0,0])for(i=[95:10:220])rotate([0,0,i+6])left(115)text3d(str((i-85)/10),h=1,anchor=FRONT,size =5,font ="FreeSans:style=bold");
        back(2)rotate([-90,0,0])for(i=[-45:10:85])rotate([0,0,i+4])left(115)rotate([0,0,180])text3d(str(abs((i-85)/10)),h=1,anchor=FRONT,size =5,font ="FreeSans:style=bold");}
    difference(){
        down(d/2-51)cuboid([180,h,20],chamfer = 10,except=[FRONT,BACK,TOP],anchor=TOP+FRONT);
        #for(k=[-1,1])translate([k*40,0,-80])ycyl(d=9,h=h,anchor=FRONT);
        }


}    
    

    
module motorConnect(){
    difference(){
        cuboid([200,2,10],rounding=4,except=[FRONT,BACK]);
        for(i=[-1,1])left(i*90)ycyl(d=6,h=4);
        }

}


module motorMount(motor = "N20"){
    d = 30;
    dist_to_shaft = 10;
    difference(){
        union(){
            cuboid([30,6,4],chamfer = 3,except=[TOP,BOTTOM],anchor=BOTTOM+LEFT);
            cyl(d = d,h=4,anchor=BOTTOM);
            if(motor == "N20")cyl(d = 8,h=6,anchor = TOP);
            else{cyl(d = 11,h=6,anchor = TOP);}
            }
    if(motor == "N20")down(9)difference(){
        cylinder(h=18,d=3);
        translate([-1.5,1,0])cube([3,3,18]);
    }
    else{
    down(9)difference(){
        cylinder(h=18,d=6);
        translate([0,5.5,9])cuboid([6,6,18]);
    }
    }
    #left(dist_to_shaft)cyl(d= 5+2*tol, h = 4, anchor =BOTTOM);
    
    //threaded_rod(d = d_thread_small,pitch = pitch,l = 4,anchor =BOTTOM,internal = true, $slop = 0.1);

    }

}

module watertank(){
    difference(){
        cuboid([130,35,18],chamfer=4,edges=BOTTOM);
        #up(1)cuboid([130-4,35-4,18-2],rounding=5, edges =BOTTOM);
        }
}


module stand(){
    tol = 0.1;
    for(i=[-1,1])fwd(i*30){
    difference(){
        sidewall_bottom(i);
       //right(10)cuboid(200,anchor=LEFT);  
        }
     }
    up(60)bearing_holder_rod();
    up(120)bearing_holder_sensor_mount();
    bottom();
    
    module sidewall(screwhole = 1){
    difference(){
        hull(){
        down(6)cuboid([25,9.2,20]);
        down(100)cuboid([150,8,20]);
        }
        ycyl(d=22+tol,h=7+3*tol);
        ycyl(d=18+tol,h=10);
        if(screwhole)for(k=[-1,1])translate([k*40,0,-80])threaded_rod(l = 9,d = 8,pitch = 2,$slop = 0.1, internal = true,orient=FRONT);
        }
        }//end module sidwall
    
       
    
    module sidewall_bottom(i){
        difference(){
            sidewall(-1+i);
            up(5)cuboid([100,20,20],anchor=TOP);
            hull(){
                down(15)cuboid([30,5,5],anchor=TOP);
                down(25)cuboid([20,4,5],anchor=TOP);
            }
            //direction_indicator
            translate([9,-2,-15])cuboid([5,5.5,5],anchor=TOP+FRONT);
            //mount_screw_hole
            translate([0,0,-22])threaded_rod(l = 9.5,d = 8,pitch = 2,$slop = 0.1, internal = true,orient=FRONT);
             }//end difference
    }
            
            
    module bottom(i){
            down(108)difference(){    
            cuboid([150,60,4]);
                for(i=[-1,1])left(i*30)cyl(d=3.2,h=4,chamfer2=-1.5);
                }
                fwd(30)down(106)cuboid([150,8,15],rounding=-15,edges=BOTTOM+BACK,anchor=BOTTOM);
                back(30)down(106)cuboid([150,8,15],rounding=-15,edges=BOTTOM+FRONT,anchor=BOTTOM);
            }
            
            module bearing_holder(){
            difference(){
            sidewall(0);
            down(15)cuboid([200,20,300],anchor=TOP);
            }
            difference(){
                hull(){
                down(15)cuboid([30-tol,5-tol,5],anchor=TOP);
                down(25)cuboid([20-tol,4-tol,5-tol],anchor=TOP);
                }
                translate([0,0,-22-tol])threaded_rod(l = 9.5,d = 8,pitch = 2,$slop = 0.1, internal = true,orient=FRONT);
                }
                translate([9,0.75,-15])cuboid([5-tol,5.5-tol,5-tol],rounding = 1,edges=[LEFT+BOTTOM,RIGHT+BOTTOM],anchor=TOP);

            }
                    
            module bearing_holder_sensor_mount(){
        
            bearing_holder();
            back(6.25)difference(){
                down(4.5)cuboid([25,3.5,17]);
                cuboid([23,1.7,23]);
                cuboid([18.5,10,18.5]);
                }
                }
                
            module bearing_holder_rod(){
        
            bearing_holder();
               fwd(4.5)difference(){
                    ycyl(d1=d,d2=26,h=3,anchor=BACK);
                    
                    up(4)cuboid([32,32,32],anchor=BOTTOM);
                    }
                    fwd(7.5)ycyl(d=d,h=10,anchor=BACK);
                    }

   }
module LockScrew(l=15,headDia = 14, headHeight=6){
        ycyl(d=headDia,h=headHeight,$fn=6,chamfer2=1,anchor=FRONT);
        threaded_rod(l = l,d = 8,pitch = 2,$slop = 0.1,orient=FRONT,anchor=BOTTOM);

}


module pointer(){
    difference(){
        hull(){
            fwd(2)cuboid([d+4,4,70],chamfer=(d+4)/2,edges=[TOP+LEFT,TOP+RIGHT],anchor=BOTTOM);
            cuboid([30,8,30]);
             fwd(2)cuboid([d+4,4,70],chamfer=(d+4)/2,edges=[TOP+LEFT,TOP+RIGHT],anchor=TOP);


            }
            ycyl(d=22,h=10);
            for(i=[0:10:40]){
                down(24+i)ycyl(d=5+2*tol, h = 10);
                }
                
            *down(45)cuboid([5,15,40],rounding=2.5,except=[FRONT,BACK]);
            #fwd(1)down(45)cuboid([40
            ,10,60],rounding=2.5,except=[FRONT,BACK],anchor=FRONT);

            }
            difference(){
                translate([0,25/2+1.5,40])rotate([-90,0,0])cuboid([d+4,4,33],rounding=-20,edges=[BOTTOM+FRONT]);
                translate([0,25/2+13,39.5])cyl(d = 5+2*tol, h =5);
                //old threaded rod, replaced by pins
                *translate([0,25/2+13,39.5])threaded_rod(d = d_thread_small , orient= UP,pitch = pitch,internal = true,l = 5,$slop = 0.1);
                }

}

module wheel(){
    d = 200;
    h = 4;
    
    color("yellow")difference(){
        union(){
            ycyl(d=d,h=h,anchor = BACK);
            fwd(h)ycyl(d=15, h=5,rounding2 = -3, anchor = BACK);
            }
            rotate([-90,0,0])for(i=[1:15:360])rotate([0,0,i])rotate_extrude(360/60)left(d/4)square([d/2-50,h],anchor = BACK);
            for(i=[1:5:360])rotate([0,i,0])left(d/2-5)cuboid([5,h,2.5],rounding=1,except=[FRONT,BACK],anchor=BACK);
            threaded_rod(d = d_thread,pitch= pitch,l =5+h, orient=BACK,internal = true,$slop=0.15,anchor=TOP);
            }
          rotate([0,126,0])color("tomato")translate([d/2-5,-4,0])mirror([0,1,0])wheelPointer();
        
}

module wheelPointer(){
    
    cuboid([5-0.1,4-0.1,2.5-0.1],rounding=1,except=[FRONT,BACK],anchor=BACK);
    right(3.5)cuboid([15,2,3],anchor=FRONT,chamfer=1.5,edges = [RIGHT+TOP,RIGHT+BOTTOM]);
}



module archimedean_spiral1(spirals=1, thickness=1, rmax = 100, rmin = 10) {
    $fa = 4;
    // mit freundlicher Unterstützung von Gemini
    // Parameter
    s_deg = spirals * 360;
    s_rad = s_deg * (PI / 180);
    t = thickness;
    
    // Bedingung prüfen
    if (rmax > rmin) {
        
        // Steigungskoeffizient 'a' berechnen
        a = (rmax - rmin) / s_rad;

        // 1. Erstellung der äußeren Punkte (r = a*theta + rmin)
        points = [
            for(i = [0:$fa:s_deg]) [
                // X = r_outer * cos(i)
                ((a * (i * (PI / 180))) + rmin) * cos(i), 
                // Y = r_outer * sin(i)
                ((a * (i * (PI / 180))) + rmin) * sin(i)  
            ]
        ];
        
        // 2. Erstellung der inneren Punkte (r_inner = max(0, r_outer - t))
        // Die Schleife läuft rückwärts, um das Polygon zu schließen.
        points_inner = [
            for(i = [s_deg:-$fa:0]) [
                // X = r_clamped * cos(i)
                max(0, ((a * (i * (PI / 180))) + rmin) - t) * cos(i), 
                // Y = r_clamped * sin(i)
                max(0, ((a * (i * (PI / 180))) + rmin) - t) * sin(i)  
            ]
        ];
        
        // 3. Polygon erstellen (durch Verbinden von außen nach innen)
        polygon(concat(points, points_inner));
        
    } else {
        echo("FEHLER: rmax muss größer sein als rmin. Modul zeichnet Platzhalter.");
        circle(r=rmax);
    }
}


module spiral(n = 4.5){
    //n = 3.5;
    difference(){
        union(){
            rotate([90,80,0])linear_extrude(10)archimedean_spiral1(n,2,40,6);
            if(n==5.5)translate([0,0,7.5])cuboid([8,10,3],anchor=BACK);
            if(n==3.5)translate([0,0,9.2])cuboid([8,10,3],anchor=BACK);
            if(n==4.5)translate([0,0,8])cuboid([8,10,3],anchor=BACK);
            if(n==6.5)translate([0,0,7])cuboid([8,10,3],anchor=BACK);

            translate([0,0,39])cuboid([12,10,3],anchor=BACK);

        }
        if(n==5.5)translate([2,0,0])cuboid([12,10,12],anchor=BACK);
        if(n==3.5)translate([6,0,0.7])cuboid([12,12,14],anchor=BACK);
        if(n==4.5)translate([2,0,0.2])cuboid([13,10,12.7],anchor=BACK);
        #if(n==6.5)translate([2,0,-0.25])cuboid([11,10,11.5],anchor=BACK);

        fwd(5)cyl(d = d_thread_small+2.5*tol,h=12,anchor=BOTTOM);
        up(37)fwd(5)cyl(d = d_thread_small+2*tol,h=8,anchor=BOTTOM);

        }
    }

module axle(){

    difference(){
    union(){
        for(i=[-1,1])fwd(i*l/4)ycyl(d= d, l = l/2-      thread_length);
        threaded_rod(d = d_thread,pitch = pitch,l =    thread_length, orient=FWD);
        translate([0,-thread_length/2-16,0])ycyl(d1 = d, d2 = d+4,h=5);
        translate([0,-thread_length/2-6,0])ycyl(d = d+4,h=15);
    }
    #fwd(spiral_pos){
        translate([0.5,0,6])cuboid([15,10+tol,4],chamfer = -4,edges = [BACK+TOP],anchor=BACK+TOP);
        *translate([0,-5,0.5])threaded_rod(d = d_thread_small , orient= UP,pitch = pitch,internal = true,l = 4,$slop = 0.1);
        #translate([0,-5,0.5])cyl(d=5.2,h=20);
    }
    fwd(-l/2+thread_length/2+3)ycyl(d=4,h=3,anchor=FRONT);

    }
    *translate([0,thread_length/2+2.5,0])ycyl(d1 = d+4, d2 = d,h=5);
    
}


module nut(){
    difference(){
    cuboid([10,10,3]);
    threaded_rod($slop = 0.1,d = d_thread_small,pitch = pitch,l =    3,internal = true);
    }
}

module snaplock(){
    difference(){
        union(){
            cyl(d=d_thread_small,h=6,anchor=BOTTOM);
            difference(){
                threaded_rod(d = d_thread_small,pitch = pitch,l = 4,anchor =TOP);
                left(2.2)cuboid([5,20,l],anchor=TOP+RIGHT);
                }
            *up(3.4)cyl(d=d_thread_small+1,h=2,anchor=BOTTOM);
            }

        up(4)rotate_extrude()left(1+2)square([2,1],center = true);
        right(d_thread_small/2-0.3)cuboid(100,anchor=LEFT);
        }
    up(4)left(0)difference(){
        cyl(d=12,h=0.9);
        cyl(d=4.1,h=0.9);
        rotate_extrude(90)left(1+3)square([6,1],center = true);

    }
}

module snaplockB(l=15){
    difference(){
        union(){
            cyl(d=d_thread_small,h=8,anchor=BOTTOM);
            cyl(d=8,h=2,anchor=BOTTOM);
            difference(){
                *threaded_rod(d = d_thread_small,pitch = pitch,l = 7,anchor =TOP);
                cyl(d=5,h=l,anchor=TOP);
             
                *left(2.5)cuboid([1,5,7],anchor=TOP);
                }
            *up(3.4)cyl(d=d_thread_small+1,h=2,anchor=BOTTOM);
            }

        up(6)rotate_extrude()left(1+2)square([2,1],center = true);
        down(l-1.2)rotate_extrude()left(1+2)square([2,1],center = true);
        right(d_thread_small/2-0.3)cuboid(100,anchor=LEFT);
        }
    up(6)left(0)difference(){
        cyl(d=12,h=0.9);
        cyl(d=4.1,h=0.9);
        rotate_extrude(90)left(1+3)square([6,1],center = true);

    }
}
module snaplockC(l =15,txt=""){
    difference(){
        union(){
            up(6)cyl(d=5,h=l,anchor=TOP);
            down(l-6)cyl(d=10,h=2,anchor=TOP);       
            }
        #left(1)down(l-6+1.75)rotate([0,0,90])text3d(txt,0.5,6,center = true);

        up(4)rotate_extrude()left(1+2)square([2,1],center = true);
        right(5/2-0.3)cuboid(100,anchor=LEFT);
        }
    up(4)left(0)difference(){
        cyl(d=12,h=0.9);
        cyl(d=4.1,h=0.9);
        rotate_extrude(90)left(1+3)square([6,1],center = true);

    }
}


