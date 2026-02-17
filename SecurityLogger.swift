import Foundation

class SecurityLogger {

    // A list to store security events
    private var events: [SecurityEvent] = []

    // Record a security event with the given details
    func logEvent(event: String, ipAddress: String) {
        let event = SecurityEvent(timestamp: Date(), timezone: TimeZone.current.identifier, ipAddress: ipAddress, eventDescription: event)
        events.append(event)
        print("[\(event.timestamp)] Security Event: \(event.eventDescription) from IP: \(event.ipAddress), Timezone: \(event.timezone)")
    }

    // Retrieve the log of security events
    func getEvents() -> [SecurityEvent] {
        return events
    }
}

struct SecurityEvent {
    let timestamp: Date
    let timezone: String
    let ipAddress: String
    let eventDescription: String
}