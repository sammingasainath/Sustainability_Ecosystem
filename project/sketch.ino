#include <WiFi.h>
#include <WebServer.h>

// WiFi credentials - replace with your own
const char* ssid = "Wokwi-GUEST";
const char* password = "";

// LED Pin (built-in LED on ESP32-S3 DevKit)
const int ledPin = 2;  // GPIO2 is typically the built-in LED on ESP32-S3

// Create WebServer instance on port 80
WebServer server(80);

// LED state variable
bool ledState = false;

void setup() {
  // Initialize serial communication
  Serial.begin(115200);
  
  // Set LED pin as output
  pinMode(ledPin, OUTPUT);
  
  // Connect to WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  
  // Print local IP address
  Serial.println("");
  Serial.println("WiFi connected.");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
  
  // Define routes
  server.on("/", handleRoot);
  server.on("/toggle", handleToggle);
  
  // Start server
  server.begin();
  Serial.println("HTTP server started");
}

void loop() {
  // Handle client requests
  server.handleClient();
}

// Root handler - shows basic status page
void handleRoot() {
  String html = "<!DOCTYPE html>"
                "<html>"
                "<head><title>ESP32-S3 LED Control</title></head>"
                "<body>"
                "<h1>LED Control</h1>"
                "<p>Current LED State: " + String(ledState ? "ON" : "OFF") + "</p>"
                "<p><a href='/toggle'>Toggle LED</a></p>"
                "</body>"
                "</html>";
  
  server.send(200, "text/html", html);
}

// Toggle LED handler
void handleToggle() {
  // Toggle LED state
  ledState = !ledState;
  
  // Write the state to the LED pin
  digitalWrite(ledPin, ledState);
  
  // Prepare response
  String response = "LED is now " + String(ledState ? "ON" : "OFF");
  
  // Send response
  server.send(200, "text/plain", response);
  
  // Log to serial
  Serial.println(response);
}