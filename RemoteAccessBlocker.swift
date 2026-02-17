import Foundation

/// RemoteAccessBlocker detects and blocks unauthorized remote access attempts
class RemoteAccessBlocker {
    
    private var blockedIPs: Set<String> = []
    private var suspiciousPatterns: [String] = []
    private let logger: SecurityLogger
    
    init(logger: SecurityLogger) {
        self.logger = logger
        setupSuspiciousPatterns()
    }
    
    /// Setup common patterns used in remote access attacks
    private func setupSuspiciousPatterns() {
        suspiciousPatterns = [
            "SSH_ATTEMPT",
            "RDP_CONNECTION",
            "REMOTE_DESKTOP",
            "SSH_BRUTE_FORCE",
            "UNAUTHORIZED_PORT_SCAN"
        ]
    }
    
    /// Check if an incoming connection is malicious
    /// - Parameters:
    ///   - ipAddress: The source IP address
    ///   - port: The target port
    ///   - protocol: The connection protocol
    /// - Returns: True if connection is blocked, false otherwise
    func blockConnection(ipAddress: String, port: Int, protocol: String) -> Bool {
        // Check if IP is already blocked
        if blockedIPs.contains(ipAddress) {
            logger.logEvent(event: "BLOCKED_CONNECTION - IP in blocklist", ipAddress: ipAddress)
            return true
        }
        
        // Check for suspicious patterns
        if isSuspiciousActivity(port: port, protocol: protocol) {
            blockedIPs.insert(ipAddress)
            logger.logEvent(event: "BLOCKED_REMOTE_ACCESS_ATTEMPT - Port: \(port), Protocol: \(protocol)", ipAddress: ipAddress)
            return true
        }
        
        return false
    }
    
    /// Detect suspicious network activity
    private func isSuspiciousActivity(port: Int, protocol: String) -> Bool {
        let suspiciousPorts = [22, 3389, 5900, 8080, 445] // SSH, RDP, VNC, HTTP-Alt, SMB
        return suspiciousPorts.contains(port)
    }
    
    /// Get list of blocked IP addresses
    func getBlockedIPs() -> [String] {
        return Array(blockedIPs)
    }
    
    /// Unblock a specific IP address
    func unblockIP(_ ipAddress: String) {
        blockedIPs.remove(ipAddress)
        logger.logEvent(event: "IP_UNBLOCKED", ipAddress: ipAddress)
    }
}