/**
 Ce programme permet de représenter l'ensemble de Mandelbrot dans le rectangle délimité par min_x+ i * min_y et max_x+ i * max_y. 
 Il est possible de changer la précision en changeant la valeur nb_d_iterations, ce changement risque de changer la vitesse d'éxecution du programme. Il est aussi possible de changer
 la puissance à laquelle le nombre complexe va être élevé (voir https://fr.wikipedia.org/wiki/Ensemble_de_Mandelbrot#G%C3%A9n%C3%A9ralisations_et_variantes)
 Les paramètres par défauts sont idéaux.
*/

//variables à changer selon les envies
int vitesse=120;//en hertz entre 1 et 120
int ordre=2;
boolean grille=false;
int nb_d_iterations=500;//max 100000 aucune amélioration aprés en plus devient lent
double min_x=-2.75;
double max_x=1.75;

//programme
double min_y;
double max_y;
double coef;
double nb_de_zoom=1.0;

boolean clique;
double[] point_de_depart;
double[] point_actuel;

color inverse(color initial) {
  return color(255-red(initial), 255-green(initial), 255-blue(initial));
}
double[] calcul(double[] z, double[] z_) {
  double a=z[0];
  double b=z[1];
  double a_=z[0];
  double b_=z[1];
  double[] z__=new double[2];
  for (int i=0; i<ordre-1; i++) {
    z__[0]=a*a_-b*b_;
    z__[1]=a*b_+b*a_;
    a_=z__[0];
    b_=z__[1];
  }
  z__[0]+=z_[0];
  z__[1]+=z_[1];
  return z__;
}

void place(double x, double y) {
  point_de_depart=new double[2];
  point_de_depart[0]=(x+(width*min_x/(max_x-min_x)))/coef;
  point_de_depart[1]=-(y+(height*min_y/(max_y-min_y)))/coef;
  point_actuel=new double[2];
  point_actuel[0]=point_de_depart[0];
  point_actuel[1]=point_de_depart[1];
}
double power(double x,int a){
  return x*x;
}
void dessine(double x,double y) {
  boolean verife=true;
  int value=0;
  for (int i_=0; i_<nb_d_iterations; i_++) {
    double a=point_actuel[0];
    double b=point_actuel[1];
    point_actuel=calcul(point_actuel, point_de_depart);
    if (power(point_actuel[0], 2)+power(point_actuel[1], 2)>4) {
      verife=false;
      value=int(2*log(i_*100+1)+i_*2);
      
      break;
    } else if (power(point_actuel[0]-a, 2)+power(point_actuel[1]-b, 2)<0.000000001D && false) {
      value=i_;
      break;
    }
  }
  if (verife) {
    stroke(20-value, value<20?20:40-value, 255);
  } else {
    stroke(value<30?0:cos(value/7.0-30.0/7.0-3.14)*20+20, value<30?0:sin(value/8.0-30.0/8.0-1.57)*35+35, value);
  }
  point((float)(x-width/2), (float)(-(y-height/2+1)));
}
void setup() {
  fullScreen();
  noSmooth();
  frameRate(vitesse);
  translate(width/2, height/2);
  clique=true;
  coef=width/( max_x-min_x);
  min_y=-2.53125D/2.0D;
  max_y=2.53125D/2.0D;
}
void draw() {
  translate(width/2, height/2);
  if (clique) {
    for (int e=0; e<width; e++) {
      for (int j=0; j<height; j++) {
        place(e, j);
        dessine(e,j);
      }
    }
    if (grille) {
      for (int i=0; i<700; i++) {
        stroke(inverse(get(350, i)));
        point(0, i-350);
      }
      for (int i=0; i<700; i++) {
        stroke(inverse(get(i, 350)));
        point(i-350, 0);
      }
      for (int i=0; i<7; i++) {
        for (int a=0; a<10; a++) {
          stroke(inverse(get(a+345, (i-3)*100+350)));
          point(a-5, (i-3)*100);
        }
      }
      for (int i=0; i<7; i++) {
        for (int a=0; a<10; a++) {
          stroke(inverse(get((i-3)*100+350, a+345)));
          point((i-3)*100, a-5);
        }
      }
    }
    clique=false;
  }
}

void mouseClicked() {
  clique=true;
  nb_de_zoom*=2.0D;
  coef*=2.0D;
  println(min_x,"   ",max_x,"   ",min_y,"   ",max_y,"   ");
  double x_=4.5D/nb_de_zoom/2.0D;
  double y_=2.53125D/nb_de_zoom/2.0D;
  double temp=(max_x*(double)mouseX/(double)width)+min_x*(1.0D-(double)mouseX/(double)width);
  min_x=temp-x_;
  max_x=temp+x_;
  temp=max_y*((double)height-(double)mouseY)/(double)(height)+min_y*(1.0D-((double)height-(double)mouseY)/(double)height);
  min_y=temp-y_;
  max_y=temp+y_;
  println(min_x,"   ",max_x,"   ",min_y,"   ",max_y);
}
