
disponible_x=2.0;
disponible_y=2.88;
disponible_z=2.6;

//de lo sig alternar valores  
//(14 , 1 , 0.9 )
//(13 , 2  , 1.05 )
//(14 , 3 , 1.15)
//(13  , 4 , 1.30)
//(14,  5 , 1.44 ) /

no_escalones=14; //total de niveles en alto
descansos_divs=5; //divisiones en los descansos
ancho_escalones=1.44; //ancho del pasillo del escalon

translate([ - disponible_x/2, - disponible_y/2, - disponible_z/2]){




//ya no variable
espaciox_pescalns=(disponible_x-ancho_escalones)*2;
espacioy_pescalns=disponible_y-(ancho_escalones *2);
total_escalones_ordinarios=no_escalones - (2 * descansos_divs);
huella_pred=(espaciox_pescalns+espacioy_pescalns)/total_escalones_ordinarios;
//echo("preeliminar_huella:",huella_pred);

//cuantos entran en el eje x
cuantos_x=round(espaciox_pescalns/huella_pred);
cuantos_y=round(espacioy_pescalns/huella_pred);
echo("seran en x,y resp. ",cuantos_x,cuantos_y);

tr_x=(espaciox_pescalns/2) / round(cuantos_x/2);
tr_y=espacioy_pescalns / cuantos_y;
tr_z=(disponible_z/(no_escalones+1));
echo("alto de escalon: ",tr_z);
echo("huella en x:",tr_x);
echo("huella en y:",tr_y);
for (i=[0:(round( cuantos_x / 2))-1]){
    tr_x_r=i*tr_x;
    tr_z_r=i*tr_z;
    translate([tr_x_r,0,tr_z_r]){
        
        cube([tr_x,ancho_escalones,tr_z]);  
    }
    
}

glob_tr_x=(round( cuantos_x / 2)) * (espaciox_pescalns/2) / round(cuantos_x/2);
glob_tr_z=(round( cuantos_x / 2)) * (disponible_z/(no_escalones+1));
glob_tr_y=ancho_escalones;

//el o los descansos
if(descansos_divs==1){
    //un cuadrado
    translate([glob_tr_x,0,glob_tr_z]){
        cube([ancho_escalones,ancho_escalones,tr_z]);
    }
    
}else{  
    //REPLICAR ESTO EN EL SIGUIENTE DESCANSO
    huella_ext=(ancho_escalones*2)/descansos_divs;
    for(i=[1:descansos_divs]){
        sig_h=i*huella_ext;
        translate_z=glob_tr_z+(tr_z*(i-1));
        if(sig_h<= ancho_escalones){
            //se sigue en el eje que se venia usando (x)
            nuePosX=(glob_tr_x+(huella_ext*(i-1)));
            translate([0,0,translate_z]){
            linear_extrude(height=tr_z){
                polygon(points=[ [nuePosX,0],[(nuePosX+huella_ext),0],[glob_tr_x,ancho_escalones ] ]);
            }}
        }else{
            //verificar si ya que da en el otro eje totalmente o no
            if( (huella_ext*(i-1)) < ancho_escalones && sig_h> ancho_escalones ){
                nuePosX=(glob_tr_x+(huella_ext*(i-1)));
                nuePosY=  ( huella_ext - ( (glob_tr_x+ancho_escalones) - nuePosX ) ) ; 
                translate([0,0,translate_z]){
                 linear_extrude(height=tr_z){
                        polygon(points=[ [nuePosX,0] ,[(glob_tr_x+ancho_escalones),0], [(glob_tr_x+ancho_escalones), nuePosY ],[glob_tr_x,ancho_escalones ] ]);
                     }}
               
            }else{
                //ya es totalmente del siguiente eje
                nuePosY=  (huella_ext*(i-1)) - ancho_escalones ;
                //echo("...",nuePosY);
                translate([0,0,translate_z]){
            linear_extrude(height=tr_z){
                polygon(points=[ [disponible_x,nuePosY],[disponible_x, (nuePosY + huella_ext)],[glob_tr_x,ancho_escalones ] ]);
            }}
            }
            
        }
    }
}
//x se queda en el mismo lugr
//asignaremos y porque ahora vamos en direccion de y+
if(cuantos_y>0){
for (i=[0: cuantos_y -1]){
    tr_y_r=(i*tr_y) +glob_tr_y;
    tr_z_r=(i*tr_z) +(glob_tr_z+(tr_z*descansos_divs));
    translate([glob_tr_x, tr_y_r, tr_z_r]){
        cube([ancho_escalones,tr_y,tr_z]);  
    }
    
    //glob1=((cuantos_y)*tr_y) +glob_tr_y;
}}else{
    //glob2=disponible_y-ancho_escalones;
}


//volver a definir los globales
glob_tr_y2=disponible_y-ancho_escalones;
glob_tr_z2=(cuantos_y * (disponible_z/(no_escalones+1))) +glob_tr_z+ (tr_z*descansos_divs);
glob_tr_x2=glob_tr_x;

//el o los descansos
if(descansos_divs==1){
    //un cuadrado
    translate([glob_tr_x2,glob_tr_y2,glob_tr_z2]){
        cube([ancho_escalones,ancho_escalones,tr_z]);
    }
    
}else{
    
    huella_ext=(ancho_escalones*2)/descansos_divs;
    for(i=[1:descansos_divs]){
        sig_h=i*huella_ext;
        translate_z=glob_tr_z2+(tr_z*(i-1));
        if(sig_h<= ancho_escalones){
            //se sigue en el eje que se venia usando (y)
            nuePosY=(glob_tr_y2+(huella_ext*(i-1)));
            translate([0,0,translate_z]){
            linear_extrude(height=tr_z){
                polygon(points=[ [disponible_x,nuePosY],[disponible_x,(nuePosY+huella_ext)],[(disponible_x-ancho_escalones) ,glob_tr_y2 ] ]);
            }}
        }else{
            //verificar si ya que da en el otro eje totalmente o no
            if( (huella_ext*(i-1)) < ancho_escalones && sig_h> ancho_escalones ){
                //un eje es en y y el otro enx
                nuePosY=(glob_tr_y2+(huella_ext*(i-1)));
                nuePosX= disponible_x -( huella_ext - ( (glob_tr_y2+ancho_escalones) - nuePosY ) ) ; 
                
                translate([0,0,translate_z]){
                 linear_extrude(height=tr_z){
                        polygon(points=[ [disponible_x,nuePosY] ,[disponible_x,(glob_tr_y2+ancho_escalones)], [nuePosX,(glob_tr_y2+ancho_escalones) ],[disponible_x-ancho_escalones , glob_tr_y2 ] ]);
                     }}
               
            }else{
                //ya es totalmente del siguiente eje
                nuePosX= disponible_x - ( (huella_ext*(i-1)) - ancho_escalones) ;
                //echo("...",nuePosX);
                translate([0,0,translate_z]){
            linear_extrude(height=tr_z){

                polygon(points=[ [nuePosX,disponible_y],[(nuePosX - huella_ext),disponible_y],[(disponible_x-ancho_escalones),glob_tr_y2 ] ]);
            }}
            }
            
        }
    }

}


for (i=[0:(round( cuantos_x / 2))-1]){
    tr_x_r=(glob_tr_x2-tr_x)-(i*tr_x);
    tr_z_r=(i*tr_z) +(glob_tr_z2+(tr_z*descansos_divs));
    translate([tr_x_r, glob_tr_y2 ,tr_z_r]){
        
        cube([tr_x,ancho_escalones,tr_z]);  
    }
    
}
}
