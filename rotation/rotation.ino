#include "MT6701.hpp"
#include <Wire.h>
#include <phyphoxBle.h> 

MT6701 mt6701;

// Hardware-Pin für den Taster
const int resetPin = 25;

float lastAngle = 0.0;         // letzter absoluter Winkel (0–360)
long  turnCount = 0;           // Umdrehungszähler
float lastContinuous = 0.0;    // letzter kontinuierlicher Winkel
unsigned long lastTime = 0;    // Zeitstempel für Geschwindigkeit
float angleOffset = 0.0;       // Offset für die Nullstellung

// Glättung
float angularVelocitySmoothed = 0.0;
const float alpha = 0.1;       // 0..1, kleiner = stärker geglättet

void setup()
{
    // Taster-Pin konfigurieren (INPUT_PULLUP nutzt den internen Widerstand)
    pinMode(resetPin, INPUT_PULLUP);

    Wire.begin(16, 17);
    Serial.begin(115200);
    mt6701.begin();

    lastAngle      = mt6701.getAngleDegrees();
    lastContinuous = 0.0; // Startet bei 0 nach Reset-Logik
    lastTime       = millis();
    angularVelocitySmoothed = 0.0;
    
    PhyphoxBLE::start("Drehpendel");
    PhyphoxBleExperiment Drehpendel;
  
    Drehpendel.setTitle("Drehpendel");
    Drehpendel.setCategory("Sensor-Boxen");
    Drehpendel.setDescription("Der Sensor misst den Drehwinkel in Abhängigkeit von der Zeit.");
  
    PhyphoxBleExperiment::View firstView;
    firstView.setLabel("Drehwinkel"); 

    PhyphoxBleExperiment::View secondView;
    secondView.setLabel("Winkelgeschwindigkeit"); 
  
    PhyphoxBleExperiment::Graph firstGraph;  
    firstGraph.setLabel("Drehwinkel");
    firstGraph.setUnitX("s");
    firstGraph.setUnitY("Grad");
    firstGraph.setLabelX("Zeit");
    firstGraph.setLabelY("Winkel");
    firstGraph.setChannel(1, 2);

    PhyphoxBleExperiment::Graph secondGraph;  
    secondGraph.setLabel("Winkelgeschwindigkeit");
    secondGraph.setUnitX("s");
    secondGraph.setUnitY("G/s");
    secondGraph.setLabelX("Zeit");
    secondGraph.setLabelY("w");
    secondGraph.setChannel(1,3);
  
    firstView.addElement(firstGraph);            
    Drehpendel.addView(firstView); 
    
    secondView.addElement(firstGraph);   
    secondView.addElement(secondGraph);            
    Drehpendel.addView(secondView);   
    PhyphoxBLE::addExperiment(Drehpendel);        
}

void loop()
{
    // Taster abfragen (LOW bedeutet gedrückt, wenn gegen GND geschaltet)
    if (digitalRead(resetPin) == LOW) {
        angleOffset = mt6701.getAngleDegrees(); // Aktuellen Winkel als Nullpunkt merken
        turnCount = 0;                          // Umdrehungen nullen
        lastAngle = angleOffset;
        lastContinuous = 0.0;
        // Kurze Pause zum Entprellen
        delay(200); 
    }

    float t = 0.001 * (float)millis();  
    mt6701.updateCount();

    float rawAngle = mt6701.getAngleDegrees();
    float diff = rawAngle - lastAngle;

    // Wrap-Detection (0°/360°)
    if (diff < -180.0) {
        turnCount++;
    } else if (diff > 180.0) {
        turnCount--;
    }

    lastAngle = rawAngle;

    // Kontinuierlicher Winkel relativ zum Offset
    float continuousAngle = (rawAngle - angleOffset) + turnCount * 360.0;

    // Zeitdifferenz
    unsigned long now = millis();
    float dt = (now - lastTime) / 1000.0;
    lastTime = now;

    if (dt > 0) {
        // Roh-Winkelgeschwindigkeit
        float dAngle = continuousAngle - lastContinuous;
        float angularVelocity = dAngle / dt;
        lastContinuous = continuousAngle;

        // Exponentielle Glättung
        angularVelocitySmoothed += alpha * (angularVelocity - angularVelocitySmoothed);
    }

    Serial.println(continuousAngle);
    PhyphoxBLE::write(t, continuousAngle, angularVelocitySmoothed);
    
    delay(5);
}
