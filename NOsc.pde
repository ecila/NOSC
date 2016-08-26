
// Alice August 2016. 
//
// Implements Neural Oscillators - pair of continuous time neurons arranged in mutual inhibition -- using simple Euler method
//
// -- As specified in Williamson 99 (ftp://www.ai.mit.edu/people/matt/iros99.pdf)
// -- After K. Matsuoka. Sustained oscillations generated by mutually  inhibiting  neurons  with  adaption. Biological Cybernetics, 52:367{376, 1985
// -- Written in processing 2.2.1


float y_out, y1, y2;
float h;//input weight
float g; // input (tonic for now)
float v1, v2, x1, x2; // state variables

float beta = 2.0; // constant
float gamma = 2.0; // constant

// time constants
float tau1 = 0.1; // natural freq is proportional to 1/tau1 
float tau2 = 0.6; // tau1:tau2 controls shape of osc (stable in range 0.1 - 0.5)

float c = 2.5; // controls amplitude of oscillation

float dt = 0.005; // euler step size
float dx1, dx2, dv1, dv2; // tmp vars for euler approximation


// to model periodic input
float count = 0.0;
float period = 20.0;
float inc = TWO_PI * period;
int val = 0;

// for testing
boolean DEBUG = false;


void setup() {
  size(360, 360);
  background(255);
  h = 0.0;
  g = 0.0;
  dx2 = dx1 = 0.0;

  // init state vars
  v1 = 0.0;
  x1 = 0.0;
  v2 = 1.0;
  x2 = 1.0;
}


void draw() {

  g = sin(count);

  //  calc all changes in state vars using current values
  dx1  =  ((c - x1 - (beta*v1) - (gamma*max(x2, 0.0)) - (h*max(g, 0.0))) / tau1);  
  dv1 = (max(x1, 0.0) - v1)/ tau2;

  dx2 =  (c - x2 - (beta*v2) - (gamma*max(x1, 0.0)) - (h*min(g, 0.0))) / tau1;  
  dv2 = (max(x2, 0.0)- v2) / tau2;



  //  Calc outputs each neuron using new vals
  y1 = max(x1, 0.0);
  y2 = max(x2, 0.0);

  //  and the final output
  y_out = y1 - y2;


  // update state vars (Euler)
  x1 = x1 + dx1*dt;
  x2 = x2 + dx2*dt;
  v1 = v1 + dv1*dt;
  v2 = v2 + dv2*dt;
  
  int n = 100;
  background(255);

  stroke(0);
  ellipse(width*0.1, height/2 + g*n, 2, 2);  

  stroke(0);
  line(width*0.25, height/2 + (y_out *n), width *0.5, height/2 + (y_out*n));  

  stroke(200, 20, 20);
  line(width*0.5, height/2 + y1*n, width*0.75, height/2 + y1*n);  

  stroke(20, 200, 20);
  line(width*0.75, height/2 + y2*n, width, height/2 + y2*n);  

  if (DEBUG) {
    print(" global output: ", y_out);
    print(" Ext output: ", y1);
    print(" Flex output: ", y2);
    println(" input: ", g);
  }
  // check for updated input 
  inc = TWO_PI/ period;
  count = count+inc;
}


// enable parameter updates
void keyPressed() {

  // update period of input oscillation
  if (key == 'F'){
    period = period+1;
    println("Freq = ", 1.0/period);    
  }
  else if (key == 'f'){
    period = period-1;
    println("Freq = ", 1.0/ period);
  }
  else if (key == '1'){
    period = 10;
    println("Freq = ", 1.0/period);
  }
   else if (key == '2'){
    period = 100;
    println("Freq = ", 1.0/period);
  }
   else if (key == '3'){
    period = 1000;
    println("Freq = ", 1.0/period);
  }
  
  // turn input weights on/off
  else if (key == 'h'){
    h = 0.0;
    println("h = ", h );
  }
  else if (key == 'H'){    
    h = 1.0;
    println("h = ", h );
  }
  
    // update tau1
  else if (key == 't'){
    tau1 = tau1-0.01;
    print("t1 = ", tau1 );
    println("t1:t2 = ", tau1/tau2 );
  }
  else if (key == 'T'){    
    tau1 = tau1+0.01;
    print("t1 = ", tau1 );
    println(" t1:t2 = ", tau1/tau2 );
  }
  
  
  // turn prints on/off
  else if (key == 'd')
    DEBUG = false;
  else if (key == 'd')
    DEBUG = true;
  
  
}
