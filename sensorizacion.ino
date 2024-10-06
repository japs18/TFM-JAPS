#include <elapsedMillis.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#include "DHT.h"



// Configuración del DHT22
#define DHTPIN 3     // Pin donde está conectado el sensor
#define DHTTYPE DHT22   // Sensor DHT22
DHT dht(DHTPIN, DHTTYPE);

// Configuración del sensor de temperatura
OneWire ourWire(2);                   //Se establece el pin 2  como bus OneWire
DallasTemperature sensors(&ourWire);  //Se declara una variable u objeto para nuestro sensor

// Pines donde se conectan los relés del secador y de la electroválvula
int secador_pin = 11;
int humedecido_pin = 12;

// Inicialización de todas las variables necesarias
unsigned long t;
unsigned long T;
unsigned long t_previo;
unsigned long t_senal_previo;
unsigned long t_senal_actual;
int v1;
int v2;
int pin1;
int pin2;
int comenzar;
unsigned long t_inicio;
unsigned long t_sincro;


elapsedMillis delayDatos;
elapsedMillis delayHumedad;


bool encendido;
int matlab;
float temp;

void setup() {
  // Se configuran los pines como salida
  pinMode(secador_pin, OUTPUT);
  pinMode(humedecido_pin, OUTPUT);
  // Se ponen estos pines en estado alto, 
  // lo que mantiene apagado el secador y la válvula
  digitalWrite(secador_pin, HIGH);
  digitalWrite(secador_pin, HIGH);
  T = 0;
  t_previo = 0;


  // Pines de los sensores de voltaje
  Serial.begin(9600);
  pin1 = A0;
  pin2 = A1;
  // Esta variable evita que se entre en el bucle principal hasta que 
  // llegue la señal de inicio de Matlab
  comenzar = -1;
  // Se envia al encenderse una señal de fin, esto se hace
  // por si se resetea en mitad de la ejecución
  Serial.println("Fin");
  encendido = false;
  sensors.begin();
  dht.begin();
}

void loop() {
  if (comenzar == 1) {// La ejecución no comienza hasta recibir de Matlab un 1

    if (Serial.available() > 0) {
      // Se lee el puierto serie cuando hay datos
      t_senal_previo = millis();
      matlab = Serial.read();
      // Se comprueba que instrucción de Matlab se ha enviado
      if (matlab == 2) {// 2 se corresponde con iniciar el secador
        encendido = true;
        digitalWrite(secador_pin, LOW);
      } else if (matlab == 3) {// 3 se corresponde con apagar el secador
        encendido = false;
        digitalWrite(secador_pin, HIGH);
      } else if (matlab == 4) {// 4 se corresponde con iniciar la electroválvula
        digitalWrite(humedecido_pin, LOW);
      } else if (matlab == 5) {// 5 se corresponde con apagar la electroválvula
        digitalWrite(humedecido_pin, HIGH);
      } else if (matlab == 6) {
        // 6 se corresponde a apagar todos los sistemas y finalizar la ejecución
        apagar_sistema();
      } else if (matlab == 8 || matlab == 9) {
        // 8 y 9 se usan para comprobar que la comunicación sigue establecida
        int a = 1;
      }
    }

    // Bloque de envio de información
    if (delayDatos > 100 && delayHumedad > 2000) {
      // Si han pasado 100 ms desde el ultimo envio y 2 s
      // desde la ultima lectura del sensor de humedad
      // se leen todos los sensores
      enviar_datos(1);
      delayDatos = delayDatos - 100;
      delayHumedad = delayHumedad - 2000;
    }else if(delayDatos > 100){
      // Si no han pasado 2 s desde la ultima lectura del sensor de humedad
      // solo se leen los datos del resto de sensores
      enviar_datos(0);
      delayDatos = delayDatos - 100;
    }

    // Codigo para apagar el sistema en caso de que pasen 90 segundos sin ninguna respuesta de
    // Matlab, esto se realiza por si el programa de Matlab se queda colgado, para que el 
    // secador no se quede nunca encendido
    t_senal_actual = millis();
    if (t_senal_actual - t_senal_previo > 60000) {
      apagar_sistema();
    }

  } else {
    // Se comprueba si Matlab ha enviado la instrucción de inicio
    comenzar = Serial.read();
    t_inicio = millis();
    delayDatos = 0;
    delayHumedad = 0;
    encendido = true;
    digitalWrite(secador_pin, HIGH);
    digitalWrite(humedecido_pin, HIGH);
    // comenzar = 1;
  }
}


void enviar_datos(int hum) {
  // Función encargada de obtener y enviar los datos de los sensores
  // El sensor de humedad solo manda señales cada 2 segundos, sino han
  // pasado, no se realiza la lectura y se manda un -1
  float h = -1;
  float temp_amb = -1;
  // Lectura del sensor de humedad
  if(hum == 1){
    h = dht.readHumidity();
    temp_amb = dht.readTemperature();
  }
  // Lectura del resto de componentes
  sensors.requestTemperatures();      //Se envía el comando para leer la temperatura
  temp = sensors.getTempCByIndex(0);  //Se obtiene la temperatura en ºC
  // matlab = 0;
  v1 = analogRead(pin1);
  v2 = analogRead(pin2);
  t = millis() - t_inicio;
  // Envio de la cadena con los datos de todos los sensores
  Serial.print(t);
  Serial.print(";");
  Serial.print(v1);
  Serial.print(";");
  Serial.print(v2);
  Serial.print(";");
  Serial.print(temp);
  Serial.print(";");
  Serial.print(h);
  Serial.print(";");
  Serial.print(temp_amb);
  Serial.println(";");
}
void apagar_sistema() {
  // Función que se encarga de apagar todo el sistema
  // Despues entra en un bucle infinito
  digitalWrite(secador_pin, HIGH);
  digitalWrite(humedecido_pin, HIGH);
  Serial.println("Fin");
  while (true) {
    delay(1000);
  }
}