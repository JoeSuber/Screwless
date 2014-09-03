// hole investigations

side = 63.5;
travel = 60;
extracam = 2.5;
shaftD=2.89;
shaftF=2.45;

linear_extrude(height=5, scale=1.01){
    displaycam(theta=360*$t);
}

module outercam(side=side, travel=travel){
    difference(){
        square([side,side*2], center=true);
        hull(){
            translate([0,travel/2-extracam/2,0])
                circle(r=travel/2+extracam/2, $fn=64);
            translate([0,-travel/2+extracam/2,0])
                circle(r=travel/2+extracam/2, $fn=64);
        }
    }
}

module dshaft(){
    echo("shaft measurements: ", shaftD, shaftF);
    sliverx=(shaftD + shaftF)/4;
    echo("sliver-off-of-shaft centered at: ",sliverx );
    dimsliver = [shaftD - shaftF+0.2, shaftD];
    echo("and is shaped like: ", dimsliver);
    difference(){
        circle(shaftD/2, $fn=24);
        translate([-sliverx,0,0])
            square(dimsliver, center=true);
    }
}
   
module innercam(tr=travel/2, deadrad=extracam, scaler=[1.22,1.22]){
    difference(){
        circle(r=tr+deadrad/2-.2, center=true, $fn=36);
        translate([-tr+deadrad/2,0,0])
            dshaft(shaft=[2.89, 2.45]*scaler);
    }
}

module movecam(dist=travel/2 - extracam/2, ang=30){
    translate([dist*cos(ang), dist*sin(ang), 0]) rotate([0,0,ang])
        innercam();
}

module displaycam(theta=240){
    translate([cos(theta)*(travel-extracam)/2,0,0])
        outercam();
    movecam(ang=theta);
}

