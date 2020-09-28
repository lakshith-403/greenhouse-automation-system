
#include <FirebaseESP8266.h>
#include <ESP8266WiFi.h>
#include <time.h>

#define FIREBASE_HOST "irrigation-system-7aa74.firebaseio.com"              // the project name address from firebase id
#define FIREBASE_AUTH "3fbE739ex93tQ1twjpT4CZR1W7fxJMaTTkPhxX5F"       // the secret key generated from firebase
#define WIFI_SSID "Dumbledore is gae"                                          
#define WIFI_PASSWORD "yesheislilgae" 

#include "DHT.h"
#define DHTPIN D2
#define SOILPIN D7

#define DHTTYPE DHT11

using namespace std;

DHT dht(DHTPIN, DHTTYPE);

int dst = 0;

void firebaseSetup()
{
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    Serial.print("Connecting to Wi-Fi");
    while (WiFi.status() != WL_CONNECTED)
    {
        Serial.print(".");
        delay(300);
    }
    Serial.println();
    Serial.print("Connected with IP: ");
    Serial.println(WiFi.localIP());
    Serial.println();

    Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
    Firebase.reconnectWiFi(true);

    //Set the size of WiFi rx/tx buffers in the case where we want to work with large data.
    firebaseData2.setBSSLBufferSize(1024, 1024);

    //Set the size of HTTP response buffers in the case where we want to work with large data.
    firebaseData2.setResponseSize(1024);
}


int getSoilMoisture(){
  int sensorValue = digitalRead(SOILPIN);
  Serial.print("Soil moisture <threshold? -> ");
  Serial.println(sensorValue);
  if(sensorValue==1)return 0;
  else return 1;
}

pair<int,int> getTempHum(){
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  // Read temperature as Fahrenheit (isFahrenheit = true)
  float f = dht.readTemperature(true);
  if (isnan(h) || isnan(t) || isnan(f)) {
    Serial.println(F("Failed to read from DHT sensor!"));
    return {-1.0,-1.0};
  }
  float hif = dht.computeHeatIndex(f, h);
  float hic = dht.computeHeatIndex(t, h, false);

  Serial.print(F("Humidity: "));
  Serial.print(h);
  Serial.print(F("%  Temperature: "));
  Serial.print(t);
  Serial.print(F("°C "));
  Serial.print(f);
  Serial.print(F("°F  Heat index: "));
  Serial.print(hic);
  Serial.print(F("°C "));
  Serial.print(hif);
  Serial.println(F("°F")); 

  return {(int)t,(int)h};
}

void setupPH(){
  return;
}

float getPh(){

    const int analogInPin = A0; 
    int sensorValue = 0; 
    unsigned long int avgValue; 
    float b;
    float buf[10],temp;
    float Po;
   for(int i=0;i<10;i++) { 
    Po = 1023.0 - analogRead(A0);  // Read and reverse the analogue input value from the pH sensor.
    Po /= 73.07;   // Map the '0 to 1023' result to '0 to 14'.
    buf[i]=Po;
    delay(10);
   }
   Serial.print("PH sensor = ");
   Serial.println(Po);
   return Po;
}

void hardSetup(){
  Serial.println(F("DHTxx test!"));
  dht.begin();
  pinMode(D8,OUTPUT);
}

void motorOn(){
  digitalWrite(D8,HIGH);
Firebase.set(firebaseData2,"/motor/", 1);
}

void motorOff(){
  digitalWrite(D8,LOW);
Firebase.set(firebaseData2,"/motor/", 0);
}

//////////////////////////////////////////////////



void updateCloud(){
    pair<int,int> th = getTempHum();
    int moist = getSoilMoisture();
    float ph = getPh();
    int PH = (int)(ph*100.0);
    Serial.print("PH ----> ");
    Serial.println(ph);
    int state;
//    uncomment the following two lines to turn on the motor
//    if(moist)setPumpState(0,0);
//    else setPumpState(0,1);

    Firebase.set(firebaseData2,"/moist/", moist);
    Firebase.set(firebaseData2,"/temp/", th.first);
    Firebase.set(firebaseData2,"/hum/", th.second);
    Firebase.set(firebaseData2,"/ph/", PH);

    Firebase.get(firebaseData2,"/dp/count/");
    int C = firebaseData2.intData();

    String Count = String(C);

    Firebase.set(firebaseData2,"/dp/moist " + Count + "/", moist);
    Firebase.set(firebaseData2,"/dp/temp " + Count + "/", th.first);
    Firebase.set(firebaseData2,"/dp/hum " + Count + "/", th.second);
    Firebase.set(firebaseData2,"/dp/ph " + Count + "/", PH);

//    int C = toint(Count);
    C++;

    Firebase.set(firebaseData2,"/dp/count/", C);
    
    delay(3000);
}





void setup() {
    Serial.begin(9600);
    hardSetup();
}

void loop() {
  updateCloud();
//  runSchedule();
}
