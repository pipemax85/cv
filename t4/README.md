# Taller de interacción

## Propósito

Estudiar las tres tareas universales de interacción en entornos virtuales.

## Tareas

Escoja una de las siguientes tres:

1. Emplee un [dispositivo de interfaz humana](https://en.wikipedia.org/wiki/Human_interface_device) no convencional para controlar una escena. Refiérase al ejemplo [SpaceNavigator](https://github.com/VisualComputing/frames/tree/master/examples/basics/SpaceNavigator). Se puede emplear la escena del [punto 2 del taller de transformaciones](https://github.com/VisualComputing/Transformations_ws)
2. Implemente una aplicación de _cámara en tercera persona_. Refiérase al ejemplo [FlockOfBoids](https://github.com/VisualComputing/frames/tree/master/examples/demos/FlockOfBoids).
3. Implemente una aplicación de _control de la aplicación_.

En cualquier caso se puede emplear la librería [frames](https://github.com/VisualComputing/frames) y/o cualquier otra.

## Integrantes

Máximo tres.

Complete la tabla:

| Integrante | github nick |
|------------|-------------|
|Felipe Ramos        | pipemax85 |
|Alejandro Sierra        | gasierram |

## Informe

## Informe

Unas de las criaturas mas interesantes y fuera de lo común en nuestro planeta son las **medusas** (Medusozoa), animales marinos de cuerpo gelatinoso y simétrico cuyas características son poco conocidas sobretodo en nuestro entorno local. 
Los hechos mas curiosos e interesantes de estos animales y su existencia fueron objeto de estudio para nosotros y por esta razón realizamos este taller como símbolo de reconocimiento para estas criaturas majestuosas, que nos dejan atonitos de sus capacidades y naturaleza, demostrando asi que la vida misma y la existencia es algo magico y que realmente todo aquello que conocemos como universo contiene seres dignos de reconocer que muy probablemente un ser superior seria quien podria construir tan semejante obra de arte.  


### ¡Las Medusas!

Las **medusas** (**Medusozoa**), también llamadas **aguamalas**, **malaguas**, **aguavivas**, **aguacuajada** o **lágrimas de mar**, son [animales](https://es.wikipedia.org/wiki/Animal "Animal") marinos pertenecientes al [filo](https://es.wikipedia.org/wiki/Filo "Filo")  [Cnidaria](https://es.wikipedia.org/wiki/Cnidaria "Cnidaria") (más conocidos como [celentéreos](https://es.wikipedia.org/wiki/Celent%C3%A9reos "Celentéreos")); son [pelágicos](https://es.wikipedia.org/wiki/Pel%C3%A1gico "Pelágico"), de cuerpo [gelatinoso](https://es.wikipedia.org/wiki/Gelatina "Gelatina"), con forma de campana de la que cuelga un manubrio tubular, con la boca y en el extremo inferior, a veces prolongado por largos tentáculos cargados con células urticantes llamados [cnidocitos](https://es.wikipedia.org/wiki/Cnidocito "Cnidocito"). Aparecieron hace unos 500 millones de años en el [Cámbrico].
(https://es.wikipedia.org/wiki/C%C3%A1mbrico "Cámbrico")

![enter image description here](https://static3.larioja.com/www/multimedia/201708/22/media/cortadas/medusas-kcyB--624x385@La%20Rioja.jpg)

Son sus características lo que en realidad llama la atencion de estos seres, pues incluso se puede decir que un tipo de medusa es inmortal. 
Algunos datos interesantes sobre las medusas y que dieron como resultado su implementación :

  - Muchos consideran que las medusas son una de las formas más intimidantes de vida acuática y pueden vivir en todas las temperaturas del agua en el    océano.
- Existen más de 2.000  [especies de    medusas](http://www.medusapedia.com/especies-medusas/ "Especies de   
   medusas") identificadas por los expertos y todavía existen muchas especies que no se han encontrado aún en las profundidades de los océanos.
- Las medusas son invertebrados simples, sin embargo, tienen la    capacidad de moverse en formas que los demás de su tipo no pueden.
- El cuerpo de una medusa es simétrico. Esto les permite detectar el    peligro y buscar alimento en cualquier dirección desde su posición particular.
         Sólo alrededor del 5% del cuerpo de la medusa se compone de    materiales sólidos.
- La medusa puede moverse verticalmente por sus propios medios, sin    embargo, el movimiento horizontal está controlado por el   
   viento y las    corrientes marinas.
- El promedio de vida de una medusa depende de la especie. Algunas de    ellas viven sólo un par de horas, otras llegan a vivir 
   unos 6 meses,    una especie puede vivir eternamente.
         Una  [picadura de    medusa](http://www.medusapedia.com/picaduras-medusas-toxicidad-tratamiento/
   "Picaduras de medusas, toxicidad y tratamiento")  es dolorosa y puede
   resultar en inflamación y ardor. La picadura de algunas medusas      
   pueden ser fatales para los seres humanos dependiendo de la especie. 
   Algunas de las maneras de curar la picazón es mediante la aplicación 
   de vinagre. En el peor caso, es posible aplicar orina en la zona para
   reducir el dolor.

### Interacción en Frames 
Basados en lo visto en la asignatura queremos "Proporcionar interactividad a los objetos de la aplicación desde cualquier fuente de entrada de la manera más simple posible." Como meta principal en este tema de Interacción. Utilizando los tres elementos base de toda interacción. 

 - Navegación  
 - Selección y Manipulación
 -  Control de la Aplicación

Es por esto que basándonos en el ejemplo FlockOfBoids visto en el taller anterior, tomamos como referencia su para crear un nuevo Flock con medusas (Jellfish) y para mostrar principalmente el elemento de navegación en la interacción creamos una cámara en tercera persona generando una escena interesante e interactiva para el usuario. 

### FlockOfJellfish
Nuestra idea es entonces, construir una escena donde se tenga como elemento principal a las medusas con las que el usuario puede interactuar mediante una aplicación de una cámara en tercera persona generando un efecto visual y una interacción con la implementación de los conceptos vistos en clase. 

Para la creación de una medusa se realizo la creación de su cabeza y luego de sus tentáculos, basando como referencia la implementación de ["anemone"]( http://www.openprocessing.org/visuals/?visualID=1439
) por Giovanni Carlo Mingati quien a su vez se basa en el sorprendente trabajo que realiza el artista multimedia [James Fader](https://vjfader.com/about/) en eventos como Coachella, Burning Man, Insomniac, Fuji Rock, Mapping Festival, Backwoods and Intro Music Festival.

La clase **JParticle** es la encargada de generar los tentaculos de la Medusa, que posteriormente se unifican y renderizan para crear el aspecto visual y la percepción de movimiento y morfología de la misma. Para la cabeza el algoritmo construye curvas de [Bezier](https://es.wikipedia.org/wiki/Curva_de_B%C3%A9zier)

 

    void render(float inx, float iny, float inz) { 
       noStroke(); 
       fill(257, 28, 65, 10);
       float tenticleSize = ms/30 + 1; 
       strokeWeight(tenticleSize);
       stroke(238, 14, 85, 30); 
       point(loc.x,loc.y,loc.z-ms*4); 
       float al = map(vel.mag(), 0, 1.2, .1, 3); 

	    stroke(238, 14, 85, al); 
	    noFill();
	    strokeWeight(1.5);
	    if(ms <= 5) {
	      bezier(inx,iny,inz+70, loc.x - (inx-loc.x)/20,loc.y - (iny-loc.y)/20,inz+60,loc.x - (inx-loc.x)/3,loc.y - (iny-loc.y)/3,inz-10,loc.x,loc.y,loc.z + lengthVar);
	       bezier(loc.x + (inx-loc.x)/1.5,loc.y + (iny-loc.y)/1.5,inz+20, loc.x - (inx-loc.x)/40,loc.y - (iny-loc.y)/40,inz+40,loc.x - (inx-loc.x)/3,loc.y - (iny-loc.y)/3,inz-10,loc.x,loc.y,loc.z + lengthVar);
	    }
      } 
Luego, construimos un **PSystem** que agrega varios tentáculos y construye el "sistema de partículas" como esta compuesta la medusa. Para ello utilizamos un vector de posición con las coordenadas x,y,z dentro del frame y otro vector para realizar el movimiento que tienen las medusas que parecen contracciones. 

    Vector run(float inx, float iny, float inz, float r) 
      { 
        Vector positionTemp = null;
        update(inx,iny,inz,r);     
        for (int i = particles.size()-1; i >= 0; i--) {         
          jParticle prt = (jParticle) particles.get(i); 
          if (positionTemp == null)
              positionTemp = prt.run(inx, iny, inz); 
          prt.run(inx, iny, inz); 
          prt.move(new PVector(ps_loc.x,ps_loc.y,ps_loc.z));  
        }
        return ps_loc2;
    }

En la clase **Jellyfish** construimos la medusa junto con su movimiento natural como lo conocemos. Para la construcción de la cabeza utilizamos coordenadas polares y para el movimiento creamos la sensación de un movimiento con números aleatorios controlados. Utilizamos la libreria Frames para crear un **Frame** sobre la escena y logramos crear varias medusas que se mueven sobre la escena. 

    Jellyfish(boolean vel) {
      this.vel=vel;
      inx = 0; 
      iny = 0; 
      
      for(int i=0; i<numSystems; i++){ 
        // dispose PSystems in a circle 
        x = r * cos(theta); 
        y = r * sin(theta); 
        z = 1;
        x += inx; 
        y += iny;       
        ps[i] = new PSystem(new PVector(x, y, z), 60, theta);  
        theta += 0.16; //0.057,inx,iny,inz,r2;
      } 
      r = 20.0f; //40
      amplitude = r; 
      frame = new Frame(scene) {
        // Note that within visit() geometry is defined at the
        // frame local coordinate system.
        @Override
        public void visit() {
          if (animate)
            run();
           }    
      };
      position = new Vector();
      position.set(inx,iny,iny);
      frame.setPosition(position);
![Jellfish](https://lh3.googleusercontent.com/lEIPOJvFw3FY_sAMqvWx8kVH51acHMOIQDCPedVY_h9jBGJEj9s_m_MPPqj_4dhfvfRkz5bX1SS1 "Jellfish")

Para implementar la cámara en tercera persona utilizamos un objeto-cámara que sigue a cada una de las medusas y la idea es que la interacción a través del mouse permita la vista de cámara de tercera persona ([Navigation](https://visualcomputing.github.io/Interaction/)) y el control de la aplicación.
![Flock](https://lh3.googleusercontent.com/HpGL-TdiNnSf_ojQErXRCRw0paPG7R9ezUzyThqk4Th2U-nJQrPEApjFz2nRADcyrAe7LZHSD1Hp "FlockOfJellfish")  


![enter image description here](https://lh3.googleusercontent.com/8ue9BaOlyAfy2lBn2NS5eynVQDmEFo6FGrFZD2KUXdrwMlVEG7M5QPxknwSV4R9vML0oScYmWLxS "third")

Como resultado obtenemos una excelente y muy relajante interacción como quien ha tenido la oportunidad de bucear o nadar debajo del agua en el mar y siente esa inmersión en otro mundo totalmente desconocido y cuya dimensión es mucho mas grande que lo que el ser humano puede imaginar. Es por esto que las medusas son un gran e interesante animal que habita en el agua y que con ejercicios como estos podemos mostrar a través de Frames estos escenarios donde se aplican las tres técnicas principales de interacción y ver un manejador (*handler*)  de grafo de escena de alto nivel con la implementación en Processing.  
## Entrega

Fecha límite Domingo 3/3/19 a las 24h.
